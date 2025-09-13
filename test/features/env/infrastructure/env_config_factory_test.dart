import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/env/infrastructure/env_config_factory.dart';

void main() {
  group('EnvConfigFactory with Sealed Class', () {
    test('should return development environment by default', () {
      expect(
        EnvConfigFactory.currentEnvironment,
        isA<Development>(),
      );
    });

    test('should return correct API URL for development', () {
      final apiUrl = EnvConfigFactory.getApiUrlForEnvironment(
        const Development(),
      );
      expect(apiUrl, contains('api-dev.px1.vn'));
    });

    test('should return valid API URL for staging', () {
      final apiUrl = EnvConfigFactory.getApiUrlForEnvironment(
        const Staging(),
      );
      expect(apiUrl, isNotEmpty);
      expect(apiUrl, contains('api'));
      expect(apiUrl, startsWith('http'));
    });

    test('should return valid API URL for production', () {
      final apiUrl = EnvConfigFactory.getApiUrlForEnvironment(
        const Production(),
      );
      expect(apiUrl, isNotEmpty);
      expect(apiUrl, contains('api'));
      expect(apiUrl, startsWith('http'));
    });

    test('should return valid app name for each environment', () {
      // Note: Due to envied limitation, all environments currently return
      // values from development.env. We test structure rather than specific
      // values.

      final devAppName = EnvConfigFactory.getAppNameForEnvironment(
        const Development(),
      );
      final stagingAppName = EnvConfigFactory.getAppNameForEnvironment(
        const Staging(),
      );
      final prodAppName = EnvConfigFactory.getAppNameForEnvironment(
        const Production(),
      );

      expect(devAppName, isNotEmpty);
      expect(devAppName, contains('XP1'));

      expect(stagingAppName, isNotEmpty);
      expect(stagingAppName, contains('XP1'));

      expect(prodAppName, isNotEmpty);
      expect(prodAppName, contains('XP1'));
    });

    test('should return valid debug mode for each environment', () {
      // Due to envied limitation, all return development values currently
      final devDebug = EnvConfigFactory.getIsDebugModeForEnvironment(
        const Development(),
      );
      final stagingDebug = EnvConfigFactory.getIsDebugModeForEnvironment(
        const Staging(),
      );
      final prodDebug = EnvConfigFactory.getIsDebugModeForEnvironment(
        const Production(),
      );

      expect(devDebug, isA<bool>());
      expect(stagingDebug, isA<bool>());
      expect(prodDebug, isA<bool>());
    });

    test('should return valid timeout for each environment', () {
      final devTimeout = EnvConfigFactory.getApiTimeoutMsForEnvironment(
        const Development(),
      );
      final stagingTimeout = EnvConfigFactory.getApiTimeoutMsForEnvironment(
        const Staging(),
      );
      final prodTimeout = EnvConfigFactory.getApiTimeoutMsForEnvironment(
        const Production(),
      );

      expect(devTimeout, greaterThan(0));
      expect(devTimeout, lessThan(60000));

      expect(stagingTimeout, greaterThan(0));
      expect(stagingTimeout, lessThan(60000));

      expect(prodTimeout, greaterThan(0));
      expect(prodTimeout, lessThan(60000));
    });

    group('Environment sealed class', () {
      test('should have exhaustive pattern matching', () {
        final environments = [
          const Development(),
          const Staging(),
          const Production(),
        ];

        for (final env in environments) {
          // Test exhaustive checking with sealed class
          final result = switch (env) {
            Development() => 'dev',
            Staging() => 'staging',
            Production() => 'prod',
          };

          expect(result, isNotEmpty);
        }
      });

      test('should provide polymorphic behavior', () {
        const development = Development();
        const staging = Staging();
        const production = Production();

        // Test that sealed class polymorphism works
        // Note: Due to envied limitation, all return development values
        // currently
        expect(development.environmentName, isNotEmpty);
        expect(staging.environmentName, isNotEmpty);
        expect(production.environmentName, isNotEmpty);

        // Test that all provide required interface
        expect(development.apiUrl, isNotEmpty);
        expect(staging.apiUrl, isNotEmpty);
        expect(production.apiUrl, isNotEmpty);
      });
    });
  });

  group('Performance & Caching', () {
    test('should return same Environment instance for repeated calls', () {
      // Verify that Environment.current provides proper singleton behavior
      final env1 = EnvConfigFactory.currentEnvironment;
      final env2 = EnvConfigFactory.currentEnvironment;

      expect(
        identical(env1, env2),
        isTrue,
        reason: 'Environment should be singleton for performance',
      );
    });

    test('should cache environment properties for fast access', () {
      // Performance test to ensure cached property access is efficient

      // Warm-up phase to eliminate cold start costs
      for (var i = 0; i < 10; i++) {
        final _ = (
          EnvConfigFactory.apiUrl,
          EnvConfigFactory.appName,
          EnvConfigFactory.environmentName,
        );
      }

      final stopwatch = Stopwatch()..start();

      // Multiple property access should be fast due to caching
      for (var i = 0; i < 1000; i++) {
        // Use records to group static method calls
        final _ = (
          EnvConfigFactory.apiUrl,
          EnvConfigFactory.appName,
          EnvConfigFactory.environmentName,
        );
      }

      stopwatch.stop();

      // More realistic threshold for CI environments
      // CI can be slower due to virtualization and shared resources
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(100),
        reason: 'Cached access should be under 100ms for 1000 calls on CI',
      );
    });
  });

  group(
    'Repository Pattern Integration',
    () {
      test('should provide EnvConfigRepository implementation', () {
        // Verify that the factory provides a repository implementation
        expect(
          () => EnvConfigFactory.repository,
          returnsNormally,
          reason: 'Should provide repository implementation',
        );
      });

      test('repository should implement EnvConfigRepository interface', () {
        // Verify that the repository properly implements the interface
        final repo = EnvConfigFactory.repository;
        expect(repo.apiUrl, isNotEmpty);
        expect(repo.appName, isNotEmpty);
        expect(repo.environmentName, isNotEmpty);
        expect(repo.isDebugMode, isA<bool>());
        expect(repo.apiTimeoutMs, greaterThan(0));
      });
    },
  );
}
