import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/mixins/loading_mixin.dart';
import 'package:xp1/core/widgets/molecules/loading_overlay.dart';

class TestClassWithLoadingMixin with LoadingMixin {
  Future<String> simulateAsyncOperation() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return 'Operation completed';
  }

  Future<String> simulateFailingOperation() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    throw Exception('Operation failed');
  }
}

void main() {
  group('LoadingMixin', () {
    late TestClassWithLoadingMixin testClass;

    setUp(() {
      testClass = TestClassWithLoadingMixin();
      LoadingOverlay.resetState();
    });

    testWidgets('showLoading displays loading overlay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => testClass.showLoading(context),
                  child: const Text('Show Loading'),
                ),
              );
            },
          ),
        ),
      );

      // Tap button to show loading
      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Verify loading overlay is displayed
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
    });

    testWidgets('hideLoading removes loading overlay successfully', (
      tester,
    ) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return const Scaffold(body: Text('Test Widget'));
            },
          ),
        ),
      );

      // Show loading overlay
      testClass.showLoading(testContext);
      await tester.pump();
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
      expect(testClass.isLoadingShowing, isTrue);

      // Hide loading overlay
      final result = testClass.hideLoading(testContext);
      await tester.pump();
      expect(find.byType(SpinKitFadingCircle), findsNothing);
      expect(result, isTrue);
      expect(testClass.isLoadingShowing, isFalse);
    });

    testWidgets('hideLoading returns false when no overlay is showing', (
      tester,
    ) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return const Scaffold(body: Text('Test Widget'));
            },
          ),
        ),
      );

      // Try to hide without showing first
      final result = testClass.hideLoading(testContext);

      expect(result, isFalse);
      expect(testClass.isLoadingShowing, isFalse);
    });

    testWidgets('withLoading executes operation with loading state', (
      tester,
    ) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await testClass.withLoading(
                      context,
                      testClass.simulateAsyncOperation(),
                    );
                  },
                  child: const Text('Execute Operation'),
                ),
              );
            },
          ),
        ),
      );

      // Start the operation
      await tester.tap(find.text('Execute Operation'));
      await tester.pump();

      // Verify loading is shown during operation
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);

      // Wait for operation to complete
      await tester.pumpAndSettle();

      // Verify loading is hidden and result is correct
      expect(find.byType(SpinKitFadingCircle), findsNothing);
      expect(result, equals('Operation completed'));
    });

    testWidgets('withLoading hides loading even when operation fails', (
      tester,
    ) async {
      Object? caughtError;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    try {
                      await testClass.withLoading(
                        context,
                        testClass.simulateFailingOperation(),
                      );
                    } on Exception catch (e) {
                      caughtError = e;
                    }
                  },
                  child: const Text('Execute Failing Operation'),
                ),
              );
            },
          ),
        ),
      );

      // Start the failing operation
      await tester.tap(find.text('Execute Failing Operation'));
      await tester.pump();

      // Verify loading is shown
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);

      // Wait for operation to fail
      await tester.pumpAndSettle();

      // Verify loading is hidden even after failure
      expect(find.byType(SpinKitFadingCircle), findsNothing);
      expect(caughtError, isA<Exception>());
    });

    testWidgets('withLoading executes operation with loading state', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    await testClass.withLoading(
                      context,
                      testClass.simulateAsyncOperation(),
                    );
                  },
                  child: const Text('Execute Operation'),
                ),
              );
            },
          ),
        ),
      );

      // Start operation
      await tester.tap(find.text('Execute Operation'));
      await tester.pump();

      // Verify loading spinner is displayed
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);

      // Wait for operation to complete
      await tester.pumpAndSettle();
    });
  });
}
