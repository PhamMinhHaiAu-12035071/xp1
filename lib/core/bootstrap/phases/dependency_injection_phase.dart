import 'package:meta/meta.dart';
import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// Bootstrap phase responsible for dependency injection setup.
///
/// This phase implements SRP by focusing solely on DI configuration
/// and provides proper error handling and rollback capabilities.
class DependencyInjectionPhase implements BootstrapPhase {
  /// Creates dependency injection phase with logger.
  const DependencyInjectionPhase({
    required LoggerService logger,
  }) : _logger = logger;

  final LoggerService _logger;

  @override
  String get phaseName => 'Dependency Injection';

  @override
  int get priority => 1; // Highest priority - everything depends on DI

  @override
  bool get canSkip => false; // Critical phase - cannot skip

  @override
  Future<void> validatePreconditions() async {
    // Check if container is already configured to avoid double initialization
    if (getIt.isRegistered<LoggerService>()) {
      throw BootstrapException(
        'Dependency injection already configured',
        phase: phaseName,
      );
    }
  }

  @override
  Future<BootstrapResult> execute() async {
    try {
      _logger.info('📦 Configuring dependency injection container...');

      // Configure dependencies
      await configureDependencies();

      // Validate critical dependencies are registered
      validateCriticalDependencies();

      _logger.info('✅ Dependency injection configured successfully');

      return BootstrapResult.success(
        data: {
          'container_state': 'configured',
          'registered_services': _getRegisteredServicesCount(),
        },
        message: 'DI container configured with critical services',
      );
    } on BootstrapException {
      rethrow; // Re-throw bootstrap exceptions as-is
    } on Exception catch (e) {
      throw BootstrapException(
        'Failed to configure dependency injection',
        phase: phaseName,
        originalError: e,
        canRetry: true,
      );
    }
  }

  @override
  Future<void> rollback() async {
    _logger.info('🔄 Rolling back dependency injection...');
    await getIt.reset();
    _logger.info('✅ Dependency injection rollback completed');
  }

  /// Validates that critical dependencies are properly registered.
  @protected
  void validateCriticalDependencies() {
    const criticalServices = <Type>[
      ILoggerService,
      // Add other critical services as they're registered
    ];

    for (final serviceType in criticalServices) {
      if (!getIt.isRegistered(type: serviceType)) {
        throw BootstrapException(
          'Critical dependency not registered: $serviceType',
          phase: phaseName,
        );
      }
    }
  }

  /// Gets count of registered services for monitoring.
  int _getRegisteredServicesCount() {
    // GetIt doesn't expose a count method, so we return a placeholder
    // In a real implementation, you might maintain your own registry
    return 1; // At least LoggerService is registered
  }
}
