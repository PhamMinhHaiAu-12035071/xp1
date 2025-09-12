import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/env/env_development.dart';

void main() {
  group('EnvDev', () {
    group('Environment Configuration Values', () {
      test('should provide valid API URL', () {
        expect(EnvDev.apiUrl, isNotEmpty);
        expect(EnvDev.apiUrl, isA<String>());
        expect(
          EnvDev.apiUrl,
          matches('^https?://.*'),
          reason: 'API URL should be a valid HTTP/HTTPS URL',
        );
      });

      test('should provide development-specific API URL', () {
        expect(EnvDev.apiUrl, contains('dev'));
        expect(EnvDev.apiUrl, contains('api'));
        expect(EnvDev.apiUrl, contains('px1.vn'));
      });

      test('should provide valid app name', () {
        expect(EnvDev.appName, isNotEmpty);
        expect(EnvDev.appName, isA<String>());
        expect(EnvDev.appName, contains('XP1'));
        expect(EnvDev.appName, contains('Development'));
      });

      test('should provide development environment name', () {
        expect(EnvDev.environmentName, isNotEmpty);
        expect(EnvDev.environmentName, isA<String>());
        expect(EnvDev.environmentName, equals('development'));
      });

      test('should have debug mode enabled for development', () {
        expect(EnvDev.isDebugMode, isA<bool>());
        expect(
          EnvDev.isDebugMode,
          isTrue,
          reason: 'Development environment should have debug mode enabled',
        );
      });

      test('should provide valid API timeout', () {
        expect(EnvDev.apiTimeoutMs, isA<int>());
        expect(
          EnvDev.apiTimeoutMs,
          greaterThan(0),
          reason: 'API timeout should be positive',
        );
        expect(
          EnvDev.apiTimeoutMs,
          lessThanOrEqualTo(60000),
          reason: 'API timeout should be reasonable (≤ 60 seconds)',
        );
      });

      test('should have development-appropriate timeout', () {
        // Development should have longer timeout for debugging
        expect(EnvDev.apiTimeoutMs, greaterThanOrEqualTo(30000));
      });
    });

    group('Field Types and Constraints', () {
      test('all static fields should be properly typed', () {
        expect(EnvDev.apiUrl, isA<String>());
        expect(EnvDev.appName, isA<String>());
        expect(EnvDev.environmentName, isA<String>());
        expect(EnvDev.isDebugMode, isA<bool>());
        expect(EnvDev.apiTimeoutMs, isA<int>());
      });

      test('string fields should not be empty', () {
        expect(EnvDev.apiUrl.trim(), isNotEmpty);
        expect(EnvDev.appName.trim(), isNotEmpty);
        expect(EnvDev.environmentName.trim(), isNotEmpty);
      });

      test('should have consistent naming convention', () {
        expect(
          EnvDev.environmentName.toLowerCase(),
          equals('development'),
        );
        expect(
          EnvDev.appName.toLowerCase(),
          contains('development'),
        );
      });
    });

    group('Environment Validation', () {
      test('should have development-specific configuration', () {
        // Development should be distinguishable from other environments
        expect(EnvDev.apiUrl.toLowerCase(), contains('dev'));
        expect(EnvDev.appName.toLowerCase(), contains('development'));
        expect(EnvDev.environmentName, equals('development'));
        expect(EnvDev.isDebugMode, isTrue);
      });

      test('should have valid URL format', () {
        final uri = Uri.tryParse(EnvDev.apiUrl);
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
            EnvDev.apiUrl.toLowerCase(),
            isNot(contains(placeholder.toLowerCase())),
            reason: 'API URL should not contain placeholder: $placeholder',
          );
        }
      });
    });

    group('Generated Code Integration', () {
      test('should access generated values without errors', () {
        expect(() => EnvDev.apiUrl, returnsNormally);
        expect(() => EnvDev.appName, returnsNormally);
        expect(() => EnvDev.environmentName, returnsNormally);
        expect(() => EnvDev.isDebugMode, returnsNormally);
        expect(() => EnvDev.apiTimeoutMs, returnsNormally);
      });

      test('values should be consistent from generated code', () {
        // These values come from generated code and should be consistent
        final apiUrl = EnvDev.apiUrl;
        final appName = EnvDev.appName;
        final environmentName = EnvDev.environmentName;
        final isDebugMode = EnvDev.isDebugMode;
        final apiTimeoutMs = EnvDev.apiTimeoutMs;

        expect(apiUrl, equals(EnvDev.apiUrl));
        expect(appName, equals(EnvDev.appName));
        expect(environmentName, equals(EnvDev.environmentName));
        expect(isDebugMode, equals(EnvDev.isDebugMode));
        expect(apiTimeoutMs, equals(EnvDev.apiTimeoutMs));
      });
    });
  });
}
