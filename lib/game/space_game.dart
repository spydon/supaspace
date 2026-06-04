import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide PointerMoveEvent;
import 'package:supaspace/game/components/bullet.dart';
import 'package:supaspace/game/components/grid.dart';
import 'package:supaspace/game/components/minimap.dart';
import 'package:supaspace/game/components/minimap_marker.dart';
import 'package:supaspace/game/components/planet.dart';
import 'package:supaspace/game/components/powerup.dart';
import 'package:supaspace/game/components/ship.dart';
import 'package:supaspace/game/components/starfield.dart';
import 'package:supaspace/game/components/taunt_bubble.dart';
import 'package:supaspace/game/countdown.dart';
import 'package:supaspace/game/game_phase.dart';
import 'package:supaspace/game/net/high_score_service.dart';
import 'package:supaspace/game/net/models/models.dart';
import 'package:supaspace/game/net/realtime_client.dart';
import 'package:supaspace/game/planet_field.dart';
import 'package:supaspace/game/player.dart';
import 'package:supaspace/game/player_store.dart';
import 'package:supaspace/game/powerup_field.dart';
import 'package:supaspace/game/powerup_type.dart';
import 'package:supaspace/game/sound_service.dart';
import 'package:supaspace/game/taunts.dart';

/// A player's planet score, for the HUD / results overlay.
class ScoreEntry {
  ScoreEntry({
    required this.id,
    required this.name,
    required this.color,
    required this.planets,
    this.spectating = false,
  });

  final String id;
  final String name;
  final Color color;
  final int planets;

  /// Whether this member is watching rather than competing. Spectators are
  /// listed separately from the ranked planet count.
  final bool spectating;
}

/// The final result of a match: who controlled the most planets when the
/// countdown ended. [leaders] holds every player sharing the top count, so a
/// tie can be shown instead of crowning an arbitrary winner.
class MatchOutcome {
  MatchOutcome({required this.leaders, required this.topPlanets});

  final List<ScoreEntry> leaders;
  final int topPlanets;

  /// Whether anyone actually captured a planet.
  bool get hasCaptures => topPlanets > 0;

  /// Whether the top count is shared by more than one player.
  bool get isTie => leaders.length > 1;

  /// The sole winner (only meaningful when [hasCaptures] and not [isTie]).
  ScoreEntry get winner => leaders.first;
}

/// Root game. Holds the world (planets, ships, bullets), the camera + fixed
/// starfield, the lobby/playing/results state machine, and bridges the
/// Supabase [RealtimeClient] to local simulation. Peer/client-authoritative:
/// this client owns its local ship and its bullets; remote ships are
/// interpolated.
class SpaceGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        PointerMoveCallbacks,
        TapCallbacks,
        DragCallbacks {
  static final Vector2 worldSize = Vector2(4200, 3000);
  static const captureSeconds = 5.0;
  static const overlayName = 'name';
  static const overlayLobby = 'lobby';
  static const overlayHud = 'hud';
  static const overlayResults = 'results';
  static const overlaySpectate = 'spectate';

  late final LocalPlayer player;
  late final RealtimeClient net;
  late final HighScoreService highScoreService;
  final PlayerStore _playerStore = PlayerStore();

  /// Shared green-flame animation used by every [Bullet]. Loaded once at boot;
  /// each bullet plays its own ticker over these frames.
  late final SpriteAnimation bulletAnimation;

  /// Looping animation per powerup type, loaded once at boot.
  late final Map<PowerupType, SpriteAnimation> _powerupAnimations;

  /// Whether the player has chosen a call sign and joined this session. Until
  /// then only the [overlayName] form is shown — there is no network presence.
  bool _sessionStarted = false;

  /// The [GameWidget]'s focus node, set by the host widget. Keyboard input
  /// (thrust/brake) only reaches the game while this node holds focus, so it is
  /// re-requested whenever a text-field overlay (the call-sign form) closes.
  FocusNode? gameFocusNode;

  /// Mouse position in world coordinates (drives local ship aim). Re-derived
  /// every frame from [_lastPointerScreen] so it tracks the camera.
  final Vector2 aimWorld = Vector2.zero();

  /// Last known cursor position in widget/screen coordinates, and whether one
  /// has been seen. The camera follows the ship, so a stationary cursor must be
  /// re-projected to world space each frame — otherwise the ship would turn to
  /// chase the now-stale world point once it flew past it.
  final Vector2 _lastPointerScreen = Vector2.zero();
  bool _hasPointer = false;

  /// Whether the left mouse button is held (drives continuous firing). Set by
  /// the pointer listener wrapping the game widget.
  bool firing = false;

  /// On-screen (mobile) thrust/brake buttons, OR-ed with the keyboard by the
  /// local ship so touch and keys both work.
  bool thrustHeld = false;
  bool brakeHeld = false;

  // Reactive state consumed by the Flutter overlays.
  final phase = ValueNotifier<GamePhase>(GamePhase.lobby);
  final roster = ValueNotifier<List<PresenceMember>>([]);
  final clock = ValueNotifier<String>('03:00');
  final scores = ValueNotifier<List<ScoreEntry>>([]);
  final outcome = ValueNotifier<MatchOutcome?>(null);
  final highScores = ValueNotifier<List<HighScore>>([]);

  /// Transient toast shown to the local player (e.g. "Bullet Speed +1" on a
  /// powerup, "Planet taken from X" on a capture); cleared after
  /// [_toastDuration]. Set via [_showToast].
  final toastMessage = ValueNotifier<String?>(null);
  static const _toastDuration = 2.2;
  double _toastTimer = 0;

  /// In the lobby, whether this client intends to spectate the next match
  /// rather than play it.
  final spectateIntent = ValueNotifier<bool>(false);

  /// Name of the ship the spectator camera is currently following.
  final followedPlayer = ValueNotifier<String?>(null);

  final Map<String, ShipComponent> _ships = {};
  final Map<String, PresenceMember> _members = {};
  final List<PlanetComponent> _planets = [];
  final List<PowerupComponent> _powerups = [];

  /// Living ships, refreshed once per frame so homing bullets can find their
  /// nearest target without re-scanning the ship map (and skipping dead ships)
  /// on every bullet. See [nearestEnemyShipPosition].
  final List<ShipComponent> _livingShips = [];

  Countdown? _countdown;
  int _lastClockSeconds = -1;
  Minimap? _minimap;
  GridComponent? _grid;
  int? _activeSeed;
  String? _followedId;
  final Set<String> _previousPresentIds = {};

  double _scoreTimer = 0;

  /// Seconds the local pilot has gone without any input while playing. Reset by
  /// [markActivity]; once it reaches [_idleTimeout] the pilot is dropped into
  /// spectator mode so an AFK player stops occupying the match.
  double _idleSeconds = 0;
  static const _idleTimeout = 60.0;

  /// When we last received a ship-state broadcast from each remote player
  /// (epoch ms). A member still advertising `playing` that we haven't heard
  /// from for longer than [_inactivePlayerTimeoutMs] is treated as inactive —
  /// typically a backgrounded/closed tab whose frozen client never demoted
  /// itself to spectator. The window is a bit longer than [_idleTimeout] so a
  /// live-but-parked pilot has time to self-demote (flipping their presence to
  /// spectating) before we'd ever flag them.
  final Map<String, int> _lastStateMs = {};
  static const _inactivePlayerTimeoutMs = 70000;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = worldSize / 2;
    camera.backdrop = Starfield();

    // Cached bullet query, used to clear bullets between matches without
    // scanning every world child.
    world.children.register<Bullet>();

    // Hold-to-acquire logic for planets and powerups runs in its own
    // components (they self-gate on the playing phase + local ship).
    add(CaptureController());
    add(PowerupController());

    final flameImage = await images.load('green_flame_bullet.png');
    bulletAnimation = SpriteAnimation.fromFrameData(
      flameImage,
      SpriteAnimationData.sequenced(
        amount: 31,
        amountPerRow: 8,
        textureSize: Vector2(48, 96),
        stepTime: 1 / 30,
      ),
    );

    _powerupAnimations = {
      for (final type in PowerupType.values)
        type: SpriteAnimation.fromFrameData(
          await images.load(type.imagePath),
          SpriteAnimationData.sequenced(
            amount: 48,
            amountPerRow: 6,
            textureSize: Vector2.all(64),
            stepTime: 0.06,
          ),
        ),
    };

    highScoreService = HighScoreService();

    // Restore the player's chosen call sign from a previous session. A
    // first-time player has none yet, so prompt them to choose one; the lobby
    // and the network connection wait until they have.
    final restored = await _playerStore.load();
    if (restored == null) {
      overlays.add(overlayName);
    } else {
      player = restored;
      await _beginSession();
    }
  }

  /// Connects to realtime and enters the lobby once [player] is known.
  Future<void> _beginSession() async {
    _members[player.id] = PresenceMember(
      id: player.id,
      name: player.name,
      color: player.colorValue,
      phase: GamePhase.lobby,
    );

    net = RealtimeClient(player: player);
    net.onRoster = _onRoster;
    net.onStart = (event) => _enterMatch(
      event.seed,
      event.startedAt,
      asSpectator: spectateIntent.value,
    );
    net.onShipState = _onShipState;
    net.onShot = _onShot;
    net.onCapture = _onCapture;
    net.onPowerupTaken = _onPowerupTaken;
    net.onTaunt = _onTaunt;
    await net.connect();

    _sessionStarted = true;
    unawaited(_refreshHighScores());

    overlays
      ..remove(overlayName)
      ..add(overlayLobby);
    gameFocusNode?.requestFocus();
  }

  // --- player identity ------------------------------------------------------

  /// Whether the player has chosen a call sign and joined this session.
  bool get hasChosenName => _sessionStarted;

  /// Handles the call-sign form. For a first-time player this creates their
  /// identity, persists it and joins the session; for an existing player it
  /// renames them, persisting the new name and re-broadcasting presence so
  /// peers see it. A blank name is ignored.
  Future<void> submitName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    if (_sessionStarted) {
      if (trimmed != player.name) {
        player.name = trimmed;
        await _playerStore.saveName(trimmed);
        _members[player.id] = PresenceMember(
          id: player.id,
          name: trimmed,
          color: player.colorValue,
          phase: GamePhase.lobby,
        );
        roster.value = [
          for (final member in roster.value)
            member.id == player.id ? _members[player.id]! : member,
        ];
        await net.updatePresence();
      }
      overlays
        ..remove(overlayName)
        ..add(overlayLobby);
      gameFocusNode?.requestFocus();
    } else {
      player = LocalPlayer.create(name: trimmed);
      await _playerStore.save(player);
      await _beginSession();
    }
  }

  /// Opens the call-sign editor from the lobby.
  void openNameEditor() {
    overlays
      ..remove(overlayLobby)
      ..add(overlayName);
  }

  /// Closes the call-sign editor with no change. Only valid once a name has
  /// been chosen — a first-time player must pick one before continuing.
  void cancelNameEditor() {
    if (!_sessionStarted) {
      return;
    }
    overlays
      ..remove(overlayName)
      ..add(overlayLobby);
    gameFocusNode?.requestFocus();
  }

  Future<void> _refreshHighScores() async {
    try {
      highScores.value = await highScoreService.fetchTop();
    } on Object catch (_) {
      // Leaderboard is non-critical; ignore transient fetch failures.
    }
  }

  /// Reports this client's view of the winner to the database. Every player
  /// reports, and the database awards the point once a majority agree on the
  /// same winner — so the win doesn't depend on any single (untrusted) client.
  /// Only reported on a clear sole winner, and only by clients that played.
  Future<void> _reportWinner(MatchOutcome outcome) async {
    final startedAt = _countdown?.startedAt;
    final iPlayed = _ships.containsKey(player.id);
    if (iPlayed &&
        startedAt != null &&
        outcome.hasCaptures &&
        !outcome.isTie) {
      try {
        await highScoreService.reportWinner(
          matchId: startedAt,
          winnerId: outcome.winner.id,
          winnerName: outcome.winner.name,
          participantCount: _ships.length,
        );
      } on Object catch (error) {
        // Non-fatal (offline, etc.), but log it so a broken RPC is visible.
        debugPrint('reportWinner failed: $error');
      }
    }
    await _refreshHighScores();
  }

  // --- lobby / lifecycle ----------------------------------------------------

  /// Pilots in the lobby who intend to play (spectators excluded). This is what
  /// the minimum-to-start check counts.
  int get playablePilotCount =>
      roster.value.where((member) => !member.spectating).length;

  bool get canStart =>
      playablePilotCount >= 2 && !isLiveGameRunning && !spectateIntent.value;

  /// A match this client missed the start of, advertised by a playing peer.
  PresenceMember? get liveGameHost {
    for (final member in roster.value) {
      if (member.isPlaying && member.seed != null && member.startedAt != null) {
        return member;
      }
    }
    return null;
  }

  bool get isLiveGameRunning => liveGameHost != null;

  /// The most pilots allowed in one match. A late arrival can still jump into
  /// an in-progress match while it has room; once full they can only spectate.
  static const maxPlayers = 10;

  /// How many pilots are currently playing the live match (no spectators).
  int get liveGamePlayerCount =>
      roster.value.where((member) => member.isPlaying).length;

  /// Whether this client may join the running match as a player (a live game
  /// exists and it isn't full yet).
  bool get canJoinLiveGame =>
      isLiveGameRunning && liveGamePlayerCount < maxPlayers;

  void toggleSpectateIntent() {
    spectateIntent.value = !spectateIntent.value;
    // Advertise the choice so peers exclude us from the start count.
    net.setSpectateIntent(spectating: spectateIntent.value);
  }

  /// Triggered by the lobby Start button. Picks a shared seed + start time,
  /// tells everyone, and starts locally.
  void startMatch() {
    if (!canStart || phase.value != GamePhase.lobby) {
      return;
    }
    final seed = Random().nextInt(1 << 31);
    final startedAt = DateTime.now().millisecondsSinceEpoch;
    net.sendStart(StartEvent(seed: seed, startedAt: startedAt));
    _enterMatch(seed, startedAt, asSpectator: false);
  }

  /// Join an already-running match as a spectator (late arrival), using the
  /// seed/start time advertised by a playing peer.
  void spectateLiveGame() {
    final host = liveGameHost;
    if (host == null || phase.value != GamePhase.lobby) {
      return;
    }
    _enterMatch(host.seed!, host.startedAt!, asSpectator: true);
  }

  /// Jump into an already-running match as a player (late arrival) while it
  /// still has room, using the seed/start time advertised by a playing peer.
  /// The countdown is wall-clock based, so the joiner gets the time remaining.
  void joinLiveGame() {
    final host = liveGameHost;
    if (host == null ||
        phase.value != GamePhase.lobby ||
        liveGamePlayerCount >= maxPlayers) {
      return;
    }
    _enterMatch(host.seed!, host.startedAt!, asSpectator: false);
  }

  void _enterMatch(int seed, int startedAt, {required bool asSpectator}) {
    final alreadyIn =
        phase.value == GamePhase.playing || phase.value == GamePhase.spectating;
    if (alreadyIn && _activeSeed == seed) {
      return;
    }
    _activeSeed = seed;
    _idleSeconds = 0;
    _resetWorld();

    if (_grid == null) {
      _grid = GridComponent(worldSize: worldSize);
      world.add(_grid!);
    }

    final planetSpecifications = generatePlanets(seed, worldSize);
    for (final specification in planetSpecifications) {
      final planet = PlanetComponent(specification);
      _planets.add(planet);
      world.add(planet);
    }

    for (final specification in generatePowerups(
      seed,
      worldSize,
      planetSpecifications,
    )) {
      final powerup = PowerupComponent(
        specification: specification,
        animation: _powerupAnimations[specification.type]!,
      );
      _powerups.add(powerup);
      world.add(powerup);
    }

    if (asSpectator) {
      net.setSpectating();
      phase.value = GamePhase.spectating;
    } else {
      final random = Random();
      final spawnPosition = Vector2(
        400 + random.nextDouble() * (worldSize.x - 800),
        400 + random.nextDouble() * (worldSize.y - 800),
      );
      final ship = LocalShip(
        id: player.id,
        shipName: player.name,
        color: player.color,
        position: spawnPosition,
      );
      // Highlight ring so the local ship stands out on the minimap.
      ship.add(MinimapMarker(shipSize: ship.size));
      _ships[player.id] = ship;
      world.add(ship);
      camera.follow(ship);
      net.setPlaying(seed, startedAt);
      phase.value = GamePhase.playing;
    }

    _countdown = Countdown(startedAt: startedAt);
    _lastClockSeconds = -1;
    outcome.value = null;
    overlays
      ..remove(overlayLobby)
      ..remove(overlayResults)
      ..add(overlayHud);
    if (asSpectator) {
      overlays.add(overlaySpectate);
    }
    _recomputeScores();
    if (_minimap == null) {
      _minimap = Minimap(world: world, worldSize: worldSize);
      add(_minimap!);
    }
    // Ensure keyboard input (thrust/brake) reaches the game, in case a lobby
    // button held focus when the match started.
    gameFocusNode?.requestFocus();
  }

  // --- spectator camera -----------------------------------------------------

  /// Ship ids that a spectator can follow, in a stable order.
  List<String> get _followableIds => (_ships.keys.toList()..sort());

  void followNextPlayer() => _cycleFollow(1);
  void followPreviousPlayer() => _cycleFollow(-1);

  void _cycleFollow(int direction) {
    final ids = _followableIds;
    if (ids.isEmpty) {
      return;
    }
    final currentIndex = _followedId == null ? -1 : ids.indexOf(_followedId!);
    final nextIndex = (currentIndex + direction) % ids.length;
    _followShip(ids[(nextIndex + ids.length) % ids.length]);
  }

  void _followShip(String id) {
    final ship = _ships[id];
    if (ship == null) {
      return;
    }
    _followedId = id;
    followedPlayer.value = ship.shipName;
    camera.follow(ship);
  }

  /// Keep the spectator camera pointed at a valid ship: pick one when we have
  /// none, or re-target when the followed player leaves.
  void _ensureSpectatorFollow() {
    if (phase.value != GamePhase.spectating) {
      return;
    }
    if (_followedId != null && _ships.containsKey(_followedId)) {
      return;
    }
    final ids = _followableIds;
    if (ids.isEmpty) {
      _followedId = null;
      followedPlayer.value = null;
      camera.stop();
    } else {
      _followShip(ids.first);
    }
  }

  void _endMatch() {
    phase.value = GamePhase.results;
    // Stop advertising this match in presence (results is a local-only phase),
    // so peers no longer see it as an ongoing game to spectate while we sit on
    // the game-over screen.
    net.setLobby();
    // The HUD (with its touch controls) is removed below, so clear any held
    // state rather than leaving it stuck on.
    thrustHeld = false;
    brakeHeld = false;
    _recomputeScores();
    final playerEntries = scores.value
        .where((entry) => !entry.spectating)
        .toList();
    final topPlanets = playerEntries.isEmpty ? 0 : playerEntries.first.planets;
    final leaders = playerEntries
        .where((entry) => entry.planets == topPlanets)
        .toList();
    final matchOutcome = MatchOutcome(leaders: leaders, topPlanets: topPlanets);
    outcome.value = matchOutcome;
    unawaited(_reportWinner(matchOutcome));
    SoundService.instance.playSoundEffect(SoundEffect.gameOver);
    overlays
      ..remove(overlayHud)
      ..remove(overlaySpectate)
      ..add(overlayResults);
  }

  /// Back to the lobby from the results screen.
  void returnToLobby() {
    _resetWorld();
    _minimap?.removeFromParent();
    _minimap = null;
    _grid?.removeFromParent();
    _grid = null;
    _countdown = null;
    _activeSeed = null;
    _followedId = null;
    followedPlayer.value = null;
    clock.value = Countdown.format(Countdown.gameDuration);
    net.setLobby();
    phase.value = GamePhase.lobby;
    unawaited(_refreshHighScores());
    overlays
      ..remove(overlayResults)
      ..remove(overlayHud)
      ..remove(overlaySpectate)
      ..add(overlayLobby);
  }

  /// Resets the idle timer. Called on any local input (aim, fire, thrust/brake,
  /// keys, taunts) while a match is running.
  void markActivity() => _idleSeconds = 0;

  /// Drops the local ship and switches to the spectator camera after a spell of
  /// inactivity (see [_idleTimeout]). Mirrors the spectator setup in
  /// [_enterMatch], but as a live transition mid-match.
  void _goIdleSpectator() {
    _idleSeconds = 0;
    final ship = _ships.remove(player.id) as LocalShip?;
    if (ship != null) {
      // Let peers know we've left the fight before we stop broadcasting, so our
      // ship doesn't linger as a parked target on their side.
      ship.alive = false;
      broadcastShipState(ship);
      ship.removeFromParent();
    }
    thrustHeld = false;
    brakeHeld = false;
    firing = false;
    net.setSpectating();
    phase.value = GamePhase.spectating;
    overlays.add(overlaySpectate);
    _followedId = null;
    followedPlayer.value = null;
    _ensureSpectatorFollow();
    _showToast('Idle — now spectating');
  }

  void _resetWorld() {
    for (final ship in _ships.values) {
      ship.removeFromParent();
    }
    _ships.clear();
    for (final planet in _planets) {
      planet.removeFromParent();
    }
    _planets.clear();
    for (final powerup in _powerups) {
      powerup.removeFromParent();
    }
    _powerups.clear();
    for (final bullet in world.children.query<Bullet>()) {
      bullet.removeFromParent();
    }
    _lastStateMs.clear();
    camera.viewfinder.position = worldSize / 2;
  }

  // --- networking callbacks -------------------------------------------------

  void _onRoster(List<PresenceMember> members) {
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final member in members) {
      _members[member.id] = member;
      // Give a newly-seen playing pilot the full grace window before their
      // first broadcast arrives, so they aren't flagged inactive at the start.
      if (member.isPlaying && member.id != player.id) {
        _lastStateMs.putIfAbsent(member.id, () => now);
      }
    }
    roster.value = members;

    final presentIds = members.map((member) => member.id).toSet();

    // Re-send our owned planets so anyone who just joined (e.g. a spectator)
    // sees the current ownership. Each owner re-broadcasts only its own
    // planets; earliest-wins reconciliation makes this idempotent.
    final newcomers = presentIds.difference(_previousPresentIds);
    _previousPresentIds
      ..clear()
      ..addAll(presentIds);
    if (newcomers.isNotEmpty &&
        newcomers.any((id) => id != player.id) &&
        phase.value == GamePhase.playing) {
      _rebroadcastOwnedCaptures();
    }

    // Drop ships + release planets for players who left.
    final departedPlayerIds = _ships.keys
        .where((id) => id != player.id && !presentIds.contains(id))
        .toList();
    for (final id in departedPlayerIds) {
      _ships.remove(id)?.removeFromParent();
      for (final planet in _planets) {
        if (planet.ownerId == id) {
          planet
            ..ownerId = null
            ..ownerColor = null
            ..capturedAt = 0;
        }
      }
    }
    _ensureSpectatorFollow();
    if (phase.value != GamePhase.lobby) {
      _recomputeScores();
    }
  }

  void _rebroadcastOwnedCaptures() {
    for (final planet in _planets) {
      if (planet.ownerId == player.id) {
        net.sendCapture(
          CaptureEvent(
            planetId: planet.specification.id,
            ownerId: player.id,
            capturedAt: planet.capturedAt,
          ),
        );
      }
    }
  }

  void _onShipState(ShipState state) {
    // Remote ships exist whenever a match is running, whether we are playing
    // or spectating it.
    if (phase.value != GamePhase.playing &&
        phase.value != GamePhase.spectating) {
      return;
    }
    _lastStateMs[state.id] = DateTime.now().millisecondsSinceEpoch;
    var ship = _ships[state.id] as RemoteShip?;
    if (ship == null) {
      ship = RemoteShip(
        id: state.id,
        shipName: state.name,
        color: Color(state.color),
        position: Vector2(state.positionX, state.positionY),
      );
      _ships[state.id] = ship;
      world.add(ship);
      _ensureSpectatorFollow();
    }
    ship.applyState(
      positionX: state.positionX,
      positionY: state.positionY,
      facing: state.angle,
      velocityX: state.velocityX,
      velocityY: state.velocityY,
      alive: state.alive,
    );
  }

  void _onShot(ShotEvent event) {
    spawnBullet(
      ownerId: event.ownerId,
      origin: Vector2(event.positionX, event.positionY),
      angle: event.angle,
      speed: event.speed,
      homing: event.homing,
    );
  }

  void _onCapture(CaptureEvent event) {
    final planet = _planetById(event.planetId);
    if (planet == null) {
      return;
    }
    // Latest-wins reconciliation, so a planet can always be taken over by a
    // more recent capture — including when several ships contest one already
    // owned. A capture is accepted only if it is strictly newer than the
    // current ownership, or, on an exact-timestamp tie, has the higher ownerId
    // (a stable tiebreak so every client converges on the same owner). This
    // also harmlessly ignores an owner re-broadcasting its existing capture.
    if (planet.capturedAt != 0) {
      final current = planet.capturedAt;
      final winsByTime = event.capturedAt > current;
      final winsByTiebreak =
          event.capturedAt == current &&
          event.ownerId.compareTo(planet.ownerId ?? '') > 0;
      if (!winsByTime && !winsByTiebreak) {
        return;
      }
    }
    planet
      ..ownerId = event.ownerId
      ..ownerColor = Color(_members[event.ownerId]?.color ?? 0xFFFFFFFF)
      ..capturedAt = event.capturedAt;
    _recomputeScores();
  }

  // --- helpers used by components ------------------------------------------

  void fireBullet({
    required String ownerId,
    required Vector2 origin,
    required double angle,
    required double speed,
    bool homing = false,
  }) {
    spawnBullet(
      ownerId: ownerId,
      origin: origin,
      angle: angle,
      speed: speed,
      homing: homing,
    );
    net.sendShot(
      ShotEvent(
        id: '${player.id}-${DateTime.now().microsecondsSinceEpoch}',
        ownerId: ownerId,
        positionX: origin.x,
        positionY: origin.y,
        angle: angle,
        speed: speed,
        firedAt: DateTime.now().millisecondsSinceEpoch,
        homing: homing,
      ),
    );
  }

  void spawnBullet({
    required String ownerId,
    required Vector2 origin,
    required double angle,
    required double speed,
    bool homing = false,
  }) {
    world.add(
      Bullet(
        ownerId: ownerId,
        animation: bulletAnimation,
        position: origin.clone(),
        velocity: Vector2(cos(angle), sin(angle))..scale(speed),
        homing: homing,
      ),
    );
  }

  void broadcastShipState(LocalShip ship) {
    net.sendState(
      ShipState(
        id: player.id,
        name: player.name,
        color: player.colorValue,
        positionX: ship.position.x,
        positionY: ship.position.y,
        angle: ship.facing,
        velocityX: ship.velocity.x,
        velocityY: ship.velocity.y,
        alive: ship.alive,
      ),
    );
  }

  // --- main loop ------------------------------------------------------------

  @override
  void update(double deltaTime) {
    // Refresh the living-ship list before the component tree updates, so homing
    // bullets (updated inside super.update) can query it this frame.
    _livingShips.clear();
    for (final ship in _ships.values) {
      if (ship.alive) {
        _livingShips.add(ship);
      }
    }

    super.update(deltaTime);

    // Re-project the cursor to world space each frame. The camera follows the
    // ship, so a stationary cursor keeps the same screen-relative aim direction
    // instead of the ship turning back toward a stale world point.
    if (_hasPointer) {
      camera.globalToLocal(_lastPointerScreen, output: aimWorld);
    }

    // Clear the toast regardless of phase, so it doesn't linger.
    if (_toastTimer > 0) {
      _toastTimer -= deltaTime;
      if (_toastTimer <= 0) {
        toastMessage.value = null;
      }
    }

    final playing = phase.value == GamePhase.playing;
    final spectating = phase.value == GamePhase.spectating;
    if (!playing && !spectating) {
      return;
    }

    // AFK guard: a pilot who gives no input for a while is moved to the
    // spectator camera so they stop occupying the match.
    if (playing) {
      _idleSeconds += deltaTime;
      if (_idleSeconds >= _idleTimeout) {
        _goIdleSpectator();
        return;
      }
    }

    // The countdown runs identically for players and spectators. Only reformat
    // the clock string when the whole-second value changes, so the per-frame
    // path allocates nothing.
    final countdown = _countdown;
    if (countdown != null) {
      final remainingMilliseconds = countdown.remainingMilliseconds();
      final remainingSeconds = remainingMilliseconds ~/ 1000;
      if (remainingSeconds != _lastClockSeconds) {
        _lastClockSeconds = remainingSeconds;
        clock.value = Countdown.formatSeconds(remainingSeconds);
      }
      if (remainingMilliseconds == 0) {
        _endMatch();
        return;
      }
    }

    // Captures and powerup pickups run in their own components
    // (CaptureController / PowerupController); bullet hits are handled by the
    // local ship's collision callback (victim-authoritative).

    _scoreTimer -= deltaTime;
    if (_scoreTimer <= 0) {
      _scoreTimer = 0.5;
      _recomputeScores();
    }
  }

  /// A peer picked up a powerup: animate the same one away on our side.
  void _onPowerupTaken(PowerupTakenEvent event) {
    for (final powerup in _powerups) {
      if (powerup.id == event.powerupId && !powerup.collected) {
        powerup.collect();
        break;
      }
    }
  }

  /// Shows a short-lived center-screen toast to the local player.
  void _showToast(String message) {
    toastMessage.value = message;
    _toastTimer = _toastDuration;
  }

  /// Toast text for taking a planet that was [previousOwnerId]'s (or nobody's).
  String _captureMessage(String? previousOwnerId) {
    if (previousOwnerId == null) {
      return 'Planet taken';
    }
    final name = _members[previousOwnerId]?.name ?? 'someone';
    return 'Planet taken from $name';
  }

  // --- taunts ---------------------------------------------------------------

  /// Plays [emoji] with a random taunt phrase over the local ship and tells
  /// peers to show the same over our ship.
  void sendTaunt(String emoji) {
    if (_ships[player.id] == null) {
      return;
    }
    markActivity();
    final phrase = Taunts.randomPhrase();
    _showTaunt(player.id, emoji, phrase);
    net.sendTaunt(TauntEvent(byId: player.id, emoji: emoji, taunt: phrase));
  }

  void _onTaunt(TauntEvent event) =>
      _showTaunt(event.byId, event.emoji, event.taunt);

  /// Shows a taunt bubble above [shipId]'s ship, replacing any current one.
  void _showTaunt(String shipId, String emoji, String taunt) {
    final ship = _ships[shipId];
    if (ship == null) {
      return;
    }
    for (final bubble in ship.children.whereType<TauntBubble>().toList()) {
      bubble.removeFromParent();
    }
    ship.add(
      TauntBubble(
        emoji: emoji,
        taunt: taunt,
        position: Vector2(ship.size.x / 2, -28),
      ),
    );
  }

  /// The position of the nearest living enemy ship within [maxDistance] of
  /// [from], or null. Used by homing bullets; returns the live ship vector
  /// (read-only) to avoid allocating. Compares squared distances to avoid a
  /// `sqrt` per ship, and scans the cached [_livingShips] list.
  Vector2? nearestEnemyShipPosition(
    String ownerId,
    Vector2 from,
    double maxDistance,
  ) {
    Vector2? nearest;
    var nearestSquared = maxDistance * maxDistance;
    for (final ship in _livingShips) {
      if (ship.id == ownerId) {
        continue;
      }
      final squared = ship.position.distanceToSquared(from);
      if (squared < nearestSquared) {
        nearestSquared = squared;
        nearest = ship.position;
      }
    }
    return nearest;
  }


  void _recomputeScores() {
    final planetCounts = <String, int>{};
    for (final planet in _planets) {
      final owner = planet.ownerId;
      if (owner != null) {
        planetCounts[owner] = (planetCounts[owner] ?? 0) + 1;
      }
    }
    // The planet ranking only includes active players. Spectators (anyone
    // watching, including pilots who went idle) are listed separately, and
    // lobby members who aren't in this match are left out entirely.
    final now = DateTime.now().millisecondsSinceEpoch;
    final players = <ScoreEntry>[];
    final spectators = <ScoreEntry>[];
    for (final member in _members.values) {
      if (member.isPlaying && _isActivePlayer(member.id, now)) {
        players.add(
          ScoreEntry(
            id: member.id,
            name: member.name,
            color: Color(member.color),
            planets: planetCounts[member.id] ?? 0,
          ),
        );
      } else if (member.isPlaying || member.isSpectating) {
        // Spectators, plus "playing" pilots we've stopped hearing from (a
        // frozen background tab that never demoted itself). Drop the latter's
        // parked ghost ship so it isn't a stray bullet-sink / homing target.
        if (member.id != player.id) {
          _ships.remove(member.id)?.removeFromParent();
        }
        spectators.add(
          ScoreEntry(
            id: member.id,
            name: member.name,
            color: Color(member.color),
            planets: 0,
            spectating: true,
          ),
        );
      }
    }
    players.sort((first, second) => second.planets.compareTo(first.planets));
    scores.value = [...players, ...spectators];
  }

  /// Whether a `playing` member is genuinely active: ourselves always, or a
  /// remote whose last broadcast is recent enough (see [_lastStateMs]).
  bool _isActivePlayer(String id, int nowMs) {
    if (id == player.id) {
      return true;
    }
    final lastHeard = _lastStateMs[id];
    return lastHeard != null && nowMs - lastHeard <= _inactivePlayerTimeoutMs;
  }

  PlanetComponent? _planetById(int id) {
    for (final planet in _planets) {
      if (planet.specification.id == id) {
        return planet;
      }
    }
    return null;
  }

  // --- input ----------------------------------------------------------------
  //
  // Aim follows the cursor via hover ([onPointerMove]); holding the primary
  // button fires. A stationary press is a tap, and a press that moves becomes a
  // drag, so firing is driven from both — and a drag also re-aims, since hover
  // events stop while a button is held.

  @override
  void onPointerMove(PointerMoveEvent event) {
    aimAtScreen(event.localPosition.x, event.localPosition.y);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Browsers block audio until a user gesture, so kick off the music on the
    // first interaction (idempotent / settings-gated).
    SoundService.instance.startMusic();
    firing = true;
    markActivity();
  }

  @override
  void onTapUp(TapUpEvent event) => firing = false;

  @override
  void onTapCancel(TapCancelEvent event) => firing = false;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    SoundService.instance.startMusic();
    firing = true;
    aimAtScreen(event.localPosition.x, event.localPosition.y);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    aimAtScreen(event.localEndPosition.x, event.localEndPosition.y);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    firing = false;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    firing = false;
  }

  /// Records the cursor's widget-local position to aim the local ship at.
  /// The screen position is stored (not converted here); [aimWorld] is derived
  /// from it every frame in [update] so it stays correct as the camera moves.
  void aimAtScreen(double x, double y) {
    _lastPointerScreen.setValues(x, y);
    _hasPointer = true;
    markActivity();
  }

  @override
  void onRemove() {
    if (_sessionStarted) {
      net.dispose();
    }
    phase.dispose();
    roster.dispose();
    clock.dispose();
    scores.dispose();
    outcome.dispose();
    highScores.dispose();
    toastMessage.dispose();
    spectateIntent.dispose();
    followedPlayer.dispose();
    super.onRemove();
  }
}

/// Drives planet capture for the local player: holding the ship over a planet
/// for [SpaceGame.captureSeconds] fills its ring and takes it. Lives in the
/// same library as [SpaceGame] so it can read its private state. Active only
/// while playing; resets itself otherwise.
class CaptureController extends Component with HasGameReference<SpaceGame> {
  int? _capturingPlanetId;
  double _elapsed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.phase.value != GamePhase.playing) {
      _capturingPlanetId = null;
      _elapsed = 0;
      return;
    }
    final ship = game._ships[game.player.id] as LocalShip?;
    if (ship == null) {
      return;
    }

    PlanetComponent? hovered;
    for (final planet in game._planets) {
      final radius = planet.radius;
      if (planet.center.distanceToSquared(ship.position) <= radius * radius) {
        hovered = planet;
        break;
      }
    }
    for (final planet in game._planets) {
      if (planet != hovered) {
        planet.captureProgress = 0;
      }
    }

    if (hovered == null) {
      _capturingPlanetId = null;
      _elapsed = 0;
      return;
    }
    if (_capturingPlanetId != hovered.specification.id) {
      _capturingPlanetId = hovered.specification.id;
      _elapsed = 0;
    }
    if (hovered.ownerId == game.player.id) {
      hovered.captureProgress = 1;
      return;
    }

    _elapsed += dt;
    hovered.captureProgress = (_elapsed / SpaceGame.captureSeconds).clamp(0, 1);

    if (_elapsed >= SpaceGame.captureSeconds) {
      final previousOwnerId = hovered.ownerId;
      final capturedAt = DateTime.now().millisecondsSinceEpoch;
      hovered
        ..ownerId = game.player.id
        ..ownerColor = game.player.color
        ..capturedAt = capturedAt;
      game.net.sendCapture(
        CaptureEvent(
          planetId: hovered.specification.id,
          ownerId: game.player.id,
          capturedAt: capturedAt,
        ),
      );
      game._showToast(game._captureMessage(previousOwnerId));
      _elapsed = 0;
      game._recomputeScores();
    }
  }
}

/// Drives powerup pickup for the local player — same hold-to-acquire mechanic
/// as [CaptureController]: hold over a powerup to fill its ring, then apply the
/// effect, toast, animate it away and tell peers. Active only while playing.
class PowerupController extends Component with HasGameReference<SpaceGame> {
  int? _capturingPowerupId;
  double _elapsed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.phase.value != GamePhase.playing) {
      _capturingPowerupId = null;
      _elapsed = 0;
      return;
    }
    final ship = game._ships[game.player.id] as LocalShip?;
    if (ship == null) {
      return;
    }

    PowerupComponent? hovered;
    final shipRadius = ship.radius;
    for (final powerup in game._powerups) {
      if (powerup.collected) {
        continue;
      }
      final reach = powerup.radius + shipRadius;
      if (powerup.position.distanceToSquared(ship.position) <= reach * reach) {
        hovered = powerup;
        break;
      }
    }
    for (final powerup in game._powerups) {
      if (powerup != hovered) {
        powerup.captureProgress = 0;
      }
    }

    if (hovered == null) {
      _capturingPowerupId = null;
      _elapsed = 0;
      return;
    }
    if (_capturingPowerupId != hovered.id) {
      _capturingPowerupId = hovered.id;
      _elapsed = 0;
    }

    _elapsed += dt;
    hovered.captureProgress = (_elapsed / SpaceGame.captureSeconds).clamp(0, 1);

    if (_elapsed >= SpaceGame.captureSeconds) {
      hovered.collect();
      ship.applyPowerup(hovered.type);
      game._showToast(hovered.type.pickupMessage);
      SoundService.instance.playSoundEffect(SoundEffect.powerup);
      game.net.sendPowerupTaken(
        PowerupTakenEvent(powerupId: hovered.id, byId: game.player.id),
      );
      _capturingPowerupId = null;
      _elapsed = 0;
    }
  }
}
