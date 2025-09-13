import 'package:flutter/widgets.dart';
import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// Bootstrap phase responsible for error handling configuration.
///
/// This phase sets up global error handlers and follows SRP by focusing
/// only on error handling setup.
class ErrorHandlingPhase implements BootstrapPhase {
  /// Creates error handling phase with logger dependency.
  const ErrorHandlingPhase({required LoggerService logger}) : _logger = logger;

  final LoggerService _logger;

  @override
  String get phaseName => 'Error Handling';

  @override
  int get priority => 2; // After DI, before other components

  @override
  bool get canSkip => false; // Critical for production stability

  @override
  Future<void> validatePreconditions() async {
    // Validate that logger is available for error handling
    // Logger is injected through constructor and always available
  }

  @override
  Future<BootstrapResult> execute() async {
    try {
      _logger.info('⚡ Configuring global error handling...');

      // Setup Flutter error handler
      FlutterError.onError = (details) {
        _logger.error(
          'Flutter Error: ${details.exceptionAsString()}',
          details.exception,
          details.stack,
        );
      };

      _logger.info('✅ Error handling configured successfully');

      return const BootstrapResult.success(
        data: {'error_handler': 'configured'},
        message: 'Global error handling is active',
      );
    } on Exception catch (e) {
      throw BootstrapException(
        'Failed to configure error handling',
        phase: phaseName,
        originalError: e,
        canRetry: true,
      );
    }
  }

  @override
  Future<void> rollback() async {
    try {
      _logger.info('🔄 Rolling back error handling...');

      // Reset to default Flutter error handler
      FlutterError.onError = null;

      _logger.info('✅ Error handling rollback completed');
    } on Exception catch (e) {
      _logger.error('Failed to rollback error handling', e);
      // Don't throw - rollback should be resilient
    }
  }
}
