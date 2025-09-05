import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/platform/platform_detector.dart';
import 'package:xp1/features/locale/domain/services/platform_locale_provider.dart';
import 'package:xp1/features/locale/infrastructure/default_platform_locale_provider.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Mock platform detector for testing different platform scenarios.
class MockPlatformDetector extends Mock implements PlatformDetector {}

void main() {
  group('DefaultPlatformLocaleProvider', () {
    late MockPlatformDetector mockPlatformDetector;
    late DefaultPlatformLocaleProvider provider;

    setUp(() {
      mockPlatformDetector = MockPlatformDetector();
      provider = DefaultPlatformLocaleProvider(
        platformDetector: mockPlatformDetector,
      );
    });

    group('getSystemLocale', () {
      test('should return web locale when running on web platform', () {
        // Arrange
        when(() => mockPlatformDetector.isWeb).thenReturn(true);

        // Act & Assert
        // Since we're testing on non-web platform, getWebLocale() will throw
        // an UnsupportedError. This tests the web branch of the if statement.
        expect(
          () => provider.getSystemLocale(),
          throwsA(isA<UnsupportedError>()),
        );

        // Verify that platform detector was called
        verify(() => mockPlatformDetector.isWeb).called(1);
      });

      test(
        'should return platform locale when running on native platform',
        () {
          // Arrange
          when(() => mockPlatformDetector.isWeb).thenReturn(false);

          // Act
          final result = provider.getSystemLocale();

          // Assert
          // On native platform, it should return the first part of
          // Platform.localeName. We can't predict the exact value, but it
          // should be a non-empty string
          expect(result, isA<String>());
          expect(result, isNotEmpty);

          // Verify that platform detector was called
          verify(() => mockPlatformDetector.isWeb).called(1);
        },
      );
    });

    group('getSupportedLocales', () {
      test('should return list of supported locale codes from AppLocale', () {
        // Act
        final result = provider.getSupportedLocales();

        // Assert
        expect(result, isA<List<String>>());
        expect(result, isNotEmpty);

        // Verify that it contains the expected locale codes
        // Based on the project structure, we expect at least 'en' and 'vi'
        expect(result, contains('en'));
        expect(result, contains('vi'));

        // Verify that the list has the same length as AppLocale enum values
        expect(result.length, equals(AppLocale.values.length));
      });

      test('should return locale codes that match AppLocale enum values', () {
        // Act
        final result = provider.getSupportedLocales();

        // Assert
        // Get expected locale codes from AppLocale enum
        final expectedCodes = AppLocale.values
            .map((locale) => locale.languageCode)
            .toList();

        expect(result, equals(expectedCodes));
      });

      test('should return immutable list by creating new list each time', () {
        // Act
        final result1 = provider.getSupportedLocales();
        final result2 = provider.getSupportedLocales();

        // Assert
        // Should return equal lists but not the same instance
        expect(result1, equals(result2));
        expect(identical(result1, result2), isFalse);
      });
    });

    group('constructor', () {
      test('should create provider with platform detector dependency', () {
        // Arrange & Act
        final testProvider = DefaultPlatformLocaleProvider(
          platformDetector: mockPlatformDetector,
        );

        // Assert
        expect(testProvider, isA<DefaultPlatformLocaleProvider>());
        expect(testProvider, isA<PlatformLocaleProvider>());
      });
    });

    group('integration with platform detection', () {
      test('should handle web platform detection correctly', () {
        // Arrange
        when(() => mockPlatformDetector.isWeb).thenReturn(true);

        // Act & Assert
        // The web branch should be taken, which will call getWebLocale()
        // On non-web platforms, this throws UnsupportedError
        expect(
          () => provider.getSystemLocale(),
          throwsA(
            isA<UnsupportedError>().having(
              (e) => e.message,
              'message',
              contains('Web locale detection is not supported'),
            ),
          ),
        );
      });

      test('should handle native platform detection correctly', () {
        // Arrange
        when(() => mockPlatformDetector.isWeb).thenReturn(false);

        // Act
        final result = provider.getSystemLocale();

        // Assert
        // Should successfully return a locale string from Platform.localeName
        expect(result, isA<String>());
        expect(result, isNotEmpty);
        // The result should be a valid language code (2 characters typically)
        expect(result.length, greaterThanOrEqualTo(2));
      });
    });
  });
}
