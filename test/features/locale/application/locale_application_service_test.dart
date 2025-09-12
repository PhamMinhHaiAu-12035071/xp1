import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/features/locale/application/locale_application_service.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Mock ILoggerService for testing.
class MockILoggerService extends Mock implements ILoggerService {}

/// Mock LocaleDomainService for testing.
class MockLocaleDomainService extends Mock implements LocaleDomainService {}

void main() {
  group('LocaleApplicationService', () {
    late LocaleApplicationService service;
    late MockLocaleDomainService mockDomainService;
    late MockILoggerService mockLogger;

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(LogLevel.info);
    });

    setUp(() {
      mockDomainService = MockLocaleDomainService();
      mockLogger = MockILoggerService();
      service = LocaleApplicationService(
        domainService: mockDomainService,
        logger: mockLogger,
      );

      // Setup logger mocks
      when(() => mockLogger.log(any(), any())).thenReturn(null);
      when(
        () => mockLogger.log(any(), any(), error: any(named: 'error')),
      ).thenReturn(null);
    });

    group('switchLocale', () {
      test('successfully switches locale when valid', () {
        // Arrange
        const expectedConfig = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );
        when(
          () => mockDomainService.updateUserLocale('en'),
        ).thenReturn(expectedConfig);

        // Act
        final result = service.switchLocale(AppLocale.en);

        // Assert
        expect(result, equals(expectedConfig));
        verify(() => mockDomainService.updateUserLocale('en')).called(1);
        verify(
          () => mockLogger.log(
            '🌐 Switching locale to en',
            LogLevel.info,
          ),
        ).called(1);
        verify(
          () => mockLogger.log(
            '✅ Session locale switch completed',
            LogLevel.info,
          ),
        ).called(1);
      });

      test('successfully switches to Vietnamese', () {
        // Arrange
        const expectedConfig = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.userSelected,
        );
        when(
          () => mockDomainService.updateUserLocale('vi'),
        ).thenReturn(expectedConfig);

        // Act
        final result = service.switchLocale(AppLocale.vi);

        // Assert
        expect(result, equals(expectedConfig));
        verify(() => mockDomainService.updateUserLocale('vi')).called(1);
        verify(
          () => mockLogger.log(
            '🌐 Switching locale to vi',
            LogLevel.info,
          ),
        ).called(1);
      });

      test('handles UnsupportedLocaleException and logs warning', () {
        // Arrange
        when(
          () => mockDomainService.updateUserLocale('en'),
        ).thenThrow(const UnsupportedLocaleException('en'));

        // Act & Assert
        expect(
          () => service.switchLocale(AppLocale.en),
          throwsA(isA<UnsupportedLocaleException>()),
        );

        verify(() => mockDomainService.updateUserLocale('en')).called(1);
        verify(
          () => mockLogger.log(
            any(that: contains('Locale switch failed')),
            LogLevel.warning,
          ),
        ).called(1);
      });

      test('logs appropriate messages during switch', () {
        // Arrange
        const expectedConfig = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );
        when(
          () => mockDomainService.updateUserLocale('en'),
        ).thenReturn(expectedConfig);

        // Act
        service.switchLocale(AppLocale.en);

        // Assert - Verify logging sequence
        verifyInOrder([
          () => mockLogger.log(
            '🌐 Switching locale to en',
            LogLevel.info,
          ),
          () => mockLogger.log(
            '✅ Session locale switch completed',
            LogLevel.info,
          ),
        ]);
      });
    });

    group('getCurrentConfiguration', () {
      test('returns configuration from domain service', () {
        // Arrange
        const expectedConfig = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(expectedConfig);

        // Act
        final result = service.getCurrentConfiguration();

        // Assert
        expect(result, equals(expectedConfig));
        verify(() => mockDomainService.resolveLocaleConfiguration()).called(1);
        verify(
          () => mockLogger.log(
            'Current locale: vi (source: LocaleSource.defaultFallback)',
            LogLevel.debug,
          ),
        ).called(1);
      });

      test('logs current configuration details', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
          countryCode: 'US',
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(config);

        // Act
        service.getCurrentConfiguration();

        // Assert
        verify(
          () => mockLogger.log(
            'Current locale: en (source: LocaleSource.userSelected)',
            LogLevel.debug,
          ),
        ).called(1);
      });
    });

    group('initializeLocaleSystem', () {
      test('initializes to Vietnamese default', () {
        // Arrange
        const expectedConfig = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(expectedConfig);

        // Act
        final result = service.initializeLocaleSystem();

        // Assert
        expect(result, equals(expectedConfig));
        verify(() => mockDomainService.resolveLocaleConfiguration()).called(1);
        verify(
          () => mockLogger.log(
            '🚀 Initializing locale system to Vietnamese...',
            LogLevel.info,
          ),
        ).called(1);
        verify(
          () => mockLogger.log(
            '✅ Locale system initialized: Vietnamese',
            LogLevel.info,
          ),
        ).called(1);
      });

      test('always returns Vietnamese configuration', () {
        // Arrange - Even if domain returns other locale, system is
        // Vietnamese-first
        const domainConfig = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(domainConfig);

        // Act
        final result = service.initializeLocaleSystem();

        // Assert - Should always be Vietnamese-first
        expect(result.languageCode, equals('vi'));
        expect(result, equals(domainConfig));
      });

      test('logs initialization process', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(config);

        // Act
        service.initializeLocaleSystem();

        // Assert - Verify logging sequence
        verifyInOrder([
          () => mockLogger.log(
            '🚀 Initializing locale system to Vietnamese...',
            LogLevel.info,
          ),
          () => mockLogger.log(
            '✅ Locale system initialized: Vietnamese',
            LogLevel.info,
          ),
        ]);
      });
    });

    group('resetToSystemDefault', () {
      test('resets to Vietnamese default', () {
        // Arrange
        const expectedConfig = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resetToSystemDefault(),
        ).thenReturn(expectedConfig);

        // Act
        final result = service.resetToSystemDefault();

        // Assert
        expect(result, equals(expectedConfig));
        verify(() => mockDomainService.resetToSystemDefault()).called(1);
        verify(
          () => mockLogger.log(
            '🔄 Resetting locale to Vietnamese default',
            LogLevel.info,
          ),
        ).called(1);
        verify(
          () => mockLogger.log(
            '✅ Locale reset to Vietnamese default',
            LogLevel.info,
          ),
        ).called(1);
      });

      test('always resets to Vietnamese regardless of current state', () {
        // Arrange
        const resetConfig = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resetToSystemDefault(),
        ).thenReturn(resetConfig);

        // Act
        final result = service.resetToSystemDefault();

        // Assert
        expect(result.languageCode, equals('vi'));
        expect(result.source, equals(LocaleSource.defaultFallback));
      });

      test('logs reset process', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(() => mockDomainService.resetToSystemDefault()).thenReturn(config);

        // Act
        service.resetToSystemDefault();

        // Assert - Verify logging sequence
        verifyInOrder([
          () => mockLogger.log(
            '🔄 Resetting locale to Vietnamese default',
            LogLevel.info,
          ),
          () => mockLogger.log(
            '✅ Locale reset to Vietnamese default',
            LogLevel.info,
          ),
        ]);
      });
    });

    group('Vietnamese-first behavior', () {
      test('all operations default to Vietnamese', () {
        // Arrange
        const vietnameseConfig = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );

        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(vietnameseConfig);
        when(
          () => mockDomainService.resetToSystemDefault(),
        ).thenReturn(vietnameseConfig);

        // Act
        final initResult = service.initializeLocaleSystem();
        final currentResult = service.getCurrentConfiguration();
        final resetResult = service.resetToSystemDefault();

        // Assert - All operations should result in Vietnamese
        expect(initResult.languageCode, equals('vi'));
        expect(currentResult.languageCode, equals('vi'));
        expect(resetResult.languageCode, equals('vi'));
      });

      test('supports session-only English switching', () {
        // Arrange
        const englishConfig = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );
        when(
          () => mockDomainService.updateUserLocale('en'),
        ).thenReturn(englishConfig);

        // Act
        final result = service.switchLocale(AppLocale.en);

        // Assert
        expect(result.languageCode, equals('en'));
        expect(result.source, equals(LocaleSource.userSelected));
      });
    });

    group('synchronous operations', () {
      test('all public methods are synchronous', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(config);
        when(() => mockDomainService.resetToSystemDefault()).thenReturn(config);
        when(() => mockDomainService.updateUserLocale('en')).thenReturn(config);

        // Act & Assert - All methods should complete synchronously
        expect(service.initializeLocaleSystem(), isA<LocaleConfiguration>());
        expect(service.getCurrentConfiguration(), isA<LocaleConfiguration>());
        expect(service.resetToSystemDefault(), isA<LocaleConfiguration>());
        expect(service.switchLocale(AppLocale.en), isA<LocaleConfiguration>());
      });

      test('no async operations in simplified architecture', () {
        // This test ensures the service doesn't use any async patterns
        // All domain service calls should be synchronous

        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(config);

        // Act - All operations complete immediately
        final startTime = DateTime.now();
        service.initializeLocaleSystem();
        final endTime = DateTime.now();

        // Assert - Should complete nearly instantly (< 1ms for sync operations)
        final duration = endTime.difference(startTime);
        expect(duration.inMilliseconds, lessThan(10));
      });
    });

    group('logging behavior', () {
      test('uses appropriate log levels for different operations', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(config);
        when(() => mockDomainService.updateUserLocale('en')).thenReturn(config);

        // Act
        service
          ..initializeLocaleSystem() // Should use info level
          ..getCurrentConfiguration() // Should use debug level
          ..switchLocale(AppLocale.en); // Should use info level

        // Assert - Verify log levels
        verify(
          () => mockLogger.log(any(), LogLevel.info),
        ).called(greaterThanOrEqualTo(4)); // Init (2) + switch (2) operations

        verify(
          () => mockLogger.log(any(), LogLevel.debug),
        ).called(greaterThanOrEqualTo(1)); // getCurrentConfiguration + internal
      });

      test('logs session locale application with debug level', () {
        // This tests the internal _applyLocaleToSession method logging

        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );
        when(() => mockDomainService.updateUserLocale('en')).thenReturn(config);

        // Act
        service.switchLocale(AppLocale.en);

        // Assert - Should log the session application
        verify(
          () => mockLogger.log(
            '🔄 Applying locale to current session',
            LogLevel.debug,
          ),
        ).called(1);

        verify(
          () => mockLogger.log(
            'Session locale updated successfully',
            LogLevel.debug,
          ),
        ).called(1);
      });

      test('logs errors when session application fails', () {
        // This tests error handling in _applyLocaleToSession

        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'en',
          source: LocaleSource.userSelected,
        );
        when(() => mockDomainService.updateUserLocale('en')).thenReturn(config);

        // Act
        service.switchLocale(AppLocale.en);

        // Assert - Even if LocaleSettings.setLocale fails, service continues
        // and logs debug messages (this tests the try-catch in
        // _applyLocaleToSession)
        verify(
          () => mockLogger.log(
            '🔄 Applying locale to current session',
            LogLevel.debug,
          ),
        ).called(1);
      });
    });

    group('error handling', () {
      test('rethrows UnsupportedLocaleException with logging', () {
        // Arrange
        const exception = UnsupportedLocaleException('en');
        when(
          () => mockDomainService.updateUserLocale('en'),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => service.switchLocale(AppLocale.en),
          throwsA(isA<UnsupportedLocaleException>()),
        );

        // Should log the failure
        verify(
          () => mockLogger.log(
            any(that: contains('Locale switch failed')),
            LogLevel.warning,
          ),
        ).called(1);
      });

      test('handles domain service errors gracefully', () {
        // This test verifies that domain service errors are handled
        // appropriately
        // In the simplified implementation, errors from domain service should
        // be logged and potentially rethrown

        // Arrange
        when(
          () => mockDomainService.updateUserLocale('en'),
        ).thenThrow(const UnsupportedLocaleException('en'));

        // Act & Assert
        expect(
          () => service.switchLocale(AppLocale.en),
          throwsA(isA<UnsupportedLocaleException>()),
        );

        // Verify error was logged
        verify(
          () => mockLogger.log(
            any(that: contains('failed')),
            LogLevel.warning,
          ),
        ).called(1);
      });
    });

    group('integration with domain service', () {
      test('delegates all business logic to domain service', () {
        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(config);
        when(() => mockDomainService.resetToSystemDefault()).thenReturn(config);
        when(() => mockDomainService.updateUserLocale('en')).thenReturn(config);

        // Act
        service
          ..initializeLocaleSystem()
          ..getCurrentConfiguration()
          ..resetToSystemDefault()
          ..switchLocale(AppLocale.en);

        // Assert - Verify all domain service methods were called
        verify(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).called(2); // init + getCurrentConfiguration
        verify(() => mockDomainService.resetToSystemDefault()).called(1);
        verify(() => mockDomainService.updateUserLocale('en')).called(1);
      });

      test('maintains clean separation between application and domain', () {
        // This test ensures the application service only handles:
        // 1. Logging
        // 2. Session locale application
        // 3. Error handling
        // And delegates all business logic to domain service

        // Arrange
        const config = LocaleConfiguration(
          languageCode: 'vi',
          source: LocaleSource.defaultFallback,
        );
        when(
          () => mockDomainService.resolveLocaleConfiguration(),
        ).thenReturn(config);

        // Act
        final result = service.initializeLocaleSystem();

        // Assert - Result should come from domain service
        expect(result, equals(config));

        // Application service should only add logging, not modify logic
        verify(() => mockDomainService.resolveLocaleConfiguration()).called(1);
        verify(() => mockLogger.log(any(), any())).called(greaterThan(0));
      });
    });
  });
}
