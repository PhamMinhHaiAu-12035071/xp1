import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';
import 'package:xp1/features/splash/presentation/widgets/splash_content.dart';

import '../../../../helpers/test_injection_container.dart';

/// Tests for refactored SplashContent using Atomic Design principles.
///
/// Tests the new implementation that uses atomic design components:
/// - ImmersiveSystemContainer (molecule) for SystemUI management
/// - SplashLayout (organism) for complete layout composition
///
/// This eliminates the need to mock GetIt services since the widget
/// now uses pure composition of atomic components.
void main() {
  group('SplashContent (Atomic Design)', () {
    setUpAll(() async {
      // Setup test dependencies including AppImages and AssetImageService
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      // Clean up test dependencies
      await TestDependencyContainer.resetTestDependencies();
    });
    testWidgets('should render using atomic design composition', (
      tester,
    ) async {
      // Arrange: Create the refactored SplashContent
      const splashContent = SplashContent();

      // Act: Pump the widget with ScreenUtil initialization
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashContent);
            },
          ),
        ),
      );

      // Assert: Verify atomic design structure is rendered
      // Should have main structural components from atomic design
      expect(find.byType(SizedBox), findsWidgets); // FullScreenContainer
      expect(find.byType(Stack), findsWidgets); // Layout structure
      expect(find.byType(Container), findsOneWidget); // OrangeBackground
      expect(find.byType(Align), findsOneWidget); // PositionedSplashImage
      expect(find.byType(Image), findsOneWidget); // Background image
    });

    testWidgets(
      'should use ImmersiveSystemContainer molecule for SystemUI management',
      (tester) async {
        // Arrange: Create the SplashContent
        const splashContent = SplashContent();

        // Act: Pump the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                ScreenUtil.init(context, designSize: const Size(375, 812));
                return const Scaffold(body: splashContent);
              },
            ),
          ),
        );

        // Assert: Should not throw SystemUI-related exceptions
        expect(tester.takeException(), isNull);

        // Widget tree should be stable
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('should use SplashLayout organism for complete layout', (
      tester,
    ) async {
      // Arrange: Create the SplashContent
      const splashContent = SplashContent();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashContent);
            },
          ),
        ),
      );

      // Assert: Verify layout composition
      // Should have orange background
      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      const appColors = AppColorsImpl();
      expect(decoration!.color, equals(appColors.orangeNormal));

      // Should have positioned image
      expect(find.byType(Align), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle responsive design correctly', (tester) async {
      // Arrange: Create the SplashContent
      const splashContent = SplashContent();

      // Act: Pump the widget with specific screen size
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashContent);
            },
          ),
        ),
      );

      // Assert: Verify responsive layout
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.length, greaterThanOrEqualTo(1));

      // Find the SizedBox with full screen width (from PositionedSplashImage)
      final fullWidthSizedBox = sizedBoxes.firstWhere(
        (sizedBox) => sizedBox.width == 1.sw,
        orElse: () =>
            throw StateError('No SizedBox with full screen width found'),
      );
      expect(fullWidthSizedBox.width, equals(1.sw));

      // Verify responsive padding exists
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      expect(paddingWidgets.length, greaterThanOrEqualTo(1));
    });

    testWidgets('should display correct image positioning', (tester) async {
      // Arrange: Create the SplashContent
      const splashContent = SplashContent();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashContent);
            },
          ),
        ),
      );

      // Assert: Verify image positioning
      final alignWidgets = tester.widgetList<Align>(find.byType(Align));
      expect(alignWidgets, hasLength(1));

      // Should have the background alignment from design
      final alignments = alignWidgets
          .map((widget) => widget.alignment)
          .toList();
      expect(alignments, contains(const Alignment(0, -0.75))); // Background
    });

    testWidgets('should handle edge cases gracefully', (tester) async {
      // Arrange: Create the SplashContent
      const splashContent = SplashContent();

      // Act: Pump the widget with extreme small size
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(1, 1));
              return const Scaffold(body: splashContent);
            },
          ),
        ),
      );

      // Assert: Should not throw exceptions with extreme sizes
      expect(tester.takeException(), isNull);

      // Basic structure should still exist
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should maintain clean atomic design architecture', (
      tester,
    ) async {
      // Arrange: Create the SplashContent
      const splashContent = SplashContent();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashContent);
            },
          ),
        ),
      );

      // Assert: Verify atomic design benefits
      // 1. No complex dependencies - no GetIt service calls needed
      // 2. Pure composition - widget tree is predictable
      // 3. Reusable components - atoms/molecules can be tested separately
      // 4. Single responsibility - each component has one job

      // Widget should render without complex setup
      expect(find.byWidget(splashContent), findsOneWidget);

      // Should be composable - can be used in other contexts
      expect(tester.takeException(), isNull);
    });
  });
}
