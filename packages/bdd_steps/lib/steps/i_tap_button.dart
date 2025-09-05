import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap {'Login'} button
///
/// Enhanced with 2024 best practices for timeout protection and robust
/// error handling to prevent hanging during widget test execution.
///
/// Taps buttons by text content across multiple button types:
/// - Any widget containing the specified text (text-based interaction)
/// - ElevatedButton, TextButton, OutlinedButton (via ButtonStyleButton)
/// - Throws error if no button is found with the specified text
///
/// The method first tries to find text within any widget, then falls back
/// to finding Material buttons with the specified text content.
Future<void> iTapButton(
  WidgetTester tester,
  String param1, {
  Duration timeout = const Duration(seconds: 5),
  Duration retryInterval = const Duration(milliseconds: 200),
}) async {
  try {
    // Strategy 1: Wait for button to appear with frame-by-frame pumping
    await _waitForButtonWithFramePumping(
      tester,
      param1,
      timeout,
      retryInterval,
    );

    // Strategy 2: Perform tap with immediate frame advancement
    await _performButtonTap(tester, param1);

    // Strategy 3: Use controlled frame pumping instead of pumpAndSettle
    await _advanceFramesControlled(tester);
  } on Exception catch (_) {
    rethrow;
  }
}

/// Advanced timeout strategy: Wait for button with controlled frame pumping
/// instead of pumpAndSettle to avoid infinite animation hangs
Future<void> _waitForButtonWithFramePumping(
  WidgetTester tester,
  String buttonText,
  Duration timeout,
  Duration retryInterval,
) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    // Advance one frame at a time
    await tester.pump(retryInterval);

    // Check for text-based button
    final textFinder = find.text(buttonText);
    if (textFinder.evaluate().isNotEmpty) {
      return;
    }

    // Check for Material button
    final buttonFinder = find.widgetWithText(ButtonStyleButton, buttonText);
    if (buttonFinder.evaluate().isNotEmpty) {
      return;
    }

    // Small delay before retry
    await Future<void>.delayed(retryInterval);
  }

  throw TimeoutException(
    'Button "$buttonText" not found within timeout',
    timeout,
  );
}

/// Perform button tap with immediate frame advancement
Future<void> _performButtonTap(WidgetTester tester, String buttonText) async {
  // First, try to find any widget containing the text
  final textFinder = find.text(buttonText);
  if (textFinder.evaluate().isNotEmpty) {
    await tester.tap(textFinder.first);
    return;
  }

  // If not found, try finding Material buttons with the text
  final buttonFinder = find.widgetWithText(ButtonStyleButton, buttonText);
  if (buttonFinder.evaluate().isNotEmpty) {
    await tester.tap(buttonFinder.first);
    return;
  }

  // If no button found, throw descriptive error
  fail(
    'Could not find button "$buttonText" to tap. '
    'Expected to find either:\n'
    '  - Any widget containing text "$buttonText"\n'
    '  - A Material button (ElevatedButton, TextButton, OutlinedButton) '
    'with text "$buttonText"',
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
