import 'package:fpdart/fpdart.dart';

import '../entities/token_entity.dart';
import '../failures/auth_failure.dart';
import '../usecases/login_usecase.dart';

/// Abstract repository interface for authentication operations
///
/// Defines the contract for authentication data operations.
/// Implementations should handle actual authentication with external services.
/// Follows Clean Architecture principles by keeping domain logic separate
/// from infrastructure.
abstract class AuthRepository {
  /// Authenticates a user with provided credentials
  ///
  /// [input] - Login credentials and options
  /// Returns Either containing AuthFailure on failure or LoginResult on success
  Future<Either<AuthFailure, LoginResult>> login(LoginInput input);

  /// Refreshes an expired access token using refresh token
  ///
  /// Returns Either containing AuthFailure on failure or new TokenEntity
  /// on success
  Future<Either<AuthFailure, TokenEntity>> refreshToken();

  /// Logs out the current user and clears authentication tokens
  ///
  /// Returns Either containing AuthFailure on failure or void on success
  Future<Either<AuthFailure, void>> logout();
}
