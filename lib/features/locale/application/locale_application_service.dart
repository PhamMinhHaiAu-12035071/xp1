import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Application service for locale management following DDD principles.
///
/// This service acts as a facade between the UI layer and the domain layer,
/// orchestrating locale operations while maintaining clean architecture.
/// It follows the Application Service pattern from DDD.
///
/// Responsibilities:
/// - Coordinate between domain services and infrastructure
/// - Handle transaction boundaries
/// - Provide a clean API for UI operations
/// - Manage cross-cutting concerns like logging
class LocaleApplicationService {
  /// Creates locale application service with dependencies.
  const LocaleApplicationService({
    required LocaleDomainService domainService,
    required LoggerService logger,
  }) : _domainService = domainService,
       _logger = logger;

  final LocaleDomainService _domainService;
  final LoggerService _logger;

  /// Switches user locale with proper validation and persistence.
  ///
  /// This method orchestrates the complete locale switching process:
  /// 1. Validates the requested locale through domain service
  /// 2. Updates user preferences via domain service
  /// 3. Applies the locale change to the current session
  /// 4. Handles any errors with proper recovery
  ///
  /// This approach maintains DDD principles by:
  /// - Using domain service for business logic
  /// - Keeping infrastructure concerns separated
  /// - Providing proper error handling and recovery
  ///
  /// Throws [UnsupportedLocaleException] if locale is not supported.
  /// Throws [LocaleApplicationException] for unexpected errors.
  Future<LocaleConfiguration> switchLocale(AppLocale locale) async {
    try {
      _logger.info('🌐 Switching locale to ${locale.languageCode}');

      // Step 1: Use domain service for validation and persistence
      final configuration = await _domainService.updateUserLocale(
        locale.languageCode,
      );

      _logger.info(
        'Domain locale update completed: ${configuration.languageCode}',
      );

      // Step 2: Apply to current session (infrastructure concern)
      // Note: This is handled separately to maintain clean architecture
      await _applyLocaleToSession(locale);

      _logger.info('✅ Locale switch completed successfully');

      return configuration;
    } on UnsupportedLocaleException catch (e) {
      _logger.warning('Locale switch failed: ${e.message}');
      // Re-throw domain exceptions as-is to preserve error semantics
      rethrow;
    } on Exception catch (e, stackTrace) {
      _logger.error('Unexpected locale switch error', e, stackTrace);
      // Wrap unexpected errors in application-specific exception
      throw LocaleApplicationException(
        'Failed to switch locale to ${locale.languageCode}',
        originalError: e,
      );
    }
  }

  /// Gets current locale configuration from domain layer.
  ///
  /// This method provides read-only access to the current locale state
  /// through the domain service, ensuring consistency with business rules.
  Future<LocaleConfiguration> getCurrentConfiguration() async {
    try {
      _logger.debug('🔍 Retrieving current locale configuration');

      final configuration = await _domainService.resolveLocaleConfiguration();

      _logger.debug(
        'Current locale: ${configuration.languageCode} '
        '(source: ${configuration.source})',
      );

      return configuration;
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to get current locale configuration',
        e,
        stackTrace,
      );
      throw LocaleApplicationException(
        'Unable to retrieve current locale configuration',
        originalError: e,
      );
    }
  }

  /// Initializes locale system for application startup.
  ///
  /// This method handles the initial locale setup during app bootstrap,
  /// determining the appropriate locale based on user preferences and
  /// system settings.
  Future<LocaleConfiguration> initializeLocaleSystem() async {
    try {
      _logger.info('🚀 Initializing locale system...');

      final configuration = await _domainService.resolveLocaleConfiguration();

      // Apply initial locale to session
      await _applyLocaleToSession(
        AppLocale.values.firstWhere(
          (locale) => locale.languageCode == configuration.languageCode,
          orElse: () => AppLocale.en, // Fallback to English
        ),
      );

      _logger.info(
        '✅ Locale system initialized: ${configuration.languageCode}',
      );

      return configuration;
    } on Exception catch (e, stackTrace) {
      _logger.error('Locale system initialization failed', e, stackTrace);
      throw LocaleApplicationException(
        'Failed to initialize locale system',
        originalError: e,
      );
    }
  }

  /// Applies locale change to current session.
  ///
  /// This method handles the infrastructure concern of updating the
  /// current session's locale. It's separated from business logic
  /// to maintain clean architecture.
  Future<void> _applyLocaleToSession(AppLocale locale) async {
    try {
      _logger.debug('🔄 Applying locale to current session');

      // Apply locale to current session
      await LocaleSettings.setLocale(locale);

      _logger.debug('Session locale updated successfully');
    } on Exception catch (e) {
      _logger.error('Failed to apply locale to session', e);
      // Don't throw here - session update is not critical for persistence
      // The domain layer has already been updated successfully
    }
  }

  /// Resets locale to system default.
  ///
  /// This operation removes user preferences and returns to system-detected
  /// locale, useful for user preference reset scenarios.
  Future<LocaleConfiguration> resetToSystemDefault() async {
    try {
      _logger.info('🔄 Resetting locale to system default');

      final configuration = await _domainService.resetToSystemDefault();

      await _applyLocaleToSession(
        AppLocale.values.firstWhere(
          (locale) => locale.languageCode == configuration.languageCode,
          orElse: () => AppLocale.en,
        ),
      );

      _logger.info('✅ Locale reset to system default');

      return configuration;
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to reset locale to system default', e, stackTrace);
      throw LocaleApplicationException(
        'Unable to reset locale to system default',
        originalError: e,
      );
    }
  }
}

/// Exception for locale application service failures.
///
/// This exception wraps infrastructure and unexpected errors that occur
/// at the application service level, providing context while preserving
/// the original error for debugging.
class LocaleApplicationException implements Exception {
  /// Creates exception with message and optional original error.
  const LocaleApplicationException(
    this.message, {
    this.originalError,
  });

  /// Description of the application service failure.
  final String message;

  /// Original error that caused the failure.
  final Object? originalError;

  @override
  String toString() =>
      'LocaleApplicationException: $message'
      '${originalError != null ? ' (caused by: $originalError)' : ''}';
}
