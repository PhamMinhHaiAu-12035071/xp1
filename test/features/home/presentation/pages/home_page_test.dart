import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/home/presentation/pages/home_page.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
      // Set consistent locale for testing
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
      // Reset to prevent interference with other tests
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    // Use helper function to eliminate code duplication
    PageTestHelpers.testStandardPage<HomePage>(
      const HomePage(),
      'Welcome to Home',
      () => const HomePage(),
      (key) => HomePage(key: key),
    );
  });
}
