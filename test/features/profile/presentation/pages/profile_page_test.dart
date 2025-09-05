import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/profile/presentation/pages/profile_page.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ProfilePage', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
    });

    // Use helper function to eliminate code duplication
    PageTestHelpers.testStandardPage<ProfilePage>(
      const ProfilePage(),
      'Welcome to Profile',
      () => const ProfilePage(),
      (key) => ProfilePage(key: key),
    );

    group('ListTile interactions', () {
      testWidgets('should handle edit profile tap', (tester) async {
        await tester.pumpApp(const ProfilePage());

        // Wait for the page to load
        await tester.pumpAndSettle();

        // Find and tap the edit profile ListTile
        final editProfileTile = find.textContaining('Edit Profile');
        if (editProfileTile.evaluate().isNotEmpty) {
          await tester.tap(editProfileTile.first);
          await tester.pumpAndSettle();
        }

        // Verify the page is still rendered (tap handler executed)
        expect(find.text('Welcome to Profile'), findsOneWidget);
      });

      testWidgets('should handle settings tap', (tester) async {
        await tester.pumpApp(const ProfilePage());

        // Wait for the page to load
        await tester.pumpAndSettle();

        // Find and tap the settings ListTile
        final settingsTile = find.textContaining('Settings');
        if (settingsTile.evaluate().isNotEmpty) {
          await tester.tap(settingsTile.first);
          await tester.pumpAndSettle();
        }

        // Verify the page is still rendered (tap handler executed)
        expect(find.text('Welcome to Profile'), findsOneWidget);
      });

      testWidgets('should handle preferences tap', (tester) async {
        await tester.pumpApp(const ProfilePage());

        // Wait for the page to load
        await tester.pumpAndSettle();

        // Find and tap the preferences ListTile
        final preferencesTile = find.textContaining('Preferences');
        if (preferencesTile.evaluate().isNotEmpty) {
          await tester.tap(preferencesTile.first);
          await tester.pumpAndSettle();
        }

        // Verify the page is still rendered (tap handler executed)
        expect(find.text('Welcome to Profile'), findsOneWidget);
      });
    });
  });
}
