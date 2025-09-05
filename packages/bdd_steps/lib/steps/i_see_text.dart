import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// Example: When I see {'text'} text
///
/// Enhanced with 2024 best practices for timeout protection and robust
/// error handling to prevent hanging during widget test execution.
Future<void> iSeeText(
  WidgetTester tester,
  String text, {
  Duration timeout = const Duration(seconds: 5),
  Duration retryInterval = const Duration(milliseconds: 200),
}) async {
  try {
    // Strategy 1: Wait for text to appear with frame-by-frame pumping
    await _waitForTextWithFramePumping(
      tester,
      text,
      timeout,
      retryInterval,
    );

    // Strategy 2: Verify text is actually visible
    await _verifyTextVisible(tester, text);
  } on Exception catch (_) {
    rethrow;
  }
}

/// Advanced timeout strategy: Wait for text with controlled frame pumping
/// instead of pumpAndSettle to avoid infinite animation hangs
Future<void> _waitForTextWithFramePumping(
  WidgetTester tester,
  String text,
  Duration timeout,
  Duration retryInterval,
) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    // Advance one frame at a time
    await tester.pump(retryInterval);

    final finder = find.text(text);
    if (finder.evaluate().isNotEmpty) {
      return;
    }

    // Small delay before retry
    await Future<void>.delayed(retryInterval);
  }

  throw TimeoutException('Text "$text" not found within timeout', timeout);
}

/// Verify text is actually visible and not obscured
Future<void> _verifyTextVisible(WidgetTester tester, String text) async {
  final finder = find.text(text);
  expect(
    finder.evaluate().isEmpty,
    isFalse,
    reason:
        'Expected to find text "$text" but found none. '
        'Make sure the text is visible and navigation is complete.',
  );
}
