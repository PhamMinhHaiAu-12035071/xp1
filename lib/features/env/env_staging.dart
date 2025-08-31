import 'package:envied/envied.dart';
import 'package:xp1/features/env/domain/env_config_repository.dart';

part 'env_staging.g.dart';

/// Environment configuration for staging environment.
/// This class serves as an interface to access environment variables
/// securely using the envied package with obfuscation enabled.
///
/// The implementation uses the `staging.env` file for staging-specific
/// configuration values. Never access these values directly in features.
/// Instead, inject the [EnvConfigRepository] through DI.
@Envied(path: 'lib/features/env/staging.env')
final class EnvStaging {
  /// Base API URL for backend communication.
  /// This is the primary endpoint for all API requests.
  @EnviedField(varName: 'API_URL')
  static String apiUrl = _EnvStaging.apiUrl;

  /// Application name used for display and identification.
  @EnviedField(varName: 'APP_NAME')
  static String appName = _EnvStaging.appName;

  /// Environment identifier, used for debugging and logging.
  @EnviedField(varName: 'ENVIRONMENT_NAME')
  static String environmentName = _EnvStaging.environmentName;

  /// Debug mode flag for development features.
  @EnviedField(varName: 'IS_DEBUG_MODE')
  static bool isDebugMode = _EnvStaging.isDebugMode;

  /// API timeout duration in milliseconds.
  @EnviedField(varName: 'API_TIMEOUT_MS')
  static int apiTimeoutMs = _EnvStaging.apiTimeoutMs;
}
