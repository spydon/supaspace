import 'package:flutter/material.dart';
import 'package:supaspace/game/space_game.dart';

/// End-of-match screen: winner + final standings, with a button back to the
/// lobby for another round.
///
/// Fades and scales in when the match ends, and plays the same transition in
/// reverse before returning to the lobby, so neither change snaps.
class ResultsOverlay extends StatefulWidget {
  const ResultsOverlay({required this.game, super.key});

  final SpaceGame game;

  @override
  State<ResultsOverlay> createState() => _ResultsOverlayState();
}

class _ResultsOverlayState extends State<ResultsOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.96,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  bool _leaving = false;

  /// Plays the entrance transition in reverse, then hands back to the lobby.
  Future<void> _returnToLobby() async {
    if (_leaving) {
      return;
    }
    _leaving = true;
    await _controller.reverse();
    widget.game.returnToLobby();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return Center(
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
            constraints: const BoxConstraints(maxWidth: 460),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0C1A).withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB388FF).withValues(alpha: 0.2),
                  blurRadius: 44,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ValueListenableBuilder<MatchOutcome?>(
              valueListenable: game.outcome,
              builder: (context, outcome, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'GAME OVER',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 13,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _OutcomeHeadline(outcome: outcome),
                    const SizedBox(height: 22),
                    // Frozen final standings (see MatchOutcome.standings), so
                    // pilots stay listed even after they head to the lobby.
                    Column(
                      children: (outcome?.standings ?? const <ScoreEntry>[])
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  Text(
                                    entry.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${entry.planets}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 26),
                    TextButton(
                      onPressed: _returnToLobby,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 13,
                        ),
                      ),
                      child: const Text(
                        'BACK TO LOBBY',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}

/// The headline shown above the standings: a sole winner, a tie between the top
/// players, or a no-captures draw.
class _OutcomeHeadline extends StatelessWidget {
  const _OutcomeHeadline({required this.outcome});

  final MatchOutcome? outcome;

  @override
  Widget build(BuildContext context) {
    final outcome = this.outcome;
    if (outcome == null || !outcome.hasCaptures) {
      return const Text(
        'No planets captured — a draw!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    if (outcome.isTie) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final leader in outcome.leaders)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _Glow(color: leader.color),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "It's a draw!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            '${outcome.leaders.length} pilots tied with '
            '${outcome.topPlanets} planets',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      );
    }

    final winner = outcome.winner;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Glow(color: winner.color),
        const SizedBox(height: 12),
        Text(
          '${winner.name} wins!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '${winner.planets} planets captured',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 16)],
      ),
    );
  }
}
