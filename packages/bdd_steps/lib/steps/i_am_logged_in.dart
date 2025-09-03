import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I am logged in
Future<void> iAmLoggedIn(WidgetTester tester) async {
  // Simulate login by tapping the login button if it exists
  final loginFinder = find.text('Login');
  if (loginFinder.evaluate().isNotEmpty) {
    await tester.tap(loginFinder.first);
    await tester.pumpAndSettle();
  } else {
    // Try finding login button widget
    final buttonFinder = find.widgetWithText(ElevatedButton, 'Login');
    if (buttonFinder.evaluate().isNotEmpty) {
      await tester.tap(buttonFinder.first);
      await tester.pumpAndSettle();
    }
  }
}
