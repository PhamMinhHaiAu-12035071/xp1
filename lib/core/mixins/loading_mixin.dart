import 'package:flutter/material.dart';
import 'package:xp1/core/widgets/molecules/loading_overlay.dart';

/// Mixin for BLoCs to easily manage loading overlay display
///
/// Provides simple methods to show/hide loading overlays and execute
/// operations with automatic loading state management.
/// Includes safety checks to prevent navigation issues.
mixin LoadingMixin {
  /// Shows loading overlay with FadingCircle spinner
  ///
  /// [context] - BuildContext for dialog display
  void showLoading(BuildContext context) {
    LoadingOverlay.show(context);
  }

  /// Hides the currently displayed loading overlay
  ///
  /// [context] - BuildContext for dialog dismissal
  ///
  /// Returns true if overlay was successfully hidden,
  /// false if no overlay was showing
  bool hideLoading(BuildContext context) {
    return LoadingOverlay.hide(context);
  }

  /// Executes an operation with automatic loading state management
  ///
  /// Shows loading overlay before operation, hides after completion.
  /// Ensures loading is hidden even if operation throws exception.
  /// Safe from navigation issues - won't pop routes if no overlay is showing.
  ///
  /// [context] - BuildContext for loading overlay
  /// [operation] - Future operation to execute
  ///
  /// Returns the result of the operation
  Future<T> withLoading<T>(BuildContext context, Future<T> operation) async {
    try {
      showLoading(context);
      return await operation;
    } finally {
      // Safe hide - won't cause navigation issues
      hideLoading(context);
    }
  }

  /// Checks if loading overlay is currently showing
  bool get isLoadingShowing => LoadingOverlay.isShowing;
}
