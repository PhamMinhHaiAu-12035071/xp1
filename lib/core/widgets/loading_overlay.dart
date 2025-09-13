import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

/// Simple full-screen loading overlay with SpinKit FadingCircle animation
///
/// Provides a clean loading dialog with only the FadingCircle spinner.
/// No text or additional elements for minimal, focused user experience.
/// Includes state tracking to prevent navigation issues.
class LoadingOverlay {
  static final Logger _logger = Logger();

  /// Tracks whether a loading overlay is currently displayed
  static bool _isShowing = false;

  /// Shows a full-screen loading overlay with FadingCircle spinner
  ///
  /// [context] - BuildContext for dialog display
  static void show(BuildContext context) {
    if (_isShowing) {
      _logger.w('LoadingOverlay.show() called but overlay is already showing');
      return;
    }

    _isShowing = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SpinKitFadingCircle(
              color: Colors.amber,
            ),
          ),
        ),
      ),
    ).then((_) {
      // Reset state when dialog is dismissed (e.g., by back button)
      _isShowing = false;
    });
  }

  /// Hides the currently displayed loading overlay
  ///
  /// [context] - BuildContext for dialog dismissal
  ///
  /// Returns true if overlay was successfully hidden,
  /// false if no overlay was showing
  static bool hide(BuildContext context) {
    if (!_isShowing) {
      _logger.w('LoadingOverlay.hide() called but no overlay is showing');
      return false;
    }

    // Double-check: ensure we can actually pop (safety check)
    if (!Navigator.of(context).canPop()) {
      _logger.e('LoadingOverlay.hide() called but Navigator cannot pop');
      _isShowing = false; // Reset state anyway
      return false;
    }

    _isShowing = false;
    Navigator.of(context).pop();
    return true;
  }

  /// Force hides the loading overlay (use with caution)
  ///
  /// This method will attempt to hide the overlay even if the state tracking
  /// suggests it's not showing. Use only in emergency situations.
  static void forceHide(BuildContext context) {
    _logger.w(
      'LoadingOverlay.forceHide() called - '
      'this may cause unexpected navigation',
    );
    _isShowing = false;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Gets the current showing state
  static bool get isShowing => _isShowing;

  /// Resets the internal state (for testing only)
  @visibleForTesting
  static void resetState() {
    _isShowing = false;
  }
}
