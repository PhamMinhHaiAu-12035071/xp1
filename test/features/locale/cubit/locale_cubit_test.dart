import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/features/locale/cubit/locale_cubit.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/errors/locale_errors.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';

/// Mock for LocaleDomainService using mocktail.
class MockLocaleDomainService extends Mock implements LocaleDomainService {}

void main() {
  group('LocaleCubit', () {
    late LocaleCubit localeCubit;
    late MockLocaleDomainService mockDomainService;

    setUp(() {
      mockDomainService = MockLocaleDomainService();
      localeCubit = LocaleCubit(domainService: mockDomainService);
    });

    tearDown(() {
      localeCubit.close();
    });

    group('constructor', () {
      test('initial state is Vietnamese default fallback configuration', () {
        expect(
          localeCubit.state,
          equals(LocaleConfigurationExtension.defaultFallback()),
        );
      });
    });

    group('initialize', () {
      blocTest<LocaleCubit, LocaleConfiguration>(
        'emits Vietnamese configuration from domain service',
        setUp: () {
          when(() => mockDomainService.resolveLocaleConfiguration()).thenReturn(
            const LocaleConfiguration(
              languageCode: 'vi',
              source: LocaleSource.defaultFallback,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.defaultFallback,
          ),
        ],
        verify: (_) {
          verify(
            () => mockDomainService.resolveLocaleConfiguration(),
          ).called(1);
        },
      );

      blocTest<LocaleCubit, LocaleConfiguration>(
        'always initializes to Vietnamese regardless of system locale',
        setUp: () {
          when(() => mockDomainService.resolveLocaleConfiguration()).thenReturn(
            const LocaleConfiguration(
              languageCode: 'vi',
              source: LocaleSource.defaultFallback,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.defaultFallback,
          ),
        ],
      );
    });

    group('updateUserLocale', () {
      test('returns Right when locale is supported', () {
        // Arrange
        when(() => mockDomainService.updateUserLocale('en')).thenReturn(
          const LocaleConfiguration(
            languageCode: 'en',
            source: LocaleSource.userSelected,
          ),
        );

        // Act
        final result = localeCubit.updateUserLocale('en');

        // Assert
        expect(result.isRight(), isTrue);
        expect(
          localeCubit.state,
          equals(
            const LocaleConfiguration(
              languageCode: 'en',
              source: LocaleSource.userSelected,
            ),
          ),
        );
        verify(() => mockDomainService.updateUserLocale('en')).called(1);
      });

      test('returns Left with LocaleError when locale is not supported', () {
        // Arrange
        when(
          () => mockDomainService.updateUserLocale('invalid'),
        ).thenThrow(const UnsupportedLocaleException('invalid'));

        // Act
        final result = localeCubit.updateUserLocale('invalid');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<UnsupportedLocaleError>());
          final unsupportedError = error as UnsupportedLocaleError;
          expect(unsupportedError.invalidLocaleCode, equals('invalid'));
          expect(unsupportedError.supportedLocales, containsAll(['en', 'vi']));
        }, (_) => fail('Expected Left but got Right'));

        // State should remain unchanged
        expect(
          localeCubit.state,
          equals(LocaleConfigurationExtension.defaultFallback()),
        );
      });

      blocTest<LocaleCubit, LocaleConfiguration>(
        'emits user selected configuration when locale is valid',
        setUp: () {
          when(() => mockDomainService.updateUserLocale('en')).thenReturn(
            const LocaleConfiguration(
              languageCode: 'en',
              source: LocaleSource.userSelected,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit.updateUserLocale('en'),
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'en',
            source: LocaleSource.userSelected,
          ),
        ],
      );

      blocTest<LocaleCubit, LocaleConfiguration>(
        'does not emit when locale is invalid',
        setUp: () {
          when(
            () => mockDomainService.updateUserLocale('invalid'),
          ).thenThrow(const UnsupportedLocaleException('invalid'));
        },
        build: () => localeCubit,
        act: (cubit) => cubit.updateUserLocale('invalid'),
        expect: () => const <LocaleConfiguration>[],
      );

      blocTest<LocaleCubit, LocaleConfiguration>(
        'supports switching to Vietnamese',
        setUp: () {
          when(() => mockDomainService.updateUserLocale('vi')).thenReturn(
            const LocaleConfiguration(
              languageCode: 'vi',
              source: LocaleSource.userSelected,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit.updateUserLocale('vi'),
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.userSelected,
          ),
        ],
      );
    });

    group('resetToSystemDefault', () {
      blocTest<LocaleCubit, LocaleConfiguration>(
        'emits Vietnamese default configuration',
        setUp: () {
          when(() => mockDomainService.resetToSystemDefault()).thenReturn(
            const LocaleConfiguration(
              languageCode: 'vi',
              source: LocaleSource.defaultFallback,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit.resetToSystemDefault(),
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.defaultFallback,
          ),
        ],
        verify: (_) {
          verify(() => mockDomainService.resetToSystemDefault()).called(1);
        },
      );

      blocTest<LocaleCubit, LocaleConfiguration>(
        'always resets to Vietnamese regardless of previous state',
        setUp: () {
          when(() => mockDomainService.updateUserLocale('en')).thenReturn(
            const LocaleConfiguration(
              languageCode: 'en',
              source: LocaleSource.userSelected,
            ),
          );
          when(() => mockDomainService.resetToSystemDefault()).thenReturn(
            const LocaleConfiguration(
              languageCode: 'vi',
              source: LocaleSource.defaultFallback,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit
          ..updateUserLocale('en') // First switch to English
          ..resetToSystemDefault(), // Then reset
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'en',
            source: LocaleSource.userSelected,
          ),
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.defaultFallback,
          ),
        ],
      );
    });

    group('error handling', () {
      test('handles UnsupportedLocaleException correctly', () {
        // Arrange
        when(
          () => mockDomainService.updateUserLocale('xyz'),
        ).thenThrow(const UnsupportedLocaleException('xyz'));

        // Act
        final result = localeCubit.updateUserLocale('xyz');

        // Assert
        final errorResult =
            result.fold(
                  (error) => error,
                  (_) => fail('Expected error for invalid locale'),
                )
                as UnsupportedLocaleError;

        final invalidLocaleCode = errorResult.invalidLocaleCode;
        final supportedLocales = errorResult.supportedLocales;
        final userMessage = errorResult.userMessage;
        final errorType = errorResult.errorType;
        final isRecoverable = errorResult.isRecoverable;

        expect(invalidLocaleCode, equals('xyz'));
        expect(supportedLocales, containsAll(['en', 'vi']));
        expect(userMessage, contains('xyz'));
        expect(userMessage, contains('not supported'));
        expect(errorType, equals('unsupported_locale'));
        expect(isRecoverable, isTrue);
      });

      test('provides technical message for debugging', () {
        // Arrange
        when(
          () => mockDomainService.updateUserLocale('xyz'),
        ).thenThrow(const UnsupportedLocaleException('xyz'));

        // Act
        final result = localeCubit.updateUserLocale('xyz');

        // Assert
        final errorResult = result.fold(
          (error) => error,
          (_) => fail('Expected error for invalid locale'),
        );
        final technicalMessage = errorResult.technicalMessage;
        expect(technicalMessage, contains('xyz'));
      });
    });

    group('session-only behavior', () {
      blocTest<LocaleCubit, LocaleConfiguration>(
        'maintains locale changes only during session',
        setUp: () {
          when(() => mockDomainService.updateUserLocale('en')).thenReturn(
            const LocaleConfiguration(
              languageCode: 'en',
              source: LocaleSource.userSelected,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit.updateUserLocale('en'),
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'en',
            source: LocaleSource.userSelected,
          ),
        ],
        verify: (_) {
          // Changes are only in session, no persistence calls
          verify(() => mockDomainService.updateUserLocale('en')).called(1);
        },
      );

      test('new cubit instance always starts with Vietnamese default', () {
        // Simulate creating a new cubit instance (like app restart)
        final newCubit = LocaleCubit(domainService: mockDomainService);

        expect(
          newCubit.state,
          equals(LocaleConfigurationExtension.defaultFallback()),
        );

        newCubit.close();
      });
    });

    group('Vietnamese-first behavior', () {
      test('defaults to Vietnamese configuration', () {
        expect(localeCubit.state.languageCode, equals('vi'));
        expect(localeCubit.state.source, equals(LocaleSource.defaultFallback));
      });

      blocTest<LocaleCubit, LocaleConfiguration>(
        'can switch from Vietnamese to English and back',
        setUp: () {
          when(() => mockDomainService.updateUserLocale('en')).thenReturn(
            const LocaleConfiguration(
              languageCode: 'en',
              source: LocaleSource.userSelected,
            ),
          );
          when(() => mockDomainService.resetToSystemDefault()).thenReturn(
            const LocaleConfiguration(
              languageCode: 'vi',
              source: LocaleSource.defaultFallback,
            ),
          );
        },
        build: () => localeCubit,
        act: (cubit) => cubit
          ..updateUserLocale('en') // Switch to English
          ..resetToSystemDefault(), // Reset to Vietnamese
        expect: () => [
          const LocaleConfiguration(
            languageCode: 'en',
            source: LocaleSource.userSelected,
          ),
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.defaultFallback,
          ),
        ],
      );
    });

    group('domain service integration', () {
      test('delegates all business logic to domain service', () {
        // Initialize
        when(() => mockDomainService.resolveLocaleConfiguration()).thenReturn(
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.defaultFallback,
          ),
        );
        localeCubit.initialize();
        verify(() => mockDomainService.resolveLocaleConfiguration()).called(1);

        // Update locale
        when(() => mockDomainService.updateUserLocale('en')).thenReturn(
          const LocaleConfiguration(
            languageCode: 'en',
            source: LocaleSource.userSelected,
          ),
        );
        localeCubit.updateUserLocale('en');
        verify(() => mockDomainService.updateUserLocale('en')).called(1);

        // Reset
        when(() => mockDomainService.resetToSystemDefault()).thenReturn(
          const LocaleConfiguration(
            languageCode: 'vi',
            source: LocaleSource.defaultFallback,
          ),
        );
        localeCubit.resetToSystemDefault();
        verify(() => mockDomainService.resetToSystemDefault()).called(1);
      });
    });
  });
}
