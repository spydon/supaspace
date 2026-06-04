// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'high_score_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HighScore {

@JsonKey(name: 'player_name') String get playerName; int get points;
/// Create a copy of HighScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HighScoreCopyWith<HighScore> get copyWith => _$HighScoreCopyWithImpl<HighScore>(this as HighScore, _$identity);

  /// Serializes this HighScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HighScore&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerName,points);

@override
String toString() {
  return 'HighScore(playerName: $playerName, points: $points)';
}


}

/// @nodoc
abstract mixin class $HighScoreCopyWith<$Res>  {
  factory $HighScoreCopyWith(HighScore value, $Res Function(HighScore) _then) = _$HighScoreCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'player_name') String playerName, int points
});




}
/// @nodoc
class _$HighScoreCopyWithImpl<$Res>
    implements $HighScoreCopyWith<$Res> {
  _$HighScoreCopyWithImpl(this._self, this._then);

  final HighScore _self;
  final $Res Function(HighScore) _then;

/// Create a copy of HighScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerName = null,Object? points = null,}) {
  return _then(_self.copyWith(
playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HighScore].
extension HighScorePatterns on HighScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HighScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HighScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HighScore value)  $default,){
final _that = this;
switch (_that) {
case _HighScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HighScore value)?  $default,){
final _that = this;
switch (_that) {
case _HighScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'player_name')  String playerName,  int points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HighScore() when $default != null:
return $default(_that.playerName,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'player_name')  String playerName,  int points)  $default,) {final _that = this;
switch (_that) {
case _HighScore():
return $default(_that.playerName,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'player_name')  String playerName,  int points)?  $default,) {final _that = this;
switch (_that) {
case _HighScore() when $default != null:
return $default(_that.playerName,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HighScore implements HighScore {
  const _HighScore({@JsonKey(name: 'player_name') this.playerName = 'Pilot', this.points = 0});
  factory _HighScore.fromJson(Map<String, dynamic> json) => _$HighScoreFromJson(json);

@override@JsonKey(name: 'player_name') final  String playerName;
@override@JsonKey() final  int points;

/// Create a copy of HighScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HighScoreCopyWith<_HighScore> get copyWith => __$HighScoreCopyWithImpl<_HighScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HighScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HighScore&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerName,points);

@override
String toString() {
  return 'HighScore(playerName: $playerName, points: $points)';
}


}

/// @nodoc
abstract mixin class _$HighScoreCopyWith<$Res> implements $HighScoreCopyWith<$Res> {
  factory _$HighScoreCopyWith(_HighScore value, $Res Function(_HighScore) _then) = __$HighScoreCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'player_name') String playerName, int points
});




}
/// @nodoc
class __$HighScoreCopyWithImpl<$Res>
    implements _$HighScoreCopyWith<$Res> {
  __$HighScoreCopyWithImpl(this._self, this._then);

  final _HighScore _self;
  final $Res Function(_HighScore) _then;

/// Create a copy of HighScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerName = null,Object? points = null,}) {
  return _then(_HighScore(
playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
