import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/core/network/api_client.dart';

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

  /// Provides configured ChopperClient instance for API communication.
  @Named('chopperClient')
  @lazySingleton
  ChopperClient chopperClient(ApiClient apiClient) => apiClient.create();

  /// Provides FlutterSecureStorage instance for web compatibility.
  ///
  /// On web platform, FlutterSecureStorage needs explicit dependency injection
  /// registration to work properly with the SecureStorageService.
  @singleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();
}
