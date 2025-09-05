import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/locale/domain/errors/locale_errors.dart';

void main() {
  group('LocaleError', () {
    group('UnsupportedLocaleError', () {
      test(
        'should create unsupported locale error with correct properties',
        () {
          // Arrange
          const invalidCode = 'xx';
          const supportedCodes = ['en', 'vi', 'fr'];

          // Act
          const error = LocaleError.unsupportedLocale(
            invalidLocaleCode: invalidCode,
            supportedLocales: supportedCodes,
          );

          // Assert
          expect(error, isA<UnsupportedLocaleError>());
          expect(
            error.when(
              unsupportedLocale: (invalidLocaleCode, supportedLocales) {
                expect(invalidLocaleCode, equals(invalidCode));
                expect(supportedLocales, equals(supportedCodes));
                return true;
              },
              platformDetectionFailed: (_) => false,
              persistenceFailed: (_, _) => false,
              validationFailed: (_, _) => false,
            ),
            isTrue,
          );
        },
      );
    });

    group('PlatformDetectionFailedError', () {
      test(
        'should create platform detection error with correct properties',
        () {
          // Arrange
          const reason = 'Platform API unavailable';

          // Act
          const error = LocaleError.platformDetectionFailed(reason: reason);

          // Assert
          expect(error, isA<PlatformDetectionFailedError>());
          expect(
            error.when(
              unsupportedLocale: (_, _) => false,
              platformDetectionFailed: (errorReason) {
                expect(errorReason, equals(reason));
                return true;
              },
              persistenceFailed: (_, _) => false,
              validationFailed: (_, _) => false,
            ),
            isTrue,
          );
        },
      );
    });

    group('PersistenceFailedError', () {
      test('should create persistence error with correct properties', () {
        // Arrange
        const operation = 'save';
        const reason = 'Storage unavailable';

        // Act
        const error = LocaleError.persistenceFailed(
          operation: operation,
          reason: reason,
        );

        // Assert
        expect(error, isA<PersistenceFailedError>());
        expect(
          error.when(
            unsupportedLocale: (_, _) => false,
            platformDetectionFailed: (_) => false,
            persistenceFailed: (errorOperation, errorReason) {
              expect(errorOperation, equals(operation));
              expect(errorReason, equals(reason));
              return true;
            },
            validationFailed: (_, _) => false,
          ),
          isTrue,
        );
      });
    });

    group('ValidationFailedError', () {
      test('should create validation error with correct properties', () {
        // Arrange
        const locale = 'invalid-locale';
        const rule = 'Must be ISO 639-1 format';

        // Act
        const error = LocaleError.validationFailed(
          locale: locale,
          validationRule: rule,
        );

        // Assert
        expect(error, isA<ValidationFailedError>());
        expect(
          error.when(
            unsupportedLocale: (_, _) => false,
            platformDetectionFailed: (_) => false,
            persistenceFailed: (_, _) => false,
            validationFailed: (errorLocale, errorRule) {
              expect(errorLocale, equals(locale));
              expect(errorRule, equals(rule));
              return true;
            },
          ),
          isTrue,
        );
      });
    });
  });

  group('LocaleErrorExtension', () {
    group('userMessage', () {
      test('should return user-friendly message for unsupported locale', () {
        // Arrange
        const error = LocaleError.unsupportedLocale(
          invalidLocaleCode: 'xx',
          supportedLocales: ['en', 'vi'],
        );

        // Act
        final message = error.userMessage;

        // Assert
        expect(message, contains('Language "xx" is not supported'));
        expect(message, contains('Available languages: en, vi'));
      });

      test(
        'should return user-friendly message for platform detection error',
        () {
          // Arrange
          const error = LocaleError.platformDetectionFailed(
            reason: 'API not available',
          );

          // Act
          final message = error.userMessage;

          // Assert
          expect(message, contains('Unable to detect your system language'));
          expect(message, contains('API not available'));
        },
      );

      test('should return user-friendly message for persistence error', () {
        // Arrange
        const error = LocaleError.persistenceFailed(
          operation: 'save',
          reason: 'Storage full',
        );

        // Act
        final message = error.userMessage;

        // Assert
        expect(message, contains('Failed to save language preference'));
        expect(message, contains('Operation: save'));
        expect(message, contains('Reason: Storage full'));
      });

      test('should return user-friendly message for validation error', () {
        // Arrange
        const error = LocaleError.validationFailed(
          locale: 'invalid-locale',
          validationRule: 'Must be ISO format',
        );

        // Act
        final message = error.userMessage;

        // Assert
        expect(message, contains('Invalid language format "invalid-locale"'));
        expect(message, contains('Rule: Must be ISO format'));
      });
    });

    group('technicalMessage', () {
      test('should return technical message for unsupported locale', () {
        // Arrange
        const error = LocaleError.unsupportedLocale(
          invalidLocaleCode: 'xx',
          supportedLocales: ['en', 'vi'],
        );

        // Act
        final message = error.technicalMessage;

        // Assert
        expect(message, equals('UnsupportedLocaleError: xx not in [en, vi]'));
      });

      test('should return technical message for platform detection error', () {
        // Arrange
        const error = LocaleError.platformDetectionFailed(
          reason: 'API failure',
        );

        // Act
        final message = error.technicalMessage;

        // Assert
        expect(message, equals('PlatformDetectionFailedError: API failure'));
      });

      test('should return technical message for persistence error', () {
        // Arrange
        const error = LocaleError.persistenceFailed(
          operation: 'load',
          reason: 'File not found',
        );

        // Act
        final message = error.technicalMessage;

        // Assert
        expect(
          message,
          equals('PersistenceFailedError: load failed - File not found'),
        );
      });

      test('should return technical message for validation error', () {
        // Arrange
        const error = LocaleError.validationFailed(
          locale: 'bad-locale',
          validationRule: 'ISO 639-1',
        );

        // Act
        final message = error.technicalMessage;

        // Assert
        expect(
          message,
          equals('ValidationFailedError: bad-locale violates ISO 639-1'),
        );
      });
    });

    group('errorType', () {
      test('should return correct error type for unsupported locale', () {
        // Arrange
        const error = LocaleError.unsupportedLocale(
          invalidLocaleCode: 'xx',
          supportedLocales: ['en'],
        );

        // Act
        final type = error.errorType;

        // Assert
        expect(type, equals('unsupported_locale'));
      });

      test('should return correct error type for platform detection error', () {
        // Arrange
        const error = LocaleError.platformDetectionFailed(reason: 'test');

        // Act
        final type = error.errorType;

        // Assert
        expect(type, equals('platform_detection_failed'));
      });

      test('should return correct error type for persistence error', () {
        // Arrange
        const error = LocaleError.persistenceFailed(
          operation: 'test',
          reason: 'test',
        );

        // Act
        final type = error.errorType;

        // Assert
        expect(type, equals('persistence_failed'));
      });

      test('should return correct error type for validation error', () {
        // Arrange
        const error = LocaleError.validationFailed(
          locale: 'test',
          validationRule: 'test',
        );

        // Act
        final type = error.errorType;

        // Assert
        expect(type, equals('validation_failed'));
      });
    });

    group('isRecoverable', () {
      test('should return true for unsupported locale error', () {
        // Arrange
        const error = LocaleError.unsupportedLocale(
          invalidLocaleCode: 'xx',
          supportedLocales: ['en'],
        );

        // Act & Assert
        expect(error.isRecoverable, isTrue);
      });

      test('should return true for platform detection error', () {
        // Arrange
        const error = LocaleError.platformDetectionFailed(reason: 'test');

        // Act & Assert
        expect(error.isRecoverable, isTrue);
      });

      test('should return false for persistence error', () {
        // Arrange
        const error = LocaleError.persistenceFailed(
          operation: 'test',
          reason: 'test',
        );

        // Act & Assert
        expect(error.isRecoverable, isFalse);
      });

      test('should return true for validation error', () {
        // Arrange
        const error = LocaleError.validationFailed(
          locale: 'test',
          validationRule: 'test',
        );

        // Act & Assert
        expect(error.isRecoverable, isTrue);
      });
    });
  });
}
