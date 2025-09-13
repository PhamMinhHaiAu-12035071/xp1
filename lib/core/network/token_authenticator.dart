import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/infrastructure/token/token_manager.dart';
import '../infrastructure/logging/i_logger_service.dart';

/// Chopper authenticator for automatic token refresh on 401 responses.
///
/// Integrates with current HTTP client to handle unauthorized
/// responses transparently without breaking existing API contracts.
/// Prevents infinite retry loops with attempt counting.
@injectable
class TokenAuthenticator extends Authenticator {
  /// Creates TokenAuthenticator with required dependencies.
  ///
  /// [_tokenManager] - Manages token state and refresh operations
  /// [_logger] - Logger for debugging and monitoring
  TokenAuthenticator(this._tokenManager, this._logger);

  final TokenManager _tokenManager;
  final ILoggerService _logger;

  // Prevent infinite retry loops
  static const int _maxAuthAttempts = 2;
  final Map<String, int> _attemptCount = <String, int>{};

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response<dynamic> response, [
    Request? originalRequest,
  ]) async {
    // Only handle 401 Unauthorized
    if (response.statusCode != 401) return null;

    final requestId = _generateRequestId(request);
    final attempts = _attemptCount[requestId] ?? 0;

    _logger
      ..log(
        '🔒 Authentication required for ${request.method} ${request.url}',
        LogLevel.debug,
      )
      ..log(
        '📊 Attempt ${attempts + 1}/$_maxAuthAttempts for $requestId',
        LogLevel.debug,
      );

    // Prevent infinite retry loops
    if (attempts >= _maxAuthAttempts) {
      _logger.log(
        '⛔ Max authentication attempts reached for $requestId',
        LogLevel.warning,
      );
      _attemptCount.remove(requestId);
      return null;
    }

    _attemptCount[requestId] = attempts + 1;

    try {
      // Wait for valid token (handles concurrent requests)
      final newToken = await _tokenManager.waitForValidToken();

      if (newToken == null) {
        _logger.log(
          '❌ Failed to obtain valid token for $requestId',
          LogLevel.error,
        );
        _attemptCount.remove(requestId);
        return null;
      }

      _logger.log(
        '✅ Got valid token for $requestId, retrying request',
        LogLevel.debug,
      );

      // Create retry request with new token
      final retryRequest = request.copyWith(
        headers: {
          ...request.headers,
          'Authorization': 'Bearer $newToken',
        },
      );

      // Clean up attempt count on successful token refresh
      _attemptCount.remove(requestId);

      return retryRequest;
    } on Exception catch (error, stackTrace) {
      _logger.log(
        '💥 Authentication error for $requestId',
        LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );
      _attemptCount.remove(requestId);
      return null;
    }
  }

  /// Generate unique request identifier for tracking retry attempts.
  ///
  /// [request] - HTTP request to generate ID for
  /// Returns unique string identifier based on method, URL and timestamp
  String _generateRequestId(Request request) =>
      '${request.method}-${request.url}-'
      '${DateTime.now().millisecondsSinceEpoch}';
}
