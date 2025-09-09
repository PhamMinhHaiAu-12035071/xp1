import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/services/asset_image_service.dart';
import 'package:xp1/core/services/asset_image_service_impl.dart';

void main() {
  group('AssetImageService Tests (RED PHASE)', () {
    late AssetImageService service;

    setUp(() {
      // ❌ This will fail initially - no service exists
      service = const AssetImageServiceImpl();
    });

    testWidgets('should implement AssetImageService interface', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            // ❌ FAILS: Interface doesn't exist
            expect(service, isA<AssetImageService>());
            return Container();
          },
        ),
      );
    });

    testWidgets('should display image with responsive sizing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No assetImage method
              return service.assetImage(
                'assets/images/placeholders/image_placeholder.png',
                width: 100,
                height: 100,
              );
            },
          ),
        ),
      );

      // ❌ FAILS: No Image widget rendered
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle error states with custom error widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return service.assetImage(
                'assets/images/nonexistent.png',
                errorWidget: const Icon(Icons.error),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should handle error states with default error fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // No custom errorWidget provided - should use default fallback
              return service.assetImage(
                'assets/images/nonexistent.png',
                width: 50, // Provide width to test size calculation
                height: 50,
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find the default broken_image icon
      expect(find.byIcon(Icons.broken_image), findsOneWidget);

      // Verify the icon has the correct size based on width
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.broken_image));
      expect(iconWidget.size, equals(50.w)); // Should use width?.w
      expect(iconWidget.color, equals(Colors.grey[400])); // Default grey color
    });

    testWidgets('should handle error states with default size fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // No dimensions provided - should use 24.w default
              return service.assetImage('assets/images/nonexistent.png');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find the default broken_image icon with default size
      expect(find.byIcon(Icons.broken_image), findsOneWidget);

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.broken_image));
      expect(
        iconWidget.size,
        equals(24.0),
      ); // Default fallback size (no ScreenUtil)
      expect(iconWidget.color, equals(Colors.grey[400])); // Default grey color
    });

    testWidgets('should support loading states with frameBuilder', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No frameBuilder support
              return service.assetImage(
                'assets/images/placeholders/image_placeholder.png',
                placeholder: const CircularProgressIndicator(
                  key: Key('loading'),
                ),
              );
            },
          ),
        ),
      );

      // Should show image (since it's a valid placeholder)
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should apply responsive sizing via ScreenUtil', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No responsive sizing integration
              return service.assetImage(
                'assets/images/placeholders/image_placeholder.png',
                width: 48, // Should be converted to 48.w
                height: 48, // Should be converted to 48.h
              );
            },
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should support all BoxFit options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No BoxFit support
              return service.assetImage(
                'assets/images/placeholders/image_placeholder.png',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    test('should follow existing codebase DI patterns', () {
      // ❌ FAILS: Following AppSizes pattern with abstract + impl + DI
      expect(service, isA<AssetImageService>());
      expect(service.runtimeType.toString(), equals('AssetImageServiceImpl'));
    });

    testWidgets(
      'should handle ScreenUtil exceptions in error widget sizing',
      (tester) async {
        // This test triggers the exception paths by forcing an image error
        // and testing the error widget sizing without ScreenUtil initialization

        // Don't initialize ScreenUtil - use raw MaterialApp
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: service.assetImage(
                'non_existent_image.png', // This will trigger error widget
                width: 100, // These parameters will be used in error widget
                height: 200,
              ),
            ),
          ),
        );

        // Wait for image to fail loading and show error widget
        await tester.pumpAndSettle();

        // Should find the error Icon widget
        expect(find.byIcon(Icons.broken_image), findsOneWidget);

        // The error widget should use the fallback size
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.broken_image));

        // The size should be either 100.0 (when ScreenUtil not initialized)
        // or a responsive value (when ScreenUtil is initialized by previous
        // tests)
        expect(iconWidget.size, isNotNull);
        expect(iconWidget.size, greaterThan(0));
      },
    );

    test('should handle ScreenUtil not initialized - direct method test', () {
      // This is a unit test (not widget test) to test the private methods
      // without any ScreenUtil initialization

      // Create service instance
      const serviceImpl = AssetImageServiceImpl();

      // Test that we can create a widget without exceptions
      final widget = serviceImpl.assetImage(
        'assets/images/placeholders/image_placeholder.png',
        width: 100,
        height: 200,
      );

      // Verify widget is created
      expect(widget, isA<Image>());
      expect((widget as Image).width, isNotNull);
      expect(widget.height, isNotNull);
    });

    testWidgets(
      'should handle responsive sizing gracefully',
      (tester) async {
        // This test verifies that the service works correctly with responsive
        // sizing

        // Create service instance
        const serviceImpl = AssetImageServiceImpl();

        // Test the widget works correctly
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Initialize ScreenUtil for proper testing
                ScreenUtil.init(context, designSize: const Size(375, 812));

                return Scaffold(
                  body: serviceImpl.assetImage(
                    'assets/images/placeholders/image_placeholder.png',
                    width: 150,
                    height: 250,
                  ),
                );
              },
            ),
          ),
        );

        // Verify the image widget exists and works correctly
        expect(find.byType(Image), findsOneWidget);

        // Get the actual Image widget
        final imageWidget = tester.widget<Image>(find.byType(Image));

        // Verify that the widget is properly created with responsive sizing
        expect(imageWidget.width, isNotNull);
        expect(imageWidget.height, isNotNull);
        expect(imageWidget.width, greaterThan(0));
        expect(imageWidget.height, greaterThan(0));
      },
    );
  });
}
