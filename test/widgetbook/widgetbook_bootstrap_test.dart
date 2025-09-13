import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';

import '../../widgetbook/core/widgetbook_bootstrap.dart';

void main() {
  group('Widgetbook Bootstrap Tests', () {
    setUpAll(() async {
      // Initialize Flutter test bindings
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      await GetIt.instance.reset();
    });

    testWidgets('should register design system services for Widgetbook', (
      tester,
    ) async {
      // Initialize ScreenUtil only for non-web platforms
      if (!kIsWeb) {
        await tester.binding.setSurfaceSize(const Size(375, 812));

        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              return const SizedBox.shrink();
            },
          ),
        );
      }

      await configureWidgetbookDependencies();

      expect(() => GetIt.I<AppTextStyles>(), returnsNormally);
      expect(() => GetIt.I<AppColors>(), returnsNormally);
      expect(() => GetIt.I<AppSizes>(), returnsNormally);

      // Verify that appropriate text styles implementation is registered
      final textStyles = GetIt.I<AppTextStyles>();
      expect(textStyles, isNotNull);
      expect(textStyles.displayLarge(), isA<TextStyle>());
      expect(textStyles.bodyLarge().fontSize, isNotNull);

      // Verify platform-specific implementation
      if (kIsWeb) {
        // On web, should use exact pixel sizes (no .sp scaling)
        expect(textStyles.displayLarge().fontSize, equals(36));
      } else {
        // On mobile, should use responsive scaling (may vary)
        expect(textStyles.displayLarge().fontSize, isPositive);
      }
    });

    test('should initialize Widgetbook without errors', () async {
      expect(() async => initWidgetbook(), returnsNormally);
    });

    tearDown(() => GetIt.instance.reset());
  });
}
