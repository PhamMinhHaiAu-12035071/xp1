import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/themes/app_theme.dart';
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
  group('AppTheme', () {
    test('should not allow instantiation', () {
      expect(AppTheme.new, throwsA(isA<UnsupportedError>()));
    });

    group('lightTheme', () {
      setUp(() {
        GetIt.I.reset();
        GetIt.I.registerSingleton<AppColors>(TestAppColors());
      });

      tearDown(() {
        GetIt.I.reset();
      });
      test('should create light theme with default ThemeData', () {
        final theme = AppTheme.lightTheme();

        expect(theme, isA<ThemeData>());
        expect(theme.brightness, equals(Brightness.light));
        expect(theme.useMaterial3, isTrue);
        expect(theme.extensions, isNotNull);
        expect(theme.extensions.length, equals(1));
        expect(
          theme.extensions[AppColorExtension],
          isA<AppColorExtension>(),
        );
      });

      test('should create light theme with custom ThemeData', () {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.light(primary: Colors.purple),
          brightness: Brightness.light,
          useMaterial3: false,
        );

        final theme = AppTheme.lightTheme(customTheme);

        expect(theme, isA<ThemeData>());
        expect(theme.colorScheme.primary, equals(Colors.purple));
        expect(theme.brightness, equals(Brightness.light));
        expect(theme.useMaterial3, isFalse);
        expect(theme.extensions, isNotNull);
        expect(theme.extensions.length, equals(1));
        expect(
          theme.extensions[AppColorExtension],
          isA<AppColorExtension>(),
        );
      });

      test('should have AppColorExtension with light colors', () {
        final theme = AppTheme.lightTheme();
        final colorExtension =
            theme.extensions[AppColorExtension]! as AppColorExtension;
        final testColors = GetIt.I<AppColors>();

        expect(colorExtension.primary, equals(testColors.primary));
        expect(colorExtension.secondary, equals(testColors.secondary));
        expect(colorExtension.accent, equals(testColors.accent));
        expect(colorExtension.textPrimary, equals(testColors.textPrimary));
        expect(colorExtension.textSecondary, equals(testColors.textSecondary));
      });
    });

    group('darkTheme', () {
      setUp(() {
        GetIt.I.reset();
        GetIt.I.registerSingleton<AppColors>(TestAppColors());
      });

      tearDown(() {
        GetIt.I.reset();
      });
      test('should create dark theme with default ThemeData', () {
        final theme = AppTheme.darkTheme();

        expect(theme, isA<ThemeData>());
        expect(theme.brightness, equals(Brightness.dark));
        expect(theme.useMaterial3, isTrue);
        expect(theme.extensions, isNotNull);
        expect(theme.extensions.length, equals(1));
        expect(
          theme.extensions[AppColorExtension],
          isA<AppColorExtension>(),
        );
      });

      test('should create dark theme with custom ThemeData', () {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.dark(primary: Colors.green),
          brightness: Brightness.dark,
          useMaterial3: false,
        );

        final theme = AppTheme.darkTheme(customTheme);

        expect(theme, isA<ThemeData>());
        expect(theme.colorScheme.primary, equals(Colors.green));
        expect(theme.brightness, equals(Brightness.dark));
        expect(theme.useMaterial3, isFalse);
        expect(theme.extensions, isNotNull);
        expect(theme.extensions.length, equals(1));
        expect(
          theme.extensions[AppColorExtension],
          isA<AppColorExtension>(),
        );
      });

      test('should have AppColorExtension with dark colors', () {
        final theme = AppTheme.darkTheme();
        final colorExtension =
            theme.extensions[AppColorExtension]! as AppColorExtension;
        final testColors = GetIt.I<AppColors>();

        expect(colorExtension.primary, equals(testColors.primaryDark));
        expect(colorExtension.secondary, equals(testColors.secondaryDark));
        expect(colorExtension.accent, equals(testColors.accentDark));
        expect(colorExtension.textPrimary, equals(testColors.textPrimaryDark));
        expect(
          colorExtension.textSecondary,
          equals(testColors.textSecondaryDark),
        );
      });
    });

    group('theme consistency', () {
      setUp(() {
        GetIt.I.reset();
        GetIt.I.registerSingleton<AppColors>(TestAppColors());
      });

      tearDown(() {
        GetIt.I.reset();
      });
      test('light and dark themes should have different brightness', () {
        final lightTheme = AppTheme.lightTheme();
        final darkTheme = AppTheme.darkTheme();

        expect(lightTheme.brightness, equals(Brightness.light));
        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(lightTheme.brightness, isNot(equals(darkTheme.brightness)));
      });

      test('both themes should use Material 3 by default', () {
        final lightTheme = AppTheme.lightTheme();
        final darkTheme = AppTheme.darkTheme();

        expect(lightTheme.useMaterial3, isTrue);
        expect(darkTheme.useMaterial3, isTrue);
      });

      test('both themes should have AppColorExtension', () {
        final lightTheme = AppTheme.lightTheme();
        final darkTheme = AppTheme.darkTheme();

        expect(
          lightTheme.extensions[AppColorExtension],
          isA<AppColorExtension>(),
        );
        expect(
          darkTheme.extensions[AppColorExtension],
          isA<AppColorExtension>(),
        );
      });

      test('light and dark theme extensions should have different colors', () {
        final lightTheme = AppTheme.lightTheme();
        final darkTheme = AppTheme.darkTheme();

        final lightExtension =
            lightTheme.extensions[AppColorExtension]! as AppColorExtension;
        final darkExtension =
            darkTheme.extensions[AppColorExtension]! as AppColorExtension;

        expect(lightExtension.primary, isNot(equals(darkExtension.primary)));
        expect(
          lightExtension.secondary,
          isNot(equals(darkExtension.secondary)),
        );
        expect(lightExtension.accent, isNot(equals(darkExtension.accent)));
        expect(
          lightExtension.textPrimary,
          isNot(equals(darkExtension.textPrimary)),
        );
        expect(
          lightExtension.textSecondary,
          isNot(equals(darkExtension.textSecondary)),
        );
      });
    });

    group('theme building', () {
      setUp(() {
        GetIt.I.reset();
        GetIt.I.registerSingleton<AppColors>(TestAppColors());
      });

      tearDown(() {
        GetIt.I.reset();
      });
      test('should preserve custom properties when building theme', () {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.light(primary: Colors.orange),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontFamily: 'CustomFont'),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red,
          ),
        );

        final lightTheme = AppTheme.lightTheme(customTheme);

        expect(lightTheme.colorScheme.primary, equals(Colors.orange));
        expect(
          lightTheme.textTheme.bodyLarge?.fontFamily,
          equals('CustomFont'),
        );
        expect(lightTheme.appBarTheme.backgroundColor, equals(Colors.red));
        expect(lightTheme.extensions.length, equals(1));
      });

      test(
        'should override extensions even if custom theme has extensions',
        () {
          final customTheme = ThemeData(
            extensions: const [
              _MockThemeExtension(),
            ],
          );

          final theme = AppTheme.lightTheme(customTheme);

          expect(theme.extensions.length, equals(1));
          expect(
            theme.extensions[AppColorExtension],
            isA<AppColorExtension>(),
          );
          expect(
            theme.extensions[_MockThemeExtension],
            isNull,
          );
        },
      );
    });

    group('null handling', () {
      setUp(() {
        GetIt.I.reset();
        GetIt.I.registerSingleton<AppColors>(TestAppColors());
      });

      tearDown(() {
        GetIt.I.reset();
      });

      test('should handle null ThemeData parameter', () {
        final lightTheme = AppTheme.lightTheme();
        final darkTheme = AppTheme.darkTheme();

        expect(lightTheme, isA<ThemeData>());
        expect(darkTheme, isA<ThemeData>());
        expect(lightTheme.brightness, equals(Brightness.light));
        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(lightTheme.useMaterial3, isTrue);
        expect(darkTheme.useMaterial3, isTrue);
      });
    });
  });
}

// Mock ThemeExtension for testing
class _MockThemeExtension extends ThemeExtension<_MockThemeExtension> {
  const _MockThemeExtension();

  @override
  ThemeExtension<_MockThemeExtension> copyWith() => this;

  @override
  ThemeExtension<_MockThemeExtension> lerp(
    covariant ThemeExtension<_MockThemeExtension>? other,
    double t,
  ) => this;
}
