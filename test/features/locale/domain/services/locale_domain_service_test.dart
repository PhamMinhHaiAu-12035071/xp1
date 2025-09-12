import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';

void main() {
  group('LocaleDomainService', () {
    late LocaleDomainService localeDomainService;

    setUp(() {
      localeDomainService = LocaleDomainService();
    });

    group('constructor', () {
      test('should create instance with no dependencies', () {
        expect(localeDomainService, isNotNull);
        expect(localeDomainService, isA<LocaleDomainService>());
      });
    });

    group('resolveLocaleConfiguration', () {
      test('should return Vietnamese default on initial call', () {
        // Act
        final result = localeDomainService.resolveLocaleConfiguration();

        // Assert
        expect(result.languageCode, equals('vi'));
        expect(result.source, equals(LocaleSource.defaultFallback));
        expect(result.isUserSelected, isFalse);
      });

      test('should return session locale after user selection', () {
        // Arrange
        localeDomainService.updateUserLocale('en');

        // Act
        final result = localeDomainService.resolveLocaleConfiguration();

        // Assert
        expect(result.languageCode, equals('en'));
        expect(result.source, equals(LocaleSource.userSelected));
        expect(result.isUserSelected, isTrue);
      });

      test('should return Vietnamese default after reset', () {
        // Arrange
        localeDomainService
          ..updateUserLocale('en')
          ..resetToSystemDefault();

        // Act
        final result = localeDomainService.resolveLocaleConfiguration();

        // Assert
        expect(result.languageCode, equals('vi'));
        expect(result.source, equals(LocaleSource.defaultFallback));
        expect(result.isUserSelected, isFalse);
      });

      test('should be synchronous operation', () {
        // Act & Assert - should complete immediately without await
        final result = localeDomainService.resolveLocaleConfiguration();
        expect(result, isA<LocaleConfiguration>());
      });
    });

    group('updateUserLocale', () {
      test('should update session locale when language code is supported', () {
        // Arrange
        const languageCode = 'en';

        // Act
        final result = localeDomainService.updateUserLocale(languageCode);

        // Assert
        expect(result.languageCode, equals(languageCode));
        expect(result.source, equals(LocaleSource.userSelected));
        expect(result.isUserSelected, isTrue);
      });

      test('should update to Vietnamese when supported', () {
        // Arrange
        const languageCode = 'vi';

        // Act
        final result = localeDomainService.updateUserLocale(languageCode);

        // Assert
        expect(result.languageCode, equals(languageCode));
        expect(result.source, equals(LocaleSource.userSelected));
        expect(result.isUserSelected, isTrue);
      });

      test('should persist session locale across multiple calls', () {
        // Arrange
        localeDomainService.updateUserLocale('en');

        // Act
        final result1 = localeDomainService.resolveLocaleConfiguration();
        final result2 = localeDomainService.resolveLocaleConfiguration();

        // Assert
        expect(result1.languageCode, equals('en'));
        expect(result2.languageCode, equals('en'));
        expect(result1, equals(result2));
      });

      test(
        'should throw UnsupportedLocaleException for unsupported locale',
        () {
          // Arrange
          const unsupportedLanguageCode = 'invalid';

          // Act & Assert
          expect(
            () => localeDomainService.updateUserLocale(unsupportedLanguageCode),
            throwsA(isA<UnsupportedLocaleException>()),
          );
        },
      );

      test(
        'should include supported locales list in exception message',
        () {
          // Arrange
          const unsupportedLanguageCode = 'invalid';

          // Act & Assert
          try {
            localeDomainService.updateUserLocale(unsupportedLanguageCode);
            fail('Expected UnsupportedLocaleException');
          } on UnsupportedLocaleException catch (e) {
            expect(e, isA<UnsupportedLocaleException>());
            expect(e.message, contains(unsupportedLanguageCode));
            expect(e.message, contains('Supported locales:'));
            expect(e.message, contains('en'));
            expect(e.message, contains('vi'));
          }
        },
      );

      test('should be synchronous operation', () {
        // Act & Assert - should complete immediately without await
        final result = localeDomainService.updateUserLocale('en');
        expect(result, isA<LocaleConfiguration>());
      });

      test('should not affect state when exception is thrown', () {
        // Arrange
        localeDomainService.updateUserLocale('en');

        // Act
        try {
          localeDomainService.updateUserLocale('invalid');
        } on UnsupportedLocaleException {
          // Expected exception
        }

        // Assert - state should remain unchanged
        final result = localeDomainService.resolveLocaleConfiguration();
        expect(result.languageCode, equals('en'));
      });
    });

    group('resetToSystemDefault', () {
      test('should reset to Vietnamese default from any session locale', () {
        // Arrange - set different locale first
        localeDomainService.updateUserLocale('en');

        // Act
        final result = localeDomainService.resetToSystemDefault();

        // Assert
        expect(result.languageCode, equals('vi'));
        expect(result.source, equals(LocaleSource.defaultFallback));
        expect(result.isUserSelected, isFalse);
      });

      test('should clear session state completely', () {
        // Arrange - set English first
        localeDomainService
          ..updateUserLocale('en')
          ..resetToSystemDefault();

        // Assert - subsequent calls should return Vietnamese default
        final result1 = localeDomainService.resolveLocaleConfiguration();
        final result2 = localeDomainService.resolveLocaleConfiguration();

        expect(result1.languageCode, equals('vi'));
        expect(result2.languageCode, equals('vi'));
      });

      test('should work correctly when already at default', () {
        // Arrange - ensure we start at default
        final initialResult = localeDomainService.resolveLocaleConfiguration();
        expect(initialResult.languageCode, equals('vi'));

        // Act
        final result = localeDomainService.resetToSystemDefault();

        // Assert
        expect(result.languageCode, equals('vi'));
        expect(result.source, equals(LocaleSource.defaultFallback));
      });

      test('should be synchronous operation', () {
        // Act & Assert - should complete immediately without await
        final result = localeDomainService.resetToSystemDefault();
        expect(result, isA<LocaleConfiguration>());
      });
    });

    group('session isolation', () {
      test('should maintain separate state per service instance', () {
        // Arrange
        final service1 = LocaleDomainService();
        final service2 = LocaleDomainService();

        // Act
        service1.updateUserLocale('en');

        // Assert
        final result1 = service1.resolveLocaleConfiguration();
        final result2 = service2.resolveLocaleConfiguration();

        expect(result1.languageCode, equals('en'));
        expect(result2.languageCode, equals('vi')); // Default
      });

      test('should handle multiple locale changes within session', () {
        // Act & Assert
        localeDomainService.updateUserLocale('en');
        expect(
          localeDomainService.resolveLocaleConfiguration().languageCode,
          equals('en'),
        );

        localeDomainService.updateUserLocale('vi');
        expect(
          localeDomainService.resolveLocaleConfiguration().languageCode,
          equals('vi'),
        );

        localeDomainService.resetToSystemDefault();
        expect(
          localeDomainService.resolveLocaleConfiguration().languageCode,
          equals('vi'),
        );
      });
    });
  });

  group('UnsupportedLocaleException', () {
    test('should create exception with message', () {
      // Arrange
      const message = 'Test error message';

      // Act
      const exception = UnsupportedLocaleException(message);

      // Assert
      expect(exception.message, equals(message));
      expect(exception.toString(), contains(message));
      expect(exception.toString(), contains('UnsupportedLocaleException'));
    });

    test('should be throwable', () {
      // Arrange
      const exception = UnsupportedLocaleException('Test');

      // Act & Assert
      expect(() => throw exception, throwsA(isA<UnsupportedLocaleException>()));
    });
  });
}
