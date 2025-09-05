import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/repositories/locale_repository.dart';
import 'package:xp1/features/locale/domain/services/platform_locale_provider.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Domain service for locale business logic and orchestration.
///
/// This service encapsulates the core business rules for locale management
/// following DDD principles. It coordinates between repository, platform
/// detection, and validation without depending on infrastructure concerns.
///
/// **DEPRECATED**: This service has been replaced by LocaleCubit which
/// provides the same business logic with automatic persistence via
/// HydratedBloc. This class is kept for backward compatibility but
/// should not be used in new code.
///
/// As Eric Evans explains: "Domain services encapsulate domain logic that
/// doesn't naturally fit within an entity or value object."
class LocaleDomainService {
  /// Creates locale domain service with required dependencies.
  const LocaleDomainService({
    required LocaleRepository repository,
    required PlatformLocaleProvider platformProvider,
  }) : _repository = repository,
       _platformProvider = platformProvider;

  final LocaleRepository _repository;
  final PlatformLocaleProvider _platformProvider;

  /// Determines the best locale configuration for the current context.
  ///
  /// This method implements the locale resolution strategy:
  /// 1. Use saved user preference if available
  /// 2. Detect and validate system locale
  /// 3. Fall back to default project locale (Vietnamese)
  ///
  /// This business logic is centralized here rather than scattered
  /// across the application, following single responsibility principle.
  Future<LocaleConfiguration> resolveLocaleConfiguration() async {
    // Strategy 1: Use saved user preference
    final savedLocale = await _repository.getCurrentLocale();
    if (savedLocale != null && _isLocaleSupported(savedLocale.languageCode)) {
      return savedLocale;
    }

    // Strategy 2: Detect and validate system locale
    final systemLocaleCode = _platformProvider.getSystemLocale();
    if (_isLocaleSupported(systemLocaleCode)) {
      final systemLocale = LocaleConfigurationExtension.systemDetected(
        systemLocaleCode,
      );
      // Auto-save system locale for consistency
      await _repository.saveLocale(systemLocale);
      return systemLocale;
    }

    // Strategy 3: Default fallback
    final defaultLocale = LocaleConfigurationExtension.defaultFallback();
    await _repository.saveLocale(defaultLocale);
    return defaultLocale;
  }

  /// Updates user's locale preference with validation.
  ///
  /// This method handles the business rules around locale changes:
  /// - Validates locale is supported
  /// - Persists the choice for future sessions
  /// - Returns the final configuration
  Future<LocaleConfiguration> updateUserLocale(String languageCode) async {
    if (!_isLocaleSupported(languageCode)) {
      throw UnsupportedLocaleException(
        'Locale "$languageCode" is not supported. '
        'Supported locales: ${_getSupportedLocaleCodes()}',
      );
    }

    final configuration = LocaleConfigurationExtension.userSelected(
      languageCode,
    );
    await _repository.saveLocale(configuration);
    return configuration;
  }

  /// Resets locale to system default, clearing user preference.
  ///
  /// This is useful for "reset to default" functionality or testing.
  Future<LocaleConfiguration> resetToSystemDefault() async {
    await _repository.clearSavedLocale();
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
