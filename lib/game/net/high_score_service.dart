import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaspace/game/net/models/high_score.dart';

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
