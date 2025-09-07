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
      expect(iconWidget.size, equals(24.w)); // Default fallback size
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
  });
}
