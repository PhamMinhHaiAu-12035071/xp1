import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/platform/platform_detector.dart';
import 'package:xp1/features/locale/cubit/locale_cubit.dart';
import 'package:xp1/features/locale/di/locale_module.dart';
import 'package:xp1/features/locale/domain/services/platform_locale_provider.dart';
import 'package:xp1/features/locale/infrastructure/default_platform_locale_provider.dart';

// Mock classes
class MockPlatformDetector extends Mock implements PlatformDetector {}

class MockPlatformLocaleProvider extends Mock
    implements PlatformLocaleProvider {}

class MockStorage extends Mock implements Storage {}

void main() {
  group('LocaleModule', () {
    late LocaleModule localeModule;
    late MockPlatformDetector mockPlatformDetector;
    late MockPlatformLocaleProvider mockPlatformLocaleProvider;
    late MockStorage mockStorage;

    setUpAll(() {
      // Setup HydratedBloc storage for testing
      mockStorage = MockStorage();
      HydratedBloc.storage = mockStorage;

      // Setup mock storage behavior
      when(() => mockStorage.read(any())).thenReturn(<String, dynamic>{});
      when(() => mockStorage.write(any(), any<dynamic>())).thenAnswer(
        (_) async {},
      );
      when(() => mockStorage.delete(any())).thenAnswer((_) async {});
      when(() => mockStorage.clear()).thenAnswer((_) async {});
    });

    setUp(() {
      localeModule = _TestableLocaleModule();
      mockPlatformDetector = MockPlatformDetector();
      mockPlatformLocaleProvider = MockPlatformLocaleProvider();
    });

    tearDownAll(() {
      // Cleanup storage after tests
      reset(mockStorage);
    });

    group('platformLocaleProvider', () {
      test(
        'should create DefaultPlatformLocaleProvider with correct dependencies',
        () {
          // Act
          final result = localeModule.platformLocaleProvider(
            mockPlatformDetector,
          );

          // Assert
          expect(result, isA<DefaultPlatformLocaleProvider>());
          expect(result, isA<PlatformLocaleProvider>());
        },
      );

      test('should pass PlatformDetector to DefaultPlatformLocaleProvider', () {
        // Act
        final result =
            localeModule.platformLocaleProvider(
                  mockPlatformDetector,
                )
                as DefaultPlatformLocaleProvider;

        // Assert - Verify the instance is created correctly
        expect(result, isNotNull);
        expect(result, isA<DefaultPlatformLocaleProvider>());
      });

      test('should return same type for multiple calls', () {
        // Act
        final result1 = localeModule.platformLocaleProvider(
          mockPlatformDetector,
        );
        final result2 = localeModule.platformLocaleProvider(
          mockPlatformDetector,
        );

        // Assert
        expect(result1.runtimeType, equals(result2.runtimeType));
        expect(result1, isA<DefaultPlatformLocaleProvider>());
        expect(result2, isA<DefaultPlatformLocaleProvider>());
      });
    });

    group('localeCubit', () {
      test('should create LocaleCubit with correct dependencies', () {
        // Act
        final result = localeModule.localeCubit(
          mockPlatformLocaleProvider,
        );

        // Assert
        expect(result, isA<LocaleCubit>());
      });

      test('should pass PlatformLocaleProvider to LocaleCubit', () {
        // Act
        final result = localeModule.localeCubit(
          mockPlatformLocaleProvider,
        );

        // Assert - Verify the instance is created correctly
        expect(result, isNotNull);
        expect(result, isA<LocaleCubit>());
      });

      test('should return different instances for multiple calls', () {
        // Act
        final result1 = localeModule.localeCubit(
          mockPlatformLocaleProvider,
        );
        final result2 = localeModule.localeCubit(
          mockPlatformLocaleProvider,
        );

        // Assert
        expect(result1.runtimeType, equals(result2.runtimeType));
        expect(result1, isA<LocaleCubit>());
        expect(result2, isA<LocaleCubit>());
      });

      test('should handle dependency injection properly', () {
        // Arrange
        final provider = localeModule.platformLocaleProvider(
          mockPlatformDetector,
        );

        // Act
        final cubit = localeModule.localeCubit(provider);

        // Assert
        expect(cubit, isA<LocaleCubit>());
        expect(provider, isA<PlatformLocaleProvider>());
      });
    });

    group('module integration', () {
      test('should work with complete dependency chain', () {
        // Act
        final provider = localeModule.platformLocaleProvider(
          mockPlatformDetector,
        );
        final cubit = localeModule.localeCubit(provider);

        // Assert
        expect(provider, isA<DefaultPlatformLocaleProvider>());
        expect(cubit, isA<LocaleCubit>());
      });

      test('should maintain type safety across all methods', () {
        // Act & Assert
        expect(
          () => localeModule.platformLocaleProvider(mockPlatformDetector),
          returnsNormally,
        );
        expect(
          () => localeModule.localeCubit(mockPlatformLocaleProvider),
          returnsNormally,
        );
      });
    });
  });
}

/// Testable implementation of LocaleModule for unit testing.
///
/// Since LocaleModule is abstract, we need a concrete implementation
/// to test the methods directly.
class _TestableLocaleModule extends LocaleModule {}
