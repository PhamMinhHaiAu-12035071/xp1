import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap {'Login'} button
Future<void> iTapButton(WidgetTester tester, String param1) async {
  final finder = find.text(param1);
  if (finder.evaluate().isNotEmpty) {
    await tester.tap(finder.first);
    await tester.pumpAndSettle();
  }
  // If button not found, try finding by button with text child
  else {
    final buttonFinder = find.widgetWithText(ElevatedButton, param1);
    if (buttonFinder.evaluate().isNotEmpty) {
      await tester.tap(buttonFinder.first);
      await tester.pumpAndSettle();
    }
  }
}
