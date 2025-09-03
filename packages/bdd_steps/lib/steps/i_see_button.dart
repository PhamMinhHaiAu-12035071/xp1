import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I see {'Login'} button
///
/// Finds buttons by text content across multiple button types:
/// - ElevatedButton, TextButton, OutlinedButton (via ButtonStyleButton)
/// - Any widget containing the specified text
/// - Provides clear error messages for debugging
Future<void> iSeeButton(WidgetTester tester, String param1) async {
  // Look for button text in any widget containing the text
  final textFinder = find.text(param1);

  // Look for buttons with the specified text using ButtonStyleButton
  // (covers ElevatedButton, TextButton, OutlinedButton, and other
  // Material buttons)
  final buttonFinder = find.widgetWithText(ButtonStyleButton, param1);

  final hasText = textFinder.evaluate().isNotEmpty;
  final hasButton = buttonFinder.evaluate().isNotEmpty;

  expect(
    hasText || hasButton,
    isTrue,
    reason:
        'Expected to find button "$param1" but found neither text '
        'nor button. Available button types: ElevatedButton, TextButton, '
        'OutlinedButton, or any widget containing the text "$param1"',
  );
}
