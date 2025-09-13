import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/sizes/app_sizes_impl.dart';

void main() {
  group('AppSizesImpl', () {
    late AppSizes appSizes;

    setUp(() {
      appSizes = const AppSizesImpl();
    });

    testWidgets('should implement AppSizes interface', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            expect(appSizes, isA<AppSizes>());
            return Container();
          },
        ),
      );
    });

    testWidgets('should be const constructible', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            const appSizes1 = AppSizesImpl();
            const appSizes2 = AppSizesImpl();
            expect(appSizes1, equals(appSizes2));
            return Container();
          },
        ),
      );
    });

    group('Responsive sizes', () {
      testWidgets('small pixel variations should work correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r2, equals(2.r));
              expect(appSizes.v2, equals(2.h));
              expect(appSizes.h2, equals(2.w));

              expect(appSizes.r4, equals(4.r));
              expect(appSizes.v4, equals(4.h));
              expect(appSizes.h4, equals(4.w));

              return Container();
            },
          ),
        );
      });

      testWidgets('medium pixel variations should work correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r16, equals(16.r));
              expect(appSizes.v16, equals(16.h));
              expect(appSizes.h16, equals(16.w));

              expect(appSizes.r24, equals(24.r));
              expect(appSizes.v24, equals(24.h));
              expect(appSizes.h24, equals(24.w));

              return Container();
            },
          ),
        );
      });

      testWidgets('large pixel variations should work correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r128, equals(128.r));
              expect(appSizes.v128, equals(128.h));
              expect(appSizes.h128, equals(128.w));

              expect(appSizes.r256, equals(256.r));
              expect(appSizes.v256, equals(256.h));
              expect(appSizes.h256, equals(256.w));

              return Container();
            },
          ),
        );
      });

      testWidgets('border radius dimensions should work correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.borderRadiusXs, equals(6.r));
              expect(appSizes.borderRadiusSm, equals(8.r));
              expect(appSizes.borderRadiusMd, equals(12.r));
              expect(appSizes.borderRadiusLg, equals(16.r));

              return Container();
            },
          ),
        );
      });
    });

    testWidgets('all getters should return positive values', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));

            // Test that all responsive sizes return positive values
            expect(appSizes.r2, greaterThan(0));
            expect(appSizes.v2, greaterThan(0));
            expect(appSizes.h2, greaterThan(0));

            expect(appSizes.r360, greaterThan(0));
            expect(appSizes.v360, greaterThan(0));
            expect(appSizes.h360, greaterThan(0));

            expect(appSizes.borderRadiusXs, greaterThan(0));
            expect(appSizes.borderRadiusLg, greaterThan(0));

            return Container();
          },
        ),
      );
    });

    testWidgets('responsive sizes should scale correctly', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));

            // Test that larger sizes return larger values
            expect(appSizes.r4, greaterThan(appSizes.r2));
            expect(appSizes.r8, greaterThan(appSizes.r4));
            expect(appSizes.r16, greaterThan(appSizes.r8));
            expect(appSizes.r32, greaterThan(appSizes.r16));

            expect(appSizes.v360, greaterThan(appSizes.v256));
            expect(appSizes.h256, greaterThan(appSizes.h128));

            return Container();
          },
        ),
      );
    });

    testWidgets('border radius sizes should be in correct order', (
      tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));

            expect(
              appSizes.borderRadiusSm,
              greaterThan(appSizes.borderRadiusXs),
            );
            expect(
              appSizes.borderRadiusMd,
              greaterThan(appSizes.borderRadiusSm),
            );
            expect(
              appSizes.borderRadiusLg,
              greaterThan(appSizes.borderRadiusMd),
            );

            return Container();
          },
        ),
      );
    });

    group('Standard UI/UX design system sizes', () {
      testWidgets('small sizes (4px/8px grid base units)', (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r8, equals(8.r));
              expect(appSizes.v8, equals(8.h));
              expect(appSizes.h8, equals(8.w));

              expect(appSizes.r12, equals(12.r));
              expect(appSizes.v12, equals(12.h));
              expect(appSizes.h12, equals(12.w));

              return Container();
            },
          ),
        );
      });

      testWidgets('medium sizes (standard grid multiples)', (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r20, equals(20.r));
              expect(appSizes.v20, equals(20.h));
              expect(appSizes.h20, equals(20.w));

              expect(appSizes.r24, equals(24.r));
              expect(appSizes.v24, equals(24.h));
              expect(appSizes.h24, equals(24.w));

              expect(appSizes.r32, equals(32.r));
              expect(appSizes.v32, equals(32.h));
              expect(appSizes.h32, equals(32.w));

              return Container();
            },
          ),
        );
      });

      testWidgets('large sizes (8px grid multiples)', (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r40, equals(40.r));
              expect(appSizes.v40, equals(40.h));
              expect(appSizes.h40, equals(40.w));

              expect(appSizes.r48, equals(48.r));
              expect(appSizes.v48, equals(48.h));
              expect(appSizes.h48, equals(48.w));

              expect(appSizes.r56, equals(56.r));
              expect(appSizes.v56, equals(56.h));
              expect(appSizes.h56, equals(56.w));

              expect(appSizes.r64, equals(64.r));
              expect(appSizes.v64, equals(64.h));
              expect(appSizes.h64, equals(64.w));

              expect(appSizes.r72, equals(72.r));
              expect(appSizes.v72, equals(72.h));
              expect(appSizes.h72, equals(72.w));

              expect(appSizes.r80, equals(80.r));
              expect(appSizes.v80, equals(80.h));
              expect(appSizes.h80, equals(80.w));

              return Container();
            },
          ),
        );
      });

      testWidgets('extra large sizes (powers of 2 and 8px multiples)', (
        tester,
      ) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r120, equals(120.r));
              expect(appSizes.v120, equals(120.h));
              expect(appSizes.h120, equals(120.w));

              expect(appSizes.r128, equals(128.r));
              expect(appSizes.v128, equals(128.h));
              expect(appSizes.h128, equals(128.w));

              expect(appSizes.r160, equals(160.r));
              expect(appSizes.v160, equals(160.h));
              expect(appSizes.h160, equals(160.w));

              return Container();
            },
          ),
        );
      });

      testWidgets('XXL sizes (large breakpoints)', (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              expect(appSizes.r192, equals(192.r));
              expect(appSizes.v192, equals(192.h));
              expect(appSizes.h192, equals(192.w));

              expect(appSizes.r224, equals(224.r));
              expect(appSizes.v224, equals(224.h));
              expect(appSizes.h224, equals(224.w));

              expect(appSizes.r256, equals(256.r));
              expect(appSizes.v256, equals(256.h));
              expect(appSizes.h256, equals(256.w));

              expect(appSizes.r360, equals(360.r));
              expect(appSizes.v360, equals(360.h));
              expect(appSizes.h360, equals(360.w));

              return Container();
            },
          ),
        );
      });
    });
  });
}
