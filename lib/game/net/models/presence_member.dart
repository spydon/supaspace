import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supaspace/game/game_phase.dart';

part 'presence_member.freezed.dart';

/// A player seen in presence (lobby roster / live participants).
///
/// Players who are mid-match advertise the [seed] and [startedAt] of the
/// running game so a late arrival can reconstruct the identical planet field
/// and countdown and join as a spectator.
@freezed
abstract class PresenceMember with _$PresenceMember {
  const factory PresenceMember({
    required String id,
    required String name,
    required int color,
    required GamePhase phase,
    int? seed,
    int? startedAt,
  }) = _PresenceMember;

  const PresenceMember._();

  bool get isPlaying => phase == GamePhase.playing;
}
