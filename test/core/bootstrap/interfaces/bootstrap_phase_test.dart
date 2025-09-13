import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';

/// Default implementation of BootstrapPhase for testing default methods.
class DefaultBootstrapPhase extends BootstrapPhase {
  DefaultBootstrapPhase({required this.phaseName, required this.priority});

  @override
  final String phaseName;

  @override
  final int priority;

  @override
  Future<BootstrapResult> execute() async {
    return const BootstrapResult.success(message: 'Default phase executed');
  }
}

/// Mock implementation of BootstrapPhase for testing.
class MockBootstrapPhase implements BootstrapPhase {
  MockBootstrapPhase({
    required this.phaseName,
    required this.priority,
    this.canSkip = false,
    this.shouldThrow = false,
    this.resultData = const <String, dynamic>{},
    this.resultMessage,
  });

  @override
  final String phaseName;

  @override
  final int priority;

  @override
  final bool canSkip;

  final bool shouldThrow;
  final Map<String, dynamic> resultData;
  final String? resultMessage;

  bool validatePreconditionsWasCalled = false;
  bool executeWasCalled = false;
  bool rollbackWasCalled = false;

  @override
  Future<void> validatePreconditions() async {
    validatePreconditionsWasCalled = true;
    if (shouldThrow) {
      throw Exception('Precondition validation failed');
    }
  }

  @override
  Future<BootstrapResult> execute() async {
    executeWasCalled = true;
    if (shouldThrow) {
      throw Exception('Phase execution failed');
    }
    return BootstrapResult.success(data: resultData, message: resultMessage);
  }

  @override
  Future<void> rollback() async {
    rollbackWasCalled = true;
    if (shouldThrow) {
      throw Exception('Rollback failed');
    }
  }
}

void main() {
  group('BootstrapResult', () {
    group('constructor', () {
      test('should create result with required success field', () {
        const result = BootstrapResult(success: true);

        expect(result.success, isTrue);
        expect(result.data, isEmpty);
        expect(result.message, isNull);
      });

      test('should create result with all parameters', () {
        const data = {'key': 'value'};
        const message = 'Test message';
        const result = BootstrapResult(
          success: false,
          data: data,
          message: message,
        );

        expect(result.success, isFalse);
        expect(result.data, equals(data));
        expect(result.message, equals(message));
      });
    });

    group('factory constructors', () {
      test('success() should create successful result', () {
        const result = BootstrapResult.success();

        expect(result.success, isTrue);
        expect(result.data, isEmpty);
        expect(result.message, isNull);
      });

      test('success() should accept optional data and message', () {
        const data = {'status': 'complete'};
        const message = 'Phase completed';
        const result = BootstrapResult.success(data: data, message: message);

        expect(result.success, isTrue);
        expect(result.data, equals(data));
        expect(result.message, equals(message));
      });

      test('failure() should create failed result with message', () {
        const message = 'Operation failed';
        const result = BootstrapResult.failure(message);

        expect(result.success, isFalse);
        expect(result.data, isEmpty);
        expect(result.message, equals(message));
      });
    });

    group('data access methods', () {
      test('getData should return typed data when key exists', () {
        const result = BootstrapResult.success(
          data: {'count': 42, 'name': 'test'},
        );

        expect(result.getData<int>('count'), equals(42));
        expect(result.getData<String>('name'), equals('test'));
      });

      test('getData should return null when key does not exist', () {
        const result = BootstrapResult.success();

        expect(result.getData<String>('missing'), isNull);
      });

      test('getRequiredData should return typed data when key exists', () {
        const result = BootstrapResult.success(data: {'value': 'required'});

        expect(result.getRequiredData<String>('value'), equals('required'));
      });

      test('getRequiredData should throw when key does not exist', () {
        const result = BootstrapResult.success();

        expect(
          () => result.getRequiredData<String>('missing'),
          throwsA(isA<BootstrapException>()),
        );
      });

      test('getRequiredData should throw with descriptive message', () {
        const result = BootstrapResult.success();

        expect(
          () => result.getRequiredData<String>('missing'),
          throwsA(
            predicate<BootstrapException>(
              (e) => e.message.contains('Required data "missing" not found'),
            ),
          ),
        );
      });
    });
  });

  group('BootstrapException', () {
    group('constructor', () {
      test('should create exception with message only', () {
        const message = 'Test error';
        const exception = BootstrapException(message);

        expect(exception.message, equals(message));
        expect(exception.phase, isNull);
        expect(exception.originalError, isNull);
        expect(exception.canRetry, isFalse);
      });

      test('should create exception with all parameters', () {
        const message = 'Test error';
        const phase = 'TestPhase';
        const originalError = 'Original error';
        const canRetry = true;

        const exception = BootstrapException(
          message,
          phase: phase,
          originalError: originalError,
          canRetry: canRetry,
        );

        expect(exception.message, equals(message));
        expect(exception.phase, equals(phase));
        expect(exception.originalError, equals(originalError));
        expect(exception.canRetry, canRetry);
      });
    });

    group('toString', () {
      test('should format message without phase or original error', () {
        const exception = BootstrapException('Test message');

        expect(
          exception.toString(),
          equals('BootstrapException: Test message'),
        );
      });

      test('should include phase in formatted message', () {
        const exception = BootstrapException(
          'Test message',
          phase: 'TestPhase',
        );

        expect(
          exception.toString(),
          equals('BootstrapException in TestPhase: Test message'),
        );
      });

      test('should include original error in formatted message', () {
        const exception = BootstrapException(
          'Test message',
          originalError: 'Original error',
        );

        expect(
          exception.toString(),
          equals(
            'BootstrapException: Test message (caused by: Original error)',
          ),
        );
      });

      test('should include both phase and original error', () {
        const exception = BootstrapException(
          'Test message',
          phase: 'TestPhase',
          originalError: 'Original error',
        );

        expect(
          exception.toString(),
          equals(
            'BootstrapException in TestPhase: Test message '
            '(caused by: Original error)',
          ),
        );
      });
    });
  });

  group('BootstrapPhase interface', () {
    late MockBootstrapPhase mockPhase;

    setUp(() {
      mockPhase = MockBootstrapPhase(phaseName: 'TestPhase', priority: 1);
    });

    test('should have correct default values', () {
      expect(mockPhase.phaseName, equals('TestPhase'));
      expect(mockPhase.priority, equals(1));
      expect(mockPhase.canSkip, isFalse);
    });

    test('validatePreconditions should be callable', () async {
      await mockPhase.validatePreconditions();

      expect(mockPhase.validatePreconditionsWasCalled, isTrue);
    });

    test('execute should return BootstrapResult', () async {
      final result = await mockPhase.execute();

      expect(mockPhase.executeWasCalled, isTrue);
      expect(result, isA<BootstrapResult>());
      expect(result.success, isTrue);
    });

    test('rollback should be callable', () async {
      await mockPhase.rollback();

      expect(mockPhase.rollbackWasCalled, isTrue);
    });

    test('should support custom canSkip value', () {
      final skippablePhase = MockBootstrapPhase(
        phaseName: 'SkippablePhase',
        priority: 2,
        canSkip: true,
      );

      expect(skippablePhase.canSkip, isTrue);
    });

    test('should use default canSkip implementation', () {
      final defaultPhase = DefaultBootstrapPhase(
        phaseName: 'DefaultPhase',
        priority: 1,
      );

      // Test the actual default implementation
      expect(defaultPhase.canSkip, isFalse);
    });

    test('should use default validatePreconditions implementation', () async {
      final defaultPhase = DefaultBootstrapPhase(
        phaseName: 'DefaultPhase',
        priority: 1,
      );

      // Test the actual default implementation (should complete without error)
      await expectLater(defaultPhase.validatePreconditions(), completes);
    });

    test('should use default rollback implementation', () async {
      final defaultPhase = DefaultBootstrapPhase(
        phaseName: 'DefaultPhase',
        priority: 1,
      );

      // Test the actual default implementation (should complete without error)
      await expectLater(defaultPhase.rollback(), completes);
    });
  });
}
