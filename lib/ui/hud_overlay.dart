import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supaspace/game/game_phase.dart';
import 'package:supaspace/game/space_game.dart';
import 'package:supaspace/game/taunts.dart';

/// In-game HUD: the shared countdown, the live planet scoreboard (top-right),
/// the powerup toast and taunts. On mobile the countdown sits under the
/// scoreboard and on-screen thrust/brake controls are added bottom-left.
class HudOverlay extends StatelessWidget {
  const HudOverlay({required this.game, super.key});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    final isMobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    final clock = ValueListenableBuilder<String>(
      valueListenable: game.clock,
      builder: (context, value, _) => _ClockChip(value),
    );

    return Stack(
      children: [
        // Scoreboard top-right; on mobile the countdown sits underneath it.
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<List<ScoreEntry>>(
                  valueListenable: game.scores,
                  builder: (context, entries, _) => _Scoreboard(
                    entries: entries,
                    youId: game.player.id,
                  ),
                ),
                if (isMobile) ...[const SizedBox(height: 12), clock],
              ],
            ),
          ),
        ),
        // On desktop the countdown is centered at the top.
        if (!isMobile)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: clock,
            ),
          ),
        Align(
          child: ValueListenableBuilder<String?>(
            valueListenable: game.toastMessage,
            builder: (context, message, _) => _Toast(message: message),
          ),
        ),
        // Taunt buttons, only while you have a ship to taunt from.
        Align(
          alignment: Alignment.bottomRight,
          child: ValueListenableBuilder<GamePhase>(
            valueListenable: game.phase,
            builder: (context, phase, _) => phase == GamePhase.playing
                ? _TauntBar(game: game)
                : const SizedBox.shrink(),
          ),
        ),
        // On-screen thrust/brake controls (mobile only), above the taunt row.
        if (isMobile)
          Align(
            alignment: Alignment.bottomLeft,
            child: ValueListenableBuilder<GamePhase>(
              valueListenable: game.phase,
              builder: (context, phase, _) => phase == GamePhase.playing
                  ? _ThrustControls(game: game)
                  : const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }
}

/// On-screen thrust + brake buttons for touch devices. Lifted above the taunt
/// row so the two don't collide on narrow screens.
class _ThrustControls extends StatelessWidget {
  const _ThrustControls({required this.game});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 88),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ControlButton(
            icon: Icons.keyboard_arrow_up,
            onHold: (held) => game.thrustHeld = held,
          ),
          const SizedBox(width: 12),
          _ControlButton(
            icon: Icons.stop,
            onHold: (held) => game.brakeHeld = held,
          ),
        ],
      ),
    );
  }
}

/// A hold-to-activate control button (press = on, release = off).
class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, required this.onHold});

  final IconData icon;
  final ValueChanged<bool> onHold;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onHold(true),
      onPointerUp: (_) => onHold(false),
      onPointerCancel: (_) => onHold(false),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF0A0C1A).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.85),
          size: 30,
        ),
      ),
    );
  }
}

/// A row of taunt emoji buttons; tapping one plays that taunt over your ship.
class _TauntBar extends StatelessWidget {
  const _TauntBar({required this.game});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final emoji in Taunts.emojis)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _TauntButton(
                emoji: emoji,
                onTap: () => game.sendTaunt(emoji),
              ),
            ),
        ],
      ),
    );
  }
}

class _TauntButton extends StatelessWidget {
  const _TauntButton({required this.emoji, required this.onTap});

  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF0A0C1A).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

/// Center-screen banner for a transient notice (a powerup picked up, e.g.
/// "Bullet Speed +1", or a planet taken). It pops in (scale + fade) when the
/// message appears and animates back out when it clears.
class _Toast extends StatelessWidget {
  const _Toast({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: message == null
          ? const SizedBox.shrink()
          : Container(
              key: ValueKey(message),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0C1A).withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF66E0FF).withValues(alpha: 0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF66E0FF).withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                message!,
                style: const TextStyle(
                  color: Color(0xFF66E0FF),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
    );
  }
}

class _ClockChip extends StatelessWidget {
  const _ClockChip(this.value);
  final String value;

  @override
  Widget build(BuildContext context) {
    final isLowOnTime =
        value.startsWith('00:') &&
        (int.tryParse(value.substring(3)) ?? 60) <= 30;
    final color = isLowOnTime ? const Color(0xFFFF6B6B) : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0C1A).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 16),
        ],
      ),
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 34,
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard({required this.entries, required this.youId});

  final List<ScoreEntry> entries;
  final String youId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0C1A).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PLANETS',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          ...entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: entry.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 130,
                    child: Text(
                      entry.name + (entry.id == youId ? ' (you)' : ''),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: entry.id == youId
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.planets}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
