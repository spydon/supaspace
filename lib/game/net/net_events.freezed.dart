// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'net_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartEvent {

 int get seed; int get startedAt;
/// Create a copy of StartEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartEventCopyWith<StartEvent> get copyWith => _$StartEventCopyWithImpl<StartEvent>(this as StartEvent, _$identity);

  /// Serializes this StartEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartEvent&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seed,startedAt);

@override
String toString() {
  return 'StartEvent(seed: $seed, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class $StartEventCopyWith<$Res>  {
  factory $StartEventCopyWith(StartEvent value, $Res Function(StartEvent) _then) = _$StartEventCopyWithImpl;
@useResult
$Res call({
 int seed, int startedAt
});




}
/// @nodoc
class _$StartEventCopyWithImpl<$Res>
    implements $StartEventCopyWith<$Res> {
  _$StartEventCopyWithImpl(this._self, this._then);

  final StartEvent _self;
  final $Res Function(StartEvent) _then;

/// Create a copy of StartEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seed = null,Object? startedAt = null,}) {
  return _then(_self.copyWith(
seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StartEvent].
extension StartEventPatterns on StartEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartEvent value)  $default,){
final _that = this;
switch (_that) {
case _StartEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartEvent value)?  $default,){
final _that = this;
switch (_that) {
case _StartEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seed,  int startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartEvent() when $default != null:
return $default(_that.seed,_that.startedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seed,  int startedAt)  $default,) {final _that = this;
switch (_that) {
case _StartEvent():
return $default(_that.seed,_that.startedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seed,  int startedAt)?  $default,) {final _that = this;
switch (_that) {
case _StartEvent() when $default != null:
return $default(_that.seed,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartEvent implements StartEvent {
  const _StartEvent({required this.seed, required this.startedAt});
  factory _StartEvent.fromJson(Map<String, dynamic> json) => _$StartEventFromJson(json);

@override final  int seed;
@override final  int startedAt;

/// Create a copy of StartEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartEventCopyWith<_StartEvent> get copyWith => __$StartEventCopyWithImpl<_StartEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartEvent&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seed,startedAt);

@override
String toString() {
  return 'StartEvent(seed: $seed, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$StartEventCopyWith<$Res> implements $StartEventCopyWith<$Res> {
  factory _$StartEventCopyWith(_StartEvent value, $Res Function(_StartEvent) _then) = __$StartEventCopyWithImpl;
@override @useResult
$Res call({
 int seed, int startedAt
});




}
/// @nodoc
class __$StartEventCopyWithImpl<$Res>
    implements _$StartEventCopyWith<$Res> {
  __$StartEventCopyWithImpl(this._self, this._then);

  final _StartEvent _self;
  final $Res Function(_StartEvent) _then;

/// Create a copy of StartEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seed = null,Object? startedAt = null,}) {
  return _then(_StartEvent(
seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ShipState {

 String get id; String get name; int get color; double get positionX; double get positionY; double get angle; double get velocityX; double get velocityY; bool get alive;
/// Create a copy of ShipState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShipStateCopyWith<ShipState> get copyWith => _$ShipStateCopyWithImpl<ShipState>(this as ShipState, _$identity);

  /// Serializes this ShipState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShipState&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.velocityX, velocityX) || other.velocityX == velocityX)&&(identical(other.velocityY, velocityY) || other.velocityY == velocityY)&&(identical(other.alive, alive) || other.alive == alive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,positionX,positionY,angle,velocityX,velocityY,alive);

@override
String toString() {
  return 'ShipState(id: $id, name: $name, color: $color, positionX: $positionX, positionY: $positionY, angle: $angle, velocityX: $velocityX, velocityY: $velocityY, alive: $alive)';
}


}

/// @nodoc
abstract mixin class $ShipStateCopyWith<$Res>  {
  factory $ShipStateCopyWith(ShipState value, $Res Function(ShipState) _then) = _$ShipStateCopyWithImpl;
@useResult
$Res call({
 String id, String name, int color, double positionX, double positionY, double angle, double velocityX, double velocityY, bool alive
});




}
/// @nodoc
class _$ShipStateCopyWithImpl<$Res>
    implements $ShipStateCopyWith<$Res> {
  _$ShipStateCopyWithImpl(this._self, this._then);

  final ShipState _self;
  final $Res Function(ShipState) _then;

/// Create a copy of ShipState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? positionX = null,Object? positionY = null,Object? angle = null,Object? velocityX = null,Object? velocityY = null,Object? alive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as double,velocityX: null == velocityX ? _self.velocityX : velocityX // ignore: cast_nullable_to_non_nullable
as double,velocityY: null == velocityY ? _self.velocityY : velocityY // ignore: cast_nullable_to_non_nullable
as double,alive: null == alive ? _self.alive : alive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShipState].
extension ShipStatePatterns on ShipState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShipState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShipState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShipState value)  $default,){
final _that = this;
switch (_that) {
case _ShipState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShipState value)?  $default,){
final _that = this;
switch (_that) {
case _ShipState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int color,  double positionX,  double positionY,  double angle,  double velocityX,  double velocityY,  bool alive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShipState() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.positionX,_that.positionY,_that.angle,_that.velocityX,_that.velocityY,_that.alive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int color,  double positionX,  double positionY,  double angle,  double velocityX,  double velocityY,  bool alive)  $default,) {final _that = this;
switch (_that) {
case _ShipState():
return $default(_that.id,_that.name,_that.color,_that.positionX,_that.positionY,_that.angle,_that.velocityX,_that.velocityY,_that.alive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int color,  double positionX,  double positionY,  double angle,  double velocityX,  double velocityY,  bool alive)?  $default,) {final _that = this;
switch (_that) {
case _ShipState() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.positionX,_that.positionY,_that.angle,_that.velocityX,_that.velocityY,_that.alive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShipState implements ShipState {
  const _ShipState({required this.id, required this.name, required this.color, required this.positionX, required this.positionY, required this.angle, required this.velocityX, required this.velocityY, this.alive = true});
  factory _ShipState.fromJson(Map<String, dynamic> json) => _$ShipStateFromJson(json);

@override final  String id;
@override final  String name;
@override final  int color;
@override final  double positionX;
@override final  double positionY;
@override final  double angle;
@override final  double velocityX;
@override final  double velocityY;
@override@JsonKey() final  bool alive;

/// Create a copy of ShipState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShipStateCopyWith<_ShipState> get copyWith => __$ShipStateCopyWithImpl<_ShipState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShipStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShipState&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.velocityX, velocityX) || other.velocityX == velocityX)&&(identical(other.velocityY, velocityY) || other.velocityY == velocityY)&&(identical(other.alive, alive) || other.alive == alive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,positionX,positionY,angle,velocityX,velocityY,alive);

@override
String toString() {
  return 'ShipState(id: $id, name: $name, color: $color, positionX: $positionX, positionY: $positionY, angle: $angle, velocityX: $velocityX, velocityY: $velocityY, alive: $alive)';
}


}

/// @nodoc
abstract mixin class _$ShipStateCopyWith<$Res> implements $ShipStateCopyWith<$Res> {
  factory _$ShipStateCopyWith(_ShipState value, $Res Function(_ShipState) _then) = __$ShipStateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int color, double positionX, double positionY, double angle, double velocityX, double velocityY, bool alive
});




}
/// @nodoc
class __$ShipStateCopyWithImpl<$Res>
    implements _$ShipStateCopyWith<$Res> {
  __$ShipStateCopyWithImpl(this._self, this._then);

  final _ShipState _self;
  final $Res Function(_ShipState) _then;

/// Create a copy of ShipState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? positionX = null,Object? positionY = null,Object? angle = null,Object? velocityX = null,Object? velocityY = null,Object? alive = null,}) {
  return _then(_ShipState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as double,velocityX: null == velocityX ? _self.velocityX : velocityX // ignore: cast_nullable_to_non_nullable
as double,velocityY: null == velocityY ? _self.velocityY : velocityY // ignore: cast_nullable_to_non_nullable
as double,alive: null == alive ? _self.alive : alive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ShotEvent {

 String get id; String get ownerId; double get positionX; double get positionY; double get angle; double get speed; int get firedAt;// epoch milliseconds when fired
 bool get homing;
/// Create a copy of ShotEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShotEventCopyWith<ShotEvent> get copyWith => _$ShotEventCopyWithImpl<ShotEvent>(this as ShotEvent, _$identity);

  /// Serializes this ShotEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShotEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.firedAt, firedAt) || other.firedAt == firedAt)&&(identical(other.homing, homing) || other.homing == homing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,positionX,positionY,angle,speed,firedAt,homing);

@override
String toString() {
  return 'ShotEvent(id: $id, ownerId: $ownerId, positionX: $positionX, positionY: $positionY, angle: $angle, speed: $speed, firedAt: $firedAt, homing: $homing)';
}


}

/// @nodoc
abstract mixin class $ShotEventCopyWith<$Res>  {
  factory $ShotEventCopyWith(ShotEvent value, $Res Function(ShotEvent) _then) = _$ShotEventCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, double positionX, double positionY, double angle, double speed, int firedAt, bool homing
});




}
/// @nodoc
class _$ShotEventCopyWithImpl<$Res>
    implements $ShotEventCopyWith<$Res> {
  _$ShotEventCopyWithImpl(this._self, this._then);

  final ShotEvent _self;
  final $Res Function(ShotEvent) _then;

/// Create a copy of ShotEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? positionX = null,Object? positionY = null,Object? angle = null,Object? speed = null,Object? firedAt = null,Object? homing = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,firedAt: null == firedAt ? _self.firedAt : firedAt // ignore: cast_nullable_to_non_nullable
as int,homing: null == homing ? _self.homing : homing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShotEvent].
extension ShotEventPatterns on ShotEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShotEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShotEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShotEvent value)  $default,){
final _that = this;
switch (_that) {
case _ShotEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShotEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ShotEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  double positionX,  double positionY,  double angle,  double speed,  int firedAt,  bool homing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShotEvent() when $default != null:
return $default(_that.id,_that.ownerId,_that.positionX,_that.positionY,_that.angle,_that.speed,_that.firedAt,_that.homing);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  double positionX,  double positionY,  double angle,  double speed,  int firedAt,  bool homing)  $default,) {final _that = this;
switch (_that) {
case _ShotEvent():
return $default(_that.id,_that.ownerId,_that.positionX,_that.positionY,_that.angle,_that.speed,_that.firedAt,_that.homing);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  double positionX,  double positionY,  double angle,  double speed,  int firedAt,  bool homing)?  $default,) {final _that = this;
switch (_that) {
case _ShotEvent() when $default != null:
return $default(_that.id,_that.ownerId,_that.positionX,_that.positionY,_that.angle,_that.speed,_that.firedAt,_that.homing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShotEvent implements ShotEvent {
  const _ShotEvent({required this.id, required this.ownerId, required this.positionX, required this.positionY, required this.angle, required this.speed, required this.firedAt, this.homing = false});
  factory _ShotEvent.fromJson(Map<String, dynamic> json) => _$ShotEventFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  double positionX;
@override final  double positionY;
@override final  double angle;
@override final  double speed;
@override final  int firedAt;
// epoch milliseconds when fired
@override@JsonKey() final  bool homing;

/// Create a copy of ShotEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShotEventCopyWith<_ShotEvent> get copyWith => __$ShotEventCopyWithImpl<_ShotEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShotEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShotEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.firedAt, firedAt) || other.firedAt == firedAt)&&(identical(other.homing, homing) || other.homing == homing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,positionX,positionY,angle,speed,firedAt,homing);

@override
String toString() {
  return 'ShotEvent(id: $id, ownerId: $ownerId, positionX: $positionX, positionY: $positionY, angle: $angle, speed: $speed, firedAt: $firedAt, homing: $homing)';
}


}

/// @nodoc
abstract mixin class _$ShotEventCopyWith<$Res> implements $ShotEventCopyWith<$Res> {
  factory _$ShotEventCopyWith(_ShotEvent value, $Res Function(_ShotEvent) _then) = __$ShotEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, double positionX, double positionY, double angle, double speed, int firedAt, bool homing
});




}
/// @nodoc
class __$ShotEventCopyWithImpl<$Res>
    implements _$ShotEventCopyWith<$Res> {
  __$ShotEventCopyWithImpl(this._self, this._then);

  final _ShotEvent _self;
  final $Res Function(_ShotEvent) _then;

/// Create a copy of ShotEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? positionX = null,Object? positionY = null,Object? angle = null,Object? speed = null,Object? firedAt = null,Object? homing = null,}) {
  return _then(_ShotEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,firedAt: null == firedAt ? _self.firedAt : firedAt // ignore: cast_nullable_to_non_nullable
as int,homing: null == homing ? _self.homing : homing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CaptureEvent {

 int get planetId; String get ownerId; int get capturedAt;
/// Create a copy of CaptureEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaptureEventCopyWith<CaptureEvent> get copyWith => _$CaptureEventCopyWithImpl<CaptureEvent>(this as CaptureEvent, _$identity);

  /// Serializes this CaptureEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaptureEvent&&(identical(other.planetId, planetId) || other.planetId == planetId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planetId,ownerId,capturedAt);

@override
String toString() {
  return 'CaptureEvent(planetId: $planetId, ownerId: $ownerId, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class $CaptureEventCopyWith<$Res>  {
  factory $CaptureEventCopyWith(CaptureEvent value, $Res Function(CaptureEvent) _then) = _$CaptureEventCopyWithImpl;
@useResult
$Res call({
 int planetId, String ownerId, int capturedAt
});




}
/// @nodoc
class _$CaptureEventCopyWithImpl<$Res>
    implements $CaptureEventCopyWith<$Res> {
  _$CaptureEventCopyWithImpl(this._self, this._then);

  final CaptureEvent _self;
  final $Res Function(CaptureEvent) _then;

/// Create a copy of CaptureEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planetId = null,Object? ownerId = null,Object? capturedAt = null,}) {
  return _then(_self.copyWith(
planetId: null == planetId ? _self.planetId : planetId // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CaptureEvent].
extension CaptureEventPatterns on CaptureEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaptureEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaptureEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaptureEvent value)  $default,){
final _that = this;
switch (_that) {
case _CaptureEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaptureEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CaptureEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int planetId,  String ownerId,  int capturedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaptureEvent() when $default != null:
return $default(_that.planetId,_that.ownerId,_that.capturedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int planetId,  String ownerId,  int capturedAt)  $default,) {final _that = this;
switch (_that) {
case _CaptureEvent():
return $default(_that.planetId,_that.ownerId,_that.capturedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int planetId,  String ownerId,  int capturedAt)?  $default,) {final _that = this;
switch (_that) {
case _CaptureEvent() when $default != null:
return $default(_that.planetId,_that.ownerId,_that.capturedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaptureEvent implements CaptureEvent {
  const _CaptureEvent({required this.planetId, required this.ownerId, required this.capturedAt});
  factory _CaptureEvent.fromJson(Map<String, dynamic> json) => _$CaptureEventFromJson(json);

@override final  int planetId;
@override final  String ownerId;
@override final  int capturedAt;

/// Create a copy of CaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaptureEventCopyWith<_CaptureEvent> get copyWith => __$CaptureEventCopyWithImpl<_CaptureEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaptureEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureEvent&&(identical(other.planetId, planetId) || other.planetId == planetId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planetId,ownerId,capturedAt);

@override
String toString() {
  return 'CaptureEvent(planetId: $planetId, ownerId: $ownerId, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class _$CaptureEventCopyWith<$Res> implements $CaptureEventCopyWith<$Res> {
  factory _$CaptureEventCopyWith(_CaptureEvent value, $Res Function(_CaptureEvent) _then) = __$CaptureEventCopyWithImpl;
@override @useResult
$Res call({
 int planetId, String ownerId, int capturedAt
});




}
/// @nodoc
class __$CaptureEventCopyWithImpl<$Res>
    implements _$CaptureEventCopyWith<$Res> {
  __$CaptureEventCopyWithImpl(this._self, this._then);

  final _CaptureEvent _self;
  final $Res Function(_CaptureEvent) _then;

/// Create a copy of CaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planetId = null,Object? ownerId = null,Object? capturedAt = null,}) {
  return _then(_CaptureEvent(
planetId: null == planetId ? _self.planetId : planetId // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PowerupTakenEvent {

 int get powerupId; String get byId;
/// Create a copy of PowerupTakenEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PowerupTakenEventCopyWith<PowerupTakenEvent> get copyWith => _$PowerupTakenEventCopyWithImpl<PowerupTakenEvent>(this as PowerupTakenEvent, _$identity);

  /// Serializes this PowerupTakenEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PowerupTakenEvent&&(identical(other.powerupId, powerupId) || other.powerupId == powerupId)&&(identical(other.byId, byId) || other.byId == byId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,powerupId,byId);

@override
String toString() {
  return 'PowerupTakenEvent(powerupId: $powerupId, byId: $byId)';
}


}

/// @nodoc
abstract mixin class $PowerupTakenEventCopyWith<$Res>  {
  factory $PowerupTakenEventCopyWith(PowerupTakenEvent value, $Res Function(PowerupTakenEvent) _then) = _$PowerupTakenEventCopyWithImpl;
@useResult
$Res call({
 int powerupId, String byId
});




}
/// @nodoc
class _$PowerupTakenEventCopyWithImpl<$Res>
    implements $PowerupTakenEventCopyWith<$Res> {
  _$PowerupTakenEventCopyWithImpl(this._self, this._then);

  final PowerupTakenEvent _self;
  final $Res Function(PowerupTakenEvent) _then;

/// Create a copy of PowerupTakenEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? powerupId = null,Object? byId = null,}) {
  return _then(_self.copyWith(
powerupId: null == powerupId ? _self.powerupId : powerupId // ignore: cast_nullable_to_non_nullable
as int,byId: null == byId ? _self.byId : byId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PowerupTakenEvent].
extension PowerupTakenEventPatterns on PowerupTakenEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PowerupTakenEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PowerupTakenEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PowerupTakenEvent value)  $default,){
final _that = this;
switch (_that) {
case _PowerupTakenEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PowerupTakenEvent value)?  $default,){
final _that = this;
switch (_that) {
case _PowerupTakenEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int powerupId,  String byId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PowerupTakenEvent() when $default != null:
return $default(_that.powerupId,_that.byId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int powerupId,  String byId)  $default,) {final _that = this;
switch (_that) {
case _PowerupTakenEvent():
return $default(_that.powerupId,_that.byId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int powerupId,  String byId)?  $default,) {final _that = this;
switch (_that) {
case _PowerupTakenEvent() when $default != null:
return $default(_that.powerupId,_that.byId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PowerupTakenEvent implements PowerupTakenEvent {
  const _PowerupTakenEvent({required this.powerupId, required this.byId});
  factory _PowerupTakenEvent.fromJson(Map<String, dynamic> json) => _$PowerupTakenEventFromJson(json);

@override final  int powerupId;
@override final  String byId;

/// Create a copy of PowerupTakenEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PowerupTakenEventCopyWith<_PowerupTakenEvent> get copyWith => __$PowerupTakenEventCopyWithImpl<_PowerupTakenEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PowerupTakenEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PowerupTakenEvent&&(identical(other.powerupId, powerupId) || other.powerupId == powerupId)&&(identical(other.byId, byId) || other.byId == byId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,powerupId,byId);

@override
String toString() {
  return 'PowerupTakenEvent(powerupId: $powerupId, byId: $byId)';
}


}

/// @nodoc
abstract mixin class _$PowerupTakenEventCopyWith<$Res> implements $PowerupTakenEventCopyWith<$Res> {
  factory _$PowerupTakenEventCopyWith(_PowerupTakenEvent value, $Res Function(_PowerupTakenEvent) _then) = __$PowerupTakenEventCopyWithImpl;
@override @useResult
$Res call({
 int powerupId, String byId
});




}
/// @nodoc
class __$PowerupTakenEventCopyWithImpl<$Res>
    implements _$PowerupTakenEventCopyWith<$Res> {
  __$PowerupTakenEventCopyWithImpl(this._self, this._then);

  final _PowerupTakenEvent _self;
  final $Res Function(_PowerupTakenEvent) _then;

/// Create a copy of PowerupTakenEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? powerupId = null,Object? byId = null,}) {
  return _then(_PowerupTakenEvent(
powerupId: null == powerupId ? _self.powerupId : powerupId // ignore: cast_nullable_to_non_nullable
as int,byId: null == byId ? _self.byId : byId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TauntEvent {

 String get byId;// player who taunted (whose ship it shows over)
 String get emoji; String get taunt;
/// Create a copy of TauntEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TauntEventCopyWith<TauntEvent> get copyWith => _$TauntEventCopyWithImpl<TauntEvent>(this as TauntEvent, _$identity);

  /// Serializes this TauntEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TauntEvent&&(identical(other.byId, byId) || other.byId == byId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.taunt, taunt) || other.taunt == taunt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,byId,emoji,taunt);

@override
String toString() {
  return 'TauntEvent(byId: $byId, emoji: $emoji, taunt: $taunt)';
}


}

/// @nodoc
abstract mixin class $TauntEventCopyWith<$Res>  {
  factory $TauntEventCopyWith(TauntEvent value, $Res Function(TauntEvent) _then) = _$TauntEventCopyWithImpl;
@useResult
$Res call({
 String byId, String emoji, String taunt
});




}
/// @nodoc
class _$TauntEventCopyWithImpl<$Res>
    implements $TauntEventCopyWith<$Res> {
  _$TauntEventCopyWithImpl(this._self, this._then);

  final TauntEvent _self;
  final $Res Function(TauntEvent) _then;

/// Create a copy of TauntEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byId = null,Object? emoji = null,Object? taunt = null,}) {
  return _then(_self.copyWith(
byId: null == byId ? _self.byId : byId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,taunt: null == taunt ? _self.taunt : taunt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TauntEvent].
extension TauntEventPatterns on TauntEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TauntEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TauntEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TauntEvent value)  $default,){
final _that = this;
switch (_that) {
case _TauntEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TauntEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TauntEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String byId,  String emoji,  String taunt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TauntEvent() when $default != null:
return $default(_that.byId,_that.emoji,_that.taunt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String byId,  String emoji,  String taunt)  $default,) {final _that = this;
switch (_that) {
case _TauntEvent():
return $default(_that.byId,_that.emoji,_that.taunt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String byId,  String emoji,  String taunt)?  $default,) {final _that = this;
switch (_that) {
case _TauntEvent() when $default != null:
return $default(_that.byId,_that.emoji,_that.taunt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TauntEvent implements TauntEvent {
  const _TauntEvent({required this.byId, required this.emoji, required this.taunt});
  factory _TauntEvent.fromJson(Map<String, dynamic> json) => _$TauntEventFromJson(json);

@override final  String byId;
// player who taunted (whose ship it shows over)
@override final  String emoji;
@override final  String taunt;

/// Create a copy of TauntEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TauntEventCopyWith<_TauntEvent> get copyWith => __$TauntEventCopyWithImpl<_TauntEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TauntEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TauntEvent&&(identical(other.byId, byId) || other.byId == byId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.taunt, taunt) || other.taunt == taunt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,byId,emoji,taunt);

@override
String toString() {
  return 'TauntEvent(byId: $byId, emoji: $emoji, taunt: $taunt)';
}


}

/// @nodoc
abstract mixin class _$TauntEventCopyWith<$Res> implements $TauntEventCopyWith<$Res> {
  factory _$TauntEventCopyWith(_TauntEvent value, $Res Function(_TauntEvent) _then) = __$TauntEventCopyWithImpl;
@override @useResult
$Res call({
 String byId, String emoji, String taunt
});




}
/// @nodoc
class __$TauntEventCopyWithImpl<$Res>
    implements _$TauntEventCopyWith<$Res> {
  __$TauntEventCopyWithImpl(this._self, this._then);

  final _TauntEvent _self;
  final $Res Function(_TauntEvent) _then;

/// Create a copy of TauntEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? byId = null,Object? emoji = null,Object? taunt = null,}) {
  return _then(_TauntEvent(
byId: null == byId ? _self.byId : byId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,taunt: null == taunt ? _self.taunt : taunt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
