import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/statistics/presentation/pages/statistics_page.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('StatisticsPage', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
    });

    // Use helper function to eliminate code duplication
    PageTestHelpers.testStandardPage<StatisticsPage>(
      const StatisticsPage(),
      'Hello World - Statistics',
      () => const StatisticsPage(),
      (key) => StatisticsPage(key: key),
    );
  });
}
