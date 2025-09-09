import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

/// Simplified splash screen state with only essential states.
///
/// Uses Freezed sealed classes for type safety and exhaustive pattern matching.
/// Only includes loading and ready states for simple splash navigation.
@freezed
class SplashState with _$SplashState {
  /// Initial loading state.
  const factory SplashState.loading() = SplashLoading;

  /// Ready to navigate to main app.
  const factory SplashState.ready() = SplashReady;
}
