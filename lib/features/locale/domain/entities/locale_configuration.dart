import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_configuration.freezed.dart';
part 'locale_configuration.g.dart';

/// Immutable locale configuration entity representing user's language
/// preferences.
///
/// Following DDD principles, this entity encapsulates locale business rules
/// and invariants. Uses Freezed for automatic generation of equality,
/// toString, copyWith, and JSON serialization methods.
///
/// As Martin Fowler advocates: "Domain objects should be responsible for
/// their own validation and consistency."
@freezed
sealed class LocaleConfiguration with _$LocaleConfiguration {
  /// Creates a locale configuration with specified parameters.
  const factory LocaleConfiguration({
    required String languageCode,
    required LocaleSource source,
    String? countryCode,
  }) = _LocaleConfiguration;

  /// Creates a LocaleConfiguration from JSON map.
  factory LocaleConfiguration.fromJson(Map<String, dynamic> json) =>
      _$LocaleConfigurationFromJson(json);
}

/// Extension methods for LocaleConfiguration to provide business logic.
extension LocaleConfigurationExtension on LocaleConfiguration {
  /// Creates configuration from user selection.
  static LocaleConfiguration userSelected(String languageCode) {
    return LocaleConfiguration(
      languageCode: languageCode,
      source: LocaleSource.userSelected,
    );
  }

  /// Creates configuration from system detection.
  static LocaleConfiguration systemDetected(
    String languageCode, [
    String? countryCode,
  ]) {
    return LocaleConfiguration(
      languageCode: languageCode,
      countryCode: countryCode,
      source: LocaleSource.systemDetected,
    );
  }

  /// Creates default fallback configuration.
  static LocaleConfiguration defaultFallback() {
    return const LocaleConfiguration(
      languageCode: 'vi', // Project default as specified
      source: LocaleSource.defaultFallback,
    );
  }

  /// Full locale identifier (language-country format when country available).
  String get fullLocaleId {
    if (countryCode != null) {
      return '${languageCode}_$countryCode';
    }
    return languageCode;
  }

  /// Whether this configuration was explicitly chosen by user.
  bool get isUserSelected => source == LocaleSource.userSelected;

  /// Whether this configuration came from system detection.
  bool get isSystemDetected => source == LocaleSource.systemDetected;

  /// Whether this is the default fallback configuration.
  bool get isDefaultFallback => source == LocaleSource.defaultFallback;
}

/// Enumeration of possible locale configuration sources.
///
/// Tracks how a locale configuration was determined to support
/// different business logic based on source.
enum LocaleSource {
  /// User explicitly selected this locale.
  userSelected,

  /// System automatically detected this locale.
  systemDetected,

  /// Default fallback when no other source available.
  defaultFallback,
}
