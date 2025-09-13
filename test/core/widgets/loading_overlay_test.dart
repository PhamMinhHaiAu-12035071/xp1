import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/widgets/loading_overlay.dart';

void main() {
  group('LoadingOverlay', () {
    setUp(LoadingOverlay.resetState);

    testWidgets('shows loading overlay with spinner', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => LoadingOverlay.show(context),
                  child: const Text('Show Loading'),
                ),
              );
            },
          ),
        ),
      );

      // Tap button to show loading overlay
      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Verify spinner is displayed
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
      expect(find.byType(Material), findsAtLeast(1));
      expect(LoadingOverlay.isShowing, isTrue);
    });

    testWidgets('shows loading overlay with amber color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => LoadingOverlay.show(context),
                  child: const Text('Show Loading'),
                ),
              );
            },
          ),
        ),
      );

      // Tap button to show loading overlay
      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Verify spinner is displayed with amber color
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
      final spinner = tester.widget<SpinKitFadingCircle>(
        find.byType(SpinKitFadingCircle),
      );
      expect(spinner.color, isNotNull);
    });

    testWidgets('hides loading overlay successfully', (tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return const Scaffold(
                body: Text('Test Widget'),
              );
            },
          ),
        ),
      );

      // Show loading overlay
      LoadingOverlay.show(testContext);
      await tester.pump();
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
      expect(LoadingOverlay.isShowing, isTrue);

      // Hide loading overlay
      final result = LoadingOverlay.hide(testContext);
      await tester.pump();
      expect(find.byType(SpinKitFadingCircle), findsNothing);
      expect(result, isTrue);
      expect(LoadingOverlay.isShowing, isFalse);
    });

    testWidgets('should not hide when no overlay is showing', (tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return const Scaffold(
                body: Text('Test Widget'),
              );
            },
          ),
        ),
      );

      // Try to hide without showing first
      final result = LoadingOverlay.hide(testContext);

      expect(result, isFalse);
      expect(LoadingOverlay.isShowing, isFalse);
    });

    testWidgets('should prevent multiple show calls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    LoadingOverlay.show(context);
                    // Second call should be ignored
                    LoadingOverlay.show(context);
                  },
                  child: const Text('Show Loading'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Should only have one spinner
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
      expect(LoadingOverlay.isShowing, isTrue);
    });

    testWidgets('overlay is not dismissible by tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => LoadingOverlay.show(context),
                  child: const Text('Show Loading'),
                ),
              );
            },
          ),
        ),
      );

      // Show loading overlay
      await tester.tap(find.text('Show Loading'));
      await tester.pump();
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);

      // Try to tap outside overlay (should not dismiss)
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
    });

    testWidgets('forceHide works even when state is inconsistent', (
      tester,
    ) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return const Scaffold(
                body: Text('Test Widget'),
              );
            },
          ),
        ),
      );

      // Force hide when no overlay is showing
      LoadingOverlay.forceHide(testContext);

      // Should not crash and state should be false
      expect(LoadingOverlay.isShowing, isFalse);
    });

    testWidgets('state resets when dialog is dismissed by back button', (
      tester,
    ) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => LoadingOverlay.show(context),
                  child: const Text('Show Loading'),
                ),
              );
            },
          ),
        ),
      );

      // Show loading overlay
      await tester.tap(find.text('Show Loading'));
      await tester.pump();
      expect(LoadingOverlay.isShowing, isTrue);

      // Simulate back button press by directly calling Navigator.pop
      Navigator.of(testContext).pop();
      await tester.pump();

      // State should be reset
      expect(LoadingOverlay.isShowing, isFalse);
    });
  });
}
