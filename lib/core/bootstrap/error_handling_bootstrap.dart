import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// Bootstrap module responsible for error handling setup.
///
/// Following Single Responsibility Principle, this module only handles
/// Flutter error configuration and logging setup. As Linus says:
/// "Do one thing and do it well."
class ErrorHandlingBootstrap {
  /// Creates error handling bootstrap with logger dependency.
  const ErrorHandlingBootstrap({required LoggerService logger})
    : _logger = logger;

  final LoggerService _logger;

  /// Configures global error handling for Flutter application.
  ///
  /// This method sets up:
  /// - FlutterError.onError for widget errors
  /// - Logging configuration for error tracking
  ///
  /// Error handling should be one of the first things configured
  /// during app initialization to catch early startup errors.
  void setupErrorHandling() {
    // Configure Flutter error handler to log errors properly
    FlutterError.onError = (FlutterErrorDetails details) {
      _logger.error('Flutter Error', details.exception, details.stack);

      // Also log to developer console for debugging
      log(
        details.exceptionAsString(),
        name: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    _logger.info('✅ Error handling configured successfully');
  }

  /// Handles uncaught async errors that escape Flutter's error zone.
  ///
  /// This is typically used with runZonedGuarded to catch async errors
  /// that don't get handled by FlutterError.onError.
  void handleAsyncError(Object error, StackTrace stackTrace) {
    _logger.error('Uncaught Async Error', error, stackTrace);

    log(
      'Uncaught async error',
      name: 'AsyncError',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
