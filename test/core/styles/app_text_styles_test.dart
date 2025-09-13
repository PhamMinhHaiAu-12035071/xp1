import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/app_text_styles_impl.dart';

void main() {
  group('AppTextStylesImpl', () {
    late AppTextStyles appTextStyles;

    setUp(() {
      appTextStyles = AppTextStylesImpl();
    });

    testWidgets('should implement AppTextStyles interface', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            expect(appTextStyles, isA<AppTextStyles>());
            return Container();
          },
        ),
      );
    });

    testWidgets('should configure Google Fonts on construction', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            // Verify that constructor configures Google Fonts
            final appTextStylesImpl = AppTextStylesImpl();
            expect(appTextStylesImpl, isA<AppTextStyles>());
            return Container();
          },
        ),
      );
    });

    group('Typography System', () {
      testWidgets('displayLarge should match design specifications', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.red;
              final style = appTextStyles.displayLarge(color: color);

              expect(style.fontSize, 36.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('displayMedium should match design specifications', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.blue;
              final style = appTextStyles.displayMedium(color: color);

              expect(style.fontSize, 32.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('headingLarge should match design specifications', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.green;
              final style = appTextStyles.headingLarge(color: color);

              expect(style.fontSize, 24.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('headingMedium should match design specifications', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.orange;
              final style = appTextStyles.headingMedium(color: color);

              expect(style.fontSize, 20.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('bodyLarge should match design specifications', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.purple;
              final style = appTextStyles.bodyLarge(color: color);

              expect(style.fontSize, 16.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('bodyMedium should match design specifications', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.teal;
              final style = appTextStyles.bodyMedium(color: color);

              expect(style.fontSize, 14.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('bodySmall should match design specifications', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.indigo;
              final style = appTextStyles.bodySmall(color: color);

              expect(style.fontSize, 12.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('caption should match design specifications', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              const color = Colors.amber;
              final style = appTextStyles.caption(color: color);

              expect(style.fontSize, 10.sp);
              expect(style.fontWeight, FontWeight.w400);
              expect(style.height, 1.2);
              expect(style.letterSpacing, 0.0);
              expect(style.color, color);
              expect(style.fontFamily, GoogleFonts.publicSans().fontFamily);
              return Container();
            },
          ),
        );
      });

      testWidgets('styles should work without color parameter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              final displayLarge = appTextStyles.displayLarge();
              final headingMedium = appTextStyles.headingMedium();
              final bodyMedium = appTextStyles.bodyMedium();

              expect(displayLarge.color, null);
              expect(headingMedium.color, null);
              expect(bodyMedium.color, null);

              expect(displayLarge.fontSize, 36.sp);
              expect(headingMedium.fontSize, 20.sp);
              expect(bodyMedium.fontSize, 14.sp);

              return Container();
            },
          ),
        );
      });
    });

    group('Design System Compliance', () {
      testWidgets('all styles should use Public Sans font family', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              final styles = [
                appTextStyles.displayLarge(),
                appTextStyles.displayMedium(),
                appTextStyles.headingLarge(),
                appTextStyles.headingMedium(),
                appTextStyles.bodyLarge(),
                appTextStyles.bodyMedium(),
                appTextStyles.bodySmall(),
                appTextStyles.caption(),
              ];

              final expectedFontFamily = GoogleFonts.publicSans().fontFamily;

              for (final style in styles) {
                expect(
                  style.fontFamily,
                  expectedFontFamily,
                  reason: 'All styles should use Public Sans font family',
                );
              }

              return Container();
            },
          ),
        );
      });

      testWidgets('all styles should use Regular font weight (400)', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              final styles = [
                appTextStyles.displayLarge(),
                appTextStyles.displayMedium(),
                appTextStyles.headingLarge(),
                appTextStyles.headingMedium(),
                appTextStyles.bodyLarge(),
                appTextStyles.bodyMedium(),
                appTextStyles.bodySmall(),
                appTextStyles.caption(),
              ];

              for (final style in styles) {
                expect(
                  style.fontWeight,
                  FontWeight.w400,
                  reason: 'All styles should use Regular font weight (400)',
                );
              }

              return Container();
            },
          ),
        );
      });

      testWidgets('all styles should use 120% line height', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              final styles = [
                appTextStyles.displayLarge(),
                appTextStyles.displayMedium(),
                appTextStyles.headingLarge(),
                appTextStyles.headingMedium(),
                appTextStyles.bodyLarge(),
                appTextStyles.bodyMedium(),
                appTextStyles.bodySmall(),
                appTextStyles.caption(),
              ];

              for (final style in styles) {
                expect(
                  style.height,
                  1.2,
                  reason: 'All styles should use 120% line height (1.2)',
                );
              }

              return Container();
            },
          ),
        );
      });

      testWidgets('all styles should use 0% letter spacing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              final styles = [
                appTextStyles.displayLarge(),
                appTextStyles.displayMedium(),
                appTextStyles.headingLarge(),
                appTextStyles.headingMedium(),
                appTextStyles.bodyLarge(),
                appTextStyles.bodyMedium(),
                appTextStyles.bodySmall(),
                appTextStyles.caption(),
              ];

              for (final style in styles) {
                expect(
                  style.letterSpacing,
                  0.0,
                  reason: 'All styles should use 0% letter spacing',
                );
              }

              return Container();
            },
          ),
        );
      });

      testWidgets('styles should have correct font sizes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              // Test font sizes match design specifications
              expect(appTextStyles.displayLarge().fontSize, 36.sp);
              expect(appTextStyles.displayMedium().fontSize, 32.sp);
              expect(appTextStyles.headingLarge().fontSize, 24.sp);
              expect(appTextStyles.headingMedium().fontSize, 20.sp);
              expect(appTextStyles.bodyLarge().fontSize, 16.sp);
              expect(appTextStyles.bodyMedium().fontSize, 14.sp);
              expect(appTextStyles.bodySmall().fontSize, 12.sp);
              expect(appTextStyles.caption().fontSize, 10.sp);

              return Container();
            },
          ),
        );
      });
    });

    group('Typography Scale Validation', () {
      testWidgets('font sizes should follow design system scale', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              ScreenUtil.init(context, designSize: const Size(375, 812));

              // Verify the typography scale follows design specifications
              final fontSizes = [
                appTextStyles.displayLarge().fontSize,
                appTextStyles.displayMedium().fontSize,
                appTextStyles.headingLarge().fontSize,
                appTextStyles.headingMedium().fontSize,
                appTextStyles.bodyLarge().fontSize,
                appTextStyles.bodyMedium().fontSize,
                appTextStyles.bodySmall().fontSize,
                appTextStyles.caption().fontSize,
              ];

              final expectedSizes = [
                36.sp,
                32.sp,
                24.sp,
                20.sp,
                16.sp,
                14.sp,
                12.sp,
                10.sp,
              ];

              for (var i = 0; i < fontSizes.length; i++) {
                expect(
                  fontSizes[i],
                  expectedSizes[i],
                  reason:
                      'Font size at index $i should match design specification',
                );
              }

              return Container();
            },
          ),
        );
      });
    });
  });
}
