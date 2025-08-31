/// Logging levels for structured logging.
enum LogLevel {
  /// Debug level - detailed information for development.
  debug,

  /// Info level - important application flow information.
  info,

  /// Warning level - potentially harmful situations.
  warning,

  /// Error level - error events but application can continue.
  error,

  /// Fatal level - severe error events that cause application termination.
  fatal,
}

/// Interface for logging service.
///
/// Simple single-method interface following KISS principle.
// ignore: one_member_abstracts
abstract class ILoggerService {
  /// Logs a message with specified level and optional error context.
  ///
  /// [message] The log message
  /// [level] The severity level
  /// [error] Optional error object for error/fatal levels
  /// [stackTrace] Optional stack trace for error/fatal levels
  /// [extra] Optional structured data for context
  void log(
    String message,
    LogLevel level, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  });
}
