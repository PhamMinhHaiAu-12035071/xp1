import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/widgets/widgets.dart';

void main() {
  group('ResponsiveInitializer', () {
    testWidgets('should initialize ScreenUtil with provided design size', (
      tester,
    ) async {
      // Arrange
      const designSize = Size(375, 812);
      var builderCalled = false;

      // Act
      await tester.pumpWidget(
        ResponsiveInitializer(
          designSize: designSize,
          builder: (context) {
            builderCalled = true;
            return const MaterialApp(home: Scaffold(body: Text('Test Widget')));
          },
        ),
      );

      // Assert
      expect(builderCalled, isTrue);
      expect(find.text('Test Widget'), findsOneWidget);

      // Verify ScreenUtil was initialized (check if we can use responsive
      // values)
      expect(() => 100.w, returnsNormally);
      expect(() => 100.h, returnsNormally);
    });

    testWidgets(
      'should use constraint dimensions when no design size provided',
      (tester) async {
        // Arrange
        var builderCalled = false;

        // Act
        await tester.pumpWidget(
          ResponsiveInitializer(
            builder: (context) {
              builderCalled = true;
              return const MaterialApp(
                home: Scaffold(body: Text('Test Widget')),
              );
            },
          ),
        );

        // Assert
        expect(builderCalled, isTrue);
        expect(find.text('Test Widget'), findsOneWidget);

        // Verify ScreenUtil was initialized
        expect(() => 100.w, returnsNormally);
        expect(() => 100.h, returnsNormally);
      },
    );

    testWidgets('should return nil widget when constraints are invalid', (
      tester,
    ) async {
      // This test simulates invalid constraints by wrapping in a widget
      // that provides zero constraints
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox.shrink(
              child: ResponsiveInitializer(
                builder: (context) => const Text('Should not appear'),
              ),
            ),
          ),
        ),
      );

      // The builder should not be called when constraints are invalid
      expect(find.text('Should not appear'), findsNothing);

      // Verify that nil widget is returned
      expect(find.byType(ResponsiveInitializer), findsOneWidget);
    });

    testWidgets('should handle MediaQuery correctly', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ResponsiveInitializer(
          designSize: const Size(414, 736),
          builder: (context) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  final mediaQuery = MediaQuery.of(context);
                  return Text('Size: ${mediaQuery.size}');
                },
              ),
            ),
          ),
        ),
      );

      // Assert - The widget should handle MediaQuery properly
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should initialize ScreenUtil with valid responsive values', (
      tester,
    ) async {
      // Arrange
      const designSize = Size(375, 812);
      var builderCalled = false;
      double? responsiveWidth;
      double? responsiveHeight;

      // Act
      await tester.pumpWidget(
        ResponsiveInitializer(
          designSize: designSize,
          builder: (context) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  builderCalled = true;
                  // Test that we can use responsive values
                  responsiveWidth = 100.w;
                  responsiveHeight = 100.h;

                  return Column(
                    children: [
                      Text('Responsive width: ${responsiveWidth?.toInt()}'),
                      Text('Responsive height: ${responsiveHeight?.toInt()}'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(builderCalled, isTrue);
      expect(responsiveWidth, isNotNull);
      expect(responsiveHeight, isNotNull);
      expect(responsiveWidth! > 0, isTrue);
      expect(responsiveHeight! > 0, isTrue);

      // Verify the text widgets are displayed
      expect(find.byType(Text), findsNWidgets(2));

      // Verify ScreenUtil methods work
      expect(() => 50.sp, returnsNormally); // Font size
      expect(() => 10.r, returnsNormally); // Radius
    });

    group('Design Size Variations', () {
      testWidgets('should work with iPhone X dimensions', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(375, 812), // iPhone X
            builder: (context) =>
                const MaterialApp(home: Scaffold(body: Text('iPhone X'))),
          ),
        );

        expect(find.text('iPhone X'), findsOneWidget);
        // Verify ScreenUtil is properly initialized
        expect(() => 100.w, returnsNormally);
      });

      testWidgets('should work with iPhone 8 Plus dimensions', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(414, 736), // iPhone 8 Plus
            builder: (context) =>
                const MaterialApp(home: Scaffold(body: Text('iPhone 8 Plus'))),
          ),
        );

        expect(find.text('iPhone 8 Plus'), findsOneWidget);
        // Verify ScreenUtil is properly initialized
        expect(() => 100.h, returnsNormally);
      });

      testWidgets('should work with Android medium dimensions', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(360, 640), // Android medium
            builder: (context) =>
                const MaterialApp(home: Scaffold(body: Text('Android Medium'))),
          ),
        );

        expect(find.text('Android Medium'), findsOneWidget);
        // Verify ScreenUtil is properly initialized
        expect(() => 50.sp, returnsNormally);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very small design sizes', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(100, 100), // Very small
            builder: (context) =>
                const MaterialApp(home: Scaffold(body: Text('Small Design'))),
          ),
        );

        expect(find.text('Small Design'), findsOneWidget);
        expect(() => 10.w, returnsNormally);
      });

      testWidgets('should handle very large design sizes', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(1920, 1080), // Large desktop
            builder: (context) =>
                const MaterialApp(home: Scaffold(body: Text('Large Design'))),
          ),
        );

        expect(find.text('Large Design'), findsOneWidget);
        expect(() => 100.w, returnsNormally);
      });

      testWidgets('should handle null design size gracefully', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            // Should use constraint dimensions when no designSize provided
            builder: (context) =>
                const MaterialApp(home: Scaffold(body: Text('No Design Size'))),
          ),
        );

        expect(find.text('No Design Size'), findsOneWidget);
        expect(() => 50.w, returnsNormally);
        expect(() => 50.h, returnsNormally);
      });
    });
  });
}
