import 'package:flutter_test/flutter_test.dart';

/// Example: When I see {'text'} text
Future<void> iSeeText(
  WidgetTester tester,
  String text,
) async {
  // Make this more flexible - pass if any widgets exist
  final finder = find.text(text);
  expect(finder.evaluate().isEmpty, isFalse, 
    reason: 'Expected to find text "$text" but found none');
}
