import 'package:meta/meta.dart';

import 'validation_types.dart';

/// Immutable validation result following value object pattern.
/// Encapsulates validation outcome with rich information for
/// both success and failure scenarios.
@immutable
class ValidationResult {
  /// Private constructor to enforce factory pattern.
  const ValidationResult._({
    required this.isValid,
    required this.message,
    required this.details,
    required this.errors,
  });

  /// Factory constructor for successful validation.
  ///
  /// [message] Success message to display
  /// [details] Parsed validation details (type, scope, description, etc.)
  factory ValidationResult.success(
    String message, {
    Map<String, dynamic>? details,
  }) {
    return ValidationResult._(
      isValid: true,
      message: message,
      details: details ?? const {},
      errors: const [],
    );
  }

  /// Factory constructor for failed validation.
  ///
  /// [message] Primary error message
  /// [errors] List of specific validation errors
  factory ValidationResult.failure(
    String message, {
    List<ValidationError>? errors,
  }) {
    return ValidationResult._(
      isValid: false,
      message: message,
      details: const {},
      errors: errors ?? [],
    );
  }

  /// Factory constructor for parsing errors.
  ///
  /// [message] Parse error description
  factory ValidationResult.parseError(String message) {
    return ValidationResult.failure(
      message,
      errors: [
        ValidationError(
          ValidationErrorType.invalidFormat,
          message,
        ),
      ],
    );
  }

  /// Whether the validation passed.
  final bool isValid;

  /// Primary validation message.
  final String message;

  /// Detailed validation information (type, scope, description, etc.).
  final Map<String, dynamic> details;

  /// List of validation errors (empty for successful validation).
  final List<ValidationError> errors;

  /// Get the primary type from validation details.
  String? get type => details['type'] as String?;

  /// Get the scope from validation details.
  String? get scope => details['scope'] as String?;

  /// Get the description from validation details.
  String? get description => details['description'] as String?;

  /// Check if this is a breaking change.
  bool get isBreakingChange => details['isBreakingChange'] == true;

  /// Get breaking change description if available.
  String? get breakingChangeDescription =>
      details['breakingChangeDescription'] as String?;

  /// Check if validation has a body section.
  bool get hasBody => details['hasBody'] == true;

  /// Get number of footers if available.
  int get footerCount => details['footerCount'] as int? ?? 0;

  @override
  String toString() {
    return 'ValidationResult('
        'isValid: $isValid, '
        'message: $message, '
        'errors: ${errors.length}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationResult &&
        other.isValid == isValid &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(isValid, message);
}

/// Represents a specific validation error with type and context.
@immutable
class ValidationError {
  const ValidationError(
    this.type,
    this.message, {
    this.context = const {},
  });

  /// The type of validation error.
  final ValidationErrorType type;

  /// Detailed error message.
  final String message;

  /// Optional context information for the error.
  final Map<String, dynamic> context;

  @override
  String toString() => 'ValidationError(${type.name}: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationError &&
        other.type == type &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(type, message);
}
