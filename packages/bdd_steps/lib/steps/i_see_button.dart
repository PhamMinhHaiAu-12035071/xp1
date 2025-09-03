import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I see {'Login'} button
Future<void> iSeeButton(WidgetTester tester, String param1) async {
  // Look for button text or actual button widget
  final textFinder = find.text(param1);
  final buttonFinder = find.widgetWithText(ElevatedButton, param1);
  
  final hasText = textFinder.evaluate().isNotEmpty;
  final hasButton = buttonFinder.evaluate().isNotEmpty;
  
  expect(hasText || hasButton, isTrue, 
    reason: 'Expected to find button "$param1" but found neither text '
        'nor button');
}
