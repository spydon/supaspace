// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StartEvent _$StartEventFromJson(Map<String, dynamic> json) => _StartEvent(
  seed: (json['seed'] as num).toInt(),
  startedAt: (json['startedAt'] as num).toInt(),
);

Map<String, dynamic> _$StartEventToJson(_StartEvent instance) =>
    <String, dynamic>{'seed': instance.seed, 'startedAt': instance.startedAt};

_ShipState _$ShipStateFromJson(Map<String, dynamic> json) => _ShipState(
  id: json['id'] as String,
  name: json['name'] as String,
  color: (json['color'] as num).toInt(),
  positionX: (json['positionX'] as num).toDouble(),
  positionY: (json['positionY'] as num).toDouble(),
  angle: (json['angle'] as num).toDouble(),
  velocityX: (json['velocityX'] as num).toDouble(),
  velocityY: (json['velocityY'] as num).toDouble(),
  alive: json['alive'] as bool? ?? true,
  braking: json['braking'] as bool? ?? false,
);

Map<String, dynamic> _$ShipStateToJson(_ShipState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'angle': instance.angle,
      'velocityX': instance.velocityX,
      'velocityY': instance.velocityY,
      'alive': instance.alive,
      'braking': instance.braking,
    };

_ShotEvent _$ShotEventFromJson(Map<String, dynamic> json) => _ShotEvent(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  positionX: (json['positionX'] as num).toDouble(),
  positionY: (json['positionY'] as num).toDouble(),
  angle: (json['angle'] as num).toDouble(),
  speed: (json['speed'] as num).toDouble(),
  firedAt: (json['firedAt'] as num).toInt(),
  homing: json['homing'] as bool? ?? false,
);

Map<String, dynamic> _$ShotEventToJson(_ShotEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'angle': instance.angle,
      'speed': instance.speed,
      'firedAt': instance.firedAt,
      'homing': instance.homing,
    };

_CaptureEvent _$CaptureEventFromJson(Map<String, dynamic> json) =>
    _CaptureEvent(
      planetId: (json['planetId'] as num).toInt(),
      ownerId: json['ownerId'] as String,
      capturedAt: (json['capturedAt'] as num).toInt(),
    );

Map<String, dynamic> _$CaptureEventToJson(_CaptureEvent instance) =>
    <String, dynamic>{
      'planetId': instance.planetId,
      'ownerId': instance.ownerId,
      'capturedAt': instance.capturedAt,
    };

_PowerupTakenEvent _$PowerupTakenEventFromJson(Map<String, dynamic> json) =>
    _PowerupTakenEvent(
      powerupId: (json['powerupId'] as num).toInt(),
      byId: json['byId'] as String,
    );

Map<String, dynamic> _$PowerupTakenEventToJson(_PowerupTakenEvent instance) =>
    <String, dynamic>{'powerupId': instance.powerupId, 'byId': instance.byId};

_TauntEvent _$TauntEventFromJson(Map<String, dynamic> json) => _TauntEvent(
  byId: json['byId'] as String,
  emoji: json['emoji'] as String,
  taunt: json['taunt'] as String,
);

Map<String, dynamic> _$TauntEventToJson(_TauntEvent instance) =>
    <String, dynamic>{
      'byId': instance.byId,
      'emoji': instance.emoji,
      'taunt': instance.taunt,
    };
