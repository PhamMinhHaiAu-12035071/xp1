import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/features/presentation/pages/features_page.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('FeaturesPage', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
    });

    // Use helper function to eliminate code duplication
    PageTestHelpers.testStandardPage<FeaturesPage>(
      const FeaturesPage(),
      'Welcome to Features',
      () => const FeaturesPage(),
      (key) => FeaturesPage(key: key),
    );
  });
}
