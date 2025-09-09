import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/atoms/fullscreen_container.dart';

/// Tests for [FullScreenContainer] atom component.
///
/// This atom should provide a container that takes full screen dimensions
/// using ScreenUtil responsive values (1.sw x 1.sh) and can display
/// a child widget.
void main() {
  group('FullScreenContainer', () {
    testWidgets('should take full screen dimensions using ScreenUtil', (
      tester,
    ) async {
      // Arrange: Create the atom component
      const fullScreenContainer = FullScreenContainer(
        child: Text('Test Content'),
      );

      // Act: Pump the widget with ScreenUtil initialization
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: fullScreenContainer,
              );
            },
          ),
        ),
      );

      // Assert: Verify the SizedBox exists with full screen dimensions
      expect(find.byType(SizedBox), findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

      // Should use 1.sw and 1.sh for full screen
      expect(sizedBox.width, equals(1.sw));
      expect(sizedBox.height, equals(1.sh));

      // Verify child content is rendered
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('should render child widget correctly', (tester) async {
      // Arrange: Create atom with specific child
      const testChild = Column(
        children: [
          Text('Title'),
          Text('Subtitle'),
        ],
      );
      const fullScreenContainer = FullScreenContainer(child: testChild);

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: fullScreenContainer,
              );
            },
          ),
        ),
      );

      // Assert: Verify both child texts are rendered
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should work without ScreenUtil initialization', (
      tester,
    ) async {
      // Arrange: Create atom without ScreenUtil init to test fallback
      const fullScreenContainer = FullScreenContainer(
        child: Text('Fallback Test'),
      );

      // Act: Pump widget without ScreenUtil initialization
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fullScreenContainer,
          ),
        ),
      );

      // Assert: Should not crash and should render content
      expect(find.text('Fallback Test'), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should handle complex child widgets', (tester) async {
      // Arrange: Create atom with complex child structure
      const complexChild = Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(color: Colors.blue),
          ),
          Center(
            child: Text('Centered Text'),
          ),
        ],
      );
      const fullScreenContainer = FullScreenContainer(child: complexChild);

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: fullScreenContainer,
              );
            },
          ),
        ),
      );

      // Assert: Verify complex structure is rendered
      expect(find.byType(ColoredBox), findsOneWidget);
      expect(find.text('Centered Text'), findsOneWidget);

      // Verify the FullScreenContainer contains the content
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
      'should handle infinite width constraints (line 25 coverage)',
      (tester) async {
        // Arrange: Create a scenario with infinite width constraints
        const fullScreenContainer = FullScreenContainer(
          child: Text('Infinite Width Test'),
        );

        // Act: Pump widget inside a Column which provides infinite width
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                ScreenUtil.init(context, designSize: const Size(375, 812));
                return const Scaffold(
                  body: Column(
                    children: [
                      // Column provides infinite width constraints to children
                      fullScreenContainer,
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Assert: Widget should handle infinite width and fall back to
        // MediaQuery
        expect(find.text('Infinite Width Test'), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        final mediaQuery = MediaQuery.of(
          tester.element(find.byType(MaterialApp)),
        );
        // Should use MediaQuery.of(context).size.width when width is infinite
        expect(sizedBox.width, equals(mediaQuery.size.width));
      },
    );

    testWidgets(
      'should handle infinite height constraints (line 28 coverage)',
      (tester) async {
        // Arrange: Create a scenario with infinite height constraints
        const fullScreenContainer = FullScreenContainer(
          child: Text('Infinite Height Test'),
        );

        // Act: Pump widget inside a Row which provides infinite height
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                ScreenUtil.init(context, designSize: const Size(375, 812));
                return const Scaffold(
                  body: Row(
                    children: [
                      // Row provides infinite height constraints to children
                      fullScreenContainer,
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Assert: Widget should handle infinite height and fall back to
        // MediaQuery
        expect(find.text('Infinite Height Test'), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        final mediaQuery = MediaQuery.of(
          tester.element(find.byType(MaterialApp)),
        );
        // Should use MediaQuery.of(context).size.height when height is infinite
        expect(sizedBox.height, equals(mediaQuery.size.height));
      },
    );

    testWidgets(
      'should handle both infinite width and height constraints',
      (tester) async {
        // Arrange: Create a scenario with both infinite constraints
        const fullScreenContainer = FullScreenContainer(
          child: Text('Both Infinite Test'),
        );

        // Act: Pump widget inside SingleChildScrollView which can provide
        // infinite constraints
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                ScreenUtil.init(context, designSize: const Size(375, 812));
                return const Scaffold(
                  body: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: fullScreenContainer,
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // Assert: Widget should handle both infinite constraints
        expect(find.text('Both Infinite Test'), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        final mediaQuery = MediaQuery.of(
          tester.element(find.byType(MaterialApp)),
        );

        // Should use MediaQuery values when constraints are infinite
        expect(sizedBox.width, equals(mediaQuery.size.width));
        expect(sizedBox.height, equals(mediaQuery.size.height));
      },
    );
  });
}
