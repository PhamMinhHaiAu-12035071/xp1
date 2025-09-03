import '../cli_logger.dart';
import '../validation_types.dart';

/// Error formatter for validation tools following Single Responsibility
/// Principle.
/// Provides consistent error message formatting across all validation tools.
///
/// Uses cascade operators to efficiently output multiple error messages
/// while maintaining proper stream separation (stderr for errors).
class ErrorFormatter {
  /// Shows conventional commit format examples and rules.
  static void showConventionalCommitHelp() {
    const descriptionRule =
        '   • ${ValidationTypes.minDescriptionLength}-'
        '${ValidationTypes.maxDescriptionLength} characters for description';

    final messages = [
      '✅ Correct format: type(scope): description',
      '',
      '📝 Examples:',
      '   feat(auth): add user registration',
      '   fix(ui): resolve button alignment issue',
      '   docs: update installation guide',
      '   feat!: add breaking change',
      '',
      '📏 Rules:',
      descriptionRule,
      '   • Lowercase description',
      '   • Optional scope in parentheses',
      '   • Use ! for breaking changes',
      '',
      '🔧 Available types: ${ValidationTypes.allowedTypes.join(', ')}',
    ];

    CliLogger.errors(messages);
  }

  /// Shows PR title format examples and rules.
  static void showPrTitleHelp() {
    const rulesText =
        '📏 Rules: '
        '${ValidationTypes.minDescriptionLength}-'
        '${ValidationTypes.maxDescriptionLength} characters, '
        'lowercase description';

    final messages = [
      '✅ Correct formats:',
      '   Conventional: type(scope): description',
      '   Capitalized: Type(scope)/ description',
      '   Breaking change: type(scope)!: description',
      '',
      '📝 Examples:',
      '   feat(auth): add user registration',
      '   fix(ui): resolve button alignment issue',
      '   Feat(auth)/ add user registration',
      '   Fix(ui)/ resolve button alignment issue',
      '   feat(api)!: change authentication system',
      '   docs: update installation guide',
      '',
      '🔧 Available types: ${ValidationTypes.allowedTypes.join(', ')}',
      rulesText,
    ];

    CliLogger.errors(messages);
  }

  /// Shows parsing error with context.
  static void showParsingError(String error) {
    CliLogger.error('❌ Invalid format');
    CliLogger.error('Parse error: $error');
    CliLogger.error('');
  }

  /// Shows type validation error.
  static void showTypeError(String invalidType) {
    CliLogger.error('❌ Invalid type: "$invalidType"');
    CliLogger.error('');
    CliLogger.error(
      '🔧 Available types: ${ValidationTypes.allowedTypes.join(', ')}',
    );
  }

  /// Shows length validation error.
  static void showLengthError(int actualLength) {
    CliLogger.error('❌ Invalid description length: $actualLength characters');
    CliLogger.error(
      '📏 Description must be ${ValidationTypes.minDescriptionLength}-'
      '${ValidationTypes.maxDescriptionLength} characters long',
    );
  }

  /// Shows capitalization validation error.
  static void showCapitalizationError() {
    CliLogger.error('❌ Description should not start with uppercase');
    CliLogger.error('📝 Use lowercase for description');
  }

  /// Shows a generic validation error with custom message.
  static void showGenericError(String message) {
    CliLogger.error('❌ $message');
  }

  /// Shows validation error based on error type.
  static void showErrorByType(
    ValidationErrorType errorType, {
    String? context,
  }) {
    switch (errorType) {
      case ValidationErrorType.invalidFormat:
        showParsingError(context ?? 'Unable to parse input format');
      case ValidationErrorType.invalidType:
        showTypeError(context ?? 'unknown');
      case ValidationErrorType.invalidLength:
        final length = int.tryParse(context ?? '0') ?? 0;
        showLengthError(length);
      case ValidationErrorType.invalidCapitalization:
        showCapitalizationError();
      case ValidationErrorType.missingDescription:
        showGenericError('Description is required');
      case ValidationErrorType.invalidScope:
        showGenericError('Invalid scope format: ${context ?? ''}');
    }
  }
}
