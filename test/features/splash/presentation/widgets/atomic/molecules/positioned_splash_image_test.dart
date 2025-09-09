import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/molecules/positioned_splash_image.dart';

/// Tests for [PositionedSplashImage] molecule component.
///
/// This molecule should combine positioning logic with responsive image
/// display using Align widget and ResponsiveImageAtom. It handles the specific
/// positioning requirements for splash screen images with design ratio
/// constraints to maintain consistent proportions across all devices.
void main() {
  group('PositionedSplashImage', () {
    testWidgets('should position image with specified alignment', (
      tester,
    ) async {
      // Arrange: Create molecule with specific alignment
      const positionedImage = PositionedSplashImage(
        imagePath: 'assets/images/splash/logo.png',
        alignment: Alignment(0, -0.53), // 1/3 from top
        horizontalPadding: 16,
      );

      // Act: Pump the widget with ScreenUtil initialization
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: positionedImage,
              );
            },
          ),
        ),
      );

      // Assert: Verify Align widget exists with correct alignment
      expect(find.byType(Align), findsOneWidget);

      final alignWidget = tester.widget<Align>(find.byType(Align));
      expect(alignWidget.alignment, equals(const Alignment(0, -0.53)));

      // Verify Padding widget exists
      expect(find.byType(Padding), findsOneWidget);

      // Verify Image is rendered
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should apply responsive horizontal padding', (tester) async {
      // Arrange: Create molecule with specific padding
      const positionedImage = PositionedSplashImage(
        imagePath: 'assets/images/splash/background.png',
        alignment: Alignment.center,
        horizontalPadding: 24,
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: positionedImage,
              );
            },
          ),
        ),
      );

      // Assert: Verify padding is responsive
      expect(find.byType(Padding), findsOneWidget);

      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      final edgeInsets = paddingWidget.padding as EdgeInsets;
      // Verify padding is symmetric and responsive (actual value depends on
      // ScreenUtil scaling)
      expect(edgeInsets.left, equals(edgeInsets.right));
      expect(edgeInsets.left, greaterThan(0)); // Should be responsive > 0
    });

    testWidgets('should work with different alignment values', (tester) async {
      // Arrange: Create molecule with bottom alignment
      const positionedImage = PositionedSplashImage(
        imagePath: 'assets/images/splash/logo.png',
        alignment: Alignment(0, -0.18), // Different position
        horizontalPadding: 20,
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: positionedImage,
              );
            },
          ),
        ),
      );

      // Assert: Verify different alignment is applied
      final alignWidget = tester.widget<Align>(find.byType(Align));
      expect(alignWidget.alignment, equals(const Alignment(0, -0.18)));

      // Verify image still renders
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle image loading errors gracefully', (
      tester,
    ) async {
      // Arrange: Create molecule with non-existent image
      const positionedImage = PositionedSplashImage(
        imagePath: 'assets/images/nonexistent.png',
        alignment: Alignment.center,
        horizontalPadding: 16,
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: positionedImage,
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should show error fallback while maintaining positioning
      expect(find.byType(Align), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });

    testWidgets('should compose atoms correctly', (tester) async {
      // Arrange: Create molecule to test atom composition
      const positionedImage = PositionedSplashImage(
        imagePath: 'assets/images/splash/logo.png',
        alignment: Alignment.topCenter,
        horizontalPadding: 12,
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(
                body: positionedImage,
              );
            },
          ),
        ),
      );

      // Assert: Verify molecule structure
      // Should have Align -> Padding -> ResponsiveImageAtom
      expect(find.byType(Align), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // ResponsiveImageAtom content

      // Verify alignment is preserved
      final alignWidget = tester.widget<Align>(find.byType(Align));
      expect(alignWidget.alignment, equals(Alignment.topCenter));
    });

    group('Design Ratio Constraints', () {
      testWidgets(
        'should apply design ratio constraint to maintain proportions',
        (tester) async {
          // Arrange: Create molecule to test ratio constraint
          const positionedImage = PositionedSplashImage(
            imagePath: 'assets/images/splash/logo.png',
            alignment: Alignment.center,
            horizontalPadding: 16,
          );

          // Act: Pump the widget with standard design size
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  ScreenUtil.init(
                    context,
                    designSize: const Size(375, 812),
                  );
                  return const Scaffold(
                    body: positionedImage,
                  );
                },
              ),
            ),
          );

          // Assert: Verify SizedBox with ratio constraint exists
          expect(find.byType(SizedBox), findsOneWidget);

          final sizedBoxWidget = tester.widget<SizedBox>(find.byType(SizedBox));
          // Full screen width ratio (1.sw means 100% of screen width)
          const expectedRatio = 1.0;

          // Verify that width is constrained and proportional
          expect(sizedBoxWidget.width, isNotNull);
          expect(sizedBoxWidget.width! > 0, isTrue);

          // Verify ratio is approximately correct (allowing for ScreenUtil
          // scaling)
          final mediaQuery = MediaQuery.of(
            tester.element(find.byType(MaterialApp)),
          );
          final screenWidth = mediaQuery.size.width;
          final actualRatio = sizedBoxWidget.width! / screenWidth;
          expect(
            actualRatio,
            closeTo(
              expectedRatio,
              0.05,
            ), // Allow small tolerance for ScreenUtil
            reason: 'Width should maintain design ratio',
          );

          expect(
            sizedBoxWidget.height,
            isNull,
          ); // Height should be unconstrained
        },
      );

      testWidgets(
        'should maintain consistent ratio across different screen sizes',
        (tester) async {
          // Test data for different device sizes
          final testCases = [
            (screenSize: const Size(375, 812), deviceName: 'iPhone 13'),
            (screenSize: const Size(414, 896), deviceName: 'iPhone 13 Pro Max'),
            (screenSize: const Size(320, 568), deviceName: 'iPhone SE'),
            (screenSize: const Size(768, 1024), deviceName: 'iPad'),
            (screenSize: const Size(1024, 1366), deviceName: 'iPad Pro'),
          ];

          for (final testCase in testCases) {
            // Arrange: Create molecule for each screen size
            const positionedImage = PositionedSplashImage(
              imagePath: 'assets/images/splash/logo.png',
              alignment: Alignment.center,
              horizontalPadding: 20,
            );

            // Act: Pump widget with specific screen size
            await tester.pumpWidget(
              MaterialApp(
                home: Builder(
                  builder: (context) {
                    ScreenUtil.init(
                      context,
                      designSize: testCase.screenSize,
                    );
                    return const Scaffold(
                      body: positionedImage,
                    );
                  },
                ),
              ),
            );

            // Assert: Verify ratio behavior for this device
            final sizedBoxWidget = tester.widget<SizedBox>(
              find.byType(SizedBox),
            );

            // Verify width is constrained and positive
            expect(sizedBoxWidget.width, isNotNull);
            expect(sizedBoxWidget.width! > 0, isTrue);

            // Verify width is reasonable relative to screen size
            // (exact ratio may vary due to ScreenUtil scaling)
            final actualWidth = sizedBoxWidget.width!;
            final mediaQuery = MediaQuery.of(
              tester.element(find.byType(MaterialApp)),
            );
            expect(
              actualWidth,
              equals(mediaQuery.size.width),
              reason:
                  'Width should equal full screen width (1.sw) on '
                  '${testCase.deviceName}',
            );
            expect(
              actualWidth,
              greaterThan(0),
              reason:
                  'Width should be reasonable size on '
                  '${testCase.deviceName}',
            );
          }
        },
      );

      testWidgets(
        'should wrap ResponsiveImageAtom within ratio-constrained SizedBox',
        (tester) async {
          // Arrange: Create molecule to test widget structure
          const positionedImage = PositionedSplashImage(
            imagePath: 'assets/images/splash/logo.png',
            alignment: Alignment.center,
            horizontalPadding: 16,
          );

          // Act: Pump the widget
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  ScreenUtil.init(context, designSize: const Size(375, 812));
                  return const Scaffold(
                    body: positionedImage,
                  );
                },
              ),
            ),
          );

          // Assert: Verify correct widget hierarchy
          // Structure should be: Align -> Padding -> SizedBox ->
          // ResponsiveImageAtom
          expect(find.byType(Align), findsOneWidget);
          expect(find.byType(Padding), findsOneWidget);
          expect(find.byType(SizedBox), findsOneWidget);
          expect(find.byType(Image), findsOneWidget);

          // Verify SizedBox contains the image
          final sizedBoxWidget = tester.widget<SizedBox>(find.byType(SizedBox));
          expect(sizedBoxWidget.child, isNotNull);
        },
      );

      testWidgets(
        'should calculate width correctly with design ratio formula',
        (tester) async {
          // Arrange: Create molecule to test calculation accuracy
          const positionedImage = PositionedSplashImage(
            imagePath: 'assets/images/splash/logo.png',
            alignment: Alignment.center,
            horizontalPadding: 16,
          );

          // Act: Pump widget with known screen size
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  // Use exact design size for precise calculation
                  ScreenUtil.init(context, designSize: const Size(393, 812));
                  return const Scaffold(
                    body: positionedImage,
                  );
                },
              ),
            ),
          );

          // Assert: Verify calculation behavior
          final sizedBoxWidget = tester.widget<SizedBox>(find.byType(SizedBox));
          const designRatio = 1.0; // Full screen width

          // Verify width is constrained
          expect(sizedBoxWidget.width, isNotNull);
          expect(sizedBoxWidget.width! > 0, isTrue);

          // Verify width is proportional to the design ratio
          // (exact values may vary due to ScreenUtil behavior in tests)
          final mediaQuery = MediaQuery.of(
            tester.element(find.byType(MaterialApp)),
          );
          final screenWidth = mediaQuery.size.width;
          final actualRatio = sizedBoxWidget.width! / screenWidth;

          expect(
            actualRatio,
            closeTo(designRatio, 0.05), // Allow small tolerance for ScreenUtil
            reason: 'Ratio should approximate design specifications',
          );
        },
      );
    });
  });
}
