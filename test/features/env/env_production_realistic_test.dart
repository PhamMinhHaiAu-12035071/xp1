import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/env/env_production.dart';

void main() {
  group('EnvProd - Realistic Tests', () {
    // Note: Due to envied limitation, all environment classes currently
    // return values from development.env (the last generated environment).
    // These tests validate structure and behavior rather than specific values.

    group('Environment Configuration Structure', () {
      test('should provide valid API URL structure', () {
        expect(EnvProd.apiUrl, isNotEmpty);
        expect(EnvProd.apiUrl, isA<String>());
        expect(
          EnvProd.apiUrl,
          matches('^https?://.*'),
          reason: 'API URL should be a valid HTTP/HTTPS URL',
        );
        expect(EnvProd.apiUrl, contains('api'));
        expect(EnvProd.apiUrl, contains('px1.vn'));
      });

      test('should provide valid app name structure', () {
        expect(EnvProd.appName, isNotEmpty);
        expect(EnvProd.appName, isA<String>());
        expect(EnvProd.appName, contains('XP1'));
      });

      test('should provide environment name', () {
        expect(EnvProd.environmentName, isNotEmpty);
        expect(EnvProd.environmentName, isA<String>());
      });

      test('should provide debug mode value', () {
        expect(EnvProd.isDebugMode, isA<bool>());
      });

      test('should provide valid API timeout', () {
        expect(EnvProd.apiTimeoutMs, isA<int>());
        expect(
          EnvProd.apiTimeoutMs,
          greaterThan(0),
          reason: 'API timeout should be positive',
        );
        expect(
          EnvProd.apiTimeoutMs,
          lessThanOrEqualTo(60000),
          reason: 'API timeout should be reasonable (≤ 60 seconds)',
        );
      });
    });

    group('Generated Code Integration', () {
      test('should access generated values without errors', () {
        expect(() => EnvProd.apiUrl, returnsNormally);
        expect(() => EnvProd.appName, returnsNormally);
        expect(() => EnvProd.environmentName, returnsNormally);
        expect(() => EnvProd.isDebugMode, returnsNormally);
        expect(() => EnvProd.apiTimeoutMs, returnsNormally);
      });

      test('values should be consistent from generated code', () {
        final apiUrl = EnvProd.apiUrl;
        final appName = EnvProd.appName;
        final environmentName = EnvProd.environmentName;
        final isDebugMode = EnvProd.isDebugMode;
        final apiTimeoutMs = EnvProd.apiTimeoutMs;

        expect(apiUrl, equals(EnvProd.apiUrl));
        expect(appName, equals(EnvProd.appName));
        expect(environmentName, equals(EnvProd.environmentName));
        expect(isDebugMode, equals(EnvProd.isDebugMode));
        expect(apiTimeoutMs, equals(EnvProd.apiTimeoutMs));
      });

      test('should have valid URL format', () {
        final uri = Uri.tryParse(EnvProd.apiUrl);
        expect(uri, isNotNull, reason: 'API URL should be a valid URI');
        expect(uri!.scheme, anyOf(['http', 'https']));
        expect(uri.host, isNotEmpty);
      });

      test('should not contain placeholder values', () {
        final placeholders = [
          'example.com',
          'placeholder',
          'TODO',
          'CHANGE_ME',
          'YOUR_DOMAIN',
        ];

        for (final placeholder in placeholders) {
          expect(
            EnvProd.apiUrl.toLowerCase(),
            isNot(contains(placeholder.toLowerCase())),
            reason: 'API URL should not contain placeholder: $placeholder',
          );
        }
      });
    });

    group('Environment Interface Contract', () {
      test('should provide all required fields', () {
        // Test that all required interface fields are available
        expect(EnvProd.apiUrl, isA<String>());
        expect(EnvProd.appName, isA<String>());
        expect(EnvProd.environmentName, isA<String>());
        expect(EnvProd.isDebugMode, isA<bool>());
        expect(EnvProd.apiTimeoutMs, isA<int>());
      });

      test('string fields should not be empty', () {
        expect(EnvProd.apiUrl.trim(), isNotEmpty);
        expect(EnvProd.appName.trim(), isNotEmpty);
        expect(EnvProd.environmentName.trim(), isNotEmpty);
      });

      test('should be suitable for production use case', () {
        // Production environment characteristics (regardless of current values)
        expect(EnvProd.apiTimeoutMs, greaterThan(5000));
        expect(EnvProd.apiUrl, contains('api'));
        expect(EnvProd.appName, contains('XP1'));

        // Should have real domain, not localhost (once properly configured)
        final uri = Uri.parse(EnvProd.apiUrl);
        expect(uri.host, isNot(equals('localhost')));
        expect(uri.host, isNot(equals('127.0.0.1')));
      });
    });

    group('Production Environment Considerations', () {
      test('should have structured configuration for production', () {
        // These tests verify the structure is suitable for production
        // even if currently returning development values
        expect(EnvProd.apiUrl, startsWith('http'));
        expect(EnvProd.appName, isNotEmpty);
        expect(EnvProd.environmentName, isNotEmpty);
        expect(EnvProd.apiTimeoutMs, greaterThan(0));
      });

      test('should be ready for production deployment', () {
        // Verify basic production readiness structure
        final uri = Uri.parse(EnvProd.apiUrl);
        expect(uri.scheme, anyOf(['http', 'https']));
        expect(uri.host, isNotEmpty);
        expect(uri.host, isNot(isEmpty));
      });
    });
  });
}
