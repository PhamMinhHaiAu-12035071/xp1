// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locale_errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocaleError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocaleError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LocaleError()';
}


}

/// @nodoc
class $LocaleErrorCopyWith<$Res>  {
$LocaleErrorCopyWith(LocaleError _, $Res Function(LocaleError) __);
}


/// Adds pattern-matching-related methods to [LocaleError].
extension LocaleErrorPatterns on LocaleError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UnsupportedLocaleError value)?  unsupportedLocale,TResult Function( PlatformDetectionFailedError value)?  platformDetectionFailed,TResult Function( PersistenceFailedError value)?  persistenceFailed,TResult Function( ValidationFailedError value)?  validationFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UnsupportedLocaleError() when unsupportedLocale != null:
return unsupportedLocale(_that);case PlatformDetectionFailedError() when platformDetectionFailed != null:
return platformDetectionFailed(_that);case PersistenceFailedError() when persistenceFailed != null:
return persistenceFailed(_that);case ValidationFailedError() when validationFailed != null:
return validationFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UnsupportedLocaleError value)  unsupportedLocale,required TResult Function( PlatformDetectionFailedError value)  platformDetectionFailed,required TResult Function( PersistenceFailedError value)  persistenceFailed,required TResult Function( ValidationFailedError value)  validationFailed,}){
final _that = this;
switch (_that) {
case UnsupportedLocaleError():
return unsupportedLocale(_that);case PlatformDetectionFailedError():
return platformDetectionFailed(_that);case PersistenceFailedError():
return persistenceFailed(_that);case ValidationFailedError():
return validationFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UnsupportedLocaleError value)?  unsupportedLocale,TResult? Function( PlatformDetectionFailedError value)?  platformDetectionFailed,TResult? Function( PersistenceFailedError value)?  persistenceFailed,TResult? Function( ValidationFailedError value)?  validationFailed,}){
final _that = this;
switch (_that) {
case UnsupportedLocaleError() when unsupportedLocale != null:
return unsupportedLocale(_that);case PlatformDetectionFailedError() when platformDetectionFailed != null:
return platformDetectionFailed(_that);case PersistenceFailedError() when persistenceFailed != null:
return persistenceFailed(_that);case ValidationFailedError() when validationFailed != null:
return validationFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String invalidLocaleCode,  List<String> supportedLocales)?  unsupportedLocale,TResult Function( String reason)?  platformDetectionFailed,TResult Function( String operation,  String reason)?  persistenceFailed,TResult Function( String locale,  String validationRule)?  validationFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UnsupportedLocaleError() when unsupportedLocale != null:
return unsupportedLocale(_that.invalidLocaleCode,_that.supportedLocales);case PlatformDetectionFailedError() when platformDetectionFailed != null:
return platformDetectionFailed(_that.reason);case PersistenceFailedError() when persistenceFailed != null:
return persistenceFailed(_that.operation,_that.reason);case ValidationFailedError() when validationFailed != null:
return validationFailed(_that.locale,_that.validationRule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String invalidLocaleCode,  List<String> supportedLocales)  unsupportedLocale,required TResult Function( String reason)  platformDetectionFailed,required TResult Function( String operation,  String reason)  persistenceFailed,required TResult Function( String locale,  String validationRule)  validationFailed,}) {final _that = this;
switch (_that) {
case UnsupportedLocaleError():
return unsupportedLocale(_that.invalidLocaleCode,_that.supportedLocales);case PlatformDetectionFailedError():
return platformDetectionFailed(_that.reason);case PersistenceFailedError():
return persistenceFailed(_that.operation,_that.reason);case ValidationFailedError():
return validationFailed(_that.locale,_that.validationRule);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String invalidLocaleCode,  List<String> supportedLocales)?  unsupportedLocale,TResult? Function( String reason)?  platformDetectionFailed,TResult? Function( String operation,  String reason)?  persistenceFailed,TResult? Function( String locale,  String validationRule)?  validationFailed,}) {final _that = this;
switch (_that) {
case UnsupportedLocaleError() when unsupportedLocale != null:
return unsupportedLocale(_that.invalidLocaleCode,_that.supportedLocales);case PlatformDetectionFailedError() when platformDetectionFailed != null:
return platformDetectionFailed(_that.reason);case PersistenceFailedError() when persistenceFailed != null:
return persistenceFailed(_that.operation,_that.reason);case ValidationFailedError() when validationFailed != null:
return validationFailed(_that.locale,_that.validationRule);case _:
  return null;

}
}

}

/// @nodoc


class UnsupportedLocaleError implements LocaleError {
  const UnsupportedLocaleError({required this.invalidLocaleCode, required final  List<String> supportedLocales}): _supportedLocales = supportedLocales;
  

 final  String invalidLocaleCode;
 final  List<String> _supportedLocales;
 List<String> get supportedLocales {
  if (_supportedLocales is EqualUnmodifiableListView) return _supportedLocales;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedLocales);
}


/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnsupportedLocaleErrorCopyWith<UnsupportedLocaleError> get copyWith => _$UnsupportedLocaleErrorCopyWithImpl<UnsupportedLocaleError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnsupportedLocaleError&&(identical(other.invalidLocaleCode, invalidLocaleCode) || other.invalidLocaleCode == invalidLocaleCode)&&const DeepCollectionEquality().equals(other._supportedLocales, _supportedLocales));
}


@override
int get hashCode => Object.hash(runtimeType,invalidLocaleCode,const DeepCollectionEquality().hash(_supportedLocales));

@override
String toString() {
  return 'LocaleError.unsupportedLocale(invalidLocaleCode: $invalidLocaleCode, supportedLocales: $supportedLocales)';
}


}

/// @nodoc
abstract mixin class $UnsupportedLocaleErrorCopyWith<$Res> implements $LocaleErrorCopyWith<$Res> {
  factory $UnsupportedLocaleErrorCopyWith(UnsupportedLocaleError value, $Res Function(UnsupportedLocaleError) _then) = _$UnsupportedLocaleErrorCopyWithImpl;
@useResult
$Res call({
 String invalidLocaleCode, List<String> supportedLocales
});




}
/// @nodoc
class _$UnsupportedLocaleErrorCopyWithImpl<$Res>
    implements $UnsupportedLocaleErrorCopyWith<$Res> {
  _$UnsupportedLocaleErrorCopyWithImpl(this._self, this._then);

  final UnsupportedLocaleError _self;
  final $Res Function(UnsupportedLocaleError) _then;

/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invalidLocaleCode = null,Object? supportedLocales = null,}) {
  return _then(UnsupportedLocaleError(
invalidLocaleCode: null == invalidLocaleCode ? _self.invalidLocaleCode : invalidLocaleCode // ignore: cast_nullable_to_non_nullable
as String,supportedLocales: null == supportedLocales ? _self._supportedLocales : supportedLocales // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class PlatformDetectionFailedError implements LocaleError {
  const PlatformDetectionFailedError({required this.reason});
  

 final  String reason;

/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformDetectionFailedErrorCopyWith<PlatformDetectionFailedError> get copyWith => _$PlatformDetectionFailedErrorCopyWithImpl<PlatformDetectionFailedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformDetectionFailedError&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'LocaleError.platformDetectionFailed(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $PlatformDetectionFailedErrorCopyWith<$Res> implements $LocaleErrorCopyWith<$Res> {
  factory $PlatformDetectionFailedErrorCopyWith(PlatformDetectionFailedError value, $Res Function(PlatformDetectionFailedError) _then) = _$PlatformDetectionFailedErrorCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$PlatformDetectionFailedErrorCopyWithImpl<$Res>
    implements $PlatformDetectionFailedErrorCopyWith<$Res> {
  _$PlatformDetectionFailedErrorCopyWithImpl(this._self, this._then);

  final PlatformDetectionFailedError _self;
  final $Res Function(PlatformDetectionFailedError) _then;

/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(PlatformDetectionFailedError(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PersistenceFailedError implements LocaleError {
  const PersistenceFailedError({required this.operation, required this.reason});
  

 final  String operation;
 final  String reason;

/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersistenceFailedErrorCopyWith<PersistenceFailedError> get copyWith => _$PersistenceFailedErrorCopyWithImpl<PersistenceFailedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersistenceFailedError&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,operation,reason);

@override
String toString() {
  return 'LocaleError.persistenceFailed(operation: $operation, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $PersistenceFailedErrorCopyWith<$Res> implements $LocaleErrorCopyWith<$Res> {
  factory $PersistenceFailedErrorCopyWith(PersistenceFailedError value, $Res Function(PersistenceFailedError) _then) = _$PersistenceFailedErrorCopyWithImpl;
@useResult
$Res call({
 String operation, String reason
});




}
/// @nodoc
class _$PersistenceFailedErrorCopyWithImpl<$Res>
    implements $PersistenceFailedErrorCopyWith<$Res> {
  _$PersistenceFailedErrorCopyWithImpl(this._self, this._then);

  final PersistenceFailedError _self;
  final $Res Function(PersistenceFailedError) _then;

/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? reason = null,}) {
  return _then(PersistenceFailedError(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ValidationFailedError implements LocaleError {
  const ValidationFailedError({required this.locale, required this.validationRule});
  

 final  String locale;
 final  String validationRule;

/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailedErrorCopyWith<ValidationFailedError> get copyWith => _$ValidationFailedErrorCopyWithImpl<ValidationFailedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailedError&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.validationRule, validationRule) || other.validationRule == validationRule));
}


@override
int get hashCode => Object.hash(runtimeType,locale,validationRule);

@override
String toString() {
  return 'LocaleError.validationFailed(locale: $locale, validationRule: $validationRule)';
}


}

/// @nodoc
abstract mixin class $ValidationFailedErrorCopyWith<$Res> implements $LocaleErrorCopyWith<$Res> {
  factory $ValidationFailedErrorCopyWith(ValidationFailedError value, $Res Function(ValidationFailedError) _then) = _$ValidationFailedErrorCopyWithImpl;
@useResult
$Res call({
 String locale, String validationRule
});




}
/// @nodoc
class _$ValidationFailedErrorCopyWithImpl<$Res>
    implements $ValidationFailedErrorCopyWith<$Res> {
  _$ValidationFailedErrorCopyWithImpl(this._self, this._then);

  final ValidationFailedError _self;
  final $Res Function(ValidationFailedError) _then;

/// Create a copy of LocaleError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? locale = null,Object? validationRule = null,}) {
  return _then(ValidationFailedError(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,validationRule: null == validationRule ? _self.validationRule : validationRule // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
