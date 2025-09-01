import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/di/injection_container.dart';

void main() {
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

      test('should throw Exception when initialization fails', () async {
        // First, initialize dependencies successfully
        await GetIt.instance.reset();
        await configureDependencies();

        // Try to initialize again without reset - this should cause conflict
        // GetIt will throw an error for duplicate registrations
        expect(
          configureDependencies,
          throwsA(
            allOf([
              isA<Exception>(),
              predicate<Exception>(
                (e) => e.toString().contains(
                  'Failed to initialize dependency injection:',
                ),
                'Exception message should contain expected prefix',
              ),
            ]),
          ),
        );
      });

      test(
        'should preserve original error details in exception message',
        () async {
          // Reset and initialize first
          await GetIt.instance.reset();
          await configureDependencies();

          // Capture the exception details
          Exception? caughtException;
          try {
            await configureDependencies();
          } on Exception catch (e) {
            caughtException = e;
          }

          expect(caughtException, isNotNull);
          expect(
            caughtException.toString(),
            allOf([
              contains('Failed to initialize dependency injection:'),
              contains('already registered'),
            ]),
          );
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
}
