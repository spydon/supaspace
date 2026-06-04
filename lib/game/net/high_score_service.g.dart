// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'high_score_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HighScore _$HighScoreFromJson(Map<String, dynamic> json) => _HighScore(
  playerName: json['player_name'] as String? ?? 'Pilot',
  points: (json['points'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HighScoreToJson(_HighScore instance) =>
    <String, dynamic>{
      'player_name': instance.playerName,
      'points': instance.points,
    };
