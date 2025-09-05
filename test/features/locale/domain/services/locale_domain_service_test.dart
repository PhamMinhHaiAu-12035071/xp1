import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/repositories/locale_repository.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';
import 'package:xp1/features/locale/domain/services/platform_locale_provider.dart';

/// Mock LocaleRepository for testing LocaleDomainService.
class TestLocaleRepository implements LocaleRepository {
  TestLocaleRepository({
    this.currentLocale,
    this.shouldThrowOnSave = false,
    this.shouldThrowOnGet = false,
    this.shouldThrowOnClear = false,
  });

  LocaleConfiguration? currentLocale;
  final bool shouldThrowOnSave;
  final bool shouldThrowOnGet;
  final bool shouldThrowOnClear;

  bool saveLocaleCalled = false;
  bool getCurrentLocaleCalled = false;
  bool clearSavedLocaleCalled = false;
  LocaleConfiguration? lastSavedLocale;

  @override
  Future<LocaleConfiguration?> getCurrentLocale() async {
    getCurrentLocaleCalled = true;
    if (shouldThrowOnGet) {
      throw Exception('Failed to get current locale');
    }
    return currentLocale;
  }

  @override
  Future<void> saveLocale(LocaleConfiguration locale) async {
    saveLocaleCalled = true;
    lastSavedLocale = locale;
    if (shouldThrowOnSave) {
      throw Exception('Failed to save locale');
    }
    currentLocale = locale;
  }

  @override
  Future<void> clearSavedLocale() async {
    clearSavedLocaleCalled = true;
    if (shouldThrowOnClear) {
      throw Exception('Failed to clear saved locale');
    }
    currentLocale = null;
  }

  @override
  Future<bool> hasExistingLocale() async {
    final locale = await getCurrentLocale();
    return locale != null;
  }
}

/// Mock PlatformLocaleProvider for testing LocaleDomainService.
class TestPlatformLocaleProvider implements PlatformLocaleProvider {
  TestPlatformLocaleProvider({
    this.systemLocale = 'en',
  });

  final String systemLocale;
  bool getSystemLocaleCalled = false;

  @override
  String getSystemLocale() {
    getSystemLocaleCalled = true;
    return systemLocale;
  }

  @override
  List<String> getSupportedLocales() {
    return ['en', 'vi'];
  }
}

void main() {
  group('LocaleDomainService', () {
    late LocaleDomainService localeDomainService;
    late TestLocaleRepository mockRepository;
    late TestPlatformLocaleProvider mockPlatformProvider;

    setUp(() {
      mockRepository = TestLocaleRepository();
      mockPlatformProvider = TestPlatformLocaleProvider();
      localeDomainService = LocaleDomainService(
        repository: mockRepository,
        platformProvider: mockPlatformProvider,
      );
    });

    group('constructor', () {
      test('should create instance with required dependencies', () {
        expect(localeDomainService, isNotNull);
        expect(localeDomainService, isA<LocaleDomainService>());
      });
    });

    group('resolveLocaleConfiguration', () {
      group('Strategy 1: Use saved user preference', () {
        test(
          'should return saved locale when available and supported',
          () async {
            // Arrange
            final savedLocale = LocaleConfigurationExtension.userSelected('vi');
            mockRepository.currentLocale = savedLocale;

            // Act
            final result = await localeDomainService
                .resolveLocaleConfiguration();

            // Assert
            expect(result, equals(savedLocale));
            expect(mockRepository.getCurrentLocaleCalled, isTrue);
            expect(mockPlatformProvider.getSystemLocaleCalled, isFalse);
          },
        );

        test(
          'should proceed to strategy 2 when saved locale is null',
          () async {
            // Arrange
            mockRepository.currentLocale = null;
            mockPlatformProvider = TestPlatformLocaleProvider();
            localeDomainService = LocaleDomainService(
              repository: mockRepository,
              platformProvider: mockPlatformProvider,
            );

            // Act
            final result = await localeDomainService
                .resolveLocaleConfiguration();

            // Assert
            expect(mockRepository.getCurrentLocaleCalled, isTrue);
            expect(mockPlatformProvider.getSystemLocaleCalled, isTrue);
            expect(result.languageCode, equals('en'));
            expect(result.source, equals(LocaleSource.systemDetected));
          },
        );

        test(
          'should proceed to strategy 2 when saved locale is unsupported',
          () async {
            // Arrange
            const unsupportedLocale = LocaleConfiguration(
              languageCode: 'invalid',
              source: LocaleSource.userSelected,
            );
            mockRepository.currentLocale = unsupportedLocale;
            mockPlatformProvider = TestPlatformLocaleProvider();
            localeDomainService = LocaleDomainService(
              repository: mockRepository,
              platformProvider: mockPlatformProvider,
            );

            // Act
            final result = await localeDomainService
                .resolveLocaleConfiguration();

            // Assert
            expect(mockRepository.getCurrentLocaleCalled, isTrue);
            expect(mockPlatformProvider.getSystemLocaleCalled, isTrue);
            expect(result.languageCode, equals('en'));
            expect(result.source, equals(LocaleSource.systemDetected));
          },
        );
      });

      group('Strategy 2: Detect and validate system locale', () {
        test('should detect and save system locale when supported', () async {
          // Arrange
          mockRepository.currentLocale = null;
          mockPlatformProvider = TestPlatformLocaleProvider(systemLocale: 'vi');
          localeDomainService = LocaleDomainService(
            repository: mockRepository,
            platformProvider: mockPlatformProvider,
          );

          // Act
          final result = await localeDomainService.resolveLocaleConfiguration();

          // Assert
          expect(result.languageCode, equals('vi'));
          expect(result.source, equals(LocaleSource.systemDetected));
          expect(mockRepository.saveLocaleCalled, isTrue);
          expect(mockRepository.lastSavedLocale?.languageCode, equals('vi'));
        });

        test(
          'should proceed to strategy 3 when system locale is unsupported',
          () async {
            // Arrange
            mockRepository.currentLocale = null;
            mockPlatformProvider = TestPlatformLocaleProvider(
              systemLocale: 'invalid',
            );
            localeDomainService = LocaleDomainService(
              repository: mockRepository,
              platformProvider: mockPlatformProvider,
            );

            // Act
            final result = await localeDomainService
                .resolveLocaleConfiguration();

            // Assert
            expect(result.languageCode, equals('vi')); // Default fallback
            expect(result.source, equals(LocaleSource.defaultFallback));
            expect(mockRepository.saveLocaleCalled, isTrue);
          },
        );
      });

      group('Strategy 3: Default fallback', () {
        test('should return default locale when all strategies fail', () async {
          // Arrange
          mockRepository.currentLocale = null;
          mockPlatformProvider = TestPlatformLocaleProvider(
            systemLocale: 'unsupported',
          );
          localeDomainService = LocaleDomainService(
            repository: mockRepository,
            platformProvider: mockPlatformProvider,
          );

          // Act
          final result = await localeDomainService.resolveLocaleConfiguration();

          // Assert
          expect(result.languageCode, equals('vi')); // Default is Vietnamese
          expect(result.source, equals(LocaleSource.defaultFallback));
          expect(mockRepository.saveLocaleCalled, isTrue);
          expect(mockRepository.lastSavedLocale?.languageCode, equals('vi'));
        });
      });

      test('should handle repository errors gracefully', () async {
        // Arrange
        mockRepository = TestLocaleRepository(shouldThrowOnGet: true);
        localeDomainService = LocaleDomainService(
          repository: mockRepository,
          platformProvider: mockPlatformProvider,
        );

        // Act & Assert
        expect(
          () => localeDomainService.resolveLocaleConfiguration(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateUserLocale', () {
      test('should update locale when language code is supported', () async {
        // Arrange
        const languageCode = 'en';

        // Act
        final result = await localeDomainService.updateUserLocale(languageCode);

        // Assert
        expect(result.languageCode, equals(languageCode));
        expect(result.source, equals(LocaleSource.userSelected));
        expect(mockRepository.saveLocaleCalled, isTrue);
        expect(
          mockRepository.lastSavedLocale?.languageCode,
          equals(languageCode),
        );
      });

      test(
        'should throw UnsupportedLocaleException for unsupported locale',
        () async {
          // Arrange
          const unsupportedLanguageCode = 'invalid';

          // Act & Assert
          expect(
            () => localeDomainService.updateUserLocale(unsupportedLanguageCode),
            throwsA(isA<UnsupportedLocaleException>()),
          );
          expect(mockRepository.saveLocaleCalled, isFalse);
        },
      );

      test(
        'should include supported locales list in exception message',
        () async {
          // Arrange
          const unsupportedLanguageCode = 'invalid';

          // Act & Assert
          try {
            await localeDomainService.updateUserLocale(unsupportedLanguageCode);
            fail('Expected UnsupportedLocaleException');
          } on UnsupportedLocaleException catch (e) {
            expect(e, isA<UnsupportedLocaleException>());
            final exception = e;
            expect(exception.message, contains(unsupportedLanguageCode));
            expect(exception.message, contains('Supported locales:'));
            expect(exception.message, contains('en'));
            expect(exception.message, contains('vi'));
          }
        },
      );

      test('should handle repository save errors', () async {
        // Arrange
        mockRepository = TestLocaleRepository(shouldThrowOnSave: true);
        localeDomainService = LocaleDomainService(
          repository: mockRepository,
          platformProvider: mockPlatformProvider,
        );

        // Act & Assert
        expect(
          () => localeDomainService.updateUserLocale('en'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('resetToSystemDefault', () {
      test('should clear saved locale and re-resolve configuration', () async {
        // Arrange
        mockPlatformProvider = TestPlatformLocaleProvider();
        localeDomainService = LocaleDomainService(
          repository: mockRepository,
          platformProvider: mockPlatformProvider,
        );

        // Act
        final result = await localeDomainService.resetToSystemDefault();

        // Assert
        expect(mockRepository.clearSavedLocaleCalled, isTrue);
        expect(result.languageCode, equals('en'));
        expect(result.source, equals(LocaleSource.systemDetected));
      });

      test('should handle repository clear errors', () async {
        // Arrange
        mockRepository = TestLocaleRepository(shouldThrowOnClear: true);
        localeDomainService = LocaleDomainService(
          repository: mockRepository,
          platformProvider: mockPlatformProvider,
        );

        // Act & Assert
        expect(
          () => localeDomainService.resetToSystemDefault(),
          throwsA(isA<Exception>()),
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
