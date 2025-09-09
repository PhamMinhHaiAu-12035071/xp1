import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/core/assets/app_images_impl.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/sizes/app_sizes_impl.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/app_text_styles_impl.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';

void main() {
  group('AppThemeContext Extension', () {
    late AppSizes testAppSizes;
    late AppColors testAppColors;
    late AppTextStyles testAppTextStyles;
    late AppImages testAppImages;

    setUp(() {
      testAppSizes = const AppSizesImpl();
      testAppColors = const AppColorsImpl();
      testAppTextStyles = const AppTextStylesImpl();
      testAppImages = const AppImagesImpl();
    });

    tearDown(() {
      GetIt.I.reset();
    });

    group('context.sizes', () {
      testWidgets('should return AppSizes from GetIt', (tester) async {
        // Arrange
        GetIt.I.registerSingleton<AppSizes>(testAppSizes);

        // Act & Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final sizes = context.sizes;
                expect(sizes, equals(testAppSizes));
                expect(sizes, isA<AppSizes>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('context.colors', () {
      testWidgets('should return AppColors from GetIt', (tester) async {
        // Arrange
        GetIt.I.registerSingleton<AppColors>(testAppColors);

        // Act & Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final colors = context.colors;
                expect(colors, equals(testAppColors));
                expect(colors, isA<AppColors>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('context.textStyles', () {
      testWidgets('should return AppTextStyles from GetIt', (tester) async {
        // Arrange
        GetIt.I.registerSingleton<AppTextStyles>(testAppTextStyles);

        // Act & Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final textStyles = context.textStyles;
                expect(textStyles, equals(testAppTextStyles));
                expect(textStyles, isA<AppTextStyles>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('context.images', () {
      testWidgets('should return AppImages from GetIt', (tester) async {
        // Arrange
        GetIt.I.registerSingleton<AppImages>(testAppImages);

        // Act & Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final images = context.images;
                expect(images, equals(testAppImages));
                expect(images, isA<AppImages>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('all extension methods together', () {
      testWidgets(
        'should provide access to all services through context',
        (tester) async {
          // Arrange
          GetIt.I
            ..registerSingleton<AppSizes>(testAppSizes)
            ..registerSingleton<AppColors>(testAppColors)
            ..registerSingleton<AppTextStyles>(testAppTextStyles)
            ..registerSingleton<AppImages>(testAppImages);

          // Act & Assert
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  // Test all extension methods are accessible
                  expect(context.sizes, isA<AppSizes>());
                  expect(context.colors, isA<AppColors>());
                  expect(context.textStyles, isA<AppTextStyles>());
                  expect(context.images, isA<AppImages>());

                  // Test that they return the correct instances
                  expect(context.sizes, equals(testAppSizes));
                  expect(context.colors, equals(testAppColors));
                  expect(context.textStyles, equals(testAppTextStyles));
                  expect(context.images, equals(testAppImages));

                  return Container();
                },
              ),
            ),
          );
        },
      );
    });

    group('extension method coverage', () {
      testWidgets('should cover all extension getters', (tester) async {
        // Arrange
        GetIt.I
          ..registerSingleton<AppSizes>(testAppSizes)
          ..registerSingleton<AppColors>(testAppColors)
          ..registerSingleton<AppTextStyles>(testAppTextStyles)
          ..registerSingleton<AppImages>(testAppImages);

        // Act & Assert - Test each extension getter for coverage
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Test context.sizes getter (line 12)
                final sizes = context.sizes;
                expect(sizes, isA<AppSizes>());

                // Test context.colors getter (line 15)
                final colors = context.colors;
                expect(colors, isA<AppColors>());

                // Test context.textStyles getter (line 18)
                final textStyles = context.textStyles;
                expect(textStyles, isA<AppTextStyles>());

                // Test context.images getter (line 21)
                final images = context.images;
                expect(images, isA<AppImages>());

                return const Placeholder();
              },
            ),
          ),
        );
      });
    });
  });
}
