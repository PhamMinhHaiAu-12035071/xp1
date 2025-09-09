import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_state.dart';

/// Test for simplified SplashState following TDD approach.
///
/// Tests that SplashState only has loading and ready states,
/// removing error and retrying states from the complex implementation.
void main() {
  group('SplashState (Simplified)', () {
    test('should have loading state constructor', () {
      const state = SplashState.loading();
      expect(state, isA<SplashLoading>());
    });

    test('should have ready state constructor', () {
      const state = SplashState.ready();
      expect(state, isA<SplashReady>());
    });

    test('should not have error state constructor', () {
      // This test should pass when error state is removed
      const loading = SplashState.loading();
      const ready = SplashState.ready();

      // Should only have 2 states: loading and ready
      expect(loading, isA<SplashLoading>());
      expect(ready, isA<SplashReady>());

      // Error and retrying constructors should not exist
      // (This will be verified by compilation errors if they exist)
    });

    test('should support when pattern matching with only 2 states', () {
      const loadingState = SplashState.loading();
      const readyState = SplashState.ready();

      // Test when pattern matching
      final loadingResult = loadingState.when(
        loading: () => 'loading',
        ready: () => 'ready',
      );

      final readyResult = readyState.when(
        loading: () => 'loading',
        ready: () => 'ready',
      );

      expect(loadingResult, equals('loading'));
      expect(readyResult, equals('ready'));
    });

    test('should support maybeWhen pattern matching', () {
      const loadingState = SplashState.loading();

      final result = loadingState.maybeWhen(
        loading: () => 'is_loading',
        orElse: () => 'other',
      );

      expect(result, equals('is_loading'));
    });

    test('should be equatable and immutable', () {
      const state1 = SplashState.loading();
      const state2 = SplashState.loading();
      const state3 = SplashState.ready();

      // Same states should be equal
      expect(state1, equals(state2));

      // Different states should not be equal
      expect(state1, isNot(equals(state3)));
    });
  });
}
