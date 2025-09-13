import 'package:injectable/injectable.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Simplified domain service for Vietnamese-first locale management.
///
/// This service implements a simplified locale strategy:
/// - Always defaults to Vietnamese on startup
/// - Session-only language switching (no persistence)
/// - Synchronous operations for fast performance
/// - No platform detection or complex resolution logic
@injectable
class LocaleDomainService {
  /// Creates locale domain service with no external dependencies.
  LocaleDomainService();

  LocaleConfiguration? _sessionLocale;

  /// Returns current locale configuration.
  ///
  /// Always starts with Vietnamese default, but can be changed during session.
  /// No async operations - returns immediately for fast startup performance.
  LocaleConfiguration resolveLocaleConfiguration() {
    return _sessionLocale ?? LocaleConfigurationExtension.defaultFallback();
  }

  /// Updates user's locale preference for current session only.
  ///
  /// This method handles session-only locale changes:
  /// - Validates locale is supported
  /// - Updates session state only (no persistence)
  /// - Returns immediately without async operations
  LocaleConfiguration updateUserLocale(String languageCode) {
    if (!_isLocaleSupported(languageCode)) {
      throw UnsupportedLocaleException(
        'Locale "$languageCode" is not supported. '
        'Supported locales: ${_getSupportedLocaleCodes()}',
      );
    }

    final configuration = LocaleConfigurationExtension.userSelected(
      languageCode,
    );
    _sessionLocale = configuration;
    return configuration;
  }

  /// Resets locale to Vietnamese default for current session.
  ///
  /// This clears any session locale and returns to Vietnamese default.
  /// No async operations or persistence involved.
  LocaleConfiguration resetToSystemDefault() {
    _sessionLocale = null;
    return resolveLocaleConfiguration();
  }

  /// Validates if a locale is supported by the application.
  ///
  /// This encapsulates the business rule of what locales are valid,
  /// keeping this logic centralized and testable.
  bool _isLocaleSupported(String languageCode) {
    return AppLocale.values.any(
      (locale) => locale.languageCode == languageCode,
    );
  }

  /// Gets list of supported locale codes for error messages.
  List<String> _getSupportedLocaleCodes() {
    return AppLocale.values.map((locale) => locale.languageCode).toList();
  }
}

/// Exception thrown when attempting to use an unsupported locale.
///
/// This domain exception clearly communicates business rule violations
/// related to locale support, following explicit error handling principles.
class UnsupportedLocaleException implements Exception {
  /// Creates exception with descriptive message.
  const UnsupportedLocaleException(this.message);

  /// Descriptive error message explaining the validation failure.
  final String message;

  @override
  String toString() => 'UnsupportedLocaleException: $message';
}
