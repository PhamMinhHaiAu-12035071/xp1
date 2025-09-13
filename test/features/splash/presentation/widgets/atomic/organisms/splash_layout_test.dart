import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/organisms/splash_layout.dart';

import '../../../../../../helpers/test_injection_container.dart';

/// Tests for [SplashLayout] organism component.
///
/// This organism should compose atoms and molecules to create the complete
/// splash screen layout with orange background, full screen container,
/// and positioned splash background image.
void main() {
  group('SplashLayout', () {
    setUpAll(() async {
      // Setup test dependencies including AppImages and AssetImageService
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      // Clean up test dependencies
      await TestDependencyContainer.resetTestDependencies();
    });
    testWidgets('should render complete splash layout structure', (
      tester,
    ) async {
      // Arrange: Create the organism
      const splashLayout = SplashLayout();

      // Act: Pump the widget with ScreenUtil initialization
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      // Assert: Verify main structural components
      expect(find.byType(SizedBox), findsWidgets); // FullScreenContainer
      expect(
        find.byType(Stack),
        findsWidgets,
      ); // Layout structure (might include Scaffold)
      expect(find.byType(Container), findsOneWidget); // OrangeBackground
      expect(find.byType(Align), findsOneWidget); // PositionedSplashImage
      expect(find.byType(Image), findsOneWidget); // Background image
    });

    testWidgets('should display orange background', (tester) async {
      // Arrange: Create the organism
      const splashLayout = SplashLayout();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      // Assert: Verify orange background container exists
      expect(find.byType(Container), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.color, isNotNull);

      // Should be orange color (from OrangeBackground atom)
      const appColors = AppColorsImpl();
      expect(decoration.color, equals(appColors.orangeNormal));
    });

    testWidgets('should display background image', (tester) async {
      // Arrange: Create the organism
      const splashLayout = SplashLayout();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      // Assert: Should have 1 image (background)
      expect(find.byType(Image), findsOneWidget);

      // Should have 1 Align widget for positioning
      expect(find.byType(Align), findsOneWidget);

      // Should have padding widgets (Scaffold might add extras)
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('should position image correctly', (tester) async {
      // Arrange: Create the organism
      const splashLayout = SplashLayout();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      // Assert: Verify alignment position
      final alignWidgets = tester.widgetList<Align>(find.byType(Align));

      expect(alignWidgets, hasLength(1));

      // Should have the background alignment from original design
      final alignments = alignWidgets
          .map((widget) => widget.alignment)
          .toList();
      expect(
        alignments,
        contains(const Alignment(0, -0.75)),
      ); // Background position
    });

    testWidgets('should use full screen dimensions', (tester) async {
      // Arrange: Create the organism
      const splashLayout = SplashLayout();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      // Assert: Verify full screen sizing
      // Find all SizedBox widgets and verify at least one has full screen width
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.length, greaterThanOrEqualTo(1));

      // Find the SizedBox with full screen width (from PositionedSplashImage)
      final fullWidthSizedBox = sizedBoxes.firstWhere(
        (sizedBox) => sizedBox.width == 1.sw,
        orElse: () =>
            throw StateError('No SizedBox with full screen width found'),
      );
      expect(fullWidthSizedBox.width, equals(1.sw));
    });

    testWidgets('should handle image loading errors gracefully', (
      tester,
    ) async {
      // Arrange: Create the organism
      const splashLayout = SplashLayout();

      // Act: Pump the widget and wait for potential errors
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should still render layout structure even if images fail
      expect(
        find.byType(Stack),
        findsWidgets,
      ); // Layout structure (might include Scaffold)
      expect(find.byType(Container), findsOneWidget); // Orange background
      expect(find.byType(Align), findsOneWidget); // Positioning structure

      // Layout should be stable regardless of image loading status
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain responsive padding', (tester) async {
      // Arrange: Create the organism
      const splashLayout = SplashLayout();

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      // Assert: Verify responsive padding exists
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));

      expect(paddingWidgets.length, greaterThanOrEqualTo(1));

      // Find the image padding widgets (should have zero horizontal padding
      // now). There might be multiple padding widgets with zero padding, so
      // we just verify that at least one exists
      final imagePaddingWidgets = paddingWidgets.where((widget) {
        final edgeInsets = widget.padding as EdgeInsets;
        return edgeInsets.horizontal == 0;
      }).toList();

      expect(imagePaddingWidgets.length, greaterThanOrEqualTo(1));

      // Verify no horizontal padding for image widget
      for (final paddingWidget in imagePaddingWidgets) {
        final edgeInsets = paddingWidget.padding as EdgeInsets;
        expect(edgeInsets.horizontal, equals(0)); // No horizontal padding
      }
    });

    testWidgets('should cover full screen on iPad dimensions', (tester) async {
      // Arrange: Set test widget binding to iPad dimensions
      const ipadSize = Size(1366, 1024); // iPad Pro landscape
      await tester.binding.setSurfaceSize(ipadSize);
      await tester.pumpAndSettle();

      const splashLayout = SplashLayout();

      // Act: Pump the widget with iPad Pro landscape dimensions
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: ipadSize);
              return const Scaffold(body: splashLayout);
            },
          ),
        ),
      );

      // Wait for ScreenUtil initialization and layout
      await tester.pumpAndSettle();

      // Assert: Verify FullScreenContainer uses full screen dimensions
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.length, greaterThanOrEqualTo(1));

      // Find the SizedBox with full screen width (from PositionedSplashImage)
      final fullWidthSizedBox = sizedBoxes.firstWhere(
        (sizedBox) => sizedBox.width == ipadSize.width,
        orElse: () => throw StateError('No SizedBox with iPad width found'),
      );

      // On iPad, should cover actual screen dimensions from MediaQuery
      expect(fullWidthSizedBox.width, greaterThanOrEqualTo(1300)); // iPad width

      // Assert: Verify orange background container covers the full area
      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));

      // Get container's render object to check actual rendered size
      final containerRenderObject = tester.renderObject(find.byType(Container));
      final containerSize = containerRenderObject.paintBounds.size;

      // Container should cover the full screen area
      expect(containerSize.width, greaterThanOrEqualTo(1300)); // iPad width
      expect(containerSize.height, greaterThanOrEqualTo(1000)); // iPad height

      // Verify the container has the orange color
      final decoration = container.decoration! as BoxDecoration;
      const appColors = AppColorsImpl();
      expect(decoration.color, equals(appColors.orangeNormal));

      // Clean up: Reset surface size for other tests
      await tester.binding.setSurfaceSize(null);
    });
  });
}
