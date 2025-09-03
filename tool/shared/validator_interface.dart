import 'validation_result.dart';
import 'validation_types.dart';

/// Abstract validator interface following Interface Segregation Principle.
/// Defines the contract for all validation implementations.
///
/// Generic type [T] allows for different input types while maintaining
/// type safety and enabling easy testing and mocking.
// ignore: one_member_abstracts
abstract class IValidator<T> {
  /// Validates the input and returns a detailed result.
  ///
  /// [input] The value to validate
  /// Returns [ValidationResult] with validation outcome and details
  ValidationResult validate(T input);
}

/// Abstract base class for text-based validators (commits, PR titles, etc.).
/// Provides common functionality for string validation while allowing
/// specific implementations to focus on their domain logic.
abstract class TextValidator implements IValidator<String> {
  /// Template method for text validation following Template Method pattern.
  ///
  /// Defines the validation algorithm structure while allowing subclasses
  /// to implement specific validation rules.
  @override
  ValidationResult validate(String input) {
    // Null and empty checks
    if (input.isEmpty) {
      return ValidationResult.failure(
        'Input cannot be empty',
        errors: const [
          ValidationError(
            ValidationErrorType.missingDescription,
            'Input is required and cannot be empty',
          ),
        ],
      );
    }

    // Delegate to specific validation implementation
    return validateText(input.trim());
  }

  /// Abstract method for specific text validation logic.
  ///
  /// Subclasses must implement this method to provide their specific
  /// validation rules and logic.
  ValidationResult validateText(String text);

  /// Helper method to check if text starts with uppercase letter.
  ///
  /// Used by multiple validators to check description capitalization.
  bool startsWithUppercase(String text) {
    return text.isNotEmpty && text[0] == text[0].toUpperCase();
  }

  /// Helper method to extract description from formatted text.
  ///
  /// Can be overridden by subclasses for specific parsing logic.
  String? extractDescription(String text) {
    // Default implementation - subclasses should override
    return text;
  }
}

/// Mixin for validators that need merge commit detection.
///
/// Provides common logic for handling merge commits which typically
/// follow different formatting rules.
mixin MergeCommitDetection {
  /// Checks if the input is a merge commit.
  ///
  /// Merge commits typically start with "Merge " and should be handled
  /// differently from regular conventional commits.
  bool isMergeCommit(String input) {
    return input.trim().startsWith('Merge ');
  }

  /// Creates a successful validation result for merge commits.
  ValidationResult createMergeCommitResult() {
    return ValidationResult.success(
      '✅ Merge commit detected, skipping validation',
      details: const {
        'type': 'merge',
        'isMergeCommit': true,
      },
    );
  }
}
