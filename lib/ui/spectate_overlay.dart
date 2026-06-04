import 'package:flutter/material.dart';
import 'package:supaspace/game/space_game.dart';

/// Spectator control bar: a badge plus arrows to change which player the
/// camera follows.
class SpectateOverlay extends StatelessWidget {
  const SpectateOverlay({required this.game, super.key});

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: ValueListenableBuilder<String?>(
          valueListenable: game.followedPlayer,
          builder: (context, followed, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0C1A).withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SPECTATING',
                    style: TextStyle(
                      color: const Color(0xFF66E0FF).withValues(alpha: 0.9),
                      fontSize: 12,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  _ArrowButton(
                    icon: Icons.chevron_left,
                    onPressed: game.followPreviousPlayer,
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      followed ?? 'Waiting for pilots…',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _ArrowButton(
                    icon: Icons.chevron_right,
                    onPressed: game.followNextPlayer,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: Colors.white,
      splashRadius: 20,
    );
  }
}
