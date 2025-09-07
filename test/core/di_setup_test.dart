import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';

void main() {
  group('DI Registration Tests', () {
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

    test('AppColors should be registered', () {
      expect(() => GetIt.I<AppColors>(), returnsNormally);
      final colors = GetIt.I<AppColors>();
      expect(colors, isNotNull);
      expect(colors.primary, isA<MaterialColor>());
    });

    testWidgets('AppSizes should be registered', (tester) async {
      // Initialize ScreenUtil through widget context
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(414, 896),
          child: MaterialApp(home: Scaffold()),
        ),
      );

      expect(() => GetIt.I<AppSizes>(), returnsNormally);
      final sizes = GetIt.I<AppSizes>();
      expect(sizes, isNotNull);
      expect(sizes.r16, isA<double>());
    });

    testWidgets('AppTextStyles should be registered', (tester) async {
      // Initialize ScreenUtil through widget context
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(414, 896),
          child: MaterialApp(home: Scaffold()),
        ),
      );

      expect(() => GetIt.I<AppTextStyles>(), returnsNormally);
      final textStyles = GetIt.I<AppTextStyles>();
      expect(textStyles, isNotNull);
      expect(textStyles.bodyLarge(), isA<TextStyle>());
    });

    testWidgets('All theme services should be registered after migration', (
      tester,
    ) async {
      // Initialize ScreenUtil through widget context
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(414, 896),
          child: MaterialApp(home: Scaffold()),
        ),
      );

      final colors = GetIt.I<AppColors>();
      final sizes = GetIt.I<AppSizes>();
      final textStyles = GetIt.I<AppTextStyles>();

      expect(colors, isNotNull);
      expect(sizes, isNotNull);
      expect(textStyles, isNotNull);
    });
  });
}
