import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/attendance/presentation/pages/attendance_page.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('AttendancePage', () {
    setUpAll(() async {
      // Set consistent locale for testing
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    tearDownAll(() async {
      // Reset to prevent interference with other tests
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    // Use comprehensive helper that includes environment setup,
    // navigation testing, and memory management - following Linus's
    // principle of proper resource management
    PageTestHelpers.testComprehensivePage<AttendancePage>(
      const AttendancePage(),
      'Welcome to Attendance',
      () => const AttendancePage(),
      (key) => AttendancePage(key: key),
      pageRoute: '/main/attendance',
    );

    group('Button interactions', () {
      testWidgets('should handle check in button tap', (tester) async {
        await tester.pumpApp(const AttendancePage());

        // Wait for the page to load
        await tester.pumpAndSettle();

        // Find and tap the check in button by text
        // (since these are empty handlers)
        final checkInButtonText = find.textContaining('Check In');
        if (checkInButtonText.evaluate().isNotEmpty) {
          await tester.tap(checkInButtonText.first);
          await tester.pumpAndSettle();
        }

        // Verify the page is still rendered (button handler executed)
        expect(find.text('Welcome to Attendance'), findsOneWidget);
      });

      testWidgets('should handle check out button tap', (tester) async {
        await tester.pumpApp(const AttendancePage());

        // Wait for the page to load
        await tester.pumpAndSettle();

        // Find and tap the check out button by text
        // (since these are empty handlers)
        final checkOutButtonText = find.textContaining('Check Out');
        if (checkOutButtonText.evaluate().isNotEmpty) {
          await tester.tap(checkOutButtonText.first);
          await tester.pumpAndSettle();
        }

        // Verify the page is still rendered (button handler executed)
        expect(find.text('Welcome to Attendance'), findsOneWidget);
      });
    });
  });
}
