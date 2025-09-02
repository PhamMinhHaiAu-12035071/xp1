import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/home/presentation/pages/home_page.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
    });

    // Use helper function to eliminate code duplication
    PageTestHelpers.testStandardPage<HomePage>(
      const HomePage(),
      'Hello World - Home',
      () => const HomePage(),
      (key) => HomePage(key: key),
    );
  });
}
