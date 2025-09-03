import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/app/app.dart';
import 'package:xp1/core/di/injection_container.dart';

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
  
  // Small delay to ensure async operations complete
  await tester.pump(const Duration(milliseconds: 50));
  
  // Configure REAL dependencies
  await configureDependencies();
  
  await tester.pumpWidget(const App());
  await tester.pumpAndSettle();

  // Extended settling for router initialization
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
}
