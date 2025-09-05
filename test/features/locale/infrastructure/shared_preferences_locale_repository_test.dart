import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/constants/app_constants.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/infrastructure/shared_preferences_locale_repository.dart';

/// Mock SharedPreferences for testing repository behavior.
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferencesLocaleRepository', () {
    late MockSharedPreferences mockPreferences;
    late SharedPreferencesLocaleRepository repository;

    setUp(() {
      mockPreferences = MockSharedPreferences();
      repository = SharedPreferencesLocaleRepository(
        preferences: mockPreferences,
      );
    });

    group('getCurrentLocale', () {
      test('should return null when no locale is stored', () async {
        // Arrange (Red)
        when(() => mockPreferences.getString(any())).thenReturn(null);

        // Act
        final result = await repository.getCurrentLocale();

        // Assert
        expect(result, isNull);
        verify(
          () => mockPreferences.getString(LocaleConstants.localeStorageKey),
        ).called(1);
      });

      test(
        'should return stored locale configuration when available',
        () async {
          // Arrange (Red)
          const storedLanguageCode = 'en';
          when(
            () => mockPreferences.getString(any()),
          ).thenReturn(storedLanguageCode);

          // Act
          final result = await repository.getCurrentLocale();

          // Assert
          expect(result, isNotNull);
          expect(result!.languageCode, equals(storedLanguageCode));
          expect(result.source, equals(LocaleSource.userSelected));
          verify(
            () => mockPreferences.getString(LocaleConstants.localeStorageKey),
          ).called(1);
        },
      );

      test(
        'should throw LocaleRepositoryException when SharedPreferences fails',
        () async {
          // Arrange (Red)
          final expectedException = Exception('SharedPreferences failed');
          when(
            () => mockPreferences.getString(any()),
          ).thenThrow(expectedException);

          // Act & Assert
          expect(
            () async => repository.getCurrentLocale(),
            throwsA(
              isA<LocaleRepositoryException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Failed to retrieve saved locale configuration'),
                  )
                  .having(
                    (e) => e.originalError,
                    'originalError',
                    equals(expectedException),
                  ),
            ),
          );
        },
      );
    });

    group('saveLocale', () {
      test('should save locale configuration successfully', () async {
        // Arrange (Red)
        final configuration = LocaleConfigurationExtension.userSelected('en');
        when(
          () => mockPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await repository.saveLocale(configuration);

        // Assert
        verify(
          () => mockPreferences.setString(
            LocaleConstants.localeStorageKey,
            'en',
          ),
        ).called(1);
      });

      test('should throw LocaleRepositoryException when save fails', () async {
        // Arrange (Red)
        final configuration = LocaleConfigurationExtension.userSelected('vi');
        final expectedException = Exception('SharedPreferences save failed');
        when(
          () => mockPreferences.setString(any(), any()),
        ).thenThrow(expectedException);

        // Act & Assert
        expect(
          () async => repository.saveLocale(configuration),
          throwsA(
            isA<LocaleRepositoryException>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('Failed to save locale configuration: vi'),
                )
                .having(
                  (e) => e.originalError,
                  'originalError',
                  equals(expectedException),
                ),
          ),
        );
      });
    });

    group('clearSavedLocale', () {
      test('should clear saved locale successfully', () async {
        // Arrange (Red)
        when(() => mockPreferences.remove(any())).thenAnswer((_) async => true);

        // Act
        await repository.clearSavedLocale();

        // Assert
        verify(
          () => mockPreferences.remove(LocaleConstants.localeStorageKey),
        ).called(1);
      });

      test('should throw LocaleRepositoryException when clear fails', () async {
        // Arrange (Red)
        final expectedException = Exception('SharedPreferences remove failed');
        when(() => mockPreferences.remove(any())).thenThrow(expectedException);

        // Act & Assert
        expect(
          () async => repository.clearSavedLocale(),
          throwsA(
            isA<LocaleRepositoryException>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('Failed to clear saved locale configuration'),
                )
                .having(
                  (e) => e.originalError,
                  'originalError',
                  equals(expectedException),
                ),
          ),
        );
      });
    });

    group('hasExistingLocale', () {
      test('should return true when locale key exists', () async {
        // Arrange (Red)
        when(() => mockPreferences.containsKey(any())).thenReturn(true);

        // Act
        final result = await repository.hasExistingLocale();

        // Assert
        expect(result, isTrue);
        verify(
          () => mockPreferences.containsKey(LocaleConstants.localeStorageKey),
        ).called(1);
      });

      test('should return false when locale key does not exist', () async {
        // Arrange (Red)
        when(() => mockPreferences.containsKey(any())).thenReturn(false);

        // Act
        final result = await repository.hasExistingLocale();

        // Assert
        expect(result, isFalse);
        verify(
          () => mockPreferences.containsKey(LocaleConstants.localeStorageKey),
        ).called(1);
      });

      test('should throw LocaleRepositoryException when check fails', () async {
        // Arrange (Red)
        final expectedException = Exception('SharedPreferences check failed');
        when(
          () => mockPreferences.containsKey(any()),
        ).thenThrow(expectedException);

        // Act & Assert
        expect(
          () async => repository.hasExistingLocale(),
          throwsA(
            isA<LocaleRepositoryException>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('Failed to check for existing locale configuration'),
                )
                .having(
                  (e) => e.originalError,
                  'originalError',
                  equals(expectedException),
                ),
          ),
        );
      });
    });

    group('LocaleRepositoryException', () {
      test('should format toString correctly with original error', () {
        // Arrange
        const message = 'Test error message';
        final originalError = Exception('Original error');
        final exception = LocaleRepositoryException(message, originalError);

        // Act
        final result = exception.toString();

        // Assert
        expect(result, contains('LocaleRepositoryException: $message'));
        expect(result, contains('caused by: $originalError'));
      });

      test('should format toString correctly without original error', () {
        // Arrange
        const message = 'Test error message';
        const exception = LocaleRepositoryException(message);

        // Act
        final result = exception.toString();

        // Assert
        expect(result, equals('LocaleRepositoryException: $message'));
        expect(result, isNot(contains('caused by')));
      });
    });
  });
}
