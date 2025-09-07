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
            return const MaterialApp(
              home: Scaffold(
                body: Text('Test Widget'),
              ),
            );
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
                home: Scaffold(
                  body: Text('Test Widget'),
                ),
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
      // This test simulates invalid constraints by creating a custom widget
      // that forces zero-width constraints
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

    group('Design Size Variations', () {
      testWidgets('should work with iPhone X dimensions', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(375, 812), // iPhone X
            builder: (context) => const MaterialApp(
              home: Scaffold(body: Text('iPhone X')),
            ),
          ),
        );

        expect(find.text('iPhone X'), findsOneWidget);
      });

      testWidgets('should work with iPhone 8 Plus dimensions', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(414, 736), // iPhone 8 Plus
            builder: (context) => const MaterialApp(
              home: Scaffold(body: Text('iPhone 8 Plus')),
            ),
          ),
        );

        expect(find.text('iPhone 8 Plus'), findsOneWidget);
      });

      testWidgets('should work with Android medium dimensions', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(360, 640), // Android medium
            builder: (context) => const MaterialApp(
              home: Scaffold(body: Text('Android Medium')),
            ),
          ),
        );

        expect(find.text('Android Medium'), findsOneWidget);
      });
    });
  });
}
