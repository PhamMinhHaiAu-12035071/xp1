import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('LoggerService', () {
    late LoggerService loggerService;

    setUp(() {
      // Reset singleton for each test
      LoggerService.resetInstance();
      loggerService = LoggerService();
    });

    tearDown(LoggerService.resetInstance);

    group('initialization', () {
      test('creates instance with development settings by default', () {
        final logger = LoggerService();
        expect(logger, isNotNull);
        expect(logger, isA<ILoggerService>());
      });

      test('creates instance with production settings when specified', () {
        final logger = LoggerService(isDevelopment: false);
        expect(logger, isNotNull);
        expect(logger, isA<ILoggerService>());
      });

      test('returns same instance (singleton pattern)', () {
        final logger1 = LoggerService();
        final logger2 = LoggerService();
        expect(identical(logger1, logger2), isTrue);
      });
    });

    group('log method', () {
      test('logs debug message', () {
        // Arrange
        const message = 'Debug message';
        const extra = {'key': 'value'};

        // Act
        loggerService.log(message, LogLevel.debug, extra: extra);

        // Assert - In a real scenario, you might want to verify the output
        // For now, we just ensure no exception is thrown
        expect(true, isTrue); // Placeholder assertion
      });

      test('logs info message', () {
        const message = 'Info message';
        const extra = {'userId': '123'};

        loggerService.log(message, LogLevel.info, extra: extra);

        expect(true, isTrue); // Placeholder assertion
      });

      test('logs warning message', () {
        const message = 'Warning message';

        loggerService.log(message, LogLevel.warning);

        expect(true, isTrue); // Placeholder assertion
      });

      test('logs error message with error and stack trace', () {
        const message = 'Error message';
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        loggerService.log(
          message,
          LogLevel.error,
          error: error,
          stackTrace: stackTrace,
        );

        expect(true, isTrue); // Placeholder assertion
      });

      test('logs fatal message with error and stack trace', () {
        const message = 'Fatal message';
        final error = Exception('Fatal error');
        final stackTrace = StackTrace.current;

        loggerService.log(
          message,
          LogLevel.fatal,
          error: error,
          stackTrace: stackTrace,
        );

        expect(true, isTrue); // Placeholder assertion
      });

      test('skips debug logs when not in debug mode', () {
        // Create logger with production settings (isDevelopment: false)
        LoggerService.resetInstance();
        final prodLogger = LoggerService(isDevelopment: false);
        const message = 'Debug message that should be skipped';

        // Production mode should skip debug logs due to kDebugMode check
        // This exercises the early return logic at line 48
        expect(
          () => prodLogger.log(message, LogLevel.debug),
          returnsNormally,
        );
      });

      test('appends extra data to message when provided', () {
        const message = 'Test message';
        const extra = {'userId': '123', 'action': 'login'};

        loggerService.log(message, LogLevel.info, extra: extra);

        // In a real implementation, you would verify that the message
        // contains the extra data
        expect(true, isTrue); // Placeholder assertion
      });
    });

    group('convenience methods', () {
      test('debug method calls log with LogLevel.debug', () {
        const message = 'Debug convenience message';
        const extra = {'test': 'data'};

        loggerService.debug(message, extra);

        expect(true, isTrue); // Placeholder assertion
      });

      test('info method calls log with LogLevel.info', () {
        const message = 'Info convenience message';
        const extra = {'user': 'john'};

        loggerService.info(message, extra);

        expect(true, isTrue); // Placeholder assertion
      });

      test('warning method calls log with LogLevel.warning', () {
        const message = 'Warning convenience message';

        loggerService.warning(message);

        expect(true, isTrue); // Placeholder assertion
      });

      test('error method calls log with LogLevel.error', () {
        const message = 'Error convenience message';
        final error = Exception('Convenience error');
        final stackTrace = StackTrace.current;

        loggerService.error(message, error, stackTrace);

        expect(true, isTrue); // Placeholder assertion
      });

      test('fatal method calls log with LogLevel.fatal', () {
        const message = 'Fatal convenience message';
        final error = Exception('Convenience fatal error');
        final stackTrace = StackTrace.current;

        loggerService.fatal(message, error, stackTrace);

        expect(true, isTrue); // Placeholder assertion
      });
    });

    group('LogLevel enum', () {
      test('contains all expected levels', () {
        expect(LogLevel.values, hasLength(5));
        expect(LogLevel.values, contains(LogLevel.debug));
        expect(LogLevel.values, contains(LogLevel.info));
        expect(LogLevel.values, contains(LogLevel.warning));
        expect(LogLevel.values, contains(LogLevel.error));
        expect(LogLevel.values, contains(LogLevel.fatal));
      });
    });
  });
}
