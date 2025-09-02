import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/routing/app_router.dart';
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

  Future<void> pumpAppWithRouter() async {
    // Setup test dependencies before rendering widgets
    await TestDependencyContainer.setupTestDependencies();

    final appRouter = AppRouter();

    return pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter.config(),
      ),
    );
  }
}
