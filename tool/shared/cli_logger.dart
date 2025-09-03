import 'dart:io';

/// CLI logger utility following Single Responsibility Principle.
/// Provides consistent logging output for command-line tools with proper
/// stream separation (stdout for info, stderr for errors/warnings).
class CliLogger {
  /// Log success/info messages to stdout.
  ///
  /// Use this for positive feedback, validation results, and general
  /// information that users should see during normal operation.
  static void info(String message) {
    // Using print for stdout output - ignore linter for CLI tools
    // ignore: avoid_print
    print(message);
  }

  /// Log warning messages to stderr.
  ///
  /// Use this for non-fatal issues that users should be aware of.
  static void warning(String message) {
    stderr.writeln(message);
  }

  /// Log error messages to stderr.
  ///
  /// Use this for validation failures, configuration errors, and other
  /// issues that require user attention.
  static void error(String message) {
    stderr.writeln(message);
  }

  /// Log multiple error messages using cascade operators.
  ///
  /// Efficiently outputs multiple error messages while maintaining
  /// proper stream separation.
  static void errors(List<String> messages) {
    stderr
      ..writeAll(messages, '\n')
      ..writeln();
  }
}
