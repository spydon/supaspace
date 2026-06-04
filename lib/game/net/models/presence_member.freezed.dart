// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presence_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PresenceMember {

 String get id; String get name; int get color; GamePhase get phase; int? get seed; int? get startedAt;// Whether this member has chosen to spectate rather than play. In the
// lobby this is the Play/Spectate toggle; it is what excludes them from the
// count of pilots needed to start a match.
 bool get spectating;
/// Create a copy of PresenceMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresenceMemberCopyWith<PresenceMember> get copyWith => _$PresenceMemberCopyWithImpl<PresenceMember>(this as PresenceMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresenceMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.spectating, spectating) || other.spectating == spectating));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,color,phase,seed,startedAt,spectating);

@override
String toString() {
  return 'PresenceMember(id: $id, name: $name, color: $color, phase: $phase, seed: $seed, startedAt: $startedAt, spectating: $spectating)';
}


}

/// @nodoc
abstract mixin class $PresenceMemberCopyWith<$Res>  {
  factory $PresenceMemberCopyWith(PresenceMember value, $Res Function(PresenceMember) _then) = _$PresenceMemberCopyWithImpl;
@useResult
$Res call({
 String id, String name, int color, GamePhase phase, int? seed, int? startedAt, bool spectating
});




}
/// @nodoc
class _$PresenceMemberCopyWithImpl<$Res>
    implements $PresenceMemberCopyWith<$Res> {
  _$PresenceMemberCopyWithImpl(this._self, this._then);

  final PresenceMember _self;
  final $Res Function(PresenceMember) _then;

/// Create a copy of PresenceMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? phase = null,Object? seed = freezed,Object? startedAt = freezed,Object? spectating = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,seed: freezed == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,spectating: null == spectating ? _self.spectating : spectating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PresenceMember].
extension PresenceMemberPatterns on PresenceMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresenceMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresenceMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresenceMember value)  $default,){
final _that = this;
switch (_that) {
case _PresenceMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresenceMember value)?  $default,){
final _that = this;
switch (_that) {
case _PresenceMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int color,  GamePhase phase,  int? seed,  int? startedAt,  bool spectating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresenceMember() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.phase,_that.seed,_that.startedAt,_that.spectating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int color,  GamePhase phase,  int? seed,  int? startedAt,  bool spectating)  $default,) {final _that = this;
switch (_that) {
case _PresenceMember():
return $default(_that.id,_that.name,_that.color,_that.phase,_that.seed,_that.startedAt,_that.spectating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int color,  GamePhase phase,  int? seed,  int? startedAt,  bool spectating)?  $default,) {final _that = this;
switch (_that) {
case _PresenceMember() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.phase,_that.seed,_that.startedAt,_that.spectating);case _:
  return null;

}
}

}

/// @nodoc


class _PresenceMember extends PresenceMember {
  const _PresenceMember({required this.id, required this.name, required this.color, required this.phase, this.seed, this.startedAt, this.spectating = false}): super._();
  

@override final  String id;
@override final  String name;
@override final  int color;
@override final  GamePhase phase;
@override final  int? seed;
@override final  int? startedAt;
// Whether this member has chosen to spectate rather than play. In the
// lobby this is the Play/Spectate toggle; it is what excludes them from the
// count of pilots needed to start a match.
@override@JsonKey() final  bool spectating;

/// Create a copy of PresenceMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresenceMemberCopyWith<_PresenceMember> get copyWith => __$PresenceMemberCopyWithImpl<_PresenceMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresenceMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.spectating, spectating) || other.spectating == spectating));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,color,phase,seed,startedAt,spectating);

@override
String toString() {
  return 'PresenceMember(id: $id, name: $name, color: $color, phase: $phase, seed: $seed, startedAt: $startedAt, spectating: $spectating)';
}


}

/// @nodoc
abstract mixin class _$PresenceMemberCopyWith<$Res> implements $PresenceMemberCopyWith<$Res> {
  factory _$PresenceMemberCopyWith(_PresenceMember value, $Res Function(_PresenceMember) _then) = __$PresenceMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int color, GamePhase phase, int? seed, int? startedAt, bool spectating
});




}
/// @nodoc
class __$PresenceMemberCopyWithImpl<$Res>
    implements _$PresenceMemberCopyWith<$Res> {
  __$PresenceMemberCopyWithImpl(this._self, this._then);

  final _PresenceMember _self;
  final $Res Function(_PresenceMember) _then;

/// Create a copy of PresenceMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? phase = null,Object? seed = freezed,Object? startedAt = freezed,Object? spectating = null,}) {
  return _then(_PresenceMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,seed: freezed == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,spectating: null == spectating ? _self.spectating : spectating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
