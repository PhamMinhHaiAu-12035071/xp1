import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Service for secure storage of JWT tokens using FlutterSecureStorage
///
/// Provides encrypted storage for sensitive authentication tokens.
/// All token operations are performed asynchronously and securely.
/// Follows security best practices for JWT token management.
@LazySingleton()
class SecureStorageService {
  /// Creates a SecureStorageService with dependency-injected storage
  ///
  /// The secure storage instance from dependency injection
  const SecureStorageService(this._storage);

  /// FlutterSecureStorage instance with default options
  final FlutterSecureStorage _storage;

  /// Storage keys for different token types
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Stores JWT access token securely
  ///
  /// [token] - The JWT access token to store
  /// Throws [Exception] if storage operation fails
  Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Stores JWT refresh token securely
  ///
  /// [token] - The JWT refresh token to store
  /// Throws [Exception] if storage operation fails
  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieves stored access token
  ///
  /// Returns the stored access token or null if none exists
  /// Throws [Exception] if storage read operation fails
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  /// Retrieves stored refresh token
  ///
  /// Returns the stored refresh token or null if none exists
  /// Throws [Exception] if storage read operation fails
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Clears all stored tokens (logout operation)
  ///
  /// Removes all authentication tokens from secure storage
  /// Throws [Exception] if storage clear operation fails
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  /// Checks if access token exists in storage
  ///
  /// Returns true if access token is stored, false otherwise
  /// Useful for checking authentication state without reading token value
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Checks if refresh token exists in storage
  ///
  /// Returns true if refresh token is stored, false otherwise
  /// Useful for checking if token refresh is possible
  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }
}
