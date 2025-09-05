// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locale_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocaleConfiguration {

 String get languageCode; LocaleSource get source; String? get countryCode;
/// Create a copy of LocaleConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocaleConfigurationCopyWith<LocaleConfiguration> get copyWith => _$LocaleConfigurationCopyWithImpl<LocaleConfiguration>(this as LocaleConfiguration, _$identity);

  /// Serializes this LocaleConfiguration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocaleConfiguration&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.source, source) || other.source == source)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,source,countryCode);

@override
String toString() {
  return 'LocaleConfiguration(languageCode: $languageCode, source: $source, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class $LocaleConfigurationCopyWith<$Res>  {
  factory $LocaleConfigurationCopyWith(LocaleConfiguration value, $Res Function(LocaleConfiguration) _then) = _$LocaleConfigurationCopyWithImpl;
@useResult
$Res call({
 String languageCode, LocaleSource source, String? countryCode
});




}
/// @nodoc
class _$LocaleConfigurationCopyWithImpl<$Res>
    implements $LocaleConfigurationCopyWith<$Res> {
  _$LocaleConfigurationCopyWithImpl(this._self, this._then);

  final LocaleConfiguration _self;
  final $Res Function(LocaleConfiguration) _then;

/// Create a copy of LocaleConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? languageCode = null,Object? source = null,Object? countryCode = freezed,}) {
  return _then(_self.copyWith(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as LocaleSource,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocaleConfiguration].
extension LocaleConfigurationPatterns on LocaleConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocaleConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocaleConfiguration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocaleConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _LocaleConfiguration():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocaleConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _LocaleConfiguration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String languageCode,  LocaleSource source,  String? countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocaleConfiguration() when $default != null:
return $default(_that.languageCode,_that.source,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String languageCode,  LocaleSource source,  String? countryCode)  $default,) {final _that = this;
switch (_that) {
case _LocaleConfiguration():
return $default(_that.languageCode,_that.source,_that.countryCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String languageCode,  LocaleSource source,  String? countryCode)?  $default,) {final _that = this;
switch (_that) {
case _LocaleConfiguration() when $default != null:
return $default(_that.languageCode,_that.source,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocaleConfiguration implements LocaleConfiguration {
  const _LocaleConfiguration({required this.languageCode, required this.source, this.countryCode});
  factory _LocaleConfiguration.fromJson(Map<String, dynamic> json) => _$LocaleConfigurationFromJson(json);

@override final  String languageCode;
@override final  LocaleSource source;
@override final  String? countryCode;

/// Create a copy of LocaleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocaleConfigurationCopyWith<_LocaleConfiguration> get copyWith => __$LocaleConfigurationCopyWithImpl<_LocaleConfiguration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocaleConfigurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocaleConfiguration&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.source, source) || other.source == source)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,source,countryCode);

@override
String toString() {
  return 'LocaleConfiguration(languageCode: $languageCode, source: $source, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$LocaleConfigurationCopyWith<$Res> implements $LocaleConfigurationCopyWith<$Res> {
  factory _$LocaleConfigurationCopyWith(_LocaleConfiguration value, $Res Function(_LocaleConfiguration) _then) = __$LocaleConfigurationCopyWithImpl;
@override @useResult
$Res call({
 String languageCode, LocaleSource source, String? countryCode
});




}
/// @nodoc
class __$LocaleConfigurationCopyWithImpl<$Res>
    implements _$LocaleConfigurationCopyWith<$Res> {
  __$LocaleConfigurationCopyWithImpl(this._self, this._then);

  final _LocaleConfiguration _self;
  final $Res Function(_LocaleConfiguration) _then;

/// Create a copy of LocaleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? languageCode = null,Object? source = null,Object? countryCode = freezed,}) {
  return _then(_LocaleConfiguration(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as LocaleSource,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
