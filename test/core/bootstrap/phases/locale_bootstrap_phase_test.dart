import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/bootstrap/phases/locale_bootstrap_phase.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/features/locale/application/locale_application_service.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';

/// Mock for LoggerService using mocktail.
class MockLoggerService extends Mock implements LoggerService {}

/// Mock for LocaleApplicationService using mocktail.
class MockLocaleApplicationService extends Mock
    implements LocaleApplicationService {}

void main() {
  late LocaleBootstrapPhase phase;
  late MockLoggerService logger;
  late MockLocaleApplicationService localeService;

  setUp(() {
    logger = MockLoggerService();
    localeService = MockLocaleApplicationService();

    // Setup logger stubs
    when(() => logger.info(any())).thenReturn(null);
    when(
      () => logger.error(any(), any<dynamic>(), any<StackTrace?>()),
    ).thenReturn(null);
    when(() => logger.warning(any())).thenReturn(null);

    // Setup locale service stubs for Vietnamese default
    when(() => localeService.initializeLocaleSystem()).thenReturn(
      const LocaleConfiguration(
        languageCode: 'vi',
        source: LocaleSource.defaultFallback,
      ),
    );
    when(() => localeService.resetToSystemDefault()).thenReturn(
      const LocaleConfiguration(
        languageCode: 'vi',
        source: LocaleSource.defaultFallback,
      ),
    );

    phase = LocaleBootstrapPhase(logger: logger);

    // Reset DI container
    getIt.reset();
  });

  tearDown(() {
    reset(logger);
    reset(localeService);
    getIt.reset();
  });

  group('LocaleBootstrapPhase Properties', () {
    test('should have correct phase properties', () {
      expect(phase.phaseName, 'Locale System');
      expect(phase.priority, 3);
      expect(phase.canSkip, false);
    });
  });

  group('validatePreconditions', () {
    test('should pass when LocaleApplicationService is registered', () async {
      // Register the service in DI container
      getIt.registerSingleton<LocaleApplicationService>(localeService);

      // Should not throw
      await phase.validatePreconditions();
    });

    test(
      'should pass when service not registered (validation moved to execute)',
      () async {
        // Don't register the service - validatePreconditions should not throw
        // since validation is now done in execute() method

        // Should not throw - validation moved to execute()
        await phase.validatePreconditions();
      },
    );
  });

  group('execute', () {
    setUp(() {
      // Register the service in DI container for all execute tests
      getIt.registerSingleton<LocaleApplicationService>(localeService);
    });

    test('should successfully initialize Vietnamese locale system', () async {
      // Arrange
      const expectedConfig = LocaleConfiguration(
        languageCode: 'vi',
        source: LocaleSource.defaultFallback,
      );

      when(
        () => localeService.initializeLocaleSystem(),
      ).thenReturn(expectedConfig);

      // Act
      final result = await phase.execute();

      // Assert - Vietnamese-first implementation
      expect(result.success, isTrue);
      expect(result.data['locale_configuration'], expectedConfig);
      expect(result.data['language_code'], 'vi');
      expect(result.data['locale_source'], 'defaultFallback');
      expect(result.data['full_locale_id'], 'vi_VN');
      expect(result.message, 'Vietnamese locale system initialized');

      // Verify service call
      verify(() => localeService.initializeLocaleSystem()).called(1);
    });

    test('should always return Vietnamese configuration', () async {
      // Arrange - Vietnamese default configuration
      const expectedConfig = LocaleConfiguration(
        languageCode: 'vi',
        source: LocaleSource.defaultFallback,
      );

      when(
        () => localeService.initializeLocaleSystem(),
      ).thenReturn(expectedConfig);

      // Act
      final result = await phase.execute();

      // Assert - Always Vietnamese in simplified system
      expect(result.success, isTrue);
      expect(result.data['locale_configuration'], expectedConfig);
      expect(result.data['language_code'], 'vi');
      expect(result.data['locale_source'], 'defaultFallback');
      expect(result.data['full_locale_id'], 'vi_VN');
      expect(result.message, 'Vietnamese locale system initialized');

      // Verify service call
      verify(() => localeService.initializeLocaleSystem()).called(1);
    });

    test('should handle Vietnamese default fallback locale', () async {
      // Arrange
      const expectedConfig = LocaleConfiguration(
        languageCode: 'vi',
        source: LocaleSource.defaultFallback,
      );

      when(
        () => localeService.initializeLocaleSystem(),
      ).thenReturn(expectedConfig);

      // Act
      final result = await phase.execute();

      // Assert
      expect(result.success, isTrue);
      expect(result.data['locale_configuration'], expectedConfig);
      expect(result.data['language_code'], 'vi');
      expect(result.data['locale_source'], 'defaultFallback');
      expect(result.message, 'Vietnamese locale system initialized');
    });

    test(
      'should throw BootstrapException when service throws exception',
      () async {
        // Arrange
        when(
          () => localeService.initializeLocaleSystem(),
        ).thenThrow(Exception('Service initialization failed'));

        // Act & Assert
        expect(
          () => phase.execute(),
          throwsA(
            isA<BootstrapException>()
                .having(
                  (e) => e.message,
                  'message',
                  'Failed to initialize Vietnamese locale system',
                )
                .having((e) => e.phase, 'phase', 'Locale System')
                .having((e) => e.canRetry, 'canRetry', true),
          ),
        );

        // Verify service call was attempted
        verify(() => localeService.initializeLocaleSystem()).called(1);
      },
    );

    test('should re-throw BootstrapException from service', () async {
      // Arrange
      const bootstrapException = BootstrapException(
        'Locale service bootstrap error',
        phase: 'Locale System',
      );

      when(
        () => localeService.initializeLocaleSystem(),
      ).thenThrow(bootstrapException);

      // Act & Assert
      expect(
        () => phase.execute(),
        throwsA(
          isA<BootstrapException>()
              .having(
                (e) => e.message,
                'message',
                'Locale service bootstrap error',
              )
              .having((e) => e.phase, 'phase', 'Locale System'),
        ),
      );
    });

    test('should throw BootstrapException when LocaleApplicationService not '
        'registered', () async {
      // Arrange - don't register the service to trigger the validation error
      await getIt.reset();

      // Act & Assert - should throw BootstrapException (covers lines 46-49)
      expect(
        () => phase.execute(),
        throwsA(
          isA<BootstrapException>()
              .having(
                (e) => e.message,
                'message',
                'LocaleApplicationService not registered in DI container',
              )
              .having((e) => e.phase, 'phase', 'Locale System'),
        ),
      );

      // Verify logger was called before the exception
      verify(
        () => logger.info('🌐 Initializing Vietnamese locale system...'),
      ).called(1);
    });
  });

  group('rollback', () {
    setUp(() {
      // Register the service in DI container for rollback tests
      getIt.registerSingleton<LocaleApplicationService>(localeService);
    });

    test('should successfully rollback to Vietnamese locale', () async {
      // Arrange
      const expectedConfig = LocaleConfiguration(
        languageCode: 'vi',
        source: LocaleSource.defaultFallback,
      );

      when(
        () => localeService.resetToSystemDefault(),
      ).thenReturn(expectedConfig);

      // Act
      await phase.rollback();

      // Assert - Vietnamese-specific messages
      verify(
        () => logger.info('🔄 Rolling back to Vietnamese locale...'),
      ).called(1);
      verify(
        () => logger.info('✅ Vietnamese locale rollback completed'),
      ).called(1);
      verify(() => localeService.resetToSystemDefault()).called(1);
      verifyNoMoreInteractions(logger);
    });

    test('should handle rollback failure gracefully', () async {
      // Arrange
      when(
        () => localeService.resetToSystemDefault(),
      ).thenThrow(Exception('Rollback failed'));

      // Act - should not throw
      await phase.rollback();

      // Assert - Vietnamese-specific logging
      verify(
        () => logger.info('🔄 Rolling back to Vietnamese locale...'),
      ).called(1);
      // Verify service call was attempted
      verify(() => localeService.resetToSystemDefault()).called(1);
    });

    test('should handle missing service gracefully', () async {
      // Arrange - don't register the service
      await getIt.reset();

      // Act - should not throw
      await phase.rollback();

      // Assert - Vietnamese-specific messages
      verify(
        () => logger.info('🔄 Rolling back to Vietnamese locale...'),
      ).called(1);
      verify(
        () => logger.info('✅ Vietnamese locale rollback completed'),
      ).called(1);
      // Should not call the service since it's not registered
    });
  });

  group('Integration with DI Container', () {
    test('should work with real DI container registration', () async {
      // Arrange - register service with a real implementation
      getIt.registerSingleton<LocaleApplicationService>(localeService);

      const expectedConfig = LocaleConfiguration(
        languageCode: 'vi',
        source: LocaleSource.defaultFallback,
      );

      when(
        () => localeService.initializeLocaleSystem(),
      ).thenReturn(expectedConfig);

      // Act
      final result = await phase.execute();

      // Assert - Vietnamese locale system
      expect(result.success, isTrue);
      expect(result.data['locale_configuration'], expectedConfig);

      // Verify the service was retrieved from DI container
      verify(() => localeService.initializeLocaleSystem()).called(1);
    });
  });
}
