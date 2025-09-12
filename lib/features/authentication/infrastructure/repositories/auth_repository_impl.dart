import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../mappers/auth_mapper.dart';
import '../models/api_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../services/auth_api_service.dart';

/// Concrete implementation of AuthRepository with comprehensive error handling
///
/// Handles authentication operations with real API integration, secure token
/// storage, and comprehensive error mapping following Either pattern for
/// functional error handling.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  /// Creates AuthRepositoryImpl with required dependencies
  ///
  /// [_apiService] - Handles HTTP authentication requests
  /// [_storageService] - Manages secure token persistence
  /// [_authMapper] - Converts between models and entities
  const AuthRepositoryImpl(
    this._apiService,
    this._storageService,
    this._authMapper,
  );

  final AuthApiService _apiService;
  final SecureStorageService _storageService;
  final AuthMapper _authMapper;

  @override
  Future<Either<AuthFailure, LoginResult>> login(LoginInput input) async {
    try {
      // Convert domain input to API request
      final request = _authMapper.fromLoginInputToRequest(input);
      final requestBody = request.toJson();

      // Call authentication API
      final response = await _apiService.login(requestBody);

      // Handle HTTP response status
      if (!response.isSuccessful) {
        return Left(_mapHttpErrorToFailure(response));
      }

      // Parse successful response
      final responseBody = response.body;
      if (responseBody == null) {
        return const Left(
          AuthFailure.unknown('Empty response from authentication server'),
        );
      }

      // Parse API response with wrapper
      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        responseBody,
        (json) => LoginResponse.fromJson(json! as Map<String, dynamic>),
      );

      // Handle wrapped response
      return apiResponse.when(
        success: (status, code, loginData) async {
          // Store tokens securely for persistent authentication
          await _storageService.storeAccessToken(loginData.accessToken);
          await _storageService.storeRefreshToken(loginData.refreshToken);

          // Convert API response to domain result
          final loginResult = _authMapper.fromLoginResponseToResult(
            loginData,
            input.username,
          );
          return Right(loginResult);
        },
        error: (status, message, code) {
          return Left(_mapErrorResponseToFailure(code, message));
        },
      );
    } on SocketException catch (e) {
      return Left(AuthFailure.networkError(e.message));
    } on FormatException catch (e) {
      return Left(AuthFailure.unknown('Invalid response format: ${e.message}'));
    } on Exception catch (e) {
      return Left(AuthFailure.unknown('Login failed: $e'));
    }
  }

  @override
  Future<Either<AuthFailure, TokenEntity>> refreshToken() async {
    try {
      // Get stored refresh token
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthFailure.unauthorized());
      }

      // Call refresh API
      final requestBody = {'refresh_token': refreshToken};
      final response = await _apiService.refreshToken(requestBody);

      // Handle HTTP response status
      if (!response.isSuccessful) {
        // Clear tokens if refresh fails with 401
        if (response.statusCode == 401) {
          await _storageService.clearTokens();
          return const Left(AuthFailure.tokenExpired());
        }
        return Left(_mapHttpErrorToFailure(response));
      }

      // Parse successful response
      final responseBody = response.body;
      if (responseBody == null) {
        return const Left(
          AuthFailure.unknown('Empty response from token refresh'),
        );
      }

      // Parse API response with wrapper
      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        responseBody,
        (json) => LoginResponse.fromJson(json! as Map<String, dynamic>),
      );

      return apiResponse.when(
        success: (status, code, refreshData) async {
          // Update stored tokens
          await _storageService.storeAccessToken(refreshData.accessToken);
          await _storageService.storeRefreshToken(refreshData.refreshToken);

          // Convert to token entity
          final tokenEntity = TokenEntity(
            accessToken: refreshData.accessToken,
            refreshToken: refreshData.refreshToken,
            tokenType: 'Bearer', // Standard bearer token type
            ttl: refreshData.ttl, // Use ttl from API response
          );

          return Right(tokenEntity);
        },
        error: (status, message, code) {
          return Left(_mapErrorResponseToFailure(code, message));
        },
      );
    } on SocketException catch (e) {
      return Left(AuthFailure.networkError(e.message));
    } on FormatException catch (e) {
      return Left(AuthFailure.unknown('Invalid response format: ${e.message}'));
    } on Exception catch (e) {
      return Left(AuthFailure.unknown('Token refresh failed: $e'));
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      // Clear all stored tokens
      await _storageService.clearTokens();
      return const Right(null);
    } on Exception catch (e) {
      return Left(AuthFailure.unknown('Logout failed: $e'));
    }
  }

  /// Maps HTTP response errors to appropriate AuthFailure variants
  ///
  /// Converts HTTP status codes and response data to business-specific
  /// authentication failures for proper error handling.
  AuthFailure _mapHttpErrorToFailure(Response<Map<String, dynamic>> response) {
    switch (response.statusCode) {
      case 401:
        return const AuthFailure.invalidCredentials();
      case 422:
        return const AuthFailure.invalidCredentials();
      case >= 500:
        return AuthFailure.serverError(response.statusCode);
      default:
        return AuthFailure.unknown(
          'HTTP ${response.statusCode}: ${response.error ?? 'Unknown error'}',
        );
    }
  }

  /// Maps API error response to appropriate AuthFailure variants
  ///
  /// Converts error responses from the API wrapper to business-specific
  /// authentication failures for proper error handling.
  AuthFailure _mapErrorResponseToFailure(int code, String message) {
    switch (code) {
      case 400:
        return const AuthFailure.invalidCredentials();
      case 401:
        return const AuthFailure.unauthorized();
      case 422:
        return const AuthFailure.invalidCredentials();
      case >= 500:
        return AuthFailure.serverError(code);
      default:
        return AuthFailure.unknown('API Error $code: $message');
    }
  }
}
