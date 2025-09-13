import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';

import '../../features/env/domain/env_config_repository.dart';

/// HTTP client configuration using Chopper with environment integration
///
/// Provides a configured ChopperClient instance that integrates with the
/// application's environment configuration. Handles base URL setup,
/// JSON conversion, and debug logging based on environment settings.
@injectable
class ApiClient {
  /// Creates an ApiClient with environment configuration
  ///
  /// [_envConfig] - Environment configuration repository for API settings
  const ApiClient(this._envConfig);

  final EnvConfigRepository _envConfig;

  /// Creates and configures a ChopperClient instance
  ///
  /// Returns a fully configured ChopperClient with:
  /// - Base URL from environment configuration
  /// - JSON converter for request/response handling
  /// - Logging interceptor when debug mode is enabled
  /// - Timeout configuration from environment
  @lazySingleton
  ChopperClient create() {
    final interceptors = <Interceptor>[];

    // Add debug logging interceptor when debug mode is enabled
    if (_envConfig.isDebugMode) {
      interceptors.add(
        PrettyChopperLogger(), // Log requests and responses in debug mode
      );
    }

    return ChopperClient(
      // Set base URL from environment configuration
      baseUrl: Uri.parse(_envConfig.apiUrl),

      // Configure JSON converter for automatic serialization/deserialization
      converter: const JsonConverter(),

      errorConverter: const JsonConverter(),

      // Add interceptors (logging, future auth interceptor, etc.)
      interceptors: interceptors,
    );
  }
}
