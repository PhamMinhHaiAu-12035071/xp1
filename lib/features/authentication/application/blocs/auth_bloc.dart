import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/auth_failure.dart';
import '../../domain/inputs/password_input.dart';
import '../../domain/inputs/username_input.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC managing authentication state and operations
///
/// Handles login, logout, token refresh, and authentication status checks
/// using clean architecture principles and Either error handling pattern.
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Creates AuthBloc with required dependencies
  ///
  /// [_authRepository] - Repository for authentication operations
  /// [_loginUseCase] - Use case for login operations
  AuthBloc(this._authRepository, this._loginUseCase)
    : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<UsernameChanged>(_onUsernameChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;

  /// Handles login requested event
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Set form to submitting state
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        authStatus: AuthenticationStatus.loading,
        errorMessage: null,
      ),
    );

    final loginInput = LoginInput(
      username: event.username,
      password: event.password,
    );

    final result = await _loginUseCase(loginInput);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          authStatus: AuthenticationStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ),
      ),
      (loginResult) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            authStatus: AuthenticationStatus.authenticated,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// Handles logout requested event
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        authStatus: AuthenticationStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _authRepository.logout();

    result.fold(
      (failure) => emit(
        state.copyWith(
          authStatus: AuthenticationStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          authStatus: AuthenticationStatus.unauthenticated,
          username: const Username.pure(),
          password: const Password.pure(),
          status: FormzSubmissionStatus.initial,
          errorMessage: null,
        ),
      ),
    );
  }

  /// Handles token refresh requested event
  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Only refresh if currently authenticated
    if (!state.isAuthenticated) {
      return;
    }

    final result = await _authRepository.refreshToken();

    result.fold(
      (failure) {
        // Log user out if token refresh fails
        emit(
          state.copyWith(
            authStatus: AuthenticationStatus.unauthenticated,
            username: const Username.pure(),
            password: const Password.pure(),
            status: FormzSubmissionStatus.initial,
            errorMessage: null,
          ),
        );
      },
      (tokenEntity) {
        // Token refreshed successfully, maintain authenticated state
        emit(
          state.copyWith(
            authStatus: AuthenticationStatus.authenticated,
          ),
        );
        // Continue monitoring after successful refresh
      },
    );
  }

  /// Handles authentication status check requested event
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        authStatus: AuthenticationStatus.loading,
        errorMessage: null,
      ),
    );

    // Try to validate authentication state by refreshing tokens
    final result = await _authRepository.refreshToken();

    result.fold(
      (failure) {
        // No valid tokens or refresh failed - user needs to authenticate
        emit(
          state.copyWith(
            authStatus: AuthenticationStatus.unauthenticated,
            username: const Username.pure(),
            password: const Password.pure(),
            status: FormzSubmissionStatus.initial,
            errorMessage: null,
          ),
        );
      },
      (tokenEntity) {
        // Tokens are valid, but we need user information for authentication
        // In a production app, this would either:
        // 1. Fetch user info from API using valid tokens
        // 2. Restore user info from secure storage
        // 3. Decode user info from JWT payload

        // User is authenticated with valid tokens
        emit(
          state.copyWith(
            authStatus: AuthenticationStatus.authenticated,
          ),
        );
      },
    );
  }

  /// Handles username field change event for real-time validation
  void _onUsernameChanged(
    UsernameChanged event,
    Emitter<AuthState> emit,
  ) {
    final username = Username.dirty(value: event.username);
    emit(
      state.copyWith(
        username: username,
      ),
    );
  }

  /// Handles password field change event for real-time validation
  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final password = Password.dirty(value: event.password);
    emit(
      state.copyWith(
        password: password,
      ),
    );
  }

  /// Handles form submission with validation
  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // Mark all fields as dirty for validation display
    final username = Username.dirty(value: state.username.value);
    final password = Password.dirty(value: state.password.value);

    emit(
      state.copyWith(
        username: username,
        password: password,
      ),
    );

    // Only proceed with login if form is valid
    if (state.isFormValid) {
      add(
        AuthEvent.loginRequested(
          username: state.username.value,
          password: state.password.value,
        ),
      );
    }
  }

  /// Maps authentication failures to user-friendly error messages
  String _mapFailureToMessage(AuthFailure failure) {
    return failure.when(
      invalidCredentials: () =>
          'Invalid username or password. Please try again.',
      networkError: (message) =>
          'Unable to connect. Please check your internet connection.',
      serverError: (statusCode) =>
          'Service temporarily unavailable. Please try again later.',
      tokenExpired: () => 'Your session has expired. Please log in again.',
      unauthorized: () => 'You are not authorized to access this resource.',
      noRefreshToken: () =>
          'Authentication session expired. Please log in again.',
      refreshFailed: () => 'Unable to refresh session. Please log in again.',
      unknown: (message) => 'An unexpected error occurred. Please try again.',
    );
  }
}
