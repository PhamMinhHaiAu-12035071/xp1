import 'package:xp1/features/env/domain/env_config_repository.dart';
import 'package:xp1/features/env/env_development.dart';
import 'package:xp1/features/env/env_production.dart';
import 'package:xp1/features/env/env_staging.dart';
import 'package:xp1/features/env/infrastructure/env_config_repository_impl.dart';

/// Sealed class representing different application environments.
///
/// This class provides a factory pattern for environment-specific
/// configurations and ensures type safety when switching between
/// development, staging, and production.
sealed class Environment {
  /// Creates an instance of Environment.
  const Environment();

  static Environment? _instance;

  /// Gets the current environment instance based on compile-time
  /// configuration.
  ///
  /// Uses lazy initialization to create the environment instance only once.
  static Environment get current {
    _instance ??= _getCurrentEnvironment();
    return _instance!;
  }

  /// The API base URL for this environment.
  String get apiUrl;

  /// The application name for this environment.
  String get appName;

  /// The human-readable name of this environment.
  String get environmentName;

  /// Whether debug mode is enabled for this environment.
  bool get isDebugMode;

  /// The API timeout duration in milliseconds.
  int get apiTimeoutMs;

  static Environment _getCurrentEnvironment() {
    const environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    return switch (environment) {
      'production' => const Production(),
      'staging' => const Staging(),
      _ => const Development(),
    };
  }
}

/// Development environment configuration.
///
/// Provides configuration values specific to development environment.
final class Development extends Environment {
  /// Creates a development environment instance.
  const Development();

  @override
  String get apiUrl => EnvDev.apiUrl;

  @override
  String get appName => EnvDev.appName;

  @override
  String get environmentName => EnvDev.environmentName;

  @override
  bool get isDebugMode => EnvDev.isDebugMode;

  @override
  int get apiTimeoutMs => EnvDev.apiTimeoutMs;
}

/// Staging environment configuration.
///
/// Provides configuration values specific to staging environment.
final class Staging extends Environment {
  /// Creates a staging environment instance.
  const Staging();

  @override
  String get apiUrl => EnvStaging.apiUrl;

  @override
  String get appName => EnvStaging.appName;

  @override
  String get environmentName => EnvStaging.environmentName;

  @override
  bool get isDebugMode => EnvStaging.isDebugMode;

  @override
  int get apiTimeoutMs => EnvStaging.apiTimeoutMs;
}

/// Production environment configuration.
///
/// Provides configuration values specific to production environment.
final class Production extends Environment {
  /// Creates a production environment instance.
  const Production();

  @override
  String get apiUrl => EnvProd.apiUrl;

  @override
  String get appName => EnvProd.appName;

  @override
  String get environmentName => EnvProd.environmentName;

  @override
  bool get isDebugMode => EnvProd.isDebugMode;

  @override
  int get apiTimeoutMs => EnvProd.apiTimeoutMs;
}

/// Factory class for accessing environment configuration.
///
/// Provides static methods to access current environment settings
/// and utilities for environment-specific operations.
class EnvConfigFactory {
  /// Gets the current environment instance.
  static Environment get currentEnvironment => Environment.current;

  static final EnvConfigRepository _repository = EnvConfigRepositoryImpl();

  /// Gets the environment configuration repository instance.
  static EnvConfigRepository get repository => _repository;

  /// Gets the cached environment configuration.
  static Environment get cachedConfig => currentEnvironment;

  /// Gets the API URL from the current environment.
  static String get apiUrl => currentEnvironment.apiUrl;

  /// Gets the app name from the current environment.
  static String get appName => currentEnvironment.appName;

  /// Gets the environment name from the current environment.
  static String get environmentName => currentEnvironment.environmentName;

  /// Gets the debug mode flag from the current environment.
  static bool get isDebugMode => currentEnvironment.isDebugMode;

  /// Gets the API timeout from the current environment.
  static int get apiTimeoutMs => currentEnvironment.apiTimeoutMs;

  /// Gets the API URL for a specific environment.
  ///
  /// [environment] The environment to get the API URL from.
  static String getApiUrlForEnvironment(Environment environment) =>
      environment.apiUrl;

  /// Gets the app name for a specific environment.
  ///
  /// [environment] The environment to get the app name from.
  static String getAppNameForEnvironment(Environment environment) =>
      environment.appName;

  /// Gets the environment name for a specific environment.
  ///
  /// [environment] The environment to get the name from.
  static String getEnvironmentNameForEnvironment(Environment environment) =>
      environment.environmentName;

  /// Gets the debug mode flag for a specific environment.
  ///
  /// [environment] The environment to get the debug mode from.
  static bool getIsDebugModeForEnvironment(Environment environment) =>
      environment.isDebugMode;

  /// Gets the API timeout for a specific environment.
  ///
  /// [environment] The environment to get the timeout from.
  static int getApiTimeoutMsForEnvironment(Environment environment) =>
      environment.apiTimeoutMs;
}
