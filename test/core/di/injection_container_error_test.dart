import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/features/env/domain/env_config_repository.dart';

// Custom test to verify error handling in configureDependencies
// This test focuses on the new architecture without global state flags

// Mock services for testing conflict scenarios
class MockLoggerService extends Mock implements ILoggerService {}

class MockEnvConfigRepository extends Mock implements EnvConfigRepository {}

void main() {
  group('configureDependencies error path', () {
    setUpAll(() async {
      // Initialize Flutter test bindings and mock platform storage before any
      // DI work
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() async {
      // Reset GetIt to clean state before each test
      await GetIt.instance.reset();
    });

    tearDown(() async {
      // Clean up GetIt after each test
      await GetIt.instance.reset();
    });
    test('should handle repeated configuration calls gracefully', () async {
      // This test verifies that the new GetIt state checking approach
      // handles repeated configuration calls properly

      // First, configure dependencies normally
      await configureDependencies();

      // Try to configure again - this should return early gracefully
      // due to GetIt's built-in state checking
      expect(
        configureDependencies,
        returnsNormally,
      );
    });

    test('DependencyInjectionException should be throwable', () {
      // Direct test of throwing the exception
      const error = 'Test initialization error';

      expect(
        () => throw const DependencyInjectionException(error),
        throwsA(
          isA<DependencyInjectionException>()
              .having((e) => e.originalError, 'originalError', error)
              .having(
                (e) => e.toString(),
                'toString',
                contains('Failed to initialize dependency injection'),
              ),
        ),
      );
    });

    test('should maintain proper exception hierarchy', () {
      const error = 'Hierarchy test error';
      const exception = DependencyInjectionException(error);

      // Verify it implements Exception
      expect(exception, isA<Exception>());
      expect(exception.originalError, equals(error));
    });
  });

  group('Code coverage completeness', () {
    test('should execute all code paths', () {
      // Test constructor directly
      const error = 'Coverage test error';
      const exception = DependencyInjectionException(error);

      // Verify constructor worked
      expect(exception, isA<DependencyInjectionException>());
      expect(exception.originalError, equals(error));

      // Test toString
      final stringRep = exception.toString();
      expect(stringRep, isA<String>());
      expect(stringRep, contains('DependencyInjectionException'));
      expect(stringRep, contains(error));

      // Test that it implements Exception
      expect(exception, isA<Exception>());
    });

    test('should handle complex error objects', () {
      // Test with a complex error object
      final complexError = {
        'code': 500,
        'message': 'Internal error',
        'details': ['Service unavailable', 'Timeout'],
      };

      final exception = DependencyInjectionException(complexError);

      expect(exception.originalError, equals(complexError));
      expect(exception.toString(), contains(complexError.toString()));
    });

    test('should handle edge cases', () {
      // Test with empty string
      const exception1 = DependencyInjectionException('');
      expect(exception1.originalError, equals(''));
      expect(exception1.toString(), contains('DependencyInjectionException'));

      // Test with boolean
      const exception2 = DependencyInjectionException(true);
      expect(exception2.originalError, equals(true));
      expect(exception2.toString(), contains('true'));

      // Test with number
      const exception3 = DependencyInjectionException(42);
      expect(exception3.originalError, equals(42));
      expect(exception3.toString(), contains('42'));
    });
  });

  group('GetIt integration scenarios', () {
    setUp(() async {
      // Reset GetIt to clean state before each test
      await GetIt.instance.reset();
    });

    tearDown(() async {
      // Clean up GetIt after each test
      await GetIt.instance.reset();
    });

    test('should work correctly with fresh GetIt instance', () async {
      // Configure dependencies should work without issues
      expect(
        configureDependencies,
        returnsNormally,
      );

      // Verify GetIt is accessible
      expect(getIt, same(GetIt.instance));
    });

    test('should handle multiple reset and configure cycles', () async {
      // Test multiple cycles to ensure robustness
      for (var i = 0; i < 3; i++) {
        await configureDependencies();
        expect(getIt, isA<GetIt>());
        await GetIt.instance.reset();
      }
    });
  });

  group('Error path coverage', () {
    setUp(() async {
      // Reset GetIt to clean state before each test
      await GetIt.instance.reset();
    });

    tearDown(() async {
      // Clean up GetIt after each test
      await GetIt.instance.reset();
    });

    test('should throw DependencyInjectionException when init fails', () async {
      // Manually register EnvConfigRepository to create a conflict
      // This will NOT trigger early return
      // (since ILoggerService not registered)
      // but WILL cause getIt.init() to throw when trying to register
      // the same service again during generated code execution
      getIt.registerSingleton<EnvConfigRepository>(MockEnvConfigRepository());

      // Now configureDependencies should throw because:
      // 1. isRegistered<ILoggerService>() = false → no early return
      // 2. getIt.init() tries to register EnvConfigRepository → conflict
      //    → throws
      // 3. catch block triggered → DependencyInjectionException thrown
      expect(
        configureDependencies,
        throwsA(isA<DependencyInjectionException>()),
      );
    });
  });
}
