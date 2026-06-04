import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaspace/game/game_phase.dart';
import 'package:supaspace/game/net/net_events.dart';
import 'package:supaspace/game/player.dart';

/// A player seen in presence (lobby roster / live participants).
///
/// Players who are mid-match advertise the [seed] and [startedAt] of the
/// running game so a late arrival can reconstruct the identical planet field
/// and countdown and join as a spectator.
class PresenceMember {
  PresenceMember({
    required this.id,
    required this.name,
    required this.color,
    required this.phase,
    this.seed,
    this.startedAt,
  });

  final String id;
  final String name;
  final int color;
  final GamePhase phase;
  final int? seed;
  final int? startedAt;

  bool get isPlaying => phase == GamePhase.playing;
}

/// Owns the single public Supabase Realtime channel for the game.
///
/// - **Presence** drives the lobby roster and disconnect detection.
/// - **Broadcast** carries start, ship state, shots and captures.
///
/// The channel is public (`private: false`) so no auth/Row Level Security is
/// needed — the publishable key is enough. Messages originating from [player]
/// are filtered out so callers only ever see remote events.
///
/// If the channel errors or times out, it is automatically torn down and
/// re-opened after a short delay, re-tracking the current presence so a dropped
/// connection recovers on its own.
class RealtimeClient {
  RealtimeClient({required this.player, SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  static const channelName = 'supaspace';
  static const _reconnectDelay = Duration(seconds: 2);

  final LocalPlayer player;
  final SupabaseClient _client;
  late RealtimeChannel _channel;

  GamePhase _phase = GamePhase.lobby;
  int? _seed;
  int? _startedAt;

  Timer? _reconnectTimer;
  bool _disposed = false;

  // Callbacks wired by the game.
  void Function(List<PresenceMember> members)? onRoster;
  void Function(StartEvent event)? onStart;
  void Function(ShipState state)? onShipState;
  void Function(ShotEvent event)? onShot;
  void Function(CaptureEvent event)? onCapture;
  void Function(PowerupTakenEvent event)? onPowerupTaken;
  void Function(TauntEvent event)? onTaunt;

  Future<void> connect() async => _openChannel();

  void _openChannel() {
    _channel = _client.channel(channelName);

    _channel
        .onPresenceSync((_) => _emitRoster())
        .onPresenceJoin((_) => _emitRoster())
        .onPresenceLeave((_) => _emitRoster())
        .onBroadcast(
          event: NetworkEvent.start.name,
          callback: (payload) =>
              onStart?.call(StartEvent.fromJson(_data(payload))),
        )
        .onBroadcast(
          event: NetworkEvent.state.name,
          callback: (payload) {
            final state = ShipState.fromJson(_data(payload));
            if (state.id == player.id) {
              return; // ignore echoes of self
            }
            onShipState?.call(state);
          },
        )
        .onBroadcast(
          event: NetworkEvent.shot.name,
          callback: (payload) {
            final shot = ShotEvent.fromJson(_data(payload));
            if (shot.ownerId == player.id) {
              return;
            }
            onShot?.call(shot);
          },
        )
        .onBroadcast(
          event: NetworkEvent.capture.name,
          callback: (payload) =>
              onCapture?.call(CaptureEvent.fromJson(_data(payload))),
        )
        .onBroadcast(
          event: NetworkEvent.powerup.name,
          callback: (payload) {
            final event = PowerupTakenEvent.fromJson(_data(payload));
            if (event.byId == player.id) {
              return; // we already collected it locally
            }
            onPowerupTaken?.call(event);
          },
        )
        .onBroadcast(
          event: NetworkEvent.taunt.name,
          callback: (payload) {
            final event = TauntEvent.fromJson(_data(payload));
            if (event.byId == player.id) {
              return; // we already show our own taunt locally
            }
            onTaunt?.call(event);
          },
        );

    _channel.subscribe((status, error) async {
      switch (status) {
        case RealtimeSubscribeStatus.subscribed:
          await _track();
        case RealtimeSubscribeStatus.channelError:
        case RealtimeSubscribeStatus.timedOut:
          _scheduleReconnect();
        case RealtimeSubscribeStatus.closed:
          break;
      }
    });
  }

  /// After a channel error/timeout, tear the channel down and re-open it once,
  /// after a short delay. Guards against overlapping retries and disposal.
  void _scheduleReconnect() {
    if (_disposed || _reconnectTimer != null) {
      return;
    }
    _reconnectTimer = Timer(_reconnectDelay, () async {
      _reconnectTimer = null;
      if (_disposed) {
        return;
      }
      await _client.removeChannel(_channel);
      _openChannel();
    });
  }

  /// Re-broadcast presence after a local identity change (e.g. the player
  /// edited their call sign in the lobby), so peers see the new name.
  Future<void> updatePresence() => _track();

  /// Advertise that this client is back in the lobby.
  Future<void> setLobby() async {
    _phase = GamePhase.lobby;
    _seed = null;
    _startedAt = null;
    await _track();
  }

  /// Advertise that this client is playing the match identified by [seed] /
  /// [startedAt], so late arrivals can spectate it.
  Future<void> setPlaying(int seed, int startedAt) async {
    _phase = GamePhase.playing;
    _seed = seed;
    _startedAt = startedAt;
    await _track();
  }

  /// Advertise that this client is spectating (no ship, not a participant).
  Future<void> setSpectating() async {
    _phase = GamePhase.spectating;
    _seed = null;
    _startedAt = null;
    await _track();
  }

  Future<void> _track() => _channel.track({
    'id': player.id,
    'name': player.name,
    'color': player.colorValue,
    'phase': _phase.name,
    if (_seed != null) 'seed': _seed,
    if (_startedAt != null) 'startedAt': _startedAt,
  });

  void _emitRoster() {
    final byId = <String, PresenceMember>{};
    for (final singleState in _channel.presenceState()) {
      for (final presence in singleState.presences) {
        final payload = presence.payload;
        final id = payload['id'] as String?;
        if (id == null) {
          continue;
        }
        byId[id] = PresenceMember(
          id: id,
          name: payload['name'] as String? ?? 'Pilot',
          color: (payload['color'] as num?)?.toInt() ?? 0xFFFFFFFF,
          phase: GamePhase.fromString(payload['phase'] as String?),
          seed: (payload['seed'] as num?)?.toInt(),
          startedAt: (payload['startedAt'] as num?)?.toInt(),
        );
      }
    }
    onRoster?.call(byId.values.toList());
  }

  // --- senders --------------------------------------------------------------

  void sendStart(StartEvent event) => _send(NetworkEvent.start, event.toJson());
  void sendState(ShipState state) => _send(NetworkEvent.state, state.toJson());
  void sendShot(ShotEvent event) => _send(NetworkEvent.shot, event.toJson());
  void sendCapture(CaptureEvent event) =>
      _send(NetworkEvent.capture, event.toJson());
  void sendPowerupTaken(PowerupTakenEvent event) =>
      _send(NetworkEvent.powerup, event.toJson());
  void sendTaunt(TauntEvent event) => _send(NetworkEvent.taunt, event.toJson());

  void _send(NetworkEvent event, Map<String, dynamic> payload) {
    _channel.sendBroadcastMessage(event: event.name, payload: payload);
  }

  /// The broadcast callback receives the full `{event, payload, type}`
  /// envelope; the data we sent lives under `payload`.
  Map<String, dynamic> _data(Map<String, dynamic> envelope) {
    final inner = envelope['payload'];
    return inner is Map<String, dynamic> ? inner : envelope;
  }

  Future<void> dispose() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _channel.untrack();
    await _client.removeChannel(_channel);
  }
}
