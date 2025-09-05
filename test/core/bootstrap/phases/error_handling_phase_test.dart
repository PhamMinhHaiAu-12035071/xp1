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
    // Các phương thức void cần stub thenReturn(null) để tránh TypeError
    when(() => logger.info(any())).thenReturn(null);
    when(
      () => logger.error(any(), any<dynamic>(), any<StackTrace?>()),
    ).thenReturn(null);

    phase = ErrorHandlingPhase(logger: logger);
    originalOnError = FlutterError.onError; // lưu lại handler hiện tại
  });

  tearDown(() {
    // Khôi phục handler ban đầu để không ảnh hưởng test khác
    FlutterError.onError = originalOnError;
    reset(logger);
  });

  test('properties và validatePreconditions hoạt động bình thường', () async {
    expect(phase.phaseName, 'Error Handling');
    expect(phase.priority, 2);
    expect(phase.canSkip, false);
    // không ném lỗi vì check dùng identical(_logger, _logger)
    await phase.validatePreconditions();
  });

  test('execute: thiết lập onError và ghi log info, trả về success', () async {
    final result = await phase.execute();

    // onError đã được cấu hình
    expect(FlutterError.onError, isNotNull);
    // Kết quả thành công theo contract
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
  });

  test(
    'execute: handler của FlutterError ghi logger.error khi có lỗi Flutter',
    () async {
      await phase.execute();

      final details = FlutterErrorDetails(
        exception: Exception('boom'),
        stack: StackTrace.current,
        library: 'test',
        context: ErrorDescription('trigger'),
      );

      // Gọi handler đã set
      FlutterError.onError!.call(details);

      // Verify logger.error được gọi với message và tham số phù hợp
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
    'execute: nếu xảy ra Exception (ví dụ logger.info ném), '
    'phải bọc thành BootstrapException',
    () async {
      // Làm cho lần gọi info đầu tiên ném lỗi để nhảy vào catch
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

  test('rollback: bình thường reset onError về null và ghi log info', () async {
    // Setup trước: đặt một handler bất kỳ
    FlutterError.onError = (details) {};
    await phase.rollback();

    expect(FlutterError.onError, isNull);
    verify(() => logger.info('🔄 Rolling back error handling...')).called(1);
    verify(() => logger.info('✅ Error handling rollback completed')).called(1);
  });

  test(
    'rollback: nếu logger.info ném lỗi, không được throw ra ngoài '
    'và phải logger.error',
    () async {
      // Lần gọi info đầu trong rollback ném lỗi để vào catch
      when(() => logger.info(any())).thenThrow(Exception('io-failed'));

      // Không được ném ra ngoài
      await expectLater(() => phase.rollback(), returnsNormally);

      // Phải ghi error
      verify(
        () => logger.error('Failed to rollback error handling', any<dynamic>()),
      ).called(1);
    },
  );
}
