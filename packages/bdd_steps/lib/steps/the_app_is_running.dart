import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Mock storage for HydratedBloc testing in BDD scenarios.
class MockStorage extends Mock implements Storage {}

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
  // Ensure Flutter test bindings are initialized
  // This is idempotent, so safe to call multiple times
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize mock SharedPreferences for dependency injection
  // Required for AppModule which uses SharedPreferences.getInstance()
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});

  // CRITICAL: Initialize HydratedBloc storage before any HydratedCubit creation
  // This prevents "Storage was accessed before it was initialized" errors
  final mockStorage = MockStorage();
  when(() => mockStorage.read(any())).thenReturn(null);
  when(() => mockStorage.write(any(), any<dynamic>())).thenAnswer((_) async {});
  when(() => mockStorage.delete(any())).thenAnswer((_) async {});
  when(mockStorage.clear).thenAnswer((_) async {});
  HydratedBloc.storage = mockStorage;

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
      supportedLocales: AppLocaleUtils.supportedLocales,
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
