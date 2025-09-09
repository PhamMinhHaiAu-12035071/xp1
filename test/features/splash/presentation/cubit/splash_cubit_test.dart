import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_state.dart';

/// Test for simplified SplashCubit following TDD approach.
///
/// Tests the new simplified implementation that only has a timer-based
/// approach without repository dependencies, error handling, or complex logic.
void main() {
  group('SplashCubit (Simplified)', () {
    late SplashCubit splashCubit;

    setUp(() {
      splashCubit = SplashCubit();
    });

    tearDown(() {
      splashCubit.close();
    });

    test('should have initial state as loading', () {
      expect(splashCubit.state, equals(const SplashState.loading()));
    });

    blocTest<SplashCubit, SplashState>(
      'should emit ready state after 2 seconds when startSplash is called',
      build: SplashCubit.new,
      act: (cubit) => cubit.startSplash(),
      wait: const Duration(seconds: 3), // Wait a bit longer than 2 seconds
      expect: () => [
        const SplashState.ready(),
      ],
      tearDown: () => splashCubit.close(),
    );

    blocTest<SplashCubit, SplashState>(
      'should not emit anything if cubit is closed before timer completes',
      build: SplashCubit.new,
      act: (cubit) async {
        cubit.startSplash();
        await cubit.close(); // Close immediately
      },
      wait: const Duration(seconds: 3),
      expect: () => <SplashState>[], // No emissions after close
    );

    test('should cancel timer on close', () async {
      splashCubit.startSplash();
      await splashCubit.close();

      // Should complete without hanging
      expect(splashCubit.isClosed, isTrue);
    });

    test('should have simple constructor without repository dependency', () {
      // Should not require any repository parameter
      final cubit = SplashCubit();
      expect(cubit.state, equals(const SplashState.loading()));
      cubit.close();
    });
  });
}
