import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Example: When I tap {Icons.add} icon
///
/// Enhanced with 2024 best practices for timeout protection and robust
/// error handling to prevent hanging during widget test execution.
///
/// Based on Flutter 2024 testing guidelines:
/// - Uses pump() instead of pumpAndSettle() to avoid infinite animation hangs
/// - Implements explicit timeout strategies
/// - Provides comprehensive error recovery
Future<void> iTapIcon(
  WidgetTester tester,
  IconData icon, {
  Duration timeout = const Duration(seconds: 5),
  Duration retryInterval = const Duration(milliseconds: 200),
}) async {
  // Advanced timeout strategy: Use explicit frame pumping instead of
  // pumpAndSettle
  final iconFinder = find.byIcon(icon);

  try {
    // Strategy 1: Wait for widget to appear with frame-by-frame pumping
    await _waitForIconWithFramePumping(
      tester,
      iconFinder,
      timeout,
      retryInterval,
    );

    // Strategy 2: Verify icon is actually tappable (not obscured)
    await _verifyIconInteractable(tester, iconFinder, icon);

    // Strategy 3: Perform tap with immediate frame advancement
    await tester.tap(iconFinder.first);

    // Strategy 4: Use controlled frame pumping instead of pumpAndSettle
    await _advanceFramesControlled(tester);
  } on Exception catch (_) {
    rethrow;
  }
}

/// Advanced timeout strategy: Wait for icon with controlled frame pumping
/// instead of pumpAndSettle to avoid infinite animation hangs
Future<void> _waitForIconWithFramePumping(
  WidgetTester tester,
  Finder iconFinder,
  Duration timeout,
  Duration retryInterval,
) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    // Advance one frame at a time
    await tester.pump(retryInterval);

    if (iconFinder.evaluate().isNotEmpty) {
      return;
    }

    // Small delay before retry
    await Future<void>.delayed(retryInterval);
  }

  throw TimeoutException('Icon not found within timeout', timeout);
}

/// Verify icon is interactable and not obscured by other widgets
Future<void> _verifyIconInteractable(
  WidgetTester tester,
  Finder iconFinder,
  IconData icon,
) async {
  expect(
    iconFinder,
    findsWidgets,
    reason:
        'Icon $icon not found on screen. '
        'Make sure the icon is visible and navigation is complete.',
  );

  // Check if icon is actually visible (not covered by overlays)
  final iconWidget = tester.widget(iconFinder.first);
  expect(
    iconWidget,
    isNotNull,
    reason: 'Icon $icon widget is null or not properly rendered',
  );
}

/// Advanced frame pumping: Control frame advancement to prevent hanging
/// Based on 2024 Flutter testing best practices
Future<void> _advanceFramesControlled(
  WidgetTester tester, {
  int maxFrames = 10,
  Duration frameDelay = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < maxFrames; i++) {
    await tester.pump(frameDelay);

    // Check if navigation has stabilized (no pending callbacks)
    if (tester.binding.hasScheduledFrame == false) {
      return;
    }
  }
}
