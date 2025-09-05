import 'package:flutter_test/flutter_test.dart';

import 'setup_hook.dart';

export 'setup_hook.dart' show setupHook, teardownHook;

/// BDD Test Configuration
/// This file provides global test setup and teardown hooks for all BDD tests
/// It ensures GetIt is properly reset between test scenarios
///
/// Usage in BDD test files:
/// ```dart
/// import 'package:xp1/test/bdd/bdd_hooks/test_config.dart';
///
/// void main() {
///   group('Feature Name', () {
///     Future<void> bddSetUp(WidgetTester tester) async {
///       await setupHook(tester);
///     }
///
///     Future<void> bddTearDown(WidgetTester tester) async {
///       await teardownHook(tester);
///     }
///
///     testWidgets('Scenario description', (tester) async {
///       await bddSetUp(tester);
///       // Test implementation
///       await bddTearDown(tester);
///     });
///   });
/// }
/// ```

/// Global BDD test setup function
/// Call this in your BDD test setup to ensure proper initialization
Future<void> bddSetUp(WidgetTester tester) async {
  await setupHook(tester);
}

/// Global BDD test teardown function
/// Call this in your BDD test teardown to ensure proper cleanup
Future<void> bddTearDown(WidgetTester tester) async {
  await teardownHook(tester);
}
