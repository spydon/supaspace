import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'high_score_service.freezed.dart';
part 'high_score_service.g.dart';

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

/// Reads and updates the persistent high score in Postgres.
///
/// Awarding a point goes through the `report_winner` database function, which
/// is the only path allowed to write the table. Every client reports who it
/// thinks won a match; the function awards the point once more than half of the
/// reporting players name the same winner (and still caps it at one point per 5
/// minutes). Reads use the public select policy.
class HighScoreService {
  HighScoreService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<HighScore>> fetchTop({int limit = 10}) async {
    final rows = await _client
        .from('high_scores')
        .select('player_name, points')
        .order('points', ascending: false)
        .limit(limit);
    return rows.map(HighScore.fromJson).toList();
  }

  /// Reports this client's view of who won [matchId] (a winner's account id and
  /// name, plus how many players took part). The database awards the winner a
  /// point once a majority of reporters agree.
  Future<void> reportWinner({
    required int matchId,
    required String winnerId,
    required String winnerName,
    required int participantCount,
  }) async {
    await _client.rpc<void>(
      'report_winner',
      params: {
        'match_id': matchId,
        'winner_id': winnerId,
        'winner_name': winnerName,
        'participant_count': participantCount,
      },
    );
  }
}
