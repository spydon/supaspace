/// Match length, and helpers to compute/format the shared countdown from the
/// broadcast `startedAt` epoch timestamp. Driven off wall-clock so all clients
/// agree (modulo small clock skew).
class Countdown {
  Countdown({required this.startedAt, this.duration = gameDuration});

  static const gameDuration = Duration(minutes: 3);

  final int startedAt; // epoch ms
  final Duration duration;

  Duration remaining() => Duration(milliseconds: remainingMilliseconds());

  /// Milliseconds left, as an int so the per-frame caller can read the clock
  /// without allocating a [Duration].
  int remainingMilliseconds() {
    final elapsed = DateTime.now().millisecondsSinceEpoch - startedAt;
    final left = duration.inMilliseconds - elapsed;
    return left < 0 ? 0 : left;
  }

  bool get isOver => remainingMilliseconds() == 0;

  static String format(Duration duration) => formatSeconds(duration.inSeconds);

  static String formatSeconds(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
