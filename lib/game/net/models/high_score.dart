import 'package:freezed_annotation/freezed_annotation.dart';

part 'high_score.freezed.dart';
part 'high_score.g.dart';

/// One leaderboard row: a player's display name and accumulated points.
@freezed
abstract class HighScore with _$HighScore {
  const factory HighScore({
    @JsonKey(name: 'player_name') @Default('Pilot') String playerName,
    @Default(0) int points,
  }) = _HighScore;

  factory HighScore.fromJson(Map<String, dynamic> json) =>
      _$HighScoreFromJson(json);
}
