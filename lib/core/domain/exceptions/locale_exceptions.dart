/// Exception classes for locale initialization and management.
///
/// This module contains custom exceptions for locale-related operations,
/// following the project pattern of specific exception classes instead of
/// generic Exception. As Linus says: "Be specific, not generic."
library;

/// Locale service exception for initialization failures.
///
/// Following project pattern of specific exception classes instead of
/// generic Exception. Linus says: "Be specific, not generic."
class LocaleInitializationException implements Exception {
  /// Creates a locale initialization exception with the given error.
  const LocaleInitializationException(this.message, [this.originalError]);

  /// The error message describing what went wrong.
  final String message;

  /// The original error that caused the locale initialization failure.
  final Object? originalError;

  @override
  String toString() =>
      'LocaleInitializationException: $message'
      '${originalError != null ? ' (caused by: $originalError)' : ''}';
}
