import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:supaspace/game/sound_service.dart';
import 'package:supaspace/game/space_game.dart';
import 'package:supaspace/ui/hud_overlay.dart';
import 'package:supaspace/ui/lobby_overlay.dart';
import 'package:supaspace/ui/name_overlay.dart';
import 'package:supaspace/ui/results_overlay.dart';
import 'package:supaspace/ui/spectate_overlay.dart';

class SupaspaceApp extends StatelessWidget {
  const SupaspaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supaspace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const _GamePage(),
    );
  }
}

class _GamePage extends StatefulWidget {
  const _GamePage();

  @override
  State<_GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<_GamePage> {
  // The game needs this focus node to receive keyboard input (thrust/brake).
  // Overlays with text fields (e.g. the call-sign form) can steal focus, so
  // the game requests it back through this node when they close.
  final FocusNode _gameFocusNode = FocusNode(debugLabel: 'SpaceGame');

  @override
  void dispose() {
    _gameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060F),
      // In-game input (aim, fire) is handled inside the game via Flame's
      // pointer/tap/drag callbacks. Overlay buttons are Flutter widgets whose
      // taps never reach the game, so each overlay is wrapped to start the
      // music on the first interaction (which also satisfies web autoplay).
      body: GameWidget<SpaceGame>.controlled(
        gameFactory: () => SpaceGame()..gameFocusNode = _gameFocusNode,
        focusNode: _gameFocusNode,
        // Shown while the game's onLoad preloads images, animations and audio.
        loadingBuilder: (_) => const _Loading(),
        overlayBuilderMap: {
          SpaceGame.overlayName: (_, game) =>
              _StartsMusic(child: NameOverlay(game: game)),
          SpaceGame.overlayLobby: (_, game) =>
              _StartsMusic(child: LobbyOverlay(game: game)),
          SpaceGame.overlayHud: (_, game) =>
              _StartsMusic(child: HudOverlay(game: game)),
          SpaceGame.overlayResults: (_, game) =>
              _StartsMusic(child: ResultsOverlay(game: game)),
          SpaceGame.overlaySpectate: (_, game) =>
              _StartsMusic(child: SpectateOverlay(game: game)),
        },
      ),
    );
  }
}

/// In-game loading screen shown while the game preloads its assets. Matches the
/// HTML loader in `web/index.html` so the hand-off is seamless.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF05060F),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SUPASPACE',
              style: TextStyle(
                color: Color(0xFF66E0FF),
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 6,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: Color(0xFF66E0FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Starts the background music on the first pointer-down within [child].
///
/// Overlay buttons are plain Flutter widgets, so tapping them never reaches the
/// game's Flame input — this kicks off the music (idempotent, settings-gated)
/// on the first overlay interaction. The default [HitTestBehavior.deferToChild]
/// means it only fires for taps that land on overlay content, so taps on empty
/// areas still fall through to the game.
class _StartsMusic extends StatelessWidget {
  const _StartsMusic({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => SoundService.instance.startMusic(),
      child: child,
    );
  }
}
