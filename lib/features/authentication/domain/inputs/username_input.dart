import 'package:formz/formz.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Validation errors for username input
enum UsernameValidationError {
  /// Username field is empty (required validation)
  empty,
}

/// Extension to provide localized error messages for username validation
extension UsernameValidationErrorX on UsernameValidationError {
  /// Returns the localized error message for the validation error
  String get message {
    switch (this) {
      case UsernameValidationError.empty:
        return t.pages.login.validation.usernameRequired;
    }
  }
}

/// Username input field with Formz validation
///
/// Extends FormzInput to provide type-safe validation for username fields.
/// Supports only required validation (not empty) as specified in requirements.
class Username extends FormzInput<String, UsernameValidationError> {
  /// Creates a pure (unmodified) username input
  const Username.pure() : super.pure('');

  /// Creates a dirty (modified) username input with a value
  const Username.dirty({String value = ''}) : super.dirty(value);

  @override
  UsernameValidationError? validator(String value) {
    // Only required validation - no minimum length rules
    if (value.isEmpty) return UsernameValidationError.empty;
    return null;
  }
}
