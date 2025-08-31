import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/counter/cubit/counter_cubit.dart';
import 'package:xp1/features/env/domain/env_config_repository.dart';

/// Mock services for testing.
class MockLoggerService extends Mock implements ILoggerService {}

class MockEnvConfigRepository extends Mock implements EnvConfigRepository {}

/// Test DI container setup for widget tests.
class TestDependencyContainer {
  /// Setup test dependencies with mocks.
  static Future<void> setupTestDependencies() async {
    // Register fallback values for mocktail
    registerFallbackValue(LogLevel.info);

    // Clear existing registrations
    await GetIt.instance.reset();

    // Register mock services
    GetIt.instance
      ..registerFactory<CounterCubit>(CounterCubit.new)
      ..registerLazySingleton<ILoggerService>(MockLoggerService.new)
      ..registerLazySingleton<EnvConfigRepository>(MockEnvConfigRepository.new);

    // Setup default mock behaviors
    final mockEnvConfig =
        GetIt.instance<EnvConfigRepository>() as MockEnvConfigRepository;
    when(() => mockEnvConfig.apiUrl).thenReturn('https://test-api.example.com');
    when(() => mockEnvConfig.appName).thenReturn('Test App');
    when(() => mockEnvConfig.environmentName).thenReturn('test');
    when(() => mockEnvConfig.isDebugMode).thenReturn(true);
    when(() => mockEnvConfig.apiTimeoutMs).thenReturn(5000);
  }

  /// Reset test dependencies.
  static Future<void> resetTestDependencies() async {
    await GetIt.instance.reset();
  }
}
