import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../entities/token_entity.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

part 'login_usecase.freezed.dart';

/// Input data transfer object for login operation
///
/// Contains all necessary information for user authentication
@freezed
sealed class LoginInput with _$LoginInput {
  /// Creates a LoginInput with authentication credentials
  ///
  /// [username] - User's username or email
  /// [password] - User's password
  const factory LoginInput({
    required String username,
    required String password,
  }) = _LoginInput;
}

/// Result data transfer object for successful login operation
///
/// Contains authentication tokens for API access
@freezed
sealed class LoginResult with _$LoginResult {
  /// Creates a LoginResult with authentication data
  ///
  /// [token] - JWT tokens for API authentication
  const factory LoginResult({required TokenEntity token}) = _LoginResult;
}

/// Use case for user authentication via login credentials
///
/// Handles the business logic for user login, delegating to the repository
/// for actual authentication implementation.
@injectable
class LoginUseCase {
  /// Creates a LoginUseCase with the authentication repository
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Executes the login use case with provided credentials
  ///
  /// [input] - User credentials and login options
  /// Returns Either containing AuthFailure on failure or LoginResult on success
  Future<Either<AuthFailure, LoginResult>> call(LoginInput input) async {
    return _authRepository.login(input);
  }
}
