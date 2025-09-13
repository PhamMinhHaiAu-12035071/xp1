import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/widgets/atoms/primary_button.dart';
import 'package:xp1/core/widgets/atoms/responsive_initializer.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('PrimaryButton', () {
    setUpAll(TestDependencyContainer.setupTestDependencies);
    tearDownAll(TestDependencyContainer.resetTestDependencies);

    Widget createTestWidget({
      required Widget child,
    }) {
      return ResponsiveInitializer(
        designSize: const Size(375, 812),
        builder: (context) => MaterialApp(
          home: Scaffold(
            body: Center(child: child),
          ),
        ),
      );
    }

    group('Basic Functionality', () {
      testWidgets('should display provided text', (tester) async {
        // Arrange
        const buttonText = 'Test Button';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: buttonText),
          ),
        );

        // Assert
        expect(find.text(buttonText), findsOneWidget);
      });

      testWidgets('should call onTap when button is pressed', (tester) async {
        // Arrange
        var tapCount = 0;
        void onTap() => tapCount++;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Tap Me',
              onTap: onTap,
            ),
          ),
        );

        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, 1);
      });

      testWidgets('should have correct default size', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: 'Test'),
          ),
        );

        // Assert
        final container = find.byType(Container).first;
        final containerWidget = tester.widget<Container>(container);
        expect(containerWidget.constraints?.maxWidth, double.infinity);
      });
    });

    group('Loading State', () {
      testWidgets('should show loading indicator when isLoading is true', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(
              text: 'Loading',
              isLoading: true,
            ),
          ),
        );

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading'), findsNothing);
      });

      testWidgets('should not call onTap when loading', (tester) async {
        // Arrange
        var tapCount = 0;
        void onTap() => tapCount++;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Loading Button',
              onTap: onTap,
              isLoading: true,
            ),
          ),
        );

        await tester.tap(find.byType(PrimaryButton));
        await tester.pump();

        // Assert
        expect(tapCount, 0);
      });

      testWidgets('should hide loading indicator when isLoading is false', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(
              text: 'Not Loading',
            ),
          ),
        );

        // Assert
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Not Loading'), findsOneWidget);
      });
    });

    group('Disabled State', () {
      testWidgets('should not call onTap when isDisabled is true', (
        tester,
      ) async {
        // Arrange
        var tapCount = 0;
        void onTap() => tapCount++;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Disabled Button',
              onTap: onTap,
              isDisabled: true,
            ),
          ),
        );

        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, 0);
      });

      testWidgets('should not call onTap when onTap is null', (tester) async {
        // Act & Assert - Should not throw when tapping
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(
              text: 'No Callback',
            ),
          ),
        );

        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        // No exception should be thrown
        expect(find.text('No Callback'), findsOneWidget);
      });

      testWidgets(
        'should call onTap when isDisabled is false and onTap exists',
        (tester) async {
          // Arrange
          var tapCount = 0;
          void onTap() => tapCount++;

          // Act
          await tester.pumpWidget(
            createTestWidget(
              child: PrimaryButton(
                text: 'Enabled Button',
                onTap: onTap,
              ),
            ),
          );

          await tester.tap(find.byType(PrimaryButton));
          await tester.pumpAndSettle();

          // Assert
          expect(tapCount, 1);
        },
      );
    });

    group('Combined States', () {
      testWidgets('should prioritize loading state over disabled state', (
        tester,
      ) async {
        // Arrange
        var tapCount = 0;
        void onTap() => tapCount++;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Loading Disabled',
              onTap: onTap,
              isLoading: true,
              isDisabled: true,
            ),
          ),
        );

        // Assert - Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading Disabled'), findsNothing);

        // Should not respond to taps
        await tester.tap(find.byType(PrimaryButton));
        await tester.pump();
        expect(tapCount, 0);
      });

      testWidgets('should be disabled when both isLoading and isDisabled false '
          'but onTap null', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(
              text: 'Null Callback',
            ),
          ),
        );

        // Should not throw on tap
        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        // Assert - text should still be visible
        expect(find.text('Null Callback'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    group('Visual Components', () {
      testWidgets('should contain Material and InkWell for ripple effect', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: 'Ripple Test'),
          ),
        );

        // Assert
        expect(find.byType(Material), findsAtLeastNWidgets(1));
        expect(find.byType(InkWell), findsAtLeastNWidgets(1));
      });

      testWidgets('should have proper container structure', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: 'Structure Test'),
          ),
        );

        // Assert - Check for nested Container structure
        expect(find.byType(Container), findsAtLeastNWidgets(2));
        expect(find.byType(AnimatedContainer), findsOneWidget);
      });

      testWidgets('should show white text color', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'White Text',
              onTap: () {}, // Provide callback to enable button
            ),
          ),
        );

        // Assert
        final defaultTextStyleFinder = find.ancestor(
          of: find.text('White Text'),
          matching: find.byType(AnimatedDefaultTextStyle),
        );

        expect(defaultTextStyleFinder, findsAtLeastNWidgets(1));

        final defaultTextStyle = tester.widget<AnimatedDefaultTextStyle>(
          defaultTextStyleFinder.first,
        );

        // Text should have white color in enabled state
        expect(defaultTextStyle.style.color, Colors.white);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty text string', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: ''),
          ),
        );

        // Assert - Should not crash
        expect(find.byType(PrimaryButton), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle very long text', (tester) async {
        // Arrange
        const longText =
            'This is a very long button text that might '
            'overflow the button container and cause layout issues';

        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: longText),
          ),
        );

        // Assert - Should not crash and text should be found
        expect(find.byType(PrimaryButton), findsOneWidget);
        expect(find.text(longText), findsOneWidget);
      });

      testWidgets('should handle rapid state changes', (tester) async {
        // Arrange
        var tapCount = 0;
        void onTap() => tapCount++;

        // Act - Create widget with initial state
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Rapid Change',
              onTap: onTap,
            ),
          ),
        );

        // Change to loading
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Rapid Change',
              onTap: onTap,
              isLoading: true,
            ),
          ),
        );
        await tester.pump();

        // Change to disabled
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Rapid Change',
              onTap: onTap,
              isDisabled: true,
            ),
          ),
        );
        await tester.pump();

        // Change back to enabled
        await tester.pumpWidget(
          createTestWidget(
            child: PrimaryButton(
              text: 'Rapid Change',
              onTap: onTap,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Test tap after rapid changes
        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        // Assert - Should work correctly after rapid changes
        expect(tapCount, 1);
        expect(find.text('Rapid Change'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    group('Animation Testing', () {
      testWidgets('should have animated container for state transitions', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: 'Animation Test'),
          ),
        );

        // Assert
        expect(find.byType(AnimatedContainer), findsAtLeastNWidgets(1));
        expect(find.byType(AnimatedDefaultTextStyle), findsAtLeastNWidgets(1));

        // Get the animated container
        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        // Check animation duration
        expect(animatedContainer.duration, const Duration(milliseconds: 300));
        expect(animatedContainer.curve, Curves.easeInOut);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            child: const PrimaryButton(text: 'Accessible Button'),
          ),
        );

        // Assert - Material and InkWell provide semantic information
        expect(find.byType(Material), findsAtLeastNWidgets(1));
        expect(find.byType(InkWell), findsAtLeastNWidgets(1));

        // Text should be readable by screen readers
        expect(find.text('Accessible Button'), findsOneWidget);
      });
    });
  });
}
