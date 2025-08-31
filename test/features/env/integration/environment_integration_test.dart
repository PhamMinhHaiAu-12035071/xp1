import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/env/domain/env_config_repository.dart';
import 'package:xp1/features/env/env_development.dart';
import 'package:xp1/features/env/env_production.dart';
import 'package:xp1/features/env/env_staging.dart';
import 'package:xp1/features/env/infrastructure/env_config_factory.dart';
import 'package:xp1/features/env/infrastructure/env_config_repository_impl.dart';

void main() {
  group('Environment System Integration', () {
    late EnvConfigRepository repository;

    setUp(() {
      repository = EnvConfigRepositoryImpl();
    });

    group('Environment Factory Integration', () {
      test('should provide current environment instance', () {
        final environment = EnvConfigFactory.currentEnvironment;

        expect(environment, isA<Environment>());
        expect(environment, isA<Development>());
      });

      test('should provide consistent values through factory', () {
        final apiUrl = EnvConfigFactory.apiUrl;
        final appName = EnvConfigFactory.appName;
        final environmentName = EnvConfigFactory.environmentName;
        final isDebugMode = EnvConfigFactory.isDebugMode;
        final apiTimeoutMs = EnvConfigFactory.apiTimeoutMs;

        expect(apiUrl, isNotEmpty);
        expect(appName, isNotEmpty);
        expect(environmentName, isNotEmpty);
        expect(isDebugMode, isA<bool>());
        expect(apiTimeoutMs, greaterThan(0));
      });

      test('should handle all environment types correctly', () {
        final environments = [
          const Development(),
          const Staging(),
          const Production(),
        ];

        for (final env in environments) {
          expect(
            () => EnvConfigFactory.getApiUrlForEnvironment(env),
            returnsNormally,
          );
          expect(
            () => EnvConfigFactory.getAppNameForEnvironment(env),
            returnsNormally,
          );
          expect(
            () => EnvConfigFactory.getEnvironmentNameForEnvironment(env),
            returnsNormally,
          );
          expect(
            () => EnvConfigFactory.getIsDebugModeForEnvironment(env),
            returnsNormally,
          );
          expect(
            () => EnvConfigFactory.getApiTimeoutMsForEnvironment(env),
            returnsNormally,
          );
        }
      });
    });

    group('Repository Integration', () {
      test('should implement repository interface correctly', () {
        expect(repository, isA<EnvConfigRepository>());
        expect(repository, isA<EnvConfigRepositoryImpl>());
      });

      test('should provide values through repository interface', () {
        expect(repository.apiUrl, isNotEmpty);
        expect(repository.appName, isNotEmpty);
        expect(repository.environmentName, isNotEmpty);
        expect(repository.isDebugMode, isA<bool>());
        expect(repository.apiTimeoutMs, greaterThan(0));
      });

      test('repository and factory should provide same values', () {
        expect(repository.apiUrl, equals(EnvConfigFactory.apiUrl));
        expect(repository.appName, equals(EnvConfigFactory.appName));
        expect(
          repository.environmentName,
          equals(EnvConfigFactory.environmentName),
        );
        expect(repository.isDebugMode, equals(EnvConfigFactory.isDebugMode));
        expect(repository.apiTimeoutMs, equals(EnvConfigFactory.apiTimeoutMs));
      });
    });

    group('Environment Class Integration', () {
      test('all environment classes should have required fields', () {
        final environments = [
          (
            EnvDev.apiUrl,
            EnvDev.appName,
            EnvDev.environmentName,
            EnvDev.isDebugMode,
            EnvDev.apiTimeoutMs,
          ),
          (
            EnvStaging.apiUrl,
            EnvStaging.appName,
            EnvStaging.environmentName,
            EnvStaging.isDebugMode,
            EnvStaging.apiTimeoutMs,
          ),
          (
            EnvProd.apiUrl,
            EnvProd.appName,
            EnvProd.environmentName,
            EnvProd.isDebugMode,
            EnvProd.apiTimeoutMs,
          ),
        ];

        for (final (apiUrl, appName, envName, debugMode, timeout)
            in environments) {
          expect(apiUrl, isNotEmpty);
          expect(appName, isNotEmpty);
          expect(envName, isNotEmpty);
          expect(debugMode, isA<bool>());
          expect(timeout, greaterThan(0));
        }
      });

      test('environment classes should have valid configurations', () {
        // Note: Due to envied limitation, all environments return values from
        // the last generated .env file (currently development.env)
        // This test validates the structure rather than cross-environment
        // values

        expect(EnvDev.environmentName, isNotEmpty);
        expect(EnvStaging.environmentName, isNotEmpty);
        expect(EnvProd.environmentName, isNotEmpty);

        // All should provide valid debug mode values
        expect(EnvDev.isDebugMode, isA<bool>());
        expect(EnvStaging.isDebugMode, isA<bool>());
        expect(EnvProd.isDebugMode, isA<bool>());
      });
    });

    group('Sealed Class Pattern Integration', () {
      test('should support exhaustive pattern matching', () {
        final environments = [
          const Development(),
          const Staging(),
          const Production(),
        ];

        for (final env in environments) {
          final result = switch (env) {
            Development() => 'dev',
            Staging() => 'staging',
            Production() => 'prod',
          };

          expect(result, isNotEmpty);
          expect(['dev', 'staging', 'prod'], contains(result));
        }
      });

      test('should provide polymorphic behavior', () {
        final environments = [
          const Development(),
          const Staging(),
          const Production(),
        ];

        for (final env in environments) {
          expect(env.apiUrl, isNotEmpty);
          expect(env.appName, isNotEmpty);
          expect(env.environmentName, isNotEmpty);
          expect(env.isDebugMode, isA<bool>());
          expect(env.apiTimeoutMs, greaterThan(0));
        }
      });

      test('sealed class instances should be const', () {
        const dev1 = Development();
        const dev2 = Development();
        const staging1 = Staging();
        const staging2 = Staging();
        const prod1 = Production();
        const prod2 = Production();

        // Same type instances should be identical
        expect(identical(dev1, dev2), isTrue);
        expect(identical(staging1, staging2), isTrue);
        expect(identical(prod1, prod2), isTrue);

        // Different types should not be identical
        expect(identical(dev1, staging1), isFalse);
        expect(identical(staging1, prod1), isFalse);
        expect(identical(dev1, prod1), isFalse);
      });
    });

    group('Error Handling and Edge Cases', () {
      test('should handle null values gracefully', () {
        // This tests that our environment values are never null
        expect(EnvConfigFactory.apiUrl, isNotNull);
        expect(EnvConfigFactory.appName, isNotNull);
        expect(EnvConfigFactory.environmentName, isNotNull);
        expect(EnvConfigFactory.isDebugMode, isNotNull);
        expect(EnvConfigFactory.apiTimeoutMs, isNotNull);
      });

      test('should have valid URL formats across all environments', () {
        final environments = [
          const Development(),
          const Staging(),
          const Production(),
        ];

        for (final env in environments) {
          final uri = Uri.tryParse(env.apiUrl);
          expect(
            uri,
            isNotNull,
            reason: '${env.runtimeType} should have valid URL format',
          );
          expect(uri!.scheme, anyOf(['http', 'https']));
          expect(uri.host, isNotEmpty);
        }
      });

      test('should have reasonable timeout values', () {
        final environments = [
          const Development(),
          const Staging(),
          const Production(),
        ];

        for (final env in environments) {
          expect(
            env.apiTimeoutMs,
            greaterThan(5000),
            reason: '${env.runtimeType} timeout should be at least 5 seconds',
          );
          expect(
            env.apiTimeoutMs,
            lessThan(60000),
            reason: '${env.runtimeType} timeout should be less than 60 seconds',
          );
        }
      });
    });

    group('Performance and Memory', () {
      test('environment access should be fast', () {
        // Test that accessing environment values is performant
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 1000; i++) {
          // Access all environment values in batch to test performance
          final _ = (
            EnvConfigFactory.apiUrl,
            EnvConfigFactory.appName,
            EnvConfigFactory.environmentName,
            EnvConfigFactory.isDebugMode,
            EnvConfigFactory.apiTimeoutMs,
          );
        }

        stopwatch.stop();

        // Should complete 1000 access operations in less than 100ms
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
          reason: 'Environment access should be fast',
        );
      });

      test('sealed class creation should be efficient', () {
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 1000; i++) {
          const Development()
            ..apiUrl
            ..appName
            ..environmentName
            ..apiTimeoutMs;
          const Staging();
          const Production();
        }

        stopwatch.stop();

        // Const creation should be very fast
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(50),
          reason: 'Const environment creation should be very fast',
        );
      });
    });
  });
}
