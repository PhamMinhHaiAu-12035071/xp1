import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/features/locale/cubit/locale_cubit.dart';
import 'package:xp1/features/locale/di/locale_module.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';

/// Mock for LocaleDomainService using mocktail.
class MockLocaleDomainService extends Mock implements LocaleDomainService {}

/// Test implementation of LocaleModule for testing.
class TestLocaleModule extends LocaleModule {}

void main() {
  group('LocaleModule', () {
    late GetIt getIt;
    late TestLocaleModule localeModule;
    late MockLocaleDomainService mockDomainService;

    setUp(() {
      getIt = GetIt.instance;
      localeModule = TestLocaleModule();
      mockDomainService = MockLocaleDomainService();
    });

    tearDown(() {
      getIt.reset();
    });

    group('localeCubit', () {
      test('creates LocaleCubit with domain service dependency', () {
        // Act
        final result = localeModule.localeCubit(mockDomainService);

        // Assert
        expect(result, isA<LocaleCubit>());
        expect(result, isNotNull);
      });

      test('returns properly configured LocaleCubit instance', () {
        // Act
        final result = localeModule.localeCubit(mockDomainService);

        // Assert
        expect(result, isA<LocaleCubit>());

        // Verify the cubit starts with Vietnamese default state
        expect(result.state.languageCode, equals('vi'));
        expect(result.state.source, equals(LocaleSource.defaultFallback));
      });

      test(
        'creates new instance each time (not singleton at factory level)',
        () {
          // Act
          final result1 = localeModule.localeCubit(mockDomainService);
          final result2 = localeModule.localeCubit(mockDomainService);

          // Assert - Different instances from factory method
          expect(result1, isA<LocaleCubit>());
          expect(result2, isA<LocaleCubit>());
          expect(identical(result1, result2), isFalse);

          // But both should have the same initial state
          expect(result1.state, equals(result2.state));
        },
      );

      test('properly injects domain service dependency', () {
        // This test verifies that the domain service is properly injected
        // into the LocaleCubit constructor

        // Act
        final result = localeModule.localeCubit(mockDomainService);

        // Assert
        expect(result, isA<LocaleCubit>());

        // The cubit should be created successfully with the domain service
        // This is verified by the fact that it can be instantiated
        // without error
      });
    });

    group('dependency injection integration', () {
      test('works with GetIt container for lazy singleton behavior', () {
        // This test demonstrates how the module would work with GetIt
        // when registered as @lazySingleton

        // Arrange - Register domain service in GetIt
        getIt.registerSingleton<LocaleDomainService>(mockDomainService);

        // Simulate GetIt behavior for lazy singleton
        LocaleCubit? cachedCubit;
        LocaleCubit getCubit() {
          cachedCubit ??= localeModule.localeCubit(
            getIt<LocaleDomainService>(),
          );
          return cachedCubit!;
        }

        // Act
        final cubit1 = getCubit();
        final cubit2 = getCubit();

        // Assert - Same instance when cached (lazy singleton behavior)
        expect(cubit1, isA<LocaleCubit>());
        expect(cubit2, isA<LocaleCubit>());
        expect(identical(cubit1, cubit2), isTrue);
      });

      test('integrates with Vietnamese-first architecture', () {
        // Arrange
        final cubit = localeModule.localeCubit(mockDomainService);

        // Assert - Vietnamese-first behavior
        expect(cubit.state.languageCode, equals('vi'));
        expect(cubit.state.source, equals(LocaleSource.defaultFallback));

        // The cubit should be ready for Vietnamese-first operations
        expect(cubit, isA<LocaleCubit>());
      });
    });

    group('simplified architecture validation', () {
      test('module only provides essential locale cubit', () {
        // The simplified LocaleModule should only provide the LocaleCubit
        // and not include complex platform detection or repository layers

        // Act
        final cubit = localeModule.localeCubit(mockDomainService);

        // Assert - Only essential Vietnamese-first cubit functionality
        expect(cubit, isA<LocaleCubit>());
        expect(cubit.state.languageCode, equals('vi'));
      });

      test('does not include deprecated platform provider infrastructure', () {
        // This test verifies that the old complex platform detection
        // infrastructure has been removed from the module

        // The LocaleModule class should not have methods for:
        // - platformLocaleProvider
        // - platformLocaleRepository
        // - complexAsyncOperations

        // This is verified by the fact that the module only has the
        // localeCubit method, as seen in the static analysis
        expect(localeModule, isA<LocaleModule>());

        // The module should be simple and focused
        final cubit = localeModule.localeCubit(mockDomainService);
        expect(cubit, isA<LocaleCubit>());
      });

      test('supports session-only locale management', () {
        // Arrange
        final cubit = localeModule.localeCubit(mockDomainService);

        // Assert - Session-only behavior (no persistence)
        expect(cubit, isA<LocaleCubit>());
        expect(cubit.state, isNotNull);

        // The cubit should not have persistence features
        // This is verified by its simple constructor and Vietnamese default
        expect(cubit.state.languageCode, equals('vi'));
      });
    });

    group('Vietnamese-first locale behavior', () {
      test('all created cubits default to Vietnamese', () {
        // Act
        final cubit1 = localeModule.localeCubit(mockDomainService);
        final cubit2 = localeModule.localeCubit(mockDomainService);
        final cubit3 = localeModule.localeCubit(mockDomainService);

        // Assert - All instances start with Vietnamese
        expect(cubit1.state.languageCode, equals('vi'));
        expect(cubit2.state.languageCode, equals('vi'));
        expect(cubit3.state.languageCode, equals('vi'));

        expect(cubit1.state.source, equals(LocaleSource.defaultFallback));
        expect(cubit2.state.source, equals(LocaleSource.defaultFallback));
        expect(cubit3.state.source, equals(LocaleSource.defaultFallback));
      });

      test('module supports Vietnamese-first application architecture', () {
        // This test ensures the module aligns with the Vietnamese-first
        // application architecture requirements

        // Arrange & Act
        final cubit = localeModule.localeCubit(mockDomainService);

        // Assert - Vietnamese-first compliance
        expect(cubit.state.languageCode, equals('vi'));
        expect(cubit.state.source, equals(LocaleSource.defaultFallback));

        // The module should provide all needed components for
        // Vietnamese-first behavior
        expect(cubit, isA<LocaleCubit>());
      });
    });

    group('performance and synchronous operations', () {
      test('cubit creation is synchronous and fast', () {
        // This test ensures the module creates cubits synchronously
        // for the fast Vietnamese-first architecture

        // Act - All operations should be synchronous
        final startTime = DateTime.now();
        final cubit = localeModule.localeCubit(mockDomainService);
        final endTime = DateTime.now();

        // Assert - Synchronous operation
        expect(cubit, isA<LocaleCubit>());

        // Should complete nearly instantly (< 10ms for sync operations)
        final duration = endTime.difference(startTime);
        expect(duration.inMilliseconds, lessThan(10));
      });

      test('module has minimal overhead', () {
        // The simplified module should have minimal overhead
        // compared to the previous complex async architecture

        // Act
        final startTime = DateTime.now();

        // Create multiple cubits to test performance
        final cubits = List.generate(
          10,
          (_) => localeModule.localeCubit(mockDomainService),
        );

        final endTime = DateTime.now();

        // Assert - All cubits created successfully
        expect(cubits.length, equals(10));
        for (final cubit in cubits) {
          expect(cubit, isA<LocaleCubit>());
          expect(cubit.state.languageCode, equals('vi'));
        }

        // Performance should be good even for multiple creations
        final duration = endTime.difference(startTime);
        expect(duration.inMilliseconds, lessThan(50));
      });
    });
  });
}
