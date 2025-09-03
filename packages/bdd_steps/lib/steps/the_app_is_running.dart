import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/l10n.dart';

/// Launches the app and waits for it to fully initialize.
///
/// This step definition pumps the main App widget and waits for all
/// initialization processes to complete, ensuring the app is in a
/// stable state for subsequent BDD test steps.
///
/// Ensures complete isolation from unit test pollution by force-resetting
/// GetIt and reinitializing with real dependencies.
///
/// [tester] The WidgetTester used to pump and interact with the app.
Future<void> theAppIsRunning(WidgetTester tester) async {
  // CRITICAL: Force clear ALL GetIt registrations including mocks
  // from page test setUpAll() callbacks
  await getIt.reset();

  // Brief pump to ensure GetIt reset completes before dependency injection
  await tester.pump();

  // Configure REAL dependencies
  await configureDependencies();

  // Create a fresh router instance for test isolation
  // This ensures each test starts with clean navigation state
  final freshRouter = AppRouter();

  // Pump a fresh app instance with new router to ensure clean state
  await tester.pumpWidget(
    MaterialApp.router(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: freshRouter.config(),
    ),
  );

  // Wait for all asynchronous operations, animations, and router initialization
  // to complete. This is more reliable than hardcoded delays as it adapts to
  // actual app initialization time on different machines/environments.
  await tester.pumpAndSettle();

  // Additional pump to ensure initial route is fully loaded
  // This ensures the login page is displayed when tests expect it
  await tester.pump();
  await tester.pumpAndSettle();
}
