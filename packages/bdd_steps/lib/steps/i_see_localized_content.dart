import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I see localized content
Future<void> iSeeLocalizedContent(WidgetTester tester) async {
  // Check that the app has text widgets (basic check for localization)
  // In a real app, localized content should be visible as Text widgets
  expect(
    find.byType(Text),
    findsWidgets,
    reason: 'Expected to find localized text content',
  );

  // Alternatively, you could pass in specific localized strings to check
  // This is a simplified version that just verifies text exists
}
