import '../shared/validation_result.dart';
import '../shared/validation_types.dart';
import '../shared/validator_interface.dart';

/// PR title validator implementing the IValidator interface.
///
/// Follows Single Responsibility Principle by focusing solely on
/// PR title validation logic without UI concerns.
///
/// Supports both conventional format (type(scope): description) and
/// capitalized format (Type(scope)/ description).
class PrTitleValidator extends TextValidator {
  /// Regular expression for conventional format: type(scope): description
  static final _conventionalPattern = RegExp(
    '^(?:${ValidationTypes.allowedTypes.join('|')})'
    r'(?:\([^)]+\))?!?:\s.{3,72}$',
  );

  /// Regular expression for capitalized format: Type(scope)/ description
  static final _capitalizedPattern = RegExp(
    '^(?:${ValidationTypes.capitalizedTypes.join('|')})'
    r'(?:\([^)]+\))?/\s.{3,72}$',
  );

  @override
  ValidationResult validateText(String text) {
    // Try conventional format first
    if (_conventionalPattern.hasMatch(text)) {
      return _validateConventionalFormat(text);
    }

    // Try capitalized format
    if (_capitalizedPattern.hasMatch(text)) {
      return _validateCapitalizedFormat(text);
    }

    // No format matched
    return ValidationResult.failure(
      'Invalid PR title format',
      errors: const [
        ValidationError(
          ValidationErrorType.invalidFormat,
          'PR title must follow either conventional format '
          '(type(scope): description) or capitalized format '
          '(Type(scope)/ description)',
        ),
      ],
    );
  }

  /// Validates PR title in conventional format: type(scope): description
  ValidationResult _validateConventionalFormat(String text) {
    final parts = text.split(': ');
    if (parts.length < 2) {
      return ValidationResult.parseError(
        'Invalid conventional format structure',
      );
    }

    final typeScope = parts[0];
    final description = parts.sublist(1).join(': ');

    // Validate description capitalization
    if (startsWithUppercase(description)) {
      return ValidationResult.failure(
        'Description should start with lowercase',
        errors: const [
          ValidationError(
            ValidationErrorType.invalidCapitalization,
            'Description must start with a lowercase letter',
          ),
        ],
      );
    }

    // Parse type and scope
    final parsedInfo = _parseTypeScope(typeScope, ':');

    return ValidationResult.success(
      '✅ PR title validation passed',
      details: {
        'type': parsedInfo['type'],
        'scope': parsedInfo['scope'],
        'description': description,
        'isBreakingChange': parsedInfo['isBreakingChange'],
        'format': 'conventional',
      },
    );
  }

  /// Validates PR title in capitalized format: Type(scope)/ description
  ValidationResult _validateCapitalizedFormat(String text) {
    final parts = text.split('/ ');
    if (parts.length < 2) {
      return ValidationResult.parseError(
        'Invalid capitalized format structure',
      );
    }

    final typeScope = parts[0];
    final description = parts.sublist(1).join('/ ');

    // Parse type and scope
    final parsedInfo = _parseTypeScope(typeScope, '/');

    return ValidationResult.success(
      '✅ PR title validation passed',
      details: {
        'type': parsedInfo['type'],
        'scope': parsedInfo['scope'],
        'description': description,
        'isBreakingChange': parsedInfo['isBreakingChange'],
        'format': 'capitalized',
      },
    );
  }

  /// Parses type and scope from the prefix part of PR title.
  Map<String, dynamic> _parseTypeScope(String typeScope, String separator) {
    final result = <String, dynamic>{
      'type': null,
      'scope': null,
      'isBreakingChange': false,
    };

    // Check for breaking change marker
    final hasBreakingChange = typeScope.contains('!');
    final cleanTypeScope = hasBreakingChange
        ? typeScope.replaceAll('!', '')
        : typeScope;

    if (hasBreakingChange) {
      result['isBreakingChange'] = true;
    }

    // Parse scope using regex
    final scopeMatch = RegExp(r'(\w+)(\((.+)\))?').firstMatch(cleanTypeScope);
    if (scopeMatch != null) {
      result['type'] = scopeMatch.group(1)?.toLowerCase();
      result['scope'] = scopeMatch.group(3);
    }

    return result;
  }
}

/// Helper utility for cleaning branch names into valid PR titles.
class BranchNameCleaner {
  /// Converts a git branch name into a clean PR title description.
  ///
  /// - Replaces dashes and underscores with spaces
  /// - Removes leading numbers and # symbols
  /// - Ensures description starts with lowercase
  static String cleanBranchName(String branchName) {
    var cleaned = branchName
        .replaceAll('-', ' ')
        .replaceAll('#', '')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'^\d+\s*'), '') // Remove leading numbers
        .trim();

    // Ensure description starts with lowercase letter
    if (cleaned.isNotEmpty && RegExp('^[A-Z]').hasMatch(cleaned[0])) {
      cleaned = cleaned[0].toLowerCase() + cleaned.substring(1);
    }

    return cleaned;
  }

  /// Converts a branch name to a conventional PR title if possible.
  ///
  /// Attempts to extract type and description from branch names like:
  /// - feat/user-authentication -> feat: user authentication
  /// - fix/button-alignment -> fix: button alignment
  static String? branchToConventionalTitle(String branchName) {
    if (!branchName.contains('/')) {
      return null;
    }

    final parts = branchName.split('/');
    if (parts.length < 2) {
      return null;
    }

    final type = parts[0].toLowerCase();
    if (!ValidationTypes.allowedTypes.contains(type)) {
      return null;
    }

    final description = cleanBranchName(parts.sublist(1).join(' '));
    return '$type: $description';
  }
}
