import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_errors.freezed.dart';

/// Sealed class representing all possible locale-related errors.
///
/// Using functional programming approach with FpDart Either pattern
/// instead of throwing exceptions. This provides better composability,
/// error handling, and follows functional programming principles.
///
/// As Rich Hickey says: "Programs must be written for people to read,
/// and only incidentally for machines to execute."
@freezed
sealed class LocaleError with _$LocaleError {
  /// Error when attempting to use an unsupported locale.
  ///
  /// Contains the invalid locale code and list of supported locales
  /// for better error context and user guidance.
  const factory LocaleError.unsupportedLocale({
    required String invalidLocaleCode,
    required List<String> supportedLocales,
  }) = UnsupportedLocaleError;

  /// Error when platform locale detection fails.
  ///
  /// This can happen on platforms where locale detection is not
  /// available or when platform APIs fail unexpectedly.
  const factory LocaleError.platformDetectionFailed({required String reason}) =
      PlatformDetectionFailedError;

  /// Error when locale persistence operations fail.
  ///
  /// This covers scenarios where HydratedBloc storage fails or
  /// when serialization/deserialization encounters issues.
  const factory LocaleError.persistenceFailed({
    required String operation,
    required String reason,
  }) = PersistenceFailedError;

  /// Error when locale validation fails.
  ///
  /// Covers cases where locale format is invalid or contains
  /// unexpected characters/structure.
  const factory LocaleError.validationFailed({
    required String locale,
    required String validationRule,
  }) = ValidationFailedError;
}

/// Extension methods for LocaleError to provide convenient error handling.
extension LocaleErrorExtension on LocaleError {
  /// Gets a user-friendly error message for display purposes.
  String get userMessage {
    return when(
      unsupportedLocale: (invalidCode, supportedCodes) =>
          'Language "$invalidCode" is not supported. '
          'Available languages: ${supportedCodes.join(", ")}',
      platformDetectionFailed: (reason) =>
          'Unable to detect your system language. $reason',
      persistenceFailed: (operation, reason) =>
          'Failed to save language preference. '
          'Operation: $operation, Reason: $reason',
      validationFailed: (locale, rule) =>
          'Invalid language format "$locale". Rule: $rule',
    );
  }

  /// Gets a technical error message for debugging/logging purposes.
  String get technicalMessage {
    return when(
      unsupportedLocale: (invalidCode, supportedCodes) =>
          'UnsupportedLocaleError: $invalidCode not in $supportedCodes',
      platformDetectionFailed: (reason) =>
          'PlatformDetectionFailedError: $reason',
      persistenceFailed: (operation, reason) =>
          'PersistenceFailedError: $operation failed - $reason',
      validationFailed: (locale, rule) =>
          'ValidationFailedError: $locale violates $rule',
    );
  }

  /// Gets the error type for metrics/analytics purposes.
  String get errorType {
    return when(
      unsupportedLocale: (_, _) => 'unsupported_locale',
      platformDetectionFailed: (_) => 'platform_detection_failed',
      persistenceFailed: (_, _) => 'persistence_failed',
      validationFailed: (_, _) => 'validation_failed',
    );
  }

  /// Checks if this error is recoverable (user can take action).
  bool get isRecoverable {
    return when(
      unsupportedLocale: (_, _) => true, // User can select different locale
      platformDetectionFailed: (_) => true, // User can manually select
      persistenceFailed: (_, _) => false, // System-level issue
      validationFailed: (_, _) => true, // User can provide valid input
    );
  }
}
