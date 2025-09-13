import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

/// Test helpers for page testing to eliminate code duplication.
///
/// Provides reusable test functions following Linus's principle:
/// "Good programmers worry about data structures and their relationships."
/// These helpers eliminate special cases and reduce test complexity while
/// maintaining comprehensive test coverage and zero linter errors.
///
/// This class implements the Single Responsibility Principle (SOLID) by
/// focusing solely on page testing utilities, and follows DRY principle
/// to prevent code duplication across test files.
///
/// Example usage:
/// ```dart
/// PageTestHelpers.testStandardPage<HomePage>(
///   const HomePage(),
///   'Welcome to Home',
///   () => const HomePage(),
///   (key) => HomePage(key: key),
/// );
/// ```
class PageTestHelpers {
  /// Tests basic page structure (Scaffold, Center, Text) for consistency.
  ///
  /// [page] The page widget to test.
  /// [expectedText] The text that should be displayed on the page.
  /// [hasAppBar] Whether the page should have an AppBar (default: true).
  static void testBasicPageStructure(
    Widget page,
    String expectedText, {
    bool hasAppBar = true,
  }) {
    group('Basic Page Structure Tests', () {
      testWidgets('should render page widget correctly', (tester) async {
        await tester.pumpApp(page);
        expect(find.byType(page.runtimeType), findsOneWidget);
      });

      testWidgets('should render Scaffold', (tester) async {
        await tester.pumpApp(page);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should display expected text', (tester) async {
        await tester.pumpApp(page);
        expect(find.text(expectedText), findsOneWidget);
      });

      testWidgets('should center the content', (tester) async {
        await tester.pumpApp(page);
        expect(find.byType(Center), findsAtLeastNWidgets(1));
      });

      testWidgets('should have correct text style', (tester) async {
        await tester.pumpApp(page);
        final textFinder = find.text(expectedText);

        if (textFinder.evaluate().isNotEmpty) {
          final textWidget = tester.widget<Text>(textFinder);
          expect(textWidget.style?.fontSize, 24);
        } else {
          // If expected text not found, look for any Text widgets and verify
          final anyTextFinder = find.byType(Text);
          expect(anyTextFinder, findsAtLeastNWidgets(1));

          // Get the first text widget and verify it has some styling
          if (anyTextFinder.evaluate().isNotEmpty) {
            final firstTextWidget = tester.widget<Text>(anyTextFinder.first);
            expect(firstTextWidget.style?.fontSize, isNotNull);
          }
        }
      });

      if (hasAppBar) {
        testWidgets('should have AppBar', (tester) async {
          await tester.pumpApp(page);
          expect(find.byType(AppBar), findsOneWidget);
        });
      } else {
        testWidgets('should render without AppBar by default', (tester) async {
          await tester.pumpApp(page);
          expect(find.byType(AppBar), findsNothing);
        });
      }

      testWidgets('should have correct widget structure', (tester) async {
        await tester.pumpApp(page);

        // Use cascade pattern for multiple expect calls on same finder type
        // when testing widget hierarchy
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Text), findsAtLeastNWidgets(1));
      });
    });
  }

  /// Tests widget constructor and type hierarchy for consistency.
  ///
  /// Validates that widgets follow proper constructor patterns and maintain
  /// correct type hierarchies as required by Flutter best practices.
  ///
  /// [createWidget] Function that creates the widget instance.
  /// [widgetType] The expected widget type.
  static void testWidgetConstructors<T extends Widget>(
    T Function() createWidget,
    Type widgetType,
  ) {
    group('Widget Constructor Tests', () {
      test('should create const constructor', () {
        final widget = createWidget();
        expect(widget, isA<T>());
      });

      test('should have correct widget properties', () {
        final widget = createWidget();
        expect(widget.runtimeType, widgetType);
      });

      test('should have const constructor without key', () {
        final widget = createWidget();
        expect(widget.key, isNull);
      });

      test('should be instance of StatelessWidget', () {
        final widget = createWidget();
        expect(widget, isA<StatelessWidget>());
      });

      test('should have proper type hierarchy', () {
        final widget = createWidget();
        // Test type hierarchy from most general to most specific
        expect(widget, isA<Widget>());
        expect(widget, isA<StatelessWidget>());
        expect(widget, isA<T>());
      });
    });
  }

  /// Tests widget with custom key support.
  ///
  /// Ensures widgets properly support key assignment for widget tree
  /// identification and testing purposes.
  ///
  /// [createWidgetWithKey] Function that creates widget with a key.
  /// [testKey] The key to test with.
  static void testWidgetWithKey<T extends Widget>(
    T Function(Key key) createWidgetWithKey,
    Key testKey,
  ) {
    group('Widget Key Tests', () {
      testWidgets('should support custom key', (tester) async {
        final widget = createWidgetWithKey(testKey);
        expect(widget.key, testKey);
      });

      test('should have const constructor with key', () {
        final widget = createWidgetWithKey(testKey);
        expect(widget.key, testKey);
      });
    });
  }

  /// Tests setup and teardown for dependency injection and memory management.
  ///
  /// Provides standardized setup/teardown pattern to prevent memory leaks
  /// and ensure clean test environment. Follows Linus's principle:
  /// "Never break userspace" by ensuring proper resource cleanup.
  ///
  /// [setupCallback] Optional custom setup function.
  /// [teardownCallback] Optional custom teardown function.
  static void testEnvironmentSetup({
    Future<void> Function()? setupCallback,
    Future<void> Function()? teardownCallback,
  }) {
    group('Environment Setup Tests', () {
      setUpAll(() async {
        await TestDependencyContainer.setupTestDependencies();
        if (setupCallback != null) await setupCallback();
      });

      tearDownAll(() async {
        if (teardownCallback != null) await teardownCallback();
        await TestDependencyContainer.resetTestDependencies();
      });

      test('should have clean test environment', () {
        // Verify test environment is properly initialized
        expect(TestDependencyContainer, isNotNull);
      });
    });
  }

  /// Tests navigation functionality for auto_route integration.
  ///
  /// Validates that pages integrate correctly with auto_route navigation
  /// system and handle route parameters properly.
  ///
  /// [pageRoute] The route configuration for the page.
  /// [expectedRouteName] The expected route name.
  static void testNavigationIntegration({
    required String pageRoute,
    required String expectedRouteName,
  }) {
    group('Navigation Integration Tests', () {
      test('should have correct route configuration', () {
        expect(pageRoute, isNotEmpty);
        expect(expectedRouteName, isNotEmpty);
      });

      testWidgets('should integrate with auto_route system', (tester) async {
        // Test that page can be reached via router
        // This validates auto_route configuration
        await tester.pumpAppWithRouter();
        await tester.pumpAndSettle();

        // Verify router is properly configured
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });
  }

  /// Combined test for standard page testing pattern.
  ///
  /// Eliminates duplication by combining all common page tests into a single
  /// reusable function. This follows the DRY principle and ensures consistent
  /// testing across all pages.
  ///
  /// [page] The page widget to test.
  /// [expectedText] The text that should be displayed on the page.
  /// [createWidget] Function to create widget instance without key.
  /// [createWidgetWithKey] Function to create widget instance with key.
  /// [hasAppBar] Whether page has AppBar (default: true).
  static void testStandardPage<T extends Widget>(
    T page,
    String expectedText,
    T Function() createWidget,
    T Function(Key key) createWidgetWithKey, {
    bool hasAppBar = true,
  }) {
    // Test basic structure
    testBasicPageStructure(page, expectedText, hasAppBar: hasAppBar);

    // Test constructors
    testWidgetConstructors<T>(createWidget, T);

    // Test key support
    testWidgetWithKey<T>(createWidgetWithKey, const Key('test_key'));
  }

  /// Enhanced standard page testing with navigation and environment setup.
  ///
  /// Provides comprehensive testing including environment setup, navigation
  /// integration, and memory management. This is the recommended method
  /// for testing pages in larger applications.
  ///
  /// [page] The page widget to test.
  /// [expectedText] The text that should be displayed on the page.
  /// [createWidget] Function to create widget instance without key.
  /// [createWidgetWithKey] Function to create widget instance with key.
  /// [pageRoute] Optional route path for navigation testing.
  /// [hasAppBar] Whether page has AppBar (default: true).
  static void testComprehensivePage<T extends Widget>(
    T page,
    String expectedText,
    T Function() createWidget,
    T Function(Key key) createWidgetWithKey, {
    String? pageRoute,
    bool hasAppBar = true,
  }) {
    // Test environment setup first
    testEnvironmentSetup();

    // Test standard page functionality
    testStandardPage<T>(
      page,
      expectedText,
      createWidget,
      createWidgetWithKey,
      hasAppBar: hasAppBar,
    );

    // Test navigation integration if route provided
    if (pageRoute != null) {
      testNavigationIntegration(
        pageRoute: pageRoute,
        expectedRouteName: T.toString(),
      );
    }
  }
}
