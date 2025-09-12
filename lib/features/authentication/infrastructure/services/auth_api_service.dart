import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

part 'auth_api_service.chopper.dart';

/// API service for authentication endpoints
///
/// Defines REST endpoints for user authentication operations including
/// login and token refresh using Chopper HTTP client library.
@ChopperApi()
@injectable
abstract class AuthApiService extends ChopperService {
  /// Creates AuthApiService instance via dependency injection
  @factoryMethod
  static AuthApiService create(@Named('chopperClient') ChopperClient client) {
    return _$AuthApiService(client);
  }

  /// Authenticates user with username/password credentials
  ///
  /// Sends login credentials to server authentication endpoint.
  /// Returns authentication tokens and user data on success.
  ///
  /// [body] - JSON request body containing login credentials
  @POST(path: '/api/v2.5/login')
  Future<Response<Map<String, dynamic>>> login(
    @Body() Map<String, dynamic> body,
  );

  /// Refreshes authentication tokens using refresh token
  ///
  /// Exchanges existing refresh token for new access/refresh token pair.
  /// Used to maintain user session without re-authentication.
  ///
  /// [body] - JSON request body containing refresh token
  @POST(path: '/refresh')
  Future<Response<Map<String, dynamic>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );
}
