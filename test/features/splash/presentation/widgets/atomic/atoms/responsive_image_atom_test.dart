import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/atoms/responsive_image_atom.dart';

/// Tests for [ResponsiveImageAtom] atom component.
///
/// This atom should provide a simple interface for displaying images with
/// automatic responsive sizing and error handling. It wraps the
/// AssetImageService
/// functionality in a reusable atom.
void main() {
  group('ResponsiveImageAtom', () {
    testWidgets('should display image with automatic responsive sizing', (
      tester,
    ) async {
      // Arrange: Create the atom with path and dimensions
      const responsiveImage = ResponsiveImageAtom(
        imagePath: 'assets/images/placeholders/image_placeholder.png',
        width: 100,
        height: 100,
      );

      // Act: Pump the widget with ScreenUtil initialization
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: responsiveImage);
            },
          ),
        ),
      );

      // Assert: Verify the Image widget exists
      expect(find.byType(Image), findsOneWidget);

      // Verify image is being loaded
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
    });

    testWidgets('should handle error states with default fallback', (
      tester,
    ) async {
      // Arrange: Create atom with non-existent image path
      const responsiveImage = ResponsiveImageAtom(
        imagePath: 'assets/images/nonexistent.png',
        width: 50,
        height: 50,
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: responsiveImage);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should show broken image icon as fallback
      expect(find.byIcon(Icons.broken_image), findsOneWidget);

      // Verify icon has correct responsive size
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.broken_image));
      expect(iconWidget.size, equals(50.w));
    });

    testWidgets('should apply different BoxFit options', (tester) async {
      // Arrange: Create atom with BoxFit.cover
      const responsiveImage = ResponsiveImageAtom(
        imagePath: 'assets/images/placeholders/image_placeholder.png',
        width: 200,
        height: 150,
        fit: BoxFit.cover,
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: responsiveImage);
            },
          ),
        ),
      );

      // Assert: Verify Image widget with correct fit
      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, equals(BoxFit.cover));
    });

    testWidgets('should use default dimensions when not provided', (
      tester,
    ) async {
      // Arrange: Create atom without dimensions
      const responsiveImage = ResponsiveImageAtom(
        imagePath: 'assets/images/placeholders/image_placeholder.png',
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: responsiveImage);
            },
          ),
        ),
      );

      // Assert: Verify Image widget exists (will use default sizing)
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should work with semantic labels for accessibility', (
      tester,
    ) async {
      // Arrange: Create atom with semantic label
      const responsiveImage = ResponsiveImageAtom(
        imagePath: 'assets/images/placeholders/image_placeholder.png',
        width: 80,
        height: 80,
        semanticLabel: 'Profile picture',
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const Scaffold(body: responsiveImage);
            },
          ),
        ),
      );

      // Assert: Verify Image widget with semantic label
      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.semanticLabel, equals('Profile picture'));
    });
  });
}
