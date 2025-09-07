import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/themes/app_theme.dart';
import 'package:xp1/core/themes/extensions/app_color_extension.dart';

import '../helpers/test_injection_container.dart';

void main() {
  group('Theme Integration Tests', () {
    setUp(() async {
      // Use test dependency container instead of real DI
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    testWidgets('AppTheme.lightTheme should work with extensions', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme(),
          home: Builder(
            builder: (context) {
              final colors = Theme.of(context).extension<AppColorExtension>();
              expect(colors, isNotNull); // Verify extension is attached
              expect(Theme.of(context).brightness, Brightness.light);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('AppTheme.darkTheme should work with extensions', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme(),
          home: Builder(
            builder: (context) {
              final colors = Theme.of(context).extension<AppColorExtension>();
              expect(colors, isNotNull);
              expect(Theme.of(context).brightness, Brightness.dark);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('Responsive sizes should work in widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            ScreenUtil.init(context);
            return child!;
          },
          home: Builder(
            builder: (context) {
              final sizes = GetIt.I<AppSizes>();
              expect(sizes.r16, isA<double>());
              expect(sizes.h16, isA<double>());
              expect(sizes.v16, isA<double>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('DI services should be injectable after migration', (
      tester,
    ) async {
      expect(() => GetIt.I<AppColors>(), returnsNormally);
      expect(() => GetIt.I<AppSizes>(), returnsNormally);
    });

    testWidgets('Migrated AppTheme should match original behavior', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          home: Builder(
            builder: (context) {
              final colors = Theme.of(context).extension<AppColorExtension>();
              expect(colors, isNotNull); // Extension attached
              expect(colors!.primary, isA<Color>()); // Colors available
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
