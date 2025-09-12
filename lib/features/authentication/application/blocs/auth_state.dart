import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/inputs/password_input.dart';
import '../../domain/inputs/username_input.dart';

part 'auth_state.freezed.dart';

/// Authentication state for BLoC state management with Formz validation
///
/// Represents authentication state with form validation using Formz
/// for type-safe form handling and validation state management.
@freezed
abstract class AuthState with _$AuthState {
  /// Creates an AuthState with form validation fields
  const factory AuthState({
    @Default(Username.pure()) Username username,
    @Default(Password.pure()) Password password,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(AuthenticationStatus.initial) AuthenticationStatus authStatus,
    String? errorMessage,
  }) = _AuthState;
}

/// Convenience getters for form validation state
extension AuthStateX on AuthState {
  /// Returns true if username field is valid
  bool get isUsernameValid => username.isValid;

  /// Returns true if password field is valid
  bool get isPasswordValid => password.isValid;

  /// Returns true if the entire form is valid (all inputs valid)
  bool get isFormValid => Formz.validate([username, password]);

  /// Returns true if form is being submitted
  bool get isSubmitting => status.isInProgress;

  /// Returns true if user is authenticated
  bool get isAuthenticated => authStatus == AuthenticationStatus.authenticated;

  /// Returns true if authentication is in progress
  bool get isAuthenticating => authStatus == AuthenticationStatus.loading;

  /// Returns list of form inputs for validation
  List<FormzInput<dynamic, dynamic>> get inputs => [username, password];
}

/// Authentication status enumeration
enum AuthenticationStatus {
  /// Initial state when authentication status is unknown
  initial,

  /// Loading state during authentication operations
  loading,

  /// Authenticated state when user is logged in
  authenticated,

  /// Unauthenticated state when user is not logged in
  unauthenticated,

  /// Error state when authentication operations fail
  error,
}
