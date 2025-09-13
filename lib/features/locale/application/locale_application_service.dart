import 'package:injectable/injectable.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Simplified application service for Vietnamese-first locale management.
///
/// This service implements a streamlined locale strategy:
/// - Vietnamese default on startup
/// - Session-only language switching
/// - Synchronous operations for fast performance
/// - Minimal logging for essential operations only
@injectable
class LocaleApplicationService {
  /// Creates locale application service with dependencies.
  const LocaleApplicationService({
    required LocaleDomainService domainService,
    required ILoggerService logger,
  }) : _domainService = domainService,
       _logger = logger;

  final LocaleDomainService _domainService;
  final ILoggerService _logger;

  /// Switches user locale for current session only.
  ///
  /// This method handles session-only locale switching:
  /// - Validates the requested locale through domain service
  /// - Updates session state only (no persistence)
  /// - Applies the locale change to current session immediately
  /// - All operations are synchronous for fast performance
  ///
  /// Throws [UnsupportedLocaleException] if locale is not supported.
  LocaleConfiguration switchLocale(AppLocale locale) {
    try {
      _logger.log(
        '🌐 Switching locale to ${locale.languageCode}',
        LogLevel.info,
      );

      // Use domain service for validation and session update
      final configuration = _domainService.updateUserLocale(
        locale.languageCode,
      );

      // Apply to current session immediately
      _applyLocaleToSession(locale);

      _logger.log('✅ Session locale switch completed', LogLevel.info);

      return configuration;
    } on UnsupportedLocaleException catch (e) {
      _logger.log('Locale switch failed: ${e.message}', LogLevel.warning);
      rethrow;
    }
  }

  /// Gets current locale configuration from domain layer.
  ///
  /// This method provides read-only access to the current locale state.
  /// Synchronous operation for fast access.
  LocaleConfiguration getCurrentConfiguration() {
    final configuration = _domainService.resolveLocaleConfiguration();

    _logger.log(
      'Current locale: ${configuration.languageCode} '
      '(source: ${configuration.source})',
      LogLevel.debug,
    );

    return configuration;
  }

  /// Initializes locale system to Vietnamese default.
  ///
  /// This method handles initial locale setup during app bootstrap.
  /// Always starts with Vietnamese default, synchronous for fast startup.
  LocaleConfiguration initializeLocaleSystem() {
    _logger.log(
      '🚀 Initializing locale system to Vietnamese...',
      LogLevel.info,
    );

    final configuration = _domainService.resolveLocaleConfiguration();

    // Apply Vietnamese default to session
    _applyLocaleToSession(AppLocale.vi);

    _logger.log('✅ Locale system initialized: Vietnamese', LogLevel.info);

    return configuration;
  }

  /// Applies locale change to current session synchronously.
  ///
  /// This method handles the infrastructure concern of updating the
  /// current session's locale immediately without async operations.
  void _applyLocaleToSession(AppLocale locale) {
    try {
      _logger.log('🔄 Applying locale to current session', LogLevel.debug);

      // Apply locale to current session synchronously
      LocaleSettings.setLocale(locale);

      _logger.log('Session locale updated successfully', LogLevel.debug);
    } on Exception catch (e) {
      _logger.log(
        'Failed to apply locale to session',
        LogLevel.error,
        error: e,
      );
      // Don't throw here - session update failure shouldn't break the app
    }
  }

  /// Resets locale to Vietnamese default for current session.
  ///
  /// This operation clears session state and returns to Vietnamese default.
  /// Synchronous operation with no persistence involved.
  LocaleConfiguration resetToSystemDefault() {
    _logger.log('🔄 Resetting locale to Vietnamese default', LogLevel.info);

    final configuration = _domainService.resetToSystemDefault();

    // Apply Vietnamese default to session
    _applyLocaleToSession(AppLocale.vi);

    _logger.log('✅ Locale reset to Vietnamese default', LogLevel.info);

    return configuration;
  }
}
