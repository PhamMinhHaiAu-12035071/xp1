import 'package:xp1/core/constants/app_constants.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// Bootstrap module responsible for dependency injection setup.
///
/// This module handles GetIt configuration and dependency registration
/// following Single Responsibility Principle. It eliminates the need
/// for global state flags by using proper lifecycle management.
class DependencyBootstrap {
  /// Creates dependency bootstrap with logger dependency.
  const DependencyBootstrap({
    required LoggerService logger,
  }) : _logger = logger;

  final LoggerService _logger;

  /// Configures dependency injection container with timeout protection.
  ///
  /// This method handles:
  /// - GetIt container initialization
  /// - Injectable code generation execution
  /// - Proper error handling and logging
  /// - Timeout protection for reliable startup
  ///
  /// Unlike the previous implementation with global flags, this uses
  /// proper exception handling and container state checking.
  Future<void> setupDependencies() async {
    try {
      _logger.info('📦 Setting up dependency injection...');

      // Check if dependencies are already configured
      if (getIt.isRegistered<LoggerService>()) {
        _logger.debug('Dependencies already configured, skipping setup');
        return;
      }

      // Configure dependencies with timeout protection
      await configureDependencies().timeout(
        BootstrapConstants.dependencySetupTimeout,
        onTimeout: () {
          _logger.error('Dependency setup timed out');
          throw const DependencyBootstrapException(
            'Dependency injection setup exceeded timeout limit',
          );
        },
      );

      _logger.info('✅ Dependency injection configured successfully');
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to setup dependencies', e, stackTrace);
      throw DependencyBootstrapException(
        'Dependency injection setup failed',
        e,
      );
    }
  }

  /// Resets dependency injection container for testing.
  ///
  /// This method is specifically for test environments to ensure
  /// clean state between test runs. Production code should not
  /// need to reset dependencies.
  Future<void> resetDependenciesForTesting() async {
    try {
      _logger.debug('🧪 Resetting dependencies for testing...');
      await getIt.reset();
      _logger.debug('✅ Dependencies reset completed');
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to reset dependencies', e, stackTrace);
      throw DependencyBootstrapException(
        'Dependency reset failed during testing',
        e,
      );
    }
  }

  /// Validates that critical dependencies are properly registered.
  ///
  /// This provides early detection of dependency configuration issues
  /// rather than failing later during runtime when dependencies are needed.
  void validateCriticalDependencies() {
    final criticalServices = <Type>[
      LoggerService,
      // Add other critical services as they're registered
    ];

    for (final serviceType in criticalServices) {
      if (!getIt.isRegistered(type: serviceType)) {
        throw DependencyBootstrapException(
          'Critical dependency not registered: $serviceType',
        );
      }
    }

    _logger.info('✅ All critical dependencies validated');
  }
}

/// Exception thrown when dependency bootstrap operations fail.
///
/// This specific exception provides clear context about dependency
/// initialization failures, making debugging easier.
class DependencyBootstrapException implements Exception {
  /// Creates exception with context and optional original error.
  const DependencyBootstrapException(this.message, [this.originalError]);

  /// Description of the dependency bootstrap failure.
  final String message;

  /// Original error that caused the bootstrap failure.
  final Object? originalError;

  @override
  String toString() =>
      'DependencyBootstrapException: $message'
      '${originalError != null ? ' (caused by: $originalError)' : ''}';
}
