import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/infrastructure/token/token_manager.dart';
import '../infrastructure/logging/i_logger_service.dart';

/// Authentication interceptor for automatic token injection.
///
/// Integrates with current Chopper HTTP client configuration
/// to automatically attach access tokens to requests. Skips
/// authentication for refresh endpoints to prevent circular dependencies.
@injectable
class AuthInterceptor implements Interceptor {
  /// Creates AuthInterceptor with required dependencies.
  ///
  /// [_tokenManager] - Manages token state and refresh operations
  /// [_logger] - Logger for debugging and monitoring
  const AuthInterceptor(this._tokenManager, this._logger);

  final TokenManager _tokenManager;
  final ILoggerService _logger;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;

    // Skip auth for login and refresh endpoints to prevent circular dependency
    final url = request.url.toString();
    if (url.contains('/login') || url.contains('/refreshtoken')) {
      return chain.proceed(request);
    }

    try {
      // Get valid token before making request
      final token = await _tokenManager.getValidAccessToken();

      if (token != null) {
        final authenticatedRequest = request.copyWith(
          headers: {
            ...request.headers,
            'Authorization': 'Bearer $token',
          },
        );

        _logger.log(
          '🔑 Added auth token to ${request.method} ${request.url}',
          LogLevel.debug,
        );
        return chain.proceed(authenticatedRequest);
      } else {
        _logger.log(
          '⚠️ No valid token for ${request.method} ${request.url}',
          LogLevel.warning,
        );
        return chain.proceed(request);
      }
    } on Exception catch (error, stackTrace) {
      _logger.log(
        '💥 Auth interceptor error',
        LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );
      return chain.proceed(request);
    }
  }
}
