/// Typed payloads exchanged over the Supabase Realtime broadcast channel.
///
/// Each model is a [freezed] class, so its JSON (de)serialization, equality and
/// `copyWith` are generated rather than hand-written.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'net_events.freezed.dart';
part 'net_events.g.dart';

/// Broadcast event types. One channel, distinguished by event. The wire string
/// is the enum's [name].
enum NetworkEvent { start, state, shot, capture, powerup, taunt }

/// Sent by whoever presses Start. Everyone seeds an identical planet field
/// from [seed] and runs the countdown from [startedAt].
@freezed
abstract class StartEvent with _$StartEvent {
  const factory StartEvent({
    required int seed,
    required int startedAt, // epoch milliseconds
  }) = _StartEvent;

  factory StartEvent.fromJson(Map<String, dynamic> json) =>
      _$StartEventFromJson(json);
}

/// A ship's authoritative state, broadcast by its owner around 20 times a
/// second.
@freezed
abstract class ShipState with _$ShipState {
  const factory ShipState({
    required String id,
    required String name,
    required int color,
    required double positionX,
    required double positionY,
    required double angle,
    required double velocityX,
    required double velocityY,
    @Default(true) bool alive,
    @Default(false) bool braking, // brakes held — braces against ship bounces
  }) = _ShipState;

  factory ShipState.fromJson(Map<String, dynamic> json) =>
      _$ShipStateFromJson(json);
}

/// A fired shot. Bullets are simulated deterministically on every client from
/// these spawn parameters, so per-frame bullet positions are never sent.
@freezed
abstract class ShotEvent with _$ShotEvent {
  const factory ShotEvent({
    required String id,
    required String ownerId,
    required double positionX,
    required double positionY,
    required double angle,
    required double speed,
    required int firedAt, // epoch milliseconds when fired
    @Default(false) bool homing, // whether the bullet gently tracks ships
  }) = _ShotEvent;

  factory ShotEvent.fromJson(Map<String, dynamic> json) =>
      _$ShotEventFromJson(json);
}

/// A planet capture claim. Reconciled latest-[capturedAt]-wins (so a planet can
/// be taken over), with the higher [ownerId] breaking exact-timestamp ties.
@freezed
abstract class CaptureEvent with _$CaptureEvent {
  const factory CaptureEvent({
    required int planetId,
    required String ownerId,
    required int capturedAt, // epoch milliseconds
  }) = _CaptureEvent;

  factory CaptureEvent.fromJson(Map<String, dynamic> json) =>
      _$CaptureEventFromJson(json);
}

/// Sent when a player picks up a powerup, so every other client removes (and
/// animates away) the same one. The picker applies the effect locally.
@freezed
abstract class PowerupTakenEvent with _$PowerupTakenEvent {
  const factory PowerupTakenEvent({
    required int powerupId,
    required String byId, // player who picked it up
  }) = _PowerupTakenEvent;

  factory PowerupTakenEvent.fromJson(Map<String, dynamic> json) =>
      _$PowerupTakenEventFromJson(json);
}

/// A taunt played by a player, shown as an emoji + phrase above their ship on
/// every client.
@freezed
abstract class TauntEvent with _$TauntEvent {
  const factory TauntEvent({
    required String byId, // player who taunted (whose ship it shows over)
    required String emoji,
    required String taunt,
  }) = _TauntEvent;

  factory TauntEvent.fromJson(Map<String, dynamic> json) =>
      _$TauntEventFromJson(json);
}
