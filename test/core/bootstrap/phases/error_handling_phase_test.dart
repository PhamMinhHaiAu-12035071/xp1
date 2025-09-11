import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/bootstrap/phases/error_handling_phase.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// Mock for LoggerService using mocktail.
class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late ErrorHandlingPhase phase;
  late MockLoggerService logger;
  void Function(FlutterErrorDetails)? originalOnError;

  setUp(() {
    logger = MockLoggerService();
    // Void methods need stub thenReturn(null) to avoid TypeError
    when(() => logger.info(any())).thenReturn(null);
    when(
      () => logger.error(any(), any<dynamic>(), any<StackTrace?>()),
    ).thenReturn(null);

    phase = ErrorHandlingPhase(logger: logger);
    originalOnError = FlutterError.onError; // save current handler
  });

  tearDown(() {
    // Restore original handler to not affect other tests
    FlutterError.onError = originalOnError;
    reset(logger);
  });

  test('properties and validatePreconditions work correctly', () async {
    expect(phase.phaseName, 'Error Handling');
    expect(phase.priority, 2);
    expect(phase.canSkip, false);
    // no exception thrown because check uses identical(_logger, _logger)
    await phase.validatePreconditions();
  });

  test(
    'execute: sets up onError handler and logs info, returns success',
    () async {
      final result = await phase.execute();

      // onError has been configured
      expect(FlutterError.onError, isNotNull);
      // Successful result according to contract
      expect(result.success, isTrue);
      expect(result.data['error_handler'], 'configured');
      expect(result.message, 'Global error handling is active');

      // Verify logger
      verify(
        () => logger.info('⚡ Configuring global error handling...'),
      ).called(1);
      verify(
        () => logger.info('✅ Error handling configured successfully'),
      ).called(1);
      verifyNoMoreInteractions(logger);
    },
  );

  test(
    'execute: FlutterError handler logs error when Flutter error occurs',
    () async {
      await phase.execute();

      final details = FlutterErrorDetails(
        exception: Exception('boom'),
        stack: StackTrace.current,
        library: 'test',
        context: ErrorDescription('trigger'),
      );

      // Call the set handler
      FlutterError.onError!.call(details);

      // Verify logger.error is called with appropriate message and parameters
      verify(
        () => logger.error(
          any(that: contains('Flutter Error: Exception: boom')),
          any(that: isA<Exception>()),
          any(that: isA<StackTrace>()),
        ),
      ).called(1);
    },
  );

  test(
    'execute: when Exception occurs (e.g. logger.info throws), '
    'must wrap as BootstrapException',
    () async {
      // Make first info call throw error to jump into catch
      when(() => logger.info(any())).thenThrow(Exception('io-failed'));

      expect(
        () => phase.execute(),
        throwsA(
          isA<BootstrapException>()
              .having(
                (e) => e.message,
                'message',
                'Failed to configure error handling',
              )
              .having((e) => e.phase, 'phase', 'Error Handling')
              .having((e) => e.canRetry, 'canRetry', true)
              .having(
                (e) => e.originalError,
                'originalError',
                isA<Exception>(),
              ),
        ),
      );
    },
  );

  test('rollback: normally resets onError to null and logs info', () async {
    // Setup first: set any handler
    FlutterError.onError = (details) {};
    await phase.rollback();

    expect(FlutterError.onError, isNull);
    verify(() => logger.info('🔄 Rolling back error handling...')).called(1);
    verify(() => logger.info('✅ Error handling rollback completed')).called(1);
  });

  test(
    'rollback: when logger.info throws error, must not throw outside '
    'and must call logger.error',
    () async {
      // First info call in rollback throws error to enter catch
      when(() => logger.info(any())).thenThrow(Exception('io-failed'));

      // Must not throw outside
      await expectLater(() => phase.rollback(), returnsNormally);

      // Must log error
      verify(
        () => logger.error('Failed to rollback error handling', any<dynamic>()),
      ).called(1);
    },
  );
}
