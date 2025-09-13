import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

/// Sealed class representing all possible authentication failures
///
/// Provides type-safe error handling for authentication operations.
/// Each variant represents a specific failure scenario with appropriate data.
@freezed
sealed class AuthFailure with _$AuthFailure {
  /// User provided invalid username/password combination
  const factory AuthFailure.invalidCredentials() = InvalidCredentialsFailure;

  /// Network connectivity or communication error occurred
  ///
  /// [message] - Description of the network error
  const factory AuthFailure.networkError(String message) = NetworkFailure;

  /// Server returned an error status code (5xx errors)
  ///
  /// [statusCode] - HTTP status code returned by server
  const factory AuthFailure.serverError(int statusCode) = ServerFailure;

  /// JWT token has expired and needs refresh
  const factory AuthFailure.tokenExpired() = TokenExpiredFailure;

  /// User is not authorized to perform this action (401 error)
  const factory AuthFailure.unauthorized() = UnauthorizedFailure;

  /// No refresh token available for token refresh operation
  const factory AuthFailure.noRefreshToken() = NoRefreshTokenFailure;

  /// Token refresh operation failed after retries
  const factory AuthFailure.refreshFailed() = RefreshFailedFailure;

  /// Unknown error that doesn't fit other categories
  ///
  /// [message] - Description of the unknown error
  const factory AuthFailure.unknown(String message) = UnknownFailure;
}
