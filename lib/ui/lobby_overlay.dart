import 'package:flutter/material.dart';
import 'package:supaspace/game/net/models/models.dart';
import 'package:supaspace/game/space_game.dart';
import 'package:supaspace/ui/settings_dialog.dart';

/// Pre-game lobby: shows the live presence roster and a Start button that
/// unlocks once at least two pilots are connected. Anyone may start.
class LobbyOverlay extends StatelessWidget {
  const LobbyOverlay({required this.game, super.key});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    // Centre the panel, but let it scroll on short windows instead of
    // overflowing.
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // Fade the panel in whenever the lobby appears (boot, or
                  // after a match) so the transition into it is smooth.
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOut,
                    builder: (context, value, child) =>
                        Opacity(opacity: value, child: child),
                    child: _LobbyPanel(game: game),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: IconButton(
            tooltip: 'Settings',
            icon: Icon(
              Icons.settings,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            onPressed: () => showSettingsDialog(context),
          ),
        ),
      ],
    );
  }

}

/// The lobby's centered content panel: title, your call sign, the live roster,
/// the start/spectate actions, the leaderboard and the controls.
class _LobbyPanel extends StatelessWidget {
  const _LobbyPanel({required this.game});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Title('Supaspace'),
          const SizedBox(height: 6),
          Text(
            'Capture the most planets in 5 minutes',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 6),
          _PlayingAs(game: game),
          const SizedBox(height: 14),
          ValueListenableBuilder<List<PresenceMember>>(
            valueListenable: game.roster,
            builder: (context, members, _) {
              final sorted = [...members]
                ..sort(
                  (first, second) => first.id == game.player.id ? -1 : 1,
                );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PILOTS IN LOBBY · ${members.length}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...sorted.map(
                    (member) => _RosterEntry(
                      // Keyed by id so existing rows keep their state (and
                      // don't re-animate) while a new pilot animates in.
                      key: ValueKey(member.id),
                      label:
                          member.name +
                          (member.id == game.player.id ? '  (you)' : ''),
                      color: Color(member.color),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _LobbyActions(game: game, playerCount: members.length),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _HighScores(game: game),
          const SizedBox(height: 24),
          const _Controls(),
        ],
      ),
    );
  }
}

/// Shows the player's own call sign with a shortcut to change it. The chosen
/// name is remembered across sessions.
class _PlayingAs extends StatelessWidget {
  const _PlayingAs({required this.game});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Playing as ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
        Text(
          game.player.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: game.openNameEditor,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF66E0FF),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Change', style: TextStyle(fontSize: 13)),
        ),
      ],
    );
  }
}

/// A single pilot row in the lobby roster. It grows in height and fades into
/// place the first time it is shown, so a pilot who just joined animates in
/// (pushing the rows below down) instead of popping into existence. Existing
/// rows keep their state via their [ValueKey], so they don't re-animate.
class _RosterEntry extends StatelessWidget {
  const _RosterEntry({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final clamped = value.clamp(0.0, 1.0);
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: clamped,
            child: Opacity(opacity: clamped, child: child),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Dot(color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

/// Persistent leaderboard, visible in the lobby. Each match win is worth one
/// point (capped at one per 5 minutes by the database).
class _HighScores extends StatelessWidget {
  const _HighScores({required this.game});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<HighScore>>(
      valueListenable: game.highScores,
      builder: (context, scores, _) {
        return Column(
          children: [
            Text(
              'HIGH SCORES',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            if (scores.isEmpty)
              Text(
                'No games won yet — be the first!',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 12,
                ),
              )
            else
              ...scores.asMap().entries.map(
                (indexed) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 26,
                        child: Text(
                          '${indexed.key + 1}.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: Text(
                          indexed.value.playerName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${indexed.value.points}',
                        style: const TextStyle(
                          color: Color(0xFF66E0FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// The lobby's main action area: either spectate a match already in progress,
/// or pick a Play/Spectate role and start the next one.
class _LobbyActions extends StatelessWidget {
  const _LobbyActions({required this.game, required this.playerCount});

  final SpaceGame game;
  final int playerCount;

  @override
  Widget build(BuildContext context) {
    if (game.isLiveGameRunning) {
      final canJoin = game.canJoinLiveGame;
      final playing = game.liveGamePlayerCount;
      return Column(
        children: [
          if (canJoin) ...[
            _PrimaryButton(
              label: 'JOIN GAME',
              enabled: true,
              onPressed: game.joinLiveGame,
            ),
            const SizedBox(height: 8),
          ],
          _PrimaryButton(
            label: 'SPECTATE LIVE GAME',
            enabled: true,
            onPressed: game.spectateLiveGame,
          ),
          const SizedBox(height: 8),
          _Hint(
            canJoin
                ? 'A match is in progress ($playing/${SpaceGame.maxPlayers}) — '
                      'jump in or watch'
                : 'Match is full (${SpaceGame.maxPlayers}/'
                      '${SpaceGame.maxPlayers}) — spectating only',
          ),
        ],
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: game.spectateIntent,
      builder: (context, spectate, _) {
        return Column(
          children: [
            _ModeToggle(
              spectating: spectate,
              onChanged: (_) => game.toggleSpectateIntent(),
            ),
            const SizedBox(height: 16),
            if (spectate)
              const _Hint('You will spectate when a match starts')
            else ...[
              _PrimaryButton(
                label: 'START GAME',
                enabled: playerCount >= 2,
                onPressed: game.startMatch,
              ),
              const SizedBox(height: 8),
              if (playerCount < 2)
                const _Hint('Waiting for at least one more pilot…'),
            ],
          ],
        );
      },
    );
  }
}

/// A small dimmed hint line under the lobby actions.
class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.45),
        fontSize: 12,
      ),
    );
  }
}

/// A two-option Play / Spectate switch.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.spectating, required this.onChanged});

  final bool spectating;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            label: 'Play',
            selected: !spectating,
            onTap: () => onChanged(false),
          ),
          _Segment(
            label: 'Spectate',
            selected: spectating,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

/// One option of the Play / Spectate switch.
class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withValues(alpha: 0.16) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.55),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: enabled
            ? const LinearGradient(
                colors: [Color(0xFF66E0FF), Color(0xFFB388FF)],
              )
            : null,
        color: enabled ? null : Colors.white.withValues(alpha: 0.08),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: const Color(0xFF66E0FF).withValues(alpha: 0.5),
                  blurRadius: 18,
                ),
              ]
            : null,
      ),
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Colors.white.withValues(alpha: 0.6),
      fontSize: 13,
      height: 1.6,
    );
    return Column(
      children: [
        Text(
          'CONTROLS',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text('Mouse — aim    ·    W — thrust    ·    S — brake', style: style),
        Text(
          'Left click (hold) — shoot    ·    Hover a planet 5s to capture',
          style: style,
        ),
      ],
    );
  }
}

// shared bits ----------------------------------------------------------------

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 36),
      constraints: const BoxConstraints(maxWidth: 460),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0C1A).withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF66E0FF).withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF66E0FF), Color(0xFFB388FF)],
      ).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          letterSpacing: 6,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 8),
        ],
      ),
    );
  }
}
