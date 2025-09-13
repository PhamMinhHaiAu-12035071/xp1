import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_state.freezed.dart';

/// Represents the current state of authentication tokens.
///
/// Uses sealed classes to eliminate special cases and ensure
/// exhaustive pattern matching for token lifecycle management.
@freezed
sealed class TokenState with _$TokenState {
  /// User is authenticated with valid tokens.
  ///
  /// [accessToken] - Current JWT access token
  /// [refreshToken] - Token for refreshing access token
  const factory TokenState.authenticated({
    required String accessToken,
    required String refreshToken,
  }) = TokenAuthenticated;

  /// Token refresh operation is in progress.
  ///
  /// [refreshToken] - Token being used for refresh
  const factory TokenState.refreshing({required String refreshToken}) =
      TokenRefreshing;

  /// User is not authenticated.
  const factory TokenState.unauthenticated() = TokenUnauthenticated;

  /// Access token has expired and needs refresh.
  ///
  /// [refreshToken] - Token to use for refresh
  const factory TokenState.expired({required String refreshToken}) =
      TokenExpired;
}

/// Extension for token state validation logic.
extension TokenStateX on TokenState {
  /// Whether the current state represents an authenticated user.
  bool get isAuthenticated => this is TokenAuthenticated;

  /// Whether a token refresh operation is currently active.
  bool get isRefreshing => this is TokenRefreshing;
}
