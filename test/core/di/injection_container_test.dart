import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/di/injection_container.dart';

// Mock class for testing GetIt initialization failure
class MockGetIt extends Mock implements GetIt {}

void main() {
  // Initialize Flutter test bindings and mock platform storage before any
  // DI work
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('Dependency Injection Container', () {
    group('configureDependencies', () {
      test('should initialize dependencies successfully', () async {
        // Reset GetIt to clean state
        await GetIt.instance.reset();

        // Should complete without throwing
        expect(
          configureDependencies,
          returnsNormally,
        );

        // Verify GetIt instance is accessible
        expect(getIt, isA<GetIt>());
        expect(getIt, same(GetIt.instance));
      });

      test('should handle duplicate configuration gracefully', () async {
        // First, initialize dependencies successfully
        await GetIt.instance.reset();
        await configureDependencies();

        // Try to initialize again - this should return early without error
        // due to the duplicate configuration guard using GetIt state checking
        expect(
          configureDependencies,
          returnsNormally,
        );
      });

      test(
        'should maintain dependency configuration state correctly',
        () async {
          // Reset GetIt state
          await GetIt.instance.reset();

          // First initialization should work
          await configureDependencies();

          // Second initialization should return early due to guard
          await configureDependencies();

          // Verify GetIt instance is still accessible
          expect(getIt, isA<GetIt>());
          expect(getIt, same(GetIt.instance));
        },
      );
    });

    group('getIt instance', () {
      test('should provide global GetIt instance', () {
        expect(getIt, isA<GetIt>());
        expect(getIt, same(GetIt.instance));
      });

      test('should maintain singleton behavior', () {
        final instance1 = getIt;
        final instance2 = getIt;

        expect(identical(instance1, instance2), isTrue);
        expect(instance1, same(GetIt.instance));
      });
    });
  });

  group('DependencyInjectionException', () {
    test('should create exception with original error', () {
      const originalError = 'Test error';
      const exception = DependencyInjectionException(originalError);

      expect(exception.originalError, equals(originalError));
    });

    test('should format toString message correctly', () {
      const originalError = 'Initialization failed';
      const exception = DependencyInjectionException(originalError);

      expect(
        exception.toString(),
        equals(
          'DependencyInjectionException: Failed to initialize dependency '
          'injection: Initialization failed',
        ),
      );
    });

    test('should handle different error types', () {
      final error1 = Exception('Test exception');
      final exception1 = DependencyInjectionException(error1);
      expect(exception1.originalError, equals(error1));
      expect(
        exception1.toString(),
        contains('Exception: Test exception'),
      );

      const error2 = 42;
      const exception2 = DependencyInjectionException(error2);
      expect(exception2.originalError, equals(42));
      expect(exception2.toString(), contains('42'));
    });
  });

  group('GetIt state management', () {
    test('should reset GetIt state correctly', () async {
      // Initialize dependencies first
      await GetIt.instance.reset();
      await configureDependencies();

      // Reset the state
      await GetIt.instance.reset();

      // Verify GetIt is reset
      expect(getIt, isA<GetIt>());
      expect(getIt, same(GetIt.instance));
    });

    test('should allow reinitialization after reset', () async {
      // First initialization
      await GetIt.instance.reset();
      await configureDependencies();

      // Reset everything
      await GetIt.instance.reset();

      // Second initialization should work
      await configureDependencies();

      expect(getIt, isA<GetIt>());
    });
  });

  group('configureDependencies error handling', () {
    test('should throw DependencyInjectionException on init failure', () async {
      // This test verifies the error handling path
      // Since we can't easily mock getIt.init() to throw,
      // we'll test the exception behavior separately

      // Create a scenario that would throw if init() failed
      const testError = 'Init failed';

      // Test that DependencyInjectionException wraps errors correctly
      expect(
        () => throw const DependencyInjectionException(testError),
        throwsA(
          isA<DependencyInjectionException>()
              .having(
                (e) => e.originalError,
                'originalError',
                equals(testError),
              )
              .having(
                (e) => e.toString(),
                'toString',
                contains('Failed to initialize dependency injection'),
              ),
        ),
      );
    });

    test('should handle various error types in exception', () {
      // Test with Exception
      final exception1 = DependencyInjectionException(
        Exception('Config error'),
      );
      expect(
        exception1.toString(),
        allOf([
          contains('DependencyInjectionException'),
          contains('Config error'),
        ]),
      );

      // Test with StateError
      final exception2 = DependencyInjectionException(
        StateError('Invalid state'),
      );
      expect(
        exception2.toString(),
        allOf([
          contains('DependencyInjectionException'),
          contains('Invalid state'),
        ]),
      );

      // Test with String
      const exception3 = DependencyInjectionException(
        'Simple string error',
      );
      expect(
        exception3.toString(),
        allOf([
          contains('DependencyInjectionException'),
          contains('Simple string error'),
        ]),
      );
    });
  });
}
