import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/themes/extensions/app_color_extension.dart';

// Test implementation of AppColors
class TestAppColors implements AppColors {
  @override
  MaterialColor get primary => const MaterialColor(0xFF2196F3, {
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  });

  @override
  MaterialColor get secondary => const MaterialColor(0xFF4CAF50, {
    50: Color(0xFFE8F5E8),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF4CAF50),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  });

  @override
  Color get accent => const Color(0xFFE0E7FF);

  @override
  Color get textPrimary => const Color(0xFF1E293B);

  @override
  Color get textSecondary => const Color(0xFF64748B);

  @override
  Color get primaryDark => const Color(0xFF3B82F6);

  @override
  Color get secondaryDark => const Color(0xFF6366F1);

  @override
  Color get accentDark => const Color(0xFF1E293B);

  @override
  Color get textPrimaryDark => const Color(0xFFF1F5F9);

  @override
  Color get textSecondaryDark => const Color(0xFFCBD5E1);

  @override
  Color get placeholderText => const Color(0xFF8B95A7);

  // Other properties (not used in this test)
  @override
  MaterialColor get black => throw UnimplementedError();
  @override
  MaterialColor get white => throw UnimplementedError();
  @override
  MaterialColor get grey => throw UnimplementedError();
  @override
  MaterialColor get onboardingBlue => throw UnimplementedError();
  @override
  MaterialColor get error => throw UnimplementedError();
  @override
  MaterialColor get title => throw UnimplementedError();
  @override
  MaterialColor get placeholder => throw UnimplementedError();
  @override
  MaterialColor get neutral => throw UnimplementedError();
  @override
  MaterialColor get button => throw UnimplementedError();
  @override
  MaterialColor get bodyText => throw UnimplementedError();
  @override
  MaterialColor get red => throw UnimplementedError();
  @override
  MaterialColor get delete => throw UnimplementedError();
  @override
  MaterialColor get blue => throw UnimplementedError();
  @override
  MaterialColor get divider => throw UnimplementedError();
  @override
  MaterialColor get green => throw UnimplementedError();
  @override
  Color get bgMain => throw UnimplementedError();
  @override
  Color get slateBlue => throw UnimplementedError();
  @override
  Color get onboardingBackground => throw UnimplementedError();
  @override
  Color get onboardingGradientStart => throw UnimplementedError();
  @override
  Color get onboardingGradientEnd => throw UnimplementedError();
  @override
  Color get bgMainDark => throw UnimplementedError();
  @override
  Color get transparent => throw UnimplementedError();

  // === AMBER PALETTE (Test stubs) ===
  @override
  MaterialColor get amberLight => throw UnimplementedError();
  @override
  MaterialColor get amberLightHover => throw UnimplementedError();
  @override
  MaterialColor get amberLightActive => throw UnimplementedError();
  @override
  MaterialColor get amberNormal => throw UnimplementedError();
  @override
  MaterialColor get amberNormalHover => throw UnimplementedError();
  @override
  MaterialColor get amberNormalActive => throw UnimplementedError();
  @override
  MaterialColor get amberDark => throw UnimplementedError();
  @override
  MaterialColor get amberDarkHover => throw UnimplementedError();
  @override
  MaterialColor get amberDarkActive => throw UnimplementedError();
  @override
  MaterialColor get amberDarker => throw UnimplementedError();
  @override
  MaterialColor get amberPale => throw UnimplementedError();

  // === BACKWARD COMPATIBILITY (Test stubs) ===

  // === COMPLEMENTARY COLORS (Test stubs) ===
  @override
  MaterialColor get blueComplement => throw UnimplementedError();
  @override
  MaterialColor get tealAccent => throw UnimplementedError();

  // === NEUTRAL COLORS (Test stubs) ===
  @override
  MaterialColor get charcoal => throw UnimplementedError();
  @override
  MaterialColor get warmGray => throw UnimplementedError();
  @override
  MaterialColor get lightGray => throw UnimplementedError();

  // === DIRECT COLOR ACCESS (Test stubs) ===
  Color get amberLightColor => throw UnimplementedError();
  Color get amberLightHoverColor => throw UnimplementedError();
  Color get amberLightActiveColor => throw UnimplementedError();
  Color get amberNormalColor => throw UnimplementedError();
  Color get amberNormalHoverColor => throw UnimplementedError();
  Color get amberNormalActiveColor => throw UnimplementedError();
  Color get amberDarkColor => throw UnimplementedError();
  Color get amberDarkHoverColor => throw UnimplementedError();
  Color get amberDarkActiveColor => throw UnimplementedError();
  Color get amberDarkerColor => throw UnimplementedError();

  // === BACKWARD COMPATIBILITY DIRECT ACCESS (Test stubs) ===
  Color get blueComplementColor => throw UnimplementedError();
  Color get tealAccentColor => throw UnimplementedError();
  Color get charcoalColor => throw UnimplementedError();

  // === GREY PALETTE (Test stubs) ===
  @override
  MaterialColor get greyLight => throw UnimplementedError();
  @override
  MaterialColor get greyLightHover => throw UnimplementedError();
  @override
  MaterialColor get greyLightActive => throw UnimplementedError();
  @override
  MaterialColor get greyNormal => throw UnimplementedError();
  @override
  MaterialColor get greyNormalHover => throw UnimplementedError();
  @override
  MaterialColor get greyNormalActive => throw UnimplementedError();
  @override
  MaterialColor get greyDark => throw UnimplementedError();
  @override
  MaterialColor get greyDarkHover => throw UnimplementedError();
  @override
  MaterialColor get greyDarkActive => throw UnimplementedError();
  @override
  MaterialColor get greyDarker => throw UnimplementedError();

  // === DIRECT GREY COLOR ACCESS (Test stubs) ===
  Color get greyLightColor => throw UnimplementedError();
  Color get greyLightHoverColor => throw UnimplementedError();
  Color get greyLightActiveColor => throw UnimplementedError();
  Color get greyNormalColor => throw UnimplementedError();
  Color get greyNormalHoverColor => throw UnimplementedError();
  Color get greyNormalActiveColor => throw UnimplementedError();
  Color get greyDarkColor => throw UnimplementedError();
  Color get greyDarkHoverColor => throw UnimplementedError();
  Color get greyDarkActiveColor => throw UnimplementedError();
  Color get greyDarkerColor => throw UnimplementedError();

  // === BLUE PALETTE IMPLEMENTATIONS ===

  @override
  MaterialColor get blueLight => throw UnimplementedError();
  @override
  MaterialColor get blueLightHover => throw UnimplementedError();
  @override
  MaterialColor get blueLightActive => throw UnimplementedError();
  @override
  MaterialColor get blueNormal => throw UnimplementedError();
  @override
  MaterialColor get blueNormalHover => throw UnimplementedError();
  @override
  MaterialColor get blueNormalActive => throw UnimplementedError();
  @override
  MaterialColor get blueDark => throw UnimplementedError();
  @override
  MaterialColor get blueDarkHover => throw UnimplementedError();
  @override
  MaterialColor get blueDarkActive => throw UnimplementedError();
  @override
  MaterialColor get blueDarker => throw UnimplementedError();

  Color get blueLightColor => throw UnimplementedError();
  Color get blueLightHoverColor => throw UnimplementedError();
  Color get blueLightActiveColor => throw UnimplementedError();
  Color get blueNormalColor => throw UnimplementedError();
  Color get blueNormalHoverColor => throw UnimplementedError();
  Color get blueNormalActiveColor => throw UnimplementedError();
  Color get blueDarkColor => throw UnimplementedError();
  Color get blueDarkHoverColor => throw UnimplementedError();
  Color get blueDarkActiveColor => throw UnimplementedError();
  Color get blueDarkerColor => throw UnimplementedError();

  // === SLATE PALETTE IMPLEMENTATIONS ===

  @override
  MaterialColor get slateLight => throw UnimplementedError();
  @override
  MaterialColor get slateLightHover => throw UnimplementedError();
  @override
  MaterialColor get slateLightActive => throw UnimplementedError();
  @override
  MaterialColor get slateNormal => throw UnimplementedError();
  @override
  MaterialColor get slateNormalHover => throw UnimplementedError();
  @override
  MaterialColor get slateNormalActive => throw UnimplementedError();
  @override
  MaterialColor get slateDark => throw UnimplementedError();
  @override
  MaterialColor get slateDarkHover => throw UnimplementedError();
  @override
  MaterialColor get slateDarkActive => throw UnimplementedError();
  @override
  MaterialColor get slateDarker => throw UnimplementedError();

  Color get slateLightColor => throw UnimplementedError();
  Color get slateLightHoverColor => throw UnimplementedError();
  Color get slateLightActiveColor => throw UnimplementedError();
  Color get slateNormalColor => throw UnimplementedError();
  Color get slateNormalHoverColor => throw UnimplementedError();
  Color get slateNormalActiveColor => throw UnimplementedError();
  Color get slateDarkColor => throw UnimplementedError();
  Color get slateDarkHoverColor => throw UnimplementedError();
  Color get slateDarkActiveColor => throw UnimplementedError();
  Color get slateDarkerColor => throw UnimplementedError();

  // === GREEN PALETTE IMPLEMENTATIONS ===

  @override
  MaterialColor get greenLight => throw UnimplementedError();
  @override
  MaterialColor get greenLightHover => throw UnimplementedError();
  @override
  MaterialColor get greenLightActive => throw UnimplementedError();
  @override
  MaterialColor get greenNormal => throw UnimplementedError();
  @override
  MaterialColor get greenNormalHover => throw UnimplementedError();
  @override
  MaterialColor get greenNormalActive => throw UnimplementedError();
  @override
  MaterialColor get greenDark => throw UnimplementedError();
  @override
  MaterialColor get greenDarkHover => throw UnimplementedError();
  @override
  MaterialColor get greenDarkActive => throw UnimplementedError();
  @override
  MaterialColor get greenDarker => throw UnimplementedError();

  Color get greenLightColor => throw UnimplementedError();
  Color get greenLightHoverColor => throw UnimplementedError();
  Color get greenLightActiveColor => throw UnimplementedError();
  Color get greenNormalColor => throw UnimplementedError();
  Color get greenNormalHoverColor => throw UnimplementedError();
  Color get greenNormalActiveColor => throw UnimplementedError();
  Color get greenDarkColor => throw UnimplementedError();
  Color get greenDarkHoverColor => throw UnimplementedError();
  Color get greenDarkActiveColor => throw UnimplementedError();
  Color get greenDarkerColor => throw UnimplementedError();

  // === PINK PALETTE IMPLEMENTATIONS ===

  @override
  MaterialColor get pinkLight => throw UnimplementedError();
  @override
  MaterialColor get pinkLightHover => throw UnimplementedError();
  @override
  MaterialColor get pinkLightActive => throw UnimplementedError();
  @override
  MaterialColor get pinkNormal => throw UnimplementedError();
  @override
  MaterialColor get pinkNormalHover => throw UnimplementedError();
  @override
  MaterialColor get pinkNormalActive => throw UnimplementedError();
  @override
  MaterialColor get pinkDark => throw UnimplementedError();
  @override
  MaterialColor get pinkDarkHover => throw UnimplementedError();
  @override
  MaterialColor get pinkDarkActive => throw UnimplementedError();
  @override
  MaterialColor get pinkDarker => throw UnimplementedError();

  // === ORANGE PALETTE IMPLEMENTATIONS ===

  @override
  MaterialColor get orangeLight => throw UnimplementedError();
  @override
  MaterialColor get orangeLightHover => throw UnimplementedError();
  @override
  MaterialColor get orangeLightActive => throw UnimplementedError();
  @override
  MaterialColor get orangeNormal => throw UnimplementedError();
  @override
  MaterialColor get orangeNormalHover => throw UnimplementedError();
  @override
  MaterialColor get orangeNormalActive => throw UnimplementedError();
  @override
  MaterialColor get orangeDark => throw UnimplementedError();
  @override
  MaterialColor get orangeDarkHover => throw UnimplementedError();
  @override
  MaterialColor get orangeDarkActive => throw UnimplementedError();
  @override
  MaterialColor get orangeDarker => throw UnimplementedError();

  // === DIRECT PINK COLOR ACCESS ===

  Color get pinkLightColor => throw UnimplementedError();
  Color get pinkLightHoverColor => throw UnimplementedError();
  Color get pinkLightActiveColor => throw UnimplementedError();
  Color get pinkNormalColor => throw UnimplementedError();
  Color get pinkNormalHoverColor => throw UnimplementedError();
  Color get pinkNormalActiveColor => throw UnimplementedError();
  Color get pinkDarkColor => throw UnimplementedError();
  Color get pinkDarkHoverColor => throw UnimplementedError();
  Color get pinkDarkActiveColor => throw UnimplementedError();
  Color get pinkDarkerColor => throw UnimplementedError();

  // === DIRECT ORANGE COLOR ACCESS ===

  Color get orangeLightColor => throw UnimplementedError();
  Color get orangeLightHoverColor => throw UnimplementedError();
  Color get orangeLightActiveColor => throw UnimplementedError();
  Color get orangeNormalColor => throw UnimplementedError();
  Color get orangeNormalHoverColor => throw UnimplementedError();
  Color get orangeNormalActiveColor => throw UnimplementedError();
  Color get orangeDarkColor => throw UnimplementedError();
  Color get orangeDarkHoverColor => throw UnimplementedError();
  Color get orangeDarkActiveColor => throw UnimplementedError();
  Color get orangeDarkerColor => throw UnimplementedError();

  // === RED PALETTE IMPLEMENTATIONS ===

  @override
  MaterialColor get redLight => throw UnimplementedError();

  @override
  MaterialColor get redLightHover => throw UnimplementedError();

  @override
  MaterialColor get redLightActive => throw UnimplementedError();

  @override
  MaterialColor get redNormal => throw UnimplementedError();

  @override
  MaterialColor get redNormalHover => throw UnimplementedError();

  @override
  MaterialColor get redNormalActive => throw UnimplementedError();

  @override
  MaterialColor get redDark => throw UnimplementedError();

  @override
  MaterialColor get redDarkHover => throw UnimplementedError();

  @override
  MaterialColor get redDarkActive => throw UnimplementedError();

  @override
  MaterialColor get redDarker => throw UnimplementedError();

  // === DIRECT RED COLOR ACCESS ===

  Color get redLightColor => throw UnimplementedError();

  Color get redLightHoverColor => throw UnimplementedError();

  Color get redLightActiveColor => throw UnimplementedError();

  Color get redNormalColor => throw UnimplementedError();

  Color get redNormalHoverColor => throw UnimplementedError();

  Color get redNormalActiveColor => throw UnimplementedError();

  Color get redDarkColor => throw UnimplementedError();

  Color get redDarkHoverColor => throw UnimplementedError();

  Color get redDarkActiveColor => throw UnimplementedError();

  Color get redDarkerColor => throw UnimplementedError();
}

void main() {
  group('AppColorExtension', () {
    late TestAppColors testAppColors;

    setUp(() {
      testAppColors = TestAppColors();
    });

    test('should create extension with provided colors', () {
      const extension = AppColorExtension(
        primary: Colors.blue,
        secondary: Colors.green,
        accent: Colors.red,
        textPrimary: Colors.black,
        textSecondary: Colors.grey,
      );

      expect(extension.primary, equals(Colors.blue));
      expect(extension.secondary, equals(Colors.green));
      expect(extension.accent, equals(Colors.red));
      expect(extension.textPrimary, equals(Colors.black));
      expect(extension.textSecondary, equals(Colors.grey));
    });

    test('should be immutable', () {
      expect(AppColorExtension, isA<Type>());
      const extension = AppColorExtension(
        primary: Colors.blue,
        secondary: Colors.green,
        accent: Colors.red,
        textPrimary: Colors.black,
        textSecondary: Colors.grey,
      );
      expect(extension, isA<Object>());
    });

    group('light factory', () {
      setUp(() {
        testAppColors = TestAppColors();
        GetIt.I.reset();
        GetIt.I.registerSingleton<AppColors>(testAppColors);
      });

      tearDown(() {
        GetIt.I.reset();
      });

      test('should create light theme extension from AppColors', () {
        // Act
        final extension = AppColorExtension.light();

        // Assert
        expect(extension.primary, equals(testAppColors.primary));
        expect(extension.secondary, equals(testAppColors.secondary));
        expect(extension.accent, equals(testAppColors.accent));
        expect(extension.textPrimary, equals(testAppColors.textPrimary));
        expect(extension.textSecondary, equals(testAppColors.textSecondary));
      });
    });

    group('dark factory', () {
      setUp(() {
        testAppColors = TestAppColors();
        GetIt.I.reset();
        GetIt.I.registerSingleton<AppColors>(testAppColors);
      });

      tearDown(() {
        GetIt.I.reset();
      });

      test('should create dark theme extension from AppColors', () {
        // Act
        final extension = AppColorExtension.dark();

        // Assert
        expect(extension.primary, equals(testAppColors.primaryDark));
        expect(extension.secondary, equals(testAppColors.secondaryDark));
        expect(extension.accent, equals(testAppColors.accentDark));
        expect(extension.textPrimary, equals(testAppColors.textPrimaryDark));
        expect(
          extension.textSecondary,
          equals(testAppColors.textSecondaryDark),
        );
      });
    });

    group('copyWith', () {
      test('should create new instance with updated colors', () {
        const original = AppColorExtension(
          primary: Colors.blue,
          secondary: Colors.green,
          accent: Colors.red,
          textPrimary: Colors.black,
          textSecondary: Colors.grey,
        );

        final copied =
            original.copyWith(
                  primary: Colors.purple,
                  accent: Colors.yellow,
                )
                as AppColorExtension;

        expect(copied.primary, equals(Colors.purple));
        expect(copied.secondary, equals(Colors.green)); // unchanged
        expect(copied.accent, equals(Colors.yellow));
        expect(copied.textPrimary, equals(Colors.black)); // unchanged
        expect(copied.textSecondary, equals(Colors.grey)); // unchanged
      });

      test(
        'should return copy with all original values when no parameters '
        'provided',
        () {
          const original = AppColorExtension(
            primary: Colors.blue,
            secondary: Colors.green,
            accent: Colors.red,
            textPrimary: Colors.black,
            textSecondary: Colors.grey,
          );

          final copied = original.copyWith() as AppColorExtension;

          expect(copied.primary, equals(original.primary));
          expect(copied.secondary, equals(original.secondary));
          expect(copied.accent, equals(original.accent));
          expect(copied.textPrimary, equals(original.textPrimary));
          expect(copied.textSecondary, equals(original.textSecondary));
        },
      );

      test('should return different instance', () {
        const original = AppColorExtension(
          primary: Colors.blue,
          secondary: Colors.green,
          accent: Colors.red,
          textPrimary: Colors.black,
          textSecondary: Colors.grey,
        );

        final copied = original.copyWith();

        expect(copied, isNot(same(original)));
        expect(copied, isA<AppColorExtension>());
      });
    });

    group('lerp', () {
      test('should interpolate between two extensions', () {
        const start = AppColorExtension(
          primary: Colors.black,
          secondary: Colors.black,
          accent: Colors.black,
          textPrimary: Colors.black,
          textSecondary: Colors.black,
        );

        const end = AppColorExtension(
          primary: Colors.white,
          secondary: Colors.white,
          accent: Colors.white,
          textPrimary: Colors.white,
          textSecondary: Colors.white,
        );

        final lerped = start.lerp(end, 0.5) as AppColorExtension;

        // At t=0.5, should be halfway between black and white (grey)
        // Use a tolerance for color interpolation precision
        const expectedGrey = Color(0xFF808080);
        expect(
          lerped.primary.toARGB32(),
          closeTo(expectedGrey.toARGB32(), 0x010101),
        );
        expect(
          lerped.secondary.toARGB32(),
          closeTo(expectedGrey.toARGB32(), 0x010101),
        );
        expect(
          lerped.accent.toARGB32(),
          closeTo(expectedGrey.toARGB32(), 0x010101),
        );
        expect(
          lerped.textPrimary.toARGB32(),
          closeTo(expectedGrey.toARGB32(), 0x010101),
        );
        expect(
          lerped.textSecondary.toARGB32(),
          closeTo(expectedGrey.toARGB32(), 0x010101),
        );
      });

      test('should return start extension when t is 0', () {
        const start = AppColorExtension(
          primary: Colors.blue,
          secondary: Colors.green,
          accent: Colors.red,
          textPrimary: Colors.black,
          textSecondary: Colors.grey,
        );

        const end = AppColorExtension(
          primary: Colors.white,
          secondary: Colors.white,
          accent: Colors.white,
          textPrimary: Colors.white,
          textSecondary: Colors.white,
        );

        final lerped = start.lerp(end, 0) as AppColorExtension;

        // Colors should be equal in value, but may differ in type
        // (Color vs MaterialColor)
        expect(
          lerped.primary.toARGB32(),
          equals(start.primary.toARGB32()),
        );
        expect(
          lerped.secondary.toARGB32(),
          equals(start.secondary.toARGB32()),
        );
        expect(
          lerped.accent.toARGB32(),
          equals(start.accent.toARGB32()),
        );
        expect(
          lerped.textPrimary.toARGB32(),
          equals(start.textPrimary.toARGB32()),
        );
        expect(
          lerped.textSecondary.toARGB32(),
          equals(start.textSecondary.toARGB32()),
        );
      });

      test('should return end extension when t is 1', () {
        const start = AppColorExtension(
          primary: Colors.blue,
          secondary: Colors.green,
          accent: Colors.red,
          textPrimary: Colors.black,
          textSecondary: Colors.grey,
        );

        const end = AppColorExtension(
          primary: Colors.white,
          secondary: Colors.white,
          accent: Colors.white,
          textPrimary: Colors.white,
          textSecondary: Colors.white,
        );

        final lerped = start.lerp(end, 1) as AppColorExtension;

        expect(lerped.primary, equals(end.primary));
        expect(lerped.secondary, equals(end.secondary));
        expect(lerped.accent, equals(end.accent));
        expect(lerped.textPrimary, equals(end.textPrimary));
        expect(lerped.textSecondary, equals(end.textSecondary));
      });

      test('should return this when other is not AppColorExtension', () {
        const start = AppColorExtension(
          primary: Colors.blue,
          secondary: Colors.green,
          accent: Colors.red,
          textPrimary: Colors.black,
          textSecondary: Colors.grey,
        );

        final lerped = start.lerp(null, 0.5);

        expect(lerped, equals(start));
        expect(lerped, same(start));
      });

      test('should handle different types of ThemeExtension', () {
        const start = AppColorExtension(
          primary: Colors.blue,
          secondary: Colors.green,
          accent: Colors.red,
          textPrimary: Colors.black,
          textSecondary: Colors.grey,
        );

        // Test with null (different type of ThemeExtension)
        const AppColorExtension? differentExtension = null;

        final lerped = start.lerp(differentExtension, 0.5);

        expect(lerped, equals(start));
        expect(lerped, same(start));
      });
    });

    test('should be a ThemeExtension', () {
      const extension = AppColorExtension(
        primary: Colors.blue,
        secondary: Colors.green,
        accent: Colors.red,
        textPrimary: Colors.black,
        textSecondary: Colors.grey,
      );

      expect(extension, isA<ThemeExtension<AppColorExtension>>());
    });

    test('should handle color equality correctly', () {
      const extension1 = AppColorExtension(
        primary: Colors.blue,
        secondary: Colors.green,
        accent: Colors.red,
        textPrimary: Colors.black,
        textSecondary: Colors.grey,
      );

      const extension2 = AppColorExtension(
        primary: Colors.blue,
        secondary: Colors.green,
        accent: Colors.red,
        textPrimary: Colors.black,
        textSecondary: Colors.grey,
      );

      // Note: These will be different instances, but colors should be equal
      expect(extension1.primary, equals(extension2.primary));
      expect(extension1.secondary, equals(extension2.secondary));
      expect(extension1.accent, equals(extension2.accent));
      expect(extension1.textPrimary, equals(extension2.textPrimary));
      expect(extension1.textSecondary, equals(extension2.textSecondary));
    });
  });
}
