import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/di/injection_container.dart';

/// Setup hook: Executed before each scenario
/// Resets GetIt container to ensure clean state for each test
Future<void> setupHook(WidgetTester tester) async {
  // Ensure Flutter test bindings are initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize mock SharedPreferences to prevent hanging
  SharedPreferences.setMockInitialValues({});

  // Force reset GetIt to clear any cached instances
  await getIt.reset();

  // Brief pump to ensure reset completes
  await tester.pump();
}

/// Teardown hook: Executed after each scenario
/// Ensures clean state for next test
Future<void> teardownHook(WidgetTester tester) async {
  // Reset GetIt container after test
  await getIt.reset();

  // Brief pump to ensure cleanup completes
  await tester.pump();
}
