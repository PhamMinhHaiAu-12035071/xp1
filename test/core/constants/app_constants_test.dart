import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    group('LocaleConstants', () {
      test('should have correct locale storage key', () {
        // Arrange & Act
        const storageKey = LocaleConstants.localeStorageKey;

        // Assert
        expect(storageKey, equals('app_locale'));
        expect(storageKey, isA<String>());
      });

      test('should have correct default locale code', () {
        // Arrange & Act
        const defaultLocale = LocaleConstants.defaultLocaleCode;

        // Assert
        expect(defaultLocale, equals('vi'));
        expect(defaultLocale, isA<String>());
      });

      test('should have correct initialization timeout', () {
        // Arrange & Act
        const timeout = LocaleConstants.initializationTimeout;

        // Assert
        expect(timeout, equals(const Duration(seconds: 2)));
        expect(timeout, isA<Duration>());
        expect(timeout.inSeconds, equals(2));
      });
    });

    group('TestConstants', () {
      test('should have correct widget test timeout', () {
        // Arrange & Act
        const timeout = TestConstants.widgetTestTimeout;

        // Assert
        expect(timeout, equals(const Duration(seconds: 3)));
        expect(timeout, isA<Duration>());
        expect(timeout.inSeconds, equals(3));
      });

      test('should have correct frame pump interval', () {
        // Arrange & Act
        const interval = TestConstants.framePumpInterval;

        // Assert
        expect(interval, equals(const Duration(milliseconds: 100)));
        expect(interval, isA<Duration>());
        expect(interval.inMilliseconds, equals(100));
      });

      test('should have correct max frames to pump', () {
        // Arrange & Act
        const maxFrames = TestConstants.maxFramesToPump;

        // Assert
        expect(maxFrames, equals(30));
        expect(maxFrames, isA<int>());
        expect(maxFrames, greaterThan(0));
      });
    });

    group('BootstrapConstants', () {
      test('should have correct dependency setup timeout', () {
        // Arrange & Act
        const timeout = BootstrapConstants.dependencySetupTimeout;

        // Assert
        expect(timeout, equals(const Duration(seconds: 5)));
        expect(timeout, isA<Duration>());
        expect(timeout.inSeconds, equals(5));
      });

      test('should have correct environment check timeout', () {
        // Arrange & Act
        const timeout = BootstrapConstants.environmentCheckTimeout;

        // Assert
        expect(timeout, equals(const Duration(seconds: 1)));
        expect(timeout, isA<Duration>());
        expect(timeout.inSeconds, equals(1));
      });
    });

    group('Constants relationship validation', () {
      test(
        'dependency setup timeout should be longer than environment check',
        () {
          // Arrange
          const dependencyTimeout = BootstrapConstants.dependencySetupTimeout;
          const environmentTimeout = BootstrapConstants.environmentCheckTimeout;

          // Assert
          expect(
            dependencyTimeout.inMilliseconds,
            greaterThan(environmentTimeout.inMilliseconds),
          );
        },
      );

      test('widget test timeout should be reasonable for UI testing', () {
        // Arrange
        const widgetTimeout = TestConstants.widgetTestTimeout;
        const frameInterval = TestConstants.framePumpInterval;

        // Assert
        expect(
          widgetTimeout.inMilliseconds,
          greaterThan(frameInterval.inMilliseconds),
        );
        // Not too long for UI testing
        expect(widgetTimeout.inSeconds, lessThanOrEqualTo(10));
      });

      test('locale initialization should complete within reasonable time', () {
        // Arrange
        const localeTimeout = LocaleConstants.initializationTimeout;

        // Assert
        expect(localeTimeout.inSeconds, greaterThan(0));
        expect(localeTimeout.inSeconds, lessThanOrEqualTo(5)); // Reasonable
      });
    });
  });
}
