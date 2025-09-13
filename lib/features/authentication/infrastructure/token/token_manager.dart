import 'dart:async';
import 'dart:collection';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/logging/i_logger_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/entities/token_state.dart';
import '../../domain/failures/auth_failure.dart';
import '../services/auth_api_service.dart';

/// Thread-safe token manager for automatic token refresh.
///
/// Handles concurrent requests during token refresh using Completer
/// pattern to prevent race conditions. Uses AuthApiService with
/// refresh-specific client to avoid circular dependencies.
@lazySingleton
class TokenManager {
  /// Creates TokenManager with required dependencies.
  ///
  /// [_storageService] - Secure storage for token persistence
  /// [_logger] - Logger for debugging and monitoring
  /// [_authApiService] - API service for refresh operations
  TokenManager(
    this._storageService,
    this._logger,
    @Named('refreshAuthApiService') this._authApiService,
  );

  final SecureStorageService _storageService;
  final ILoggerService _logger;
  final AuthApiService _authApiService;

  // Thread safety mechanisms
  Completer<Either<AuthFailure, TokenEntity>>? _refreshCompleter;
  final Queue<Completer<String?>> _pendingRequests =
      Queue<Completer<String?>>();

  // State management
  TokenState _currentState = const TokenState.unauthenticated();
  final _stateController = StreamController<TokenState>.broadcast();

  // Configuration - integrate with current env system
  static const int _maxRetries = 3;
  int _retryCount = 0;

  /// Stream of token state changes for reactive UI updates.
  Stream<TokenState> get stateStream => _stateController.stream;

  /// Current token state.
  TokenState get currentState => _currentState;

  /// Thread-safe token refresh with concurrent request handling.
  ///
  /// Returns `Either<AuthFailure, String>` following current error pattern.
  /// If refresh is already in progress, waits for existing operation.
  Future<Either<AuthFailure, String>> refreshToken() async {
    _logger.log('🔄 Token refresh requested', LogLevel.info);

    // If refresh already in progress, wait for existing operation
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      _logger.log(
        '⏳ Refresh in progress, joining existing operation',
        LogLevel.debug,
      );
      final result = await _refreshCompleter!.future;
      return result.map((tokenEntity) => tokenEntity.accessToken);
    }

    // Start new refresh operation
    _refreshCompleter = Completer<Either<AuthFailure, TokenEntity>>();
    unawaited(_performRefresh());

    final result = await _refreshCompleter!.future;
    return result.map((tokenEntity) => tokenEntity.accessToken);
  }

  Future<void> _performRefresh() async {
    try {
      final storedRefreshToken = await _storageService.getRefreshToken();

      _updateState(
        TokenState.refreshing(
          refreshToken: storedRefreshToken ?? '',
        ),
      );

      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        _completeRefresh(const Left(AuthFailure.noRefreshToken()));
        return;
      }

      _logger.log('🔑 Performing token refresh...', LogLevel.debug);

      final response = await _authApiService.refreshToken(storedRefreshToken);

      if (response.isSuccessful && response.body != null) {
        final tokenEntity = TokenEntity.fromJson(response.body!);

        // Store new tokens using current storage service
        await Future.wait([
          _storageService.storeAccessToken(tokenEntity.accessToken),
          _storageService.storeRefreshToken(tokenEntity.refreshToken),
        ]);

        _updateState(
          TokenState.authenticated(
            accessToken: tokenEntity.accessToken,
            refreshToken: tokenEntity.refreshToken,
          ),
        );

        _retryCount = 0; // Reset retry count on success
        _completeRefresh(Right(tokenEntity));
        _logger.log('✅ Token refresh successful', LogLevel.info);

        // Notify pending requests
        _notifyPendingRequests(tokenEntity.accessToken);
      } else {
        throw Exception('Invalid response: ${response.statusCode}');
      }
    } on Exception catch (error, stackTrace) {
      _logger.log(
        '❌ Token refresh failed',
        LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );

      // ✅ FIX: Check retry condition BEFORE incrementing
      if (_retryCount < _maxRetries) {
        _retryCount++;
        _logger.log(
          '🔄 Retrying refresh... ($_retryCount/$_maxRetries)',
          LogLevel.warning,
        );
        // Exponential backoff
        await Future<void>.delayed(Duration(seconds: _retryCount * 2));
        // ✅ FIX: Use await instead of unawaited to prevent race conditions
        await _performRefresh();
        return;
      }

      // Max retries reached - fail and logout
      await _storageService.clearTokens();
      _updateState(const TokenState.unauthenticated());
      _completeRefresh(const Left(AuthFailure.refreshFailed()));
      _notifyPendingRequests(null);
    }
  }

  void _completeRefresh(Either<AuthFailure, TokenEntity> result) {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      _refreshCompleter!.complete(result);
    }
  }

  void _notifyPendingRequests(String? token) {
    while (_pendingRequests.isNotEmpty) {
      final completer = _pendingRequests.removeFirst();
      if (!completer.isCompleted) {
        completer.complete(token);
      }
    }
  }

  /// Get current access token with automatic refresh if needed.
  ///
  /// Returns null if no token available or refresh fails.
  Future<String?> getValidAccessToken() async {
    final storedToken = await _storageService.getAccessToken();

    if (storedToken == null) return null;

    // Return token - if expired, 401 response will trigger refresh
    return storedToken;
  }

  /// Queue request for token when refresh is in progress.
  ///
  /// Returns `Future<String?>` that completes when token is available.
  Future<String?> waitForValidToken() async {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      final completer = Completer<String?>();
      _pendingRequests.add(completer);
      return completer.future;
    }

    return getValidAccessToken();
  }

  /// Initialize token state from stored tokens.
  ///
  /// Call this during app startup to restore authentication state.
  Future<void> initializeFromStorage() async {
    final accessToken = await _storageService.getAccessToken();
    final refreshToken = await _storageService.getRefreshToken();

    if (accessToken != null && refreshToken != null) {
      // Try to determine expiration - for existing tokens, check if valid
      final isValid = await _validateStoredToken(accessToken);

      if (isValid) {
        _updateState(
          TokenState.authenticated(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
        );
      } else {
        _updateState(TokenState.expired(refreshToken: refreshToken));
      }
    } else {
      _updateState(const TokenState.unauthenticated());
    }
  }

  Future<bool> _validateStoredToken(String token) async {
    try {
      // Simple validation - check if token is not empty and looks like JWT
      return token.isNotEmpty && token.split('.').length == 3;
    } on Exception {
      return false;
    }
  }

  void _updateState(TokenState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  /// Dispose of resources when TokenManager is no longer needed.
  ///
  /// Closes the state controller to prevent memory leaks.
  @disposeMethod
  void dispose() {
    _stateController.close();
  }
}
