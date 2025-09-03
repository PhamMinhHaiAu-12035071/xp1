import 'package:conventional_commit/conventional_commit.dart';

import '../shared/validation_result.dart';
import '../shared/validation_types.dart';
import '../shared/validator_interface.dart';

/// Commit message validator implementing the IValidator interface.
///
/// Follows Single Responsibility Principle by focusing solely on
/// commit message validation logic without UI concerns.
///
/// Uses the conventional_commit package for robust parsing and
/// implements the Conventional Commits specification.
class CommitValidator extends TextValidator with MergeCommitDetection {
  @override
  ValidationResult validateText(String text) {
    // Handle merge commits with special logic
    if (isMergeCommit(text)) {
      return createMergeCommitResult();
    }

    // Parse using conventional_commit package
    final parsedCommit = ConventionalCommit.tryParse(text);

    if (parsedCommit == null) {
      return ValidationResult.parseError(
        'Unable to parse conventional commit format',
      );
    }

    // Validate type
    final typeValidation = _validateType(parsedCommit);
    if (!typeValidation.isValid) {
      return typeValidation;
    }

    // Validate description
    final descriptionValidation = _validateDescription(parsedCommit);
    if (!descriptionValidation.isValid) {
      return descriptionValidation;
    }

    // Create success result with detailed information
    return ValidationResult.success(
      '✅ Commit message validation passed',
      details: _buildValidationDetails(parsedCommit),
    );
  }

  /// Validates the commit type against allowed types.
  ValidationResult _validateType(ConventionalCommit commit) {
    if (commit.type != null &&
        !ValidationTypes.allowedTypes.contains(commit.type)) {
      return ValidationResult.failure(
        'Invalid commit type: "${commit.type}"',
        errors: [
          ValidationError(
            ValidationErrorType.invalidType,
            'Type "${commit.type}" is not in allowed types: '
            '${ValidationTypes.allowedTypes.join(', ')}',
            context: {'invalidType': commit.type},
          ),
        ],
      );
    }
    return ValidationResult.success('Type validation passed');
  }

  /// Validates the commit description.
  ValidationResult _validateDescription(ConventionalCommit commit) {
    final description = commit.description;

    if (description == null || description.isEmpty) {
      return ValidationResult.failure(
        'Description is required',
        errors: const [
          ValidationError(
            ValidationErrorType.missingDescription,
            'Commit message must include a description',
          ),
        ],
      );
    }

    // Check length
    if (description.length < ValidationTypes.minDescriptionLength ||
        description.length > ValidationTypes.maxDescriptionLength) {
      return ValidationResult.failure(
        'Invalid description length: ${description.length} characters',
        errors: [
          ValidationError(
            ValidationErrorType.invalidLength,
            ValidationErrorType.invalidLength.message,
            context: {'actualLength': description.length},
          ),
        ],
      );
    }

    // Check capitalization
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

    return ValidationResult.success('Description validation passed');
  }

  /// Builds detailed validation information for successful validation.
  Map<String, dynamic> _buildValidationDetails(ConventionalCommit commit) {
    final details = <String, dynamic>{
      'type': commit.type,
      'description': commit.description,
      'isBreakingChange': commit.isBreakingChange,
    };

    // Add scope if present
    if (commit.scopes.isNotEmpty) {
      details['scope'] = commit.scopes.join(', ');
    }

    // Add breaking change information
    if (commit.isBreakingChange) {
      details['breakingChangeDescription'] = commit.breakingChangeDescription;
    }

    // Add body information
    if (commit.body != null && commit.body!.isNotEmpty) {
      details['hasBody'] = true;
    }

    // Add footer information
    if (commit.footers.isNotEmpty) {
      details['footerCount'] = commit.footers.length;
    }

    return details;
  }
}
