import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/l10n/l10n.dart';

import 'test_injection_container.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    // Setup test dependencies before rendering widgets
    await TestDependencyContainer.setupTestDependencies();

    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
