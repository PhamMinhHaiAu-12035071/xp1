import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/infrastructure/services/auth_api_service.dart';
import '../../features/env/infrastructure/env_config_factory.dart';
import '../infrastructure/logging/i_logger_service.dart';
import '../infrastructure/logging/logger_service.dart';
import '../network/auth_interceptor.dart';
import '../network/token_authenticator.dart';

/// App module for providing services that require custom initialization.
@module
abstract class AppModule {
  /// Provides LoggerService instance.
  @singleton
  ILoggerService get loggerService => LoggerService();

  /// Provides SharedPreferences instance for persistent storage.
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// Provides configured ChopperClient instance with authentication.
  ///
  /// Integrates token refresh system with Chopper HTTP client while
  /// maintaining compatibility with existing API services.
  @Named('chopperClient')
  @lazySingleton
  ChopperClient chopperClient(
    TokenAuthenticator authenticator,
    AuthInterceptor authInterceptor,
    ILoggerService logger,
  ) {
    return ChopperClient(
      baseUrl: Uri.parse(EnvConfigFactory.apiUrl),

      // 🛡️ Authentication system
      authenticator: authenticator,

      interceptors: [
        // 🔑 Auto-inject tokens
        authInterceptor,

        // 📊 Beautiful logging (development only)
        if (kDebugMode) PrettyChopperLogger(),

        // 🔧 Custom headers
        const HeadersInterceptor({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      ],

      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
  }

  /// Provides a dedicated ChopperClient for token refresh requests.
  ///
  /// This client does NOT include the AuthInterceptor to prevent
  /// circular dependencies during token refresh operations.
  @Named('refreshChopperClient')
  @lazySingleton
  ChopperClient refreshChopperClient(ILoggerService logger) {
    return ChopperClient(
      baseUrl: Uri.parse(EnvConfigFactory.apiUrl),
      interceptors: [
        if (kDebugMode) PrettyChopperLogger(),
        const HeadersInterceptor({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      ],
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
  }

  /// Provides AuthApiService for token refresh operations.
  ///
  /// Uses the refresh-specific client to avoid circular dependencies.
  @Named('refreshAuthApiService')
  @lazySingleton
  AuthApiService refreshAuthApiService(
    @Named('refreshChopperClient') ChopperClient client,
  ) {
    return AuthApiService.create(client);
  }

  /// Provides FlutterSecureStorage instance for web compatibility.
  ///
  /// On web platform, FlutterSecureStorage needs explicit dependency injection
  /// registration to work properly with the SecureStorageService.
  @singleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();
}
