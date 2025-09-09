import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/atoms/orange_background.dart';

/// Tests for [OrangeBackground] atom component.
///
/// This atom should provide a simple orange background container
/// using the design system colors with full container coverage.
void main() {
  group('OrangeBackground', () {
    setUp(() {
      GetIt.instance.registerSingleton<AppColors>(const AppColorsImpl());
    });

    tearDown(() {
      GetIt.instance.reset();
    });
    testWidgets('should display orange background with design system color', (
      tester,
    ) async {
      // Arrange: Create the atom component
      const orangeBackground = OrangeBackground();

      // Act: Pump the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: orangeBackground,
          ),
        ),
      );

      // Assert: Verify the container exists with orange background
      expect(find.byType(Container), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;

      expect(decoration, isNotNull);
      expect(decoration!.color, isNotNull);
      // Verify exact design system color
      const appColors = AppColorsImpl();
      expect(decoration.color, equals(appColors.orangeNormal));
    });

    testWidgets('should take full available space by default', (tester) async {
      // Arrange: Create atom in a sized container
      const orangeBackground = OrangeBackground();

      // Act: Pump widget with constrained size
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 200,
              child: orangeBackground,
            ),
          ),
        ),
      );

      // Assert: Verify it takes full available space by checking render object
      final containerRenderObject = tester.renderObject(find.byType(Container));
      expect(containerRenderObject.paintBounds.width, equals(300));
      expect(containerRenderObject.paintBounds.height, equals(200));

      // Verify container is present
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should allow child widget overlay', (tester) async {
      // Arrange: Create atom with child
      const testChild = Text('Test Child');
      const orangeBackground = OrangeBackground(child: testChild);

      // Act: Pump the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: orangeBackground,
          ),
        ),
      );

      // Assert: Verify child is rendered
      expect(find.text('Test Child'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
