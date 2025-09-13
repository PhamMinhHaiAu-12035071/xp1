import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

/// Authentication events for BLoC event handling
///
/// Represents all possible authentication events that can be triggered
/// in the application using sealed classes for type-safe event handling.
@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Login requested event with user credentials
  ///
  /// [username] - User's username or email
  /// [password] - User's password
  const factory AuthEvent.loginRequested({
    required String username,
    required String password,
  }) = LoginRequested;

  /// Logout requested event to end current session
  const factory AuthEvent.logoutRequested() = LogoutRequested;

  /// Token refresh requested event to renew authentication tokens
  const factory AuthEvent.tokenRefreshRequested() = TokenRefreshRequested;

  /// Authentication status check requested event
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;

  /// Username field changed event for real-time validation
  ///
  /// [username] - New username value from form input
  const factory AuthEvent.usernameChanged({
    required String username,
  }) = UsernameChanged;

  /// Password field changed event for real-time validation
  ///
  /// [password] - New password value from form input
  const factory AuthEvent.passwordChanged({
    required String password,
  }) = PasswordChanged;

  /// Form submitted event for validation and submission
  ///
  /// Validates both fields and submits if valid
  const factory AuthEvent.formSubmitted() = FormSubmitted;

  /// Clear authentication state event to reset to initial state
  ///
  /// Clears all tokens and resets authentication state
  const factory AuthEvent.clearAuthState() = ClearAuthState;
}
