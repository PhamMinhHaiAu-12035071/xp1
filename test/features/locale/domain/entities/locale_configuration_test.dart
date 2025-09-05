import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';

void main() {
  group('LocaleConfiguration', () {
    group('factory constructors', () {
      test('should create configuration with all parameters', () {
        // Arrange & Act
        const configuration = LocaleConfiguration(
          languageCode: 'en',
          countryCode: 'US',
          source: LocaleSource.userSelected,
        );

        // Assert
        expect(configuration.languageCode, equals('en'));
        expect(configuration.countryCode, equals('US'));
        expect(configuration.source, equals(LocaleSource.userSelected));
      });

      test('should create configuration without country code', () {
        // Arrange & Act
        const configuration = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );

        // Assert
        expect(configuration.languageCode, equals('vi'));
        expect(configuration.countryCode, isNull);
        expect(configuration.source, equals(LocaleSource.defaultFallback));
      });

      test('should create configuration from JSON with all fields', () {
        // Arrange
        final json = {
          'languageCode': 'fr',
          'countryCode': 'FR',
          'source': 'systemDetected',
        };

        // Act
        final configuration = LocaleConfiguration.fromJson(json);

        // Assert
        expect(configuration.languageCode, equals('fr'));
        expect(configuration.countryCode, equals('FR'));
        expect(configuration.source, equals(LocaleSource.systemDetected));
      });

      test('should create configuration from JSON without country code', () {
        // Arrange
        final json = {
          'languageCode': 'en',
          'source': 'userSelected',
        };

        // Act
        final configuration = LocaleConfiguration.fromJson(json);

        // Assert
        expect(configuration.languageCode, equals('en'));
        expect(configuration.countryCode, isNull);
        expect(configuration.source, equals(LocaleSource.userSelected));
      });
    });

    group('equality and hashCode', () {
      test('should be equal when all properties match', () {
        // Arrange
        const config1 = LocaleConfiguration(
          languageCode: 'en',
          countryCode: 'US',
          source: LocaleSource.userSelected,
        );
        const config2 = LocaleConfiguration(
          languageCode: 'en',
          countryCode: 'US',
          source: LocaleSource.userSelected,
        );

        // Assert
        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('should not be equal when language codes differ', () {
        // Arrange
        const config1 = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );
        const config2 = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.userSelected,
        );

        // Assert
        expect(config1, isNot(equals(config2)));
      });

      test('should not be equal when sources differ', () {
        // Arrange
        const config1 = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );
        const config2 = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.systemDetected,
        );

        // Assert
        expect(config1, isNot(equals(config2)));
      });
    });

    group('copyWith', () {
      test('should create copy with updated language code', () {
        // Arrange
        const original = LocaleConfiguration(
          languageCode: 'en',
          countryCode: 'US',
          source: LocaleSource.userSelected,
        );

        // Act
        final copied = original.copyWith(languageCode: 'vi');

        // Assert
        expect(copied.languageCode, equals('vi'));
        expect(copied.countryCode, equals('US')); // Unchanged
        expect(copied.source, equals(LocaleSource.userSelected)); // Unchanged
      });

      test('should create copy with updated source', () {
        // Arrange
        const original = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );

        // Act
        final copied = original.copyWith(source: LocaleSource.systemDetected);

        // Assert
        expect(copied.languageCode, equals('en')); // Unchanged
        expect(copied.source, equals(LocaleSource.systemDetected));
      });
    });
  });

  group('LocaleConfigurationExtension', () {
    group('factory methods', () {
      test('userSelected should create user selected configuration', () {
        // Act
        final config = LocaleConfigurationExtension.userSelected('en');

        // Assert
        expect(config.languageCode, equals('en'));
        expect(config.source, equals(LocaleSource.userSelected));
        expect(config.countryCode, isNull);
      });

      test('systemDetected should create system detected configuration', () {
        // Act
        final config = LocaleConfigurationExtension.systemDetected('fr', 'FR');

        // Assert
        expect(config.languageCode, equals('fr'));
        expect(config.countryCode, equals('FR'));
        expect(config.source, equals(LocaleSource.systemDetected));
      });

      test(
        'systemDetected should create configuration without country code',
        () {
          // Act
          final config = LocaleConfigurationExtension.systemDetected('es');

          // Assert
          expect(config.languageCode, equals('es'));
          expect(config.countryCode, isNull);
          expect(config.source, equals(LocaleSource.systemDetected));
        },
      );

      test('defaultFallback should create default fallback configuration', () {
        // Act
        final config = LocaleConfigurationExtension.defaultFallback();

        // Assert
        expect(config.languageCode, equals('vi'));
        expect(config.source, equals(LocaleSource.defaultFallback));
        expect(config.countryCode, isNull);
      });
    });

    group('fullLocaleId', () {
      test('should return language code when country code is null', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );

        // Act
        final localeId = config.fullLocaleId;

        // Assert
        expect(localeId, equals('en'));
      });

      test('should return language_country when country code is present', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'en',
          countryCode: 'US',
          source: LocaleSource.systemDetected,
        );

        // Act
        final localeId = config.fullLocaleId;

        // Assert
        expect(localeId, equals('en_US'));
      });
    });

    group('source type checking', () {
      test('isUserSelected should return true for user selected source', () {
        // Arrange
        final config = LocaleConfigurationExtension.userSelected('en');

        // Assert
        expect(config.isUserSelected, isTrue);
        expect(config.isSystemDetected, isFalse);
        expect(config.isDefaultFallback, isFalse);
      });

      test(
        'isSystemDetected should return true for system detected source',
        () {
          // Arrange
          final config = LocaleConfigurationExtension.systemDetected('fr');

          // Assert
          expect(config.isUserSelected, isFalse);
          expect(config.isSystemDetected, isTrue);
          expect(config.isDefaultFallback, isFalse);
        },
      );

      test(
        'isDefaultFallback should return true for default fallback source',
        () {
          // Arrange
          final config = LocaleConfigurationExtension.defaultFallback();

          // Assert
          expect(config.isUserSelected, isFalse);
          expect(config.isSystemDetected, isFalse);
          expect(config.isDefaultFallback, isTrue);
        },
      );
    });
  });

  group('LocaleSource enum', () {
    test('should have correct enum values', () {
      // Assert
      expect(LocaleSource.values, hasLength(3));
      expect(LocaleSource.values, contains(LocaleSource.userSelected));
      expect(LocaleSource.values, contains(LocaleSource.systemDetected));
      expect(LocaleSource.values, contains(LocaleSource.defaultFallback));
    });

    test('should have correct string representation', () {
      // Assert
      expect(
        LocaleSource.userSelected.toString(),
        equals('LocaleSource.userSelected'),
      );
      expect(
        LocaleSource.systemDetected.toString(),
        equals('LocaleSource.systemDetected'),
      );
      expect(
        LocaleSource.defaultFallback.toString(),
        equals('LocaleSource.defaultFallback'),
      );
    });
  });
}
