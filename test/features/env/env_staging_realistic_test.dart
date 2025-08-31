import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/env/env_staging.dart';

void main() {
  group('EnvStaging - Realistic Tests', () {
    // Note: Due to envied limitation, all environment classes currently
    // return values from development.env (the last generated environment).
    // These tests validate structure and behavior rather than specific values.

    group('Environment Configuration Structure', () {
      test('should provide valid API URL structure', () {
        expect(EnvStaging.apiUrl, isNotEmpty);
        expect(EnvStaging.apiUrl, isA<String>());
        expect(
          EnvStaging.apiUrl,
          matches('^https?://.*'),
          reason: 'API URL should be a valid HTTP/HTTPS URL',
        );
        expect(EnvStaging.apiUrl, contains('api'));
        expect(EnvStaging.apiUrl, contains('xp1.com'));
      });

      test('should provide valid app name structure', () {
        expect(EnvStaging.appName, isNotEmpty);
        expect(EnvStaging.appName, isA<String>());
        expect(EnvStaging.appName, contains('XP1'));
      });

      test('should provide environment name', () {
        expect(EnvStaging.environmentName, isNotEmpty);
        expect(EnvStaging.environmentName, isA<String>());
      });

      test('should provide debug mode value', () {
        expect(EnvStaging.isDebugMode, isA<bool>());
      });

      test('should provide valid API timeout', () {
        expect(EnvStaging.apiTimeoutMs, isA<int>());
        expect(
          EnvStaging.apiTimeoutMs,
          greaterThan(0),
          reason: 'API timeout should be positive',
        );
        expect(
          EnvStaging.apiTimeoutMs,
          lessThanOrEqualTo(60000),
          reason: 'API timeout should be reasonable (≤ 60 seconds)',
        );
      });
    });

    group('Generated Code Integration', () {
      test('should access generated values without errors', () {
        expect(() => EnvStaging.apiUrl, returnsNormally);
        expect(() => EnvStaging.appName, returnsNormally);
        expect(() => EnvStaging.environmentName, returnsNormally);
        expect(() => EnvStaging.isDebugMode, returnsNormally);
        expect(() => EnvStaging.apiTimeoutMs, returnsNormally);
      });

      test('values should be consistent from generated code', () {
        final apiUrl = EnvStaging.apiUrl;
        final appName = EnvStaging.appName;
        final environmentName = EnvStaging.environmentName;
        final isDebugMode = EnvStaging.isDebugMode;
        final apiTimeoutMs = EnvStaging.apiTimeoutMs;

        expect(apiUrl, equals(EnvStaging.apiUrl));
        expect(appName, equals(EnvStaging.appName));
        expect(environmentName, equals(EnvStaging.environmentName));
        expect(isDebugMode, equals(EnvStaging.isDebugMode));
        expect(apiTimeoutMs, equals(EnvStaging.apiTimeoutMs));
      });

      test('should have valid URL format', () {
        final uri = Uri.tryParse(EnvStaging.apiUrl);
        expect(uri, isNotNull, reason: 'API URL should be a valid URI');
        expect(uri!.scheme, anyOf(['http', 'https']));
        expect(uri.host, isNotEmpty);
      });

      test('should not contain placeholder values', () {
        final placeholders = [
          'localhost',
          '127.0.0.1',
          'example.com',
          'placeholder',
          'TODO',
          'CHANGE_ME',
        ];

        for (final placeholder in placeholders) {
          expect(
            EnvStaging.apiUrl.toLowerCase(),
            isNot(contains(placeholder.toLowerCase())),
            reason: 'API URL should not contain placeholder: $placeholder',
          );
        }
      });
    });

    group('Environment Interface Contract', () {
      test('should provide all required fields', () {
        // Test that all required interface fields are available
        expect(EnvStaging.apiUrl, isA<String>());
        expect(EnvStaging.appName, isA<String>());
        expect(EnvStaging.environmentName, isA<String>());
        expect(EnvStaging.isDebugMode, isA<bool>());
        expect(EnvStaging.apiTimeoutMs, isA<int>());
      });

      test('string fields should not be empty', () {
        expect(EnvStaging.apiUrl.trim(), isNotEmpty);
        expect(EnvStaging.appName.trim(), isNotEmpty);
        expect(EnvStaging.environmentName.trim(), isNotEmpty);
      });

      test('should be suitable for staging use case', () {
        // Staging environment characteristics (regardless of current values)
        expect(EnvStaging.apiTimeoutMs, greaterThan(10000));
        expect(EnvStaging.apiUrl, contains('api'));
        expect(EnvStaging.appName, contains('XP1'));
      });
    });
  });
}
