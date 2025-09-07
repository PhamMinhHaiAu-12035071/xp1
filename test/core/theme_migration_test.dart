import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/themes/app_theme.dart';
import 'package:xp1/core/themes/extensions/app_color_extension.dart';

void main() {
  group('Theme Migration Tests', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      // Mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});

      await GetIt.instance.reset();
      await configureDependencies();
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    test('AppColors should be injectable from lib/core', () {
      expect(() => GetIt.I<AppColors>(), returnsNormally);
      final colors = GetIt.I<AppColors>();
      expect(colors.primary, isA<MaterialColor>());
      expect(colors.bgMain, isA<Color>());
    });

    testWidgets('AppSizes should provide responsive values', (tester) async {
      // Initialize ScreenUtil through widget context
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(414, 896),
          child: MaterialApp(home: Scaffold()),
        ),
      );

      expect(() => GetIt.I<AppSizes>(), returnsNormally);
      final sizes = GetIt.I<AppSizes>();
      expect(sizes.r16, isA<double>());
      expect(sizes.h16, isA<double>());
      expect(sizes.v16, isA<double>());
    });

    testWidgets('AppTextStyles should provide typography', (tester) async {
      // Initialize ScreenUtil through widget context
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(414, 896),
          child: MaterialApp(home: Scaffold()),
        ),
      );

      expect(() => GetIt.I<AppTextStyles>(), returnsNormally);
      final textStyles = GetIt.I<AppTextStyles>();
      expect(textStyles.bodyLarge(), isA<TextStyle>());
      expect(textStyles.bodyMedium(), isA<TextStyle>());
    });

    testWidgets('AppTheme should create valid light ThemeData', (tester) async {
      final lightTheme = AppTheme.lightTheme();
      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.extensions, isNotEmpty);

      final colorExtension = lightTheme.extension<AppColorExtension>();
      expect(colorExtension, isNotNull);
    });

    testWidgets('AppTheme should create valid dark ThemeData', (tester) async {
      final darkTheme = AppTheme.darkTheme();
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.extensions, isNotEmpty);

      final colorExtension = darkTheme.extension<AppColorExtension>();
      expect(colorExtension, isNotNull);
    });

    testWidgets('Theme extensions should work in widget context', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(414, 896),
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: Builder(
              builder: (context) {
                final colors = Theme.of(context).extension<AppColorExtension>();
                expect(colors, isNotNull);
                expect(colors!.primary, isA<Color>());
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('Dark theme extensions should work in widget context', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(414, 896),
          child: MaterialApp(
            theme: AppTheme.darkTheme(),
            home: Builder(
              builder: (context) {
                final colors = Theme.of(context).extension<AppColorExtension>();
                expect(colors, isNotNull);
                expect(colors!.primary, isA<Color>());
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}
