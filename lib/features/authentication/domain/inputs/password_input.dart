import 'package:formz/formz.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Validation errors for password input
enum PasswordValidationError {
  /// Password field is empty (required validation)
  empty,
}

/// Extension to provide localized error messages for password validation
extension PasswordValidationErrorX on PasswordValidationError {
  /// Returns the localized error message for the validation error
  String get message {
    switch (this) {
      case PasswordValidationError.empty:
        return t.pages.login.validation.passwordRequired;
    }
  }
}

/// Password input field with Formz validation
///
/// Extends FormzInput to provide type-safe validation for password fields.
/// Supports only required validation (not empty) as specified in requirements.
class Password extends FormzInput<String, PasswordValidationError> {
  /// Creates a pure (unmodified) password input
  const Password.pure() : super.pure('');

  /// Creates a dirty (modified) password input with a value
  const Password.dirty({String value = ''}) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    // Only required validation - no minimum length rules
    if (value.isEmpty) return PasswordValidationError.empty;
    return null;
  }
}
