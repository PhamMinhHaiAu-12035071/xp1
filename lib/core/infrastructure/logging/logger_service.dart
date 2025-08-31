import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'i_logger_service.dart';

/// Implementation of [ILoggerService] using logger package.
///
/// Singleton pattern with immediate initialization - no late vars.
class LoggerService implements ILoggerService {
  /// Factory constructor with immediate logger creation.
  ///
  /// [isDevelopment] enables detailed logging if true. Defaults to kDebugMode.
  factory LoggerService({
    bool? isDevelopment,
  }) {
    final devMode = isDevelopment ?? kDebugMode;
    _instance ??= LoggerService._internal(_createLogger(devMode));
    return _instance!;
  }

  LoggerService._internal(this._logger);

  static LoggerService? _instance;
  final Logger _logger;

  /// Creates logger instance with environment-specific configuration.
  static Logger _createLogger(bool isDevelopment) {
    return Logger(
      filter: isDevelopment ? DevelopmentFilter() : ProductionFilter(),
      printer: isDevelopment
          ? PrettyPrinter(
              lineLength: 80, // Follow 80-char limit
            )
          : SimplePrinter(), // No bloat in production
      level: isDevelopment ? Level.debug : Level.warning,
    );
  }

  @override
  void log(
    String message,
    LogLevel level, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    // Performance: Skip debug logs in release builds
    if (level == LogLevel.debug && !kDebugMode) return;

    // Append extra data to message if provided
    final logMessage = extra != null ? '$message | Extra: $extra' : message;

    switch (level) {
      case LogLevel.debug:
        _logger.d(logMessage);
      case LogLevel.info:
        _logger.i(logMessage);
      case LogLevel.warning:
        _logger.w(logMessage);
      case LogLevel.error:
        _logger.e(logMessage, error: error, stackTrace: stackTrace);
      case LogLevel.fatal:
        _logger.f(logMessage, error: error, stackTrace: stackTrace);
    }
  }

  // Convenience methods (optional - can be removed for ultimate simplicity)

  /// Logs a debug message with optional extra data.
  void debug(String message, [Map<String, dynamic>? extra]) =>
      log(message, LogLevel.debug, extra: extra);

  /// Logs an info message with optional extra data.
  void info(String message, [Map<String, dynamic>? extra]) =>
      log(message, LogLevel.info, extra: extra);

  /// Logs a warning message with optional extra data.
  void warning(String message, [Map<String, dynamic>? extra]) =>
      log(message, LogLevel.warning, extra: extra);

  /// Logs an error message with optional error and stack trace.
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      log(message, LogLevel.error, error: error, stackTrace: stackTrace);

  /// Logs a fatal message with optional error and stack trace.
  void fatal(String message, [Object? error, StackTrace? stackTrace]) =>
      log(message, LogLevel.fatal, error: error, stackTrace: stackTrace);

  /// Reset singleton instance for testing purposes.
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
  }
}
