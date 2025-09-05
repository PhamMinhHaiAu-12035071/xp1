import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/features/locale/application/locale_application_service.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';

/// Bootstrap phase responsible for locale system initialization.
///
/// This phase implements SRP by focusing solely on locale configuration
/// and provides proper error handling and rollback capabilities.
///
/// The locale system determines the appropriate language based on:
/// 1. Saved user preferences (if available)
/// 2. System-detected locale (if supported)
/// 3. Default fallback locale (Vietnamese as project default)
class LocaleBootstrapPhase implements BootstrapPhase {
  /// Creates locale bootstrap phase with logger.
  const LocaleBootstrapPhase({
    required LoggerService logger,
  }) : _logger = logger;

  final LoggerService _logger;

  @override
  String get phaseName => 'Locale System';

  @override
  int get priority => 3; // After DI and error handling

  @override
  bool get canSkip => false; // Critical for user experience

  @override
  Future<void> validatePreconditions() async {
    // No preconditions to validate - DI registration will be checked during
    // execution since the DependencyInjectionPhase runs before this phase
  }

  @override
  Future<BootstrapResult> execute() async {
    try {
      _logger.info('🌐 Initializing locale system...');

      // Validate that dependency injection is configured
      if (!getIt.isRegistered<LocaleApplicationService>()) {
        throw BootstrapException(
          'LocaleApplicationService not registered in DI container',
          phase: phaseName,
        );
      }

      // Get locale application service from DI container
      final localeService = getIt<LocaleApplicationService>();

      // Initialize locale system using existing application service
      final localeConfiguration = await localeService.initializeLocaleSystem();

      _logger.info(
        '✅ Locale system initialized: ${localeConfiguration.languageCode} '
        '(source: ${localeConfiguration.source})',
      );

      return BootstrapResult.success(
        data: {
          'locale_configuration': localeConfiguration,
          'language_code': localeConfiguration.languageCode,
          'locale_source': localeConfiguration.source.name,
          'full_locale_id': localeConfiguration.fullLocaleId,
        },
        message:
            'Locale system initialized with '
            '${localeConfiguration.languageCode}',
      );
    } on BootstrapException {
      rethrow; // Re-throw bootstrap exceptions as-is
    } on Exception catch (e) {
      throw BootstrapException(
        'Failed to initialize locale system',
        phase: phaseName,
        originalError: e,
        canRetry: true,
      );
    }
  }

  @override
  Future<void> rollback() async {
    try {
      _logger.info('🔄 Rolling back locale system...');

      // Get locale service for rollback
      if (getIt.isRegistered<LocaleApplicationService>()) {
        final localeService = getIt<LocaleApplicationService>();

        // Reset to system default as rollback strategy
        await localeService.resetToSystemDefault();
      }

      _logger.info('✅ Locale system rollback completed');
    } on Exception catch (e) {
      _logger.error('Failed to rollback locale system', e);
      // Don't throw - rollback should be resilient
    }
  }
}
