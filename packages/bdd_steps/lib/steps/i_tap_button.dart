import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap {'Login'} button
///
/// Taps buttons by text content across multiple button types:
/// - Any widget containing the specified text (text-based interaction)
/// - ElevatedButton, TextButton, OutlinedButton (via ButtonStyleButton)
/// - Throws error if no button is found with the specified text
///
/// The method first tries to find text within any widget, then falls back
/// to finding Material buttons with the specified text content.
Future<void> iTapButton(WidgetTester tester, String param1) async {
  // Wait for the UI to settle first
  await tester.pumpAndSettle();

  // First, try to find any widget containing the text
  final textFinder = find.text(param1);
  if (textFinder.evaluate().isNotEmpty) {
    await tester.tap(textFinder.first);
    await tester.pumpAndSettle();
    return;
  }

  // If not found, try finding Material buttons with the text
  // (covers ElevatedButton, TextButton, OutlinedButton, etc.)
  final buttonFinder = find.widgetWithText(ButtonStyleButton, param1);
  if (buttonFinder.evaluate().isNotEmpty) {
    await tester.tap(buttonFinder.first);
    await tester.pumpAndSettle();
    return;
  }

  // If no button found, throw descriptive error
  fail(
    'Could not find button "$param1" to tap. '
    'Expected to find either:\n'
    '  - Any widget containing text "$param1"\n'
    '  - A Material button (ElevatedButton, TextButton, OutlinedButton) '
    'with text "$param1"',
  );
}
