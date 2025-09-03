/// Shared validation types and constants following DRY principle.
/// Contains all conventional commit and PR title validation constants
/// in a single location to eliminate duplication.
class ValidationTypes {
  /// Standard conventional commit types as defined in the specification.
  /// Used by both commit message and PR title validation.
  static const allowedTypes = [
    'feat', // New features
    'fix', // Bug fixes
    'docs', // Documentation changes
    'style', // Code style changes (formatting, etc.)
    'refactor', // Code refactoring
    'perf', // Performance improvements
    'test', // Adding or updating tests
    'chore', // Maintenance tasks
    'ci', // CI/CD related changes
    'build', // Build system changes
    'revert', // Reverting previous changes
  ];

  /// Capitalized versions of allowed types for PR title "Type/" format.
  /// Example: "Feat/", "Fix/", etc.
  static final List<String> capitalizedTypes = allowedTypes
      .map((type) => type[0].toUpperCase() + type.substring(1))
      .toList();

  /// Minimum description length for validation.
  static const minDescriptionLength = 3;

  /// Maximum description length for validation.
  static const maxDescriptionLength = 72;

  /// Regular expression for valid scope format.
  /// Matches: (scope), (multi-word-scope), (nested/scope)
  static final scopePattern = RegExp(r'\([^)]+\)');

  /// Regular expression for breaking change marker.
  /// Matches: ! at the end of type(scope)
  static final breakingChangePattern = RegExp(r'!$');
}

/// Validation error types for better error categorization.
enum ValidationErrorType {
  invalidFormat,
  invalidType,
  invalidLength,
  invalidCapitalization,
  missingDescription,
  invalidScope,
}

/// Extension to provide human-readable error messages.
extension ValidationErrorTypeExtension on ValidationErrorType {
  String get message {
    switch (this) {
      case ValidationErrorType.invalidFormat:
        return 'Invalid format structure';
      case ValidationErrorType.invalidType:
        return 'Invalid commit/PR type';
      case ValidationErrorType.invalidLength:
        return 'Description length must be '
            '${ValidationTypes.minDescriptionLength}-'
            '${ValidationTypes.maxDescriptionLength} characters';
      case ValidationErrorType.invalidCapitalization:
        return 'Description should start with lowercase letter';
      case ValidationErrorType.missingDescription:
        return 'Description is required';
      case ValidationErrorType.invalidScope:
        return 'Invalid scope format';
    }
  }
}
