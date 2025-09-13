import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/features/locale/application/locale_application_service.dart';

/// Bootstrap phase responsible for Vietnamese-first locale initialization.
///
/// This simplified phase implements fast locale initialization:
/// - Always starts with Vietnamese default
/// - Synchronous operations for fast startup
/// - No persistence or complex resolution logic
class LocaleBootstrapPhase implements BootstrapPhase {
  /// Creates locale bootstrap phase with logger.
  const LocaleBootstrapPhase({required LoggerService logger})
    : _logger = logger;

  final LoggerService _logger;

  @override
  String get phaseName => 'Locale System';

  @override
  int get priority => 3; // After DI and error handling

  @override
  bool get canSkip => false; // Critical for user experience

  @override
  Future<void> validatePreconditions() async {
    // No preconditions needed - fast Vietnamese initialization
  }

  @override
  Future<BootstrapResult> execute() async {
    try {
      _logger.info('🌐 Initializing Vietnamese locale system...');

      // Validate that dependency injection is configured
      if (!getIt.isRegistered<LocaleApplicationService>()) {
        throw BootstrapException(
          'LocaleApplicationService not registered in DI container',
          phase: phaseName,
        );
      }

      // Get locale application service from DI container
      final localeService = getIt<LocaleApplicationService>();

      // Initialize locale system synchronously to Vietnamese
      final localeConfiguration = localeService.initializeLocaleSystem();

      _logger.info('✅ Vietnamese locale system initialized');

      return BootstrapResult.success(
        data: {
          'locale_configuration': localeConfiguration,
          'language_code': 'vi',
          'locale_source': 'defaultFallback',
          'full_locale_id': 'vi_VN',
        },
        message: 'Vietnamese locale system initialized',
      );
    } on BootstrapException {
      rethrow; // Re-throw bootstrap exceptions as-is
    } on Exception catch (e) {
      throw BootstrapException(
        'Failed to initialize Vietnamese locale system',
        phase: phaseName,
        originalError: e,
        canRetry: true,
      );
    }
  }

  @override
  Future<void> rollback() async {
    try {
      _logger.info('🔄 Rolling back to Vietnamese locale...');

      // Get locale service for rollback
      if (getIt.isRegistered<LocaleApplicationService>()) {
        // Reset to Vietnamese default as rollback strategy
        getIt<LocaleApplicationService>().resetToSystemDefault();
      }

      _logger.info('✅ Vietnamese locale rollback completed');
    } on Exception catch (e) {
      _logger.error('Failed to rollback Vietnamese locale system', e);
      // Don't throw - rollback should be resilient
    }
  }
}
