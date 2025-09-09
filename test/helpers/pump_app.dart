import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

import 'test_injection_container.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    // Setup test dependencies before rendering widgets
    await TestDependencyContainer.setupTestDependencies();

    return pumpWidget(
      MaterialApp(
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: widget,
      ),
    );
  }

  Future<void> pumpAppWithRouter() async {
    // Setup test dependencies before rendering widgets
    await TestDependencyContainer.setupTestDependencies();

    final appRouter = AppRouter();

    return pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852), // Standard design size for tests
        builder: (context, child) => MaterialApp.router(
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: appRouter.config(),
        ),
      ),
    );
  }
}
