/// Interface for individual bootstrap phases following Chain of
/// Responsibility pattern.
///
/// This interface enables:
/// - Single Responsibility: Each phase handles one concern
/// - Open/Closed Principle: New phases can be added without modification
/// - Testability: Each phase can be tested independently
/// - Flexibility: Phases can be reordered, skipped, or added dynamically
abstract class BootstrapPhase {
  /// Executes this bootstrap phase.
  ///
  /// Returns [BootstrapResult] containing success status and any data needed
  /// by subsequent phases. This enables phases to communicate without
  /// tight coupling.
  ///
  /// Throws [BootstrapException] if the phase fails critically.
  Future<BootstrapResult> execute();

  /// Human-readable name for this phase (used in logging and error messages).
  String get phaseName;

  /// Priority order for this phase (lower numbers execute first).
  int get priority;

  /// Whether this phase can be skipped in case of non-critical errors.
  bool get canSkip => false;

  /// Validates phase preconditions before execution.
  ///
  /// This enables early failure detection and better error messages.
  Future<void> validatePreconditions() async {}

  /// Cleanup actions if this phase needs to be rolled back.
  ///
  /// This enables error recovery and proper resource cleanup.
  Future<void> rollback() async {}
}

/// Result of a bootstrap phase execution.
///
/// This value object encapsulates the result of each phase and enables
/// communication between phases without tight coupling.
class BootstrapResult {
  /// Creates a bootstrap result with success status and optional data.
  const BootstrapResult({
    required this.success,
    this.data = const <String, dynamic>{},
    this.message,
  });

  /// Creates a successful result with optional data.
  const BootstrapResult.success({
    Map<String, dynamic> data = const <String, dynamic>{},
    String? message,
  }) : this(success: true, data: data, message: message);

  /// Creates a failed result with error message.
  const BootstrapResult.failure(String message)
    : this(success: false, message: message);

  /// Whether the phase executed successfully.
  final bool success;

  /// Data produced by this phase that might be needed by subsequent phases.
  final Map<String, dynamic> data;

  /// Optional message (success or error description).
  final String? message;

  /// Gets typed data from the result map.
  T? getData<T>(String key) => data[key] as T?;

  /// Gets required typed data, throws if not found.
  T getRequiredData<T>(String key) {
    final value = getData<T>(key);
    if (value == null) {
      throw BootstrapException(
        'Required data "$key" not found in bootstrap result',
      );
    }
    return value;
  }
}

/// Exception thrown by bootstrap phases.
///
/// This specific exception provides clear context about bootstrap failures
/// and enables proper error handling strategies.
class BootstrapException implements Exception {
  /// Creates exception with phase context and optional original error.
  const BootstrapException(
    this.message, {
    this.phase,
    this.originalError,
    this.canRetry = false,
  });

  /// Description of the bootstrap failure.
  final String message;

  /// Phase that caused the failure (if known).
  final String? phase;

  /// Original error that caused the bootstrap failure.
  final Object? originalError;

  /// Whether this error can be retried.
  final bool canRetry;

  @override
  String toString() =>
      'BootstrapException'
      '${phase != null ? ' in $phase' : ''}: $message'
      '${originalError != null ? ' (caused by: $originalError)' : ''}';
}
