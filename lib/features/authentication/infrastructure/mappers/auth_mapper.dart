import 'package:injectable/injectable.dart';

import '../../domain/usecases/login_usecase.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import 'token_mapper.dart';

/// Comprehensive authentication mapper for use case conversions
///
/// Handles complex mapping between use case inputs/outputs and
/// infrastructure models, orchestrating specialized mappers.
@injectable
class AuthMapper {
  /// Creates AuthMapper with required dependencies
  ///
  /// [_tokenMapper] - Handles LoginResponse → TokenEntity conversions
  const AuthMapper(this._tokenMapper);

  final TokenMapper _tokenMapper;

  /// Converts LoginInput (use case) to LoginRequest (API model)
  ///
  /// Maps from domain use case input to infrastructure API request format.
  /// Note: Only maps fields supported by the PX1 API (userName, password).
  /// deviceId and rememberMe are handled at the application layer.
  LoginRequest fromLoginInputToRequest(LoginInput input) {
    return LoginRequest(
      userName: input.username, // Map username to userName
      password: input.password,
    );
  }

  /// Converts LoginResponse (API model) to LoginResult (use case output)
  ///
  /// Creates LoginResult from API response data with token information.
  LoginResult fromLoginResponseToResult(
    LoginResponse response,
    String username,
  ) {
    final tokenEntity = _tokenMapper.fromModelToEntity(response);

    return LoginResult(token: tokenEntity);
  }
}
