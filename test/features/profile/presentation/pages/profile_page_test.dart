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
      'Hello World - Profile',
      () => const ProfilePage(),
      (key) => ProfilePage(key: key),
    );
  });
}
