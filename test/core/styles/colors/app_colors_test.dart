import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';

void main() {
  group('AppColorsImpl', () {
    late AppColors appColors;

    setUp(() {
      appColors = const AppColorsImpl();
    });

    test('should implement AppColors interface', () {
      expect(appColors, isA<AppColors>());
    });

    test('should be const constructible', () {
      const appColors1 = AppColorsImpl();
      const appColors2 = AppColorsImpl();
      expect(appColors1, equals(appColors2));
    });

    group('MaterialColor properties', () {
      test('primary should return MaterialColor', () {
        final primary = appColors.primary;
        expect(primary, isA<MaterialColor>());
        expect(primary.toARGB32(), equals(0xFF013773));
        expect(primary[500], equals(const Color(0xFF013773)));
        expect(primary[100], equals(const Color(0xFFC7D1E1)));
        expect(primary[900], equals(const Color(0xFF011A2B)));
      });

      test('secondary should return MaterialColor', () {
        final secondary = appColors.secondary;
        expect(secondary, isA<MaterialColor>());
        expect(secondary.toARGB32(), equals(0xFF4F46E5));
        expect(secondary[500], equals(const Color(0xFF4F46E5)));
        expect(secondary[100], equals(const Color(0xFFD7D5F8)));
        expect(secondary[900], equals(const Color(0xFF252069)));
      });

      test('black should return MaterialColor', () {
        final black = appColors.black;
        expect(black, isA<MaterialColor>());
        expect(black.toARGB32(), equals(0xFF000000));
        expect(black[500], equals(const Color(0xFF000000)));
        expect(black[100], equals(const Color(0xFFCCCCCC)));
        expect(black[10], equals(const Color(0xFFF9F9F9)));
      });

      test('white should return MaterialColor', () {
        final white = appColors.white;
        expect(white, isA<MaterialColor>());
        expect(white.toARGB32(), equals(0xFFFFFFFF));
        expect(white[500], equals(const Color(0xFFFFFFFF)));
        expect(white[100], equals(const Color(0xFFFFFFFF)));
        expect(white[900], equals(const Color(0xFFC4C4C4)));
      });

      test('grey should return MaterialColor', () {
        final grey = appColors.grey;
        expect(grey, isA<MaterialColor>());
        expect(grey.toARGB32(), equals(0xFF9E9E9E));
        expect(grey[500], equals(const Color(0xFF9E9E9E)));
        expect(grey[100], equals(const Color(0xFFF5F5F5)));
        expect(grey[900], equals(const Color(0xFF212121)));
      });

      test('onboardingBlue should return MaterialColor', () {
        final onboardingBlue = appColors.onboardingBlue;
        expect(onboardingBlue, isA<MaterialColor>());
        expect(onboardingBlue.toARGB32(), equals(0xFF7384A2));
        expect(onboardingBlue[500], equals(const Color(0xFF7384A2)));
        expect(onboardingBlue[100], equals(const Color(0xFFD9DEE7)));
        expect(onboardingBlue[900], equals(const Color(0xFF2A3240)));
      });

      test('error should return MaterialColor', () {
        final error = appColors.error;
        expect(error, isA<MaterialColor>());
        expect(error.toARGB32(), equals(0xFFDC3545));
        expect(error[500], equals(const Color(0xFFDC3545)));
        expect(error[100], equals(const Color(0xFFF5D3D7)));
        expect(error[900], equals(const Color(0xFF841925)));
      });

      test('title should return MaterialColor', () {
        final title = appColors.title;
        expect(title, isA<MaterialColor>());
        expect(title.toARGB32(), equals(0xFF333333));
        expect(title[500], equals(const Color(0xFF333333)));
        expect(title[100], equals(const Color(0xFFCCCCCC)));
        expect(title[900], equals(const Color(0xFF0A0A0A)));
      });

      test('placeholder should return MaterialColor', () {
        final placeholder = appColors.placeholder;
        expect(placeholder, isA<MaterialColor>());
        expect(placeholder.toARGB32(), equals(0xFFB0B0B0));
        expect(placeholder[500], equals(const Color(0xFFB0B0B0)));
        expect(placeholder[100], equals(const Color(0xFFE6E6E6)));
        expect(placeholder[900], equals(const Color(0xFF686868)));
      });

      test('neutral should return MaterialColor', () {
        final neutral = appColors.neutral;
        expect(neutral, isA<MaterialColor>());
        expect(neutral.toARGB32(), equals(0xFFE6E6E6));
        expect(neutral[500], equals(const Color(0xFF666666)));
        expect(neutral[20], equals(const Color(0xFFF4F4F4)));
        expect(neutral[900], equals(const Color(0xFF000000)));
      });

      test('button should return MaterialColor', () {
        final button = appColors.button;
        expect(button, isA<MaterialColor>());
        expect(button.toARGB32(), equals(0xFF013773));
        expect(button[500], equals(const Color(0xFF013773)));
        expect(button[100], equals(const Color(0xFFCCD7E5)));
        expect(button[900], equals(const Color(0xFF001717)));
      });

      test('bodyText should return MaterialColor', () {
        final bodyText = appColors.bodyText;
        expect(bodyText, isA<MaterialColor>());
        expect(bodyText.toARGB32(), equals(0xFF545454));
        expect(bodyText[500], equals(const Color(0xFF545454)));
        expect(bodyText[100], equals(const Color(0xFFE6E6E6)));
        expect(bodyText[900], equals(const Color(0xFF2C2C2C)));
      });

      test('red should return MaterialColor', () {
        final red = appColors.red;
        expect(red, isA<MaterialColor>());
        expect(red.toARGB32(), equals(0xFFF4C0C5));
        expect(red[300], equals(const Color(0xFFF4C0C5)));
        expect(red[100], equals(const Color(0xFFFFE6E8)));
        expect(red[900], equals(const Color(0xFF66151B)));
      });

      test('delete should return MaterialColor', () {
        final delete = appColors.delete;
        expect(delete, isA<MaterialColor>());
        expect(delete.toARGB32(), equals(0xFFDC3545));
        expect(delete[500], equals(const Color(0xFFDC3545)));
        expect(delete[100], equals(const Color(0xFFFEE2E2)));
        expect(delete[900], equals(const Color(0xFF63171B)));
      });

      test('blue should return MaterialColor', () {
        final blue = appColors.blue;
        expect(blue, isA<MaterialColor>());
        expect(blue.toARGB32(), equals(0xFF2196F3));
        expect(blue[500], equals(const Color(0xFF2196F3)));
        expect(blue[50], equals(const Color(0xFFF7FBFF)));
        expect(blue[900], equals(const Color(0xFF0D47A1)));
      });

      test('divider should return MaterialColor', () {
        final divider = appColors.divider;
        expect(divider, isA<MaterialColor>());
        expect(divider.toARGB32(), equals(0xFFB0B0B0));
        expect(divider[500], equals(const Color(0xFFB0B0B0)));
        expect(divider[100], equals(const Color(0xFFCFCFCF)));
        expect(divider[900], equals(const Color(0xFF909090)));
      });

      test('green should return MaterialColor', () {
        final green = appColors.green;
        expect(green, isA<MaterialColor>());
        expect(green.toARGB32(), equals(0xFF28A745));
        expect(green[500], equals(const Color(0xFF28A745)));
        expect(green[100], equals(const Color(0xFFA5DBB1)));
        expect(green[900], equals(const Color(0xFF186329)));
      });
    });

    group('Amber Palette Colors (Figma Design System)', () {
      // === New Amber Palette Tests ===
      test('amberLight should return MaterialColor', () {
        final amberLight = appColors.amberLight;
        expect(amberLight, isA<MaterialColor>());
        expect(amberLight.toARGB32(), equals(0xFFFF9575));
        expect(amberLight[500], equals(const Color(0xFFFF9575)));
        expect(amberLight[50], equals(const Color(0xFFFFF7F4)));
        expect(amberLight[900], equals(const Color(0xFF99511D)));
      });

      test('amberLightHover should return MaterialColor', () {
        final amberLightHover = appColors.amberLightHover;
        expect(amberLightHover, isA<MaterialColor>());
        expect(amberLightHover.toARGB32(), equals(0xFFFF8C5C));
        expect(amberLightHover[500], equals(const Color(0xFFFF8C5C)));
        expect(amberLightHover[50], equals(const Color(0xFFFFF6F2)));
        expect(amberLightHover[900], equals(const Color(0xFF994810)));
      });

      test('amberLightActive should return MaterialColor', () {
        final amberLightActive = appColors.amberLightActive;
        expect(amberLightActive, isA<MaterialColor>());
        expect(amberLightActive.toARGB32(), equals(0xFFFF8347));
        expect(amberLightActive[500], equals(const Color(0xFFFF8347)));
        expect(amberLightActive[50], equals(const Color(0xFFFFF5F1)));
        expect(amberLightActive[900], equals(const Color(0xFF993F13)));
      });

      test('amberNormal should return MaterialColor', () {
        final amberNormal = appColors.amberNormal;
        expect(amberNormal, isA<MaterialColor>());
        expect(amberNormal.toARGB32(), equals(0xFFFF6B35));
        expect(amberNormal[500], equals(const Color(0xFFFF6B35)));
        expect(amberNormal[50], equals(const Color(0xFFFFF4F0)));
        expect(amberNormal[900], equals(const Color(0xFF99270D)));
      });

      test('amberNormalHover should return MaterialColor', () {
        final amberNormalHover = appColors.amberNormalHover;
        expect(amberNormalHover, isA<MaterialColor>());
        expect(amberNormalHover.toARGB32(), equals(0xFFFF5A1F));
        expect(amberNormalHover[500], equals(const Color(0xFFFF5A1F)));
        expect(amberNormalHover[50], equals(const Color(0xFFFFF3EE)));
        expect(amberNormalHover[900], equals(const Color(0xFF991603)));
      });

      test('amberNormalActive should return MaterialColor', () {
        final amberNormalActive = appColors.amberNormalActive;
        expect(amberNormalActive, isA<MaterialColor>());
        expect(amberNormalActive.toARGB32(), equals(0xFFE55A2B));
        expect(amberNormalActive[500], equals(const Color(0xFFE55A2B)));
        expect(amberNormalActive[50], equals(const Color(0xFFFEF2F0)));
        expect(amberNormalActive[900], equals(const Color(0xFF8B2E0F)));
      });

      test('amberDark should return MaterialColor', () {
        final amberDark = appColors.amberDark;
        expect(amberDark, isA<MaterialColor>());
        expect(amberDark.toARGB32(), equals(0xFFCC5429));
        expect(amberDark[500], equals(const Color(0xFFCC5429)));
        expect(amberDark[50], equals(const Color(0xFFFDF1ED)));
        expect(amberDark[900], equals(const Color(0xFF802B15)));
      });

      test('amberDarkHover should return MaterialColor', () {
        final amberDarkHover = appColors.amberDarkHover;
        expect(amberDarkHover, isA<MaterialColor>());
        expect(amberDarkHover.toARGB32(), equals(0xFFB8481F));
        expect(amberDarkHover[500], equals(const Color(0xFFB8481F)));
        expect(amberDarkHover[50], equals(const Color(0xFFFCEFEA)));
        expect(amberDarkHover[900], equals(const Color(0xFF742013)));
      });

      test('amberDarkActive should return MaterialColor', () {
        final amberDarkActive = appColors.amberDarkActive;
        expect(amberDarkActive, isA<MaterialColor>());
        expect(amberDarkActive.toARGB32(), equals(0xFFA53D1A));
        expect(amberDarkActive[500], equals(const Color(0xFFA53D1A)));
        expect(amberDarkActive[50], equals(const Color(0xFFFBEDE7)));
        expect(amberDarkActive[900], equals(const Color(0xFF61250E)));
      });

      test('amberDarker should return MaterialColor', () {
        final amberDarker = appColors.amberDarker;
        expect(amberDarker, isA<MaterialColor>());
        expect(amberDarker.toARGB32(), equals(0xFF923315));
        expect(amberDarker[500], equals(const Color(0xFF923315)));
        expect(amberDarker[50], equals(const Color(0xFFF9EBE5)));
        expect(amberDarker[900], equals(const Color(0xFF521F0D)));
      });

      test('amberPale should return MaterialColor', () {
        final amberPale = appColors.amberPale;
        expect(amberPale, isA<MaterialColor>());
        expect(amberPale.toARGB32(), equals(0xFFFFF4F0));
        expect(amberPale[50], equals(const Color(0xFFFFF4F0)));
      });

      // === MaterialColor as Color Tests ===
      test('all amber MaterialColor can be used directly as Color', () {
        // MaterialColor can be used directly as Color
        expect(appColors.amberLight, isA<MaterialColor>());
        expect(appColors.amberLight, isA<Color>());
        expect(appColors.amberLight.toARGB32(), equals(0xFFFF9575));

        expect(appColors.amberLightHover, isA<MaterialColor>());
        expect(appColors.amberLightHover.toARGB32(), equals(0xFFFF8C5C));

        expect(appColors.amberLightActive, isA<MaterialColor>());
        expect(appColors.amberLightActive.toARGB32(), equals(0xFFFF8347));

        expect(appColors.amberNormal, isA<MaterialColor>());
        expect(appColors.amberNormal.toARGB32(), equals(0xFFFF6B35));

        expect(appColors.amberNormalHover, isA<MaterialColor>());
        expect(appColors.amberNormalHover.toARGB32(), equals(0xFFFF5A1F));

        expect(appColors.amberNormalActive, isA<MaterialColor>());
        expect(appColors.amberNormalActive.toARGB32(), equals(0xFFE55A2B));

        expect(appColors.amberDark, isA<MaterialColor>());
        expect(appColors.amberDark.toARGB32(), equals(0xFFCC5429));

        expect(appColors.amberDarkHover, isA<MaterialColor>());
        expect(appColors.amberDarkHover.toARGB32(), equals(0xFFB8481F));

        expect(appColors.amberDarkActive, isA<MaterialColor>());
        expect(appColors.amberDarkActive.toARGB32(), equals(0xFFA53D1A));

        expect(appColors.amberDarker, isA<MaterialColor>());
        expect(appColors.amberDarker.toARGB32(), equals(0xFF923315));
      });

      // === Amber Palette Consistency Tests ===
      test('all amber MaterialColors should have proper swatch values', () {
        final amberColors = [
          appColors.amberLight,
          appColors.amberLightHover,
          appColors.amberLightActive,
          appColors.amberNormal,
          appColors.amberNormalHover,
          appColors.amberNormalActive,
          appColors.amberDark,
          appColors.amberDarkHover,
          appColors.amberDarkActive,
          appColors.amberDarker,
        ];

        for (final amberColor in amberColors) {
          expect(amberColor[50], isNotNull);
          expect(amberColor[100], isNotNull);
          expect(amberColor[200], isNotNull);
          expect(amberColor[300], isNotNull);
          expect(amberColor[400], isNotNull);
          expect(amberColor[500], isNotNull);
          expect(amberColor[600], isNotNull);
          expect(amberColor[700], isNotNull);
          expect(amberColor[800], isNotNull);
          expect(amberColor[900], isNotNull);
        }
      });
    });

    group('Complementary Colors', () {
      test('blueComplement should return MaterialColor', () {
        final blueComplement = appColors.blueComplement;
        expect(blueComplement, isA<MaterialColor>());
        expect(blueComplement.toARGB32(), equals(0xFF357DFF));
        expect(blueComplement[500], equals(const Color(0xFF357DFF)));
      });

      test('tealAccent should return MaterialColor', () {
        final tealAccent = appColors.tealAccent;
        expect(tealAccent, isA<MaterialColor>());
        expect(tealAccent.toARGB32(), equals(0xFF35FFB8));
        expect(tealAccent[500], equals(const Color(0xFF35FFB8)));
      });

      test('blueComplementColor should provide direct access', () {
        expect(appColors.blueComplement.toARGB32(), equals(0xFF357DFF));
      });

      test('tealAccentColor should provide direct access', () {
        expect(appColors.tealAccent.toARGB32(), equals(0xFF35FFB8));
      });
    });

    group('Grey Palette', () {
      test('greyLight should return MaterialColor', () {
        final greyLight = appColors.greyLight;
        expect(greyLight, isA<MaterialColor>());
        expect(greyLight.toARGB32(), equals(0xFFE9E9E9));
        expect(greyLight[500], equals(const Color(0xFFE9E9E9)));
        expect(greyLight[50], equals(const Color(0xFFFBFBFB)));
        expect(greyLight[900], equals(const Color(0xFFD9D9D9)));
      });

      test('greyLightHover should return MaterialColor', () {
        final greyLightHover = appColors.greyLightHover;
        expect(greyLightHover, isA<MaterialColor>());
        expect(greyLightHover.toARGB32(), equals(0xFFDEDEDE));
        expect(greyLightHover[500], equals(const Color(0xFFDEDEDE)));
        expect(greyLightHover[50], equals(const Color(0xFFF9F9F9)));
        expect(greyLightHover[900], equals(const Color(0xFFC6C6C6)));
      });

      test('greyLightActive should return MaterialColor', () {
        final greyLightActive = appColors.greyLightActive;
        expect(greyLightActive, isA<MaterialColor>());
        expect(greyLightActive.toARGB32(), equals(0xFFBBBBBB));
        expect(greyLightActive[500], equals(const Color(0xFFBBBBBB)));
        expect(greyLightActive[50], equals(const Color(0xFFF5F5F5)));
        expect(greyLightActive[900], equals(const Color(0xFF979797)));
      });

      test('greyNormal should return MaterialColor', () {
        final greyNormal = appColors.greyNormal;
        expect(greyNormal, isA<MaterialColor>());
        expect(greyNormal.toARGB32(), equals(0xFF242424));
        expect(greyNormal[500], equals(const Color(0xFF242424)));
        expect(greyNormal[50], equals(const Color(0xFFEBEBEB)));
        expect(greyNormal[900], equals(const Color(0xFF181818)));
      });

      test('greyNormalHover should return MaterialColor', () {
        final greyNormalHover = appColors.greyNormalHover;
        expect(greyNormalHover, isA<MaterialColor>());
        expect(greyNormalHover.toARGB32(), equals(0xFF202020));
        expect(greyNormalHover[500], equals(const Color(0xFF202020)));
        expect(greyNormalHover[50], equals(const Color(0xFFE9E9E9)));
        expect(greyNormalHover[900], equals(const Color(0xFF181818)));
      });

      test('greyNormalActive should return MaterialColor', () {
        final greyNormalActive = appColors.greyNormalActive;
        expect(greyNormalActive, isA<MaterialColor>());
        expect(greyNormalActive.toARGB32(), equals(0xFF1D1D1D));
        expect(greyNormalActive[500], equals(const Color(0xFF1D1D1D)));
        expect(greyNormalActive[50], equals(const Color(0xFFE7E7E7)));
        expect(greyNormalActive[900], equals(const Color(0xFF151515)));
      });

      test('greyDark should return MaterialColor', () {
        final greyDark = appColors.greyDark;
        expect(greyDark, isA<MaterialColor>());
        expect(greyDark.toARGB32(), equals(0xFF1B1B1B));
        expect(greyDark[500], equals(const Color(0xFF1B1B1B)));
        expect(greyDark[50], equals(const Color(0xFFE5E5E5)));
        expect(greyDark[900], equals(const Color(0xFF131313)));
      });

      test('greyDarkHover should return MaterialColor', () {
        final greyDarkHover = appColors.greyDarkHover;
        expect(greyDarkHover, isA<MaterialColor>());
        expect(greyDarkHover.toARGB32(), equals(0xFF161616));
        expect(greyDarkHover[500], equals(const Color(0xFF161616)));
        expect(greyDarkHover[50], equals(const Color(0xFFE2E2E2)));
        expect(greyDarkHover[900], equals(const Color(0xFF0E0E0E)));
      });

      test('greyDarkActive should return MaterialColor', () {
        final greyDarkActive = appColors.greyDarkActive;
        expect(greyDarkActive, isA<MaterialColor>());
        expect(greyDarkActive.toARGB32(), equals(0xFF101010));
        expect(greyDarkActive[500], equals(const Color(0xFF101010)));
        expect(greyDarkActive[50], equals(const Color(0xFFDFDFDF)));
        expect(greyDarkActive[900], equals(const Color(0xFF0C0C0C)));
      });

      test('greyDarker should return MaterialColor', () {
        final greyDarker = appColors.greyDarker;
        expect(greyDarker, isA<MaterialColor>());
        expect(greyDarker.toARGB32(), equals(0xFF0D0D0D));
        expect(greyDarker[500], equals(const Color(0xFF0D0D0D)));
        expect(greyDarker[50], equals(const Color(0xFFDCDCDC)));
        expect(greyDarker[900], equals(const Color(0xFF090909)));
      });

      test('all grey direct access colors should be correct', () {
        expect(appColors.greyLight.toARGB32(), equals(0xFFE9E9E9));
        expect(appColors.greyLightHover.toARGB32(), equals(0xFFDEDEDE));
        expect(appColors.greyLightActive.toARGB32(), equals(0xFFBBBBBB));
        expect(appColors.greyNormal.toARGB32(), equals(0xFF242424));
        expect(appColors.greyNormalHover.toARGB32(), equals(0xFF202020));
        expect(appColors.greyNormalActive.toARGB32(), equals(0xFF1D1D1D));
        expect(appColors.greyDark.toARGB32(), equals(0xFF1B1B1B));
        expect(appColors.greyDarkHover.toARGB32(), equals(0xFF161616));
        expect(appColors.greyDarkActive.toARGB32(), equals(0xFF101010));
        expect(appColors.greyDarker.toARGB32(), equals(0xFF0D0D0D));
      });

      test('all grey MaterialColors should have proper swatch values', () {
        final greyColors = [
          appColors.greyLight,
          appColors.greyLightHover,
          appColors.greyLightActive,
          appColors.greyNormal,
          appColors.greyNormalHover,
          appColors.greyNormalActive,
          appColors.greyDark,
          appColors.greyDarkHover,
          appColors.greyDarkActive,
          appColors.greyDarker,
        ];

        for (final greyColor in greyColors) {
          expect(greyColor[50], isNotNull);
          expect(greyColor[100], isNotNull);
          expect(greyColor[200], isNotNull);
          expect(greyColor[300], isNotNull);
          expect(greyColor[400], isNotNull);
          expect(greyColor[500], isNotNull);
          expect(greyColor[600], isNotNull);
          expect(greyColor[700], isNotNull);
          expect(greyColor[800], isNotNull);
          expect(greyColor[900], isNotNull);
        }
      });
    });

    group('Neutral Colors MaterialColor Properties', () {
      test('charcoal should return MaterialColor', () {
        final charcoal = appColors.charcoal;
        expect(charcoal, isA<MaterialColor>());
        expect(charcoal.toARGB32(), equals(0xFF2D3436));
        expect(charcoal[500], equals(const Color(0xFF2D3436)));
        expect(charcoal[50], equals(const Color(0xFFF7F8F8)));
        expect(charcoal[900], equals(const Color(0xFF1D2022)));
      });

      test('warmGray should return MaterialColor', () {
        final warmGray = appColors.warmGray;
        expect(warmGray, isA<MaterialColor>());
        expect(warmGray.toARGB32(), equals(0xFF8B7355));
        expect(warmGray[500], equals(const Color(0xFF8B7355)));
        expect(warmGray[50], equals(const Color(0xFFF9F8F6)));
        expect(warmGray[900], equals(const Color(0xFF533B31)));
      });

      test('lightGray should return MaterialColor', () {
        final lightGray = appColors.lightGray;
        expect(lightGray, isA<MaterialColor>());
        expect(lightGray.toARGB32(), equals(0xFFF8F9FA));
        expect(lightGray[500], equals(const Color(0xFFEEEFF0)));
        expect(lightGray[50], equals(const Color(0xFFF8F9FA)));
        expect(lightGray[900], equals(const Color(0xFFE6E7E8)));
      });

      test('charcoalColor should provide direct access', () {
        expect(appColors.charcoal.toARGB32(), equals(0xFF2D3436));
        expect(appColors.charcoal, isA<Color>());
      });
    });

    group('Basic Color properties', () {
      test('bgMain should return correct color', () {
        expect(appColors.bgMain.toARGB32(), equals(0xFFFFFFFF));
      });

      test('accent should return correct color', () {
        expect(appColors.accent.toARGB32(), equals(0xFFE0E7FF));
      });

      test('textPrimary should return correct color', () {
        expect(appColors.textPrimary.toARGB32(), equals(0xFF1E293B));
      });

      test('textSecondary should return correct color', () {
        expect(appColors.textSecondary.toARGB32(), equals(0xFF64748B));
      });

      test('slateBlue should return correct color', () {
        expect(appColors.slateBlue.toARGB32(), equals(0xFF607395));
      });

      test('onboardingBackground should return correct color', () {
        expect(appColors.onboardingBackground.toARGB32(), equals(0xFFE9F0F2));
      });

      test('onboardingGradientStart should return correct color', () {
        expect(
          appColors.onboardingGradientStart.toARGB32(),
          equals(0xFF00B3C6),
        );
      });

      test('onboardingGradientEnd should return correct color', () {
        expect(appColors.onboardingGradientEnd.toARGB32(), equals(0xFF5D84B4));
      });
    });

    group('Dark mode Color properties', () {
      test('bgMainDark should return correct color', () {
        expect(appColors.bgMainDark.toARGB32(), equals(0xFF121212));
      });

      test('primaryDark should return correct color', () {
        expect(appColors.primaryDark.toARGB32(), equals(0xFF3B82F6));
      });

      test('secondaryDark should return correct color', () {
        expect(appColors.secondaryDark.toARGB32(), equals(0xFF6366F1));
      });

      test('accentDark should return correct color', () {
        expect(appColors.accentDark.toARGB32(), equals(0xFF1E293B));
      });

      test('textPrimaryDark should return correct color', () {
        expect(appColors.textPrimaryDark.toARGB32(), equals(0xFFF1F5F9));
      });

      test('textSecondaryDark should return correct color', () {
        expect(appColors.textSecondaryDark.toARGB32(), equals(0xFFCBD5E1));
      });
    });

    group('Special Color properties', () {
      test('transparent should return correct color', () {
        expect(appColors.transparent, equals(Colors.transparent));
      });
    });

    group('Color consistency tests', () {
      test('all MaterialColors should have proper swatch values', () {
        final materialColors = [
          appColors.primary,
          appColors.secondary,
          appColors.black,
          appColors.white,
          appColors.grey,
          appColors.onboardingBlue,
          appColors.error,
          appColors.title,
          appColors.placeholder,
          appColors.neutral,
          appColors.button,
          appColors.bodyText,
          appColors.red,
          appColors.delete,
          appColors.blue,
          appColors.divider,
          appColors.green,
          // Neutral MaterialColors
          appColors.charcoal,
          appColors.warmGray,
          appColors.lightGray,
        ];

        for (final color in materialColors) {
          expect(color[50], isA<Color>());
          expect(color[100], isA<Color>());
          expect(color[500], isA<Color>());
          expect(color[900], isA<Color>());
        }
      });

      test('light and dark mode colors should be different', () {
        expect(appColors.bgMain, isNot(equals(appColors.bgMainDark)));
        expect(appColors.textPrimary, isNot(equals(appColors.textPrimaryDark)));
        expect(
          appColors.textSecondary,
          isNot(equals(appColors.textSecondaryDark)),
        );
        expect(appColors.accent, isNot(equals(appColors.accentDark)));
      });

      test('all basic colors should be opaque', () {
        final opaqueColors = [
          appColors.bgMain,
          appColors.accent,
          appColors.textPrimary,
          appColors.textSecondary,
          appColors.slateBlue,
          appColors.onboardingBackground,
          appColors.onboardingGradientStart,
          appColors.onboardingGradientEnd,
          appColors.bgMainDark,
          appColors.primaryDark,
          appColors.secondaryDark,
          appColors.accentDark,
          appColors.textPrimaryDark,
          appColors.textSecondaryDark,
        ];

        for (final color in opaqueColors) {
          expect((color.a * 255.0).round() & 0xff, equals(255));
        }
      });

      test('transparent color should be completely transparent', () {
        expect((appColors.transparent.a * 255.0).round() & 0xff, equals(0));
      });
    });

    // === BLUE PALETTE TESTS ===

    group('Blue Palette MaterialColor Tests', () {
      test('should return correct blue light MaterialColor', () {
        final materialColor = appColors.blueLight;
        expect(materialColor.toARGB32(), equals(0xFFEBF3FF));
        expect(materialColor[500], equals(const Color(0xFFEBF3FF)));
        expect(materialColor[50], equals(const Color(0xFFEBF3FF)));
        expect(materialColor[900], equals(const Color(0xFFC3DBFF)));
      });

      test('should return correct blue light hover MaterialColor', () {
        final materialColor = appColors.blueLightHover;
        expect(materialColor.toARGB32(), equals(0xFFD7E7FF));
        expect(materialColor[500], equals(const Color(0xFFD7E7FF)));
      });

      test('should return correct blue light active MaterialColor', () {
        final materialColor = appColors.blueLightActive;
        expect(materialColor.toARGB32(), equals(0xFFAFCFFF));
        expect(materialColor[500], equals(const Color(0xFFAFCFFF)));
      });

      test('should return correct blue normal MaterialColor', () {
        final materialColor = appColors.blueNormal;
        expect(materialColor.toARGB32(), equals(0xFF8B95A7));
        expect(materialColor[500], equals(const Color(0xFF8B95A7)));
        expect(materialColor[50], equals(const Color(0xFFF4F5F7)));
        expect(materialColor[900], equals(const Color(0xFF535963)));
      });

      test('should return correct blue normal hover MaterialColor', () {
        final materialColor = appColors.blueNormalHover;
        expect(materialColor.toARGB32(), equals(0xFF2366E6));
        expect(materialColor[500], equals(const Color(0xFF2366E6)));
      });

      test('should return correct blue normal active MaterialColor', () {
        final materialColor = appColors.blueNormalActive;
        expect(materialColor.toARGB32(), equals(0xFF1C57CC));
        expect(materialColor[500], equals(const Color(0xFF1C57CC)));
      });

      test('should return correct blue dark MaterialColor', () {
        final materialColor = appColors.blueDark;
        expect(materialColor.toARGB32(), equals(0xFF1548B3));
        expect(materialColor[500], equals(const Color(0xFF1548B3)));
      });

      test('should return correct blue dark hover MaterialColor', () {
        final materialColor = appColors.blueDarkHover;
        expect(materialColor.toARGB32(), equals(0xFF0E3999));
        expect(materialColor[500], equals(const Color(0xFF0E3999)));
      });

      test('should return correct blue dark active MaterialColor', () {
        final materialColor = appColors.blueDarkActive;
        expect(materialColor.toARGB32(), equals(0xFF0A2D80));
        expect(materialColor[500], equals(const Color(0xFF0A2D80)));
      });

      test('should return correct blue darker MaterialColor', () {
        final materialColor = appColors.blueDarker;
        expect(materialColor.toARGB32(), equals(0xFF072166));
        expect(materialColor[500], equals(const Color(0xFF072166)));
      });
    });

    group('Blue Palette Direct Color Access Tests', () {
      test('should return correct blue light color', () {
        expect(appColors.blueLight.toARGB32(), equals(0xFFEBF3FF));
      });

      test('should return correct blue light hover color', () {
        expect(appColors.blueLightHover.toARGB32(), equals(0xFFD7E7FF));
      });

      test('should return correct blue light active color', () {
        expect(appColors.blueLightActive.toARGB32(), equals(0xFFAFCFFF));
      });

      test('should return correct blue normal color', () {
        expect(appColors.blueNormal.toARGB32(), equals(0xFF8B95A7));
      });

      test('should return correct blue normal hover color', () {
        expect(appColors.blueNormalHover.toARGB32(), equals(0xFF2366E6));
      });

      test('should return correct blue normal active color', () {
        expect(appColors.blueNormalActive.toARGB32(), equals(0xFF1C57CC));
      });

      test('should return correct blue dark color', () {
        expect(appColors.blueDark.toARGB32(), equals(0xFF1548B3));
      });

      test('should return correct blue dark hover color', () {
        expect(appColors.blueDarkHover.toARGB32(), equals(0xFF0E3999));
      });

      test('should return correct blue dark active color', () {
        expect(appColors.blueDarkActive.toARGB32(), equals(0xFF0A2D80));
      });

      test('should return correct blue darker color', () {
        expect(appColors.blueDarker.toARGB32(), equals(0xFF072166));
      });
    });

    // === SLATE PALETTE TESTS ===

    group('Slate Palette MaterialColor Tests', () {
      test('should return correct slate light MaterialColor', () {
        final materialColor = appColors.slateLight;
        expect(materialColor.toARGB32(), equals(0xFFE8F0FF));
        expect(materialColor[500], equals(const Color(0xFFE8F0FF)));
        expect(materialColor[50], equals(const Color(0xFFE8F0FF)));
        expect(materialColor[900], equals(const Color(0xFFC0D8FF)));
      });

      test('should return correct slate light hover MaterialColor', () {
        final materialColor = appColors.slateLightHover;
        expect(materialColor.toARGB32(), equals(0xFFD1E2FF));
        expect(materialColor[500], equals(const Color(0xFFD1E2FF)));
      });

      test('should return correct slate light active MaterialColor', () {
        final materialColor = appColors.slateLightActive;
        expect(materialColor.toARGB32(), equals(0xFFA3C7FF));
        expect(materialColor[500], equals(const Color(0xFFA3C7FF)));
      });

      test('should return correct slate normal MaterialColor', () {
        final materialColor = appColors.slateNormal;
        expect(materialColor.toARGB32(), equals(0xFF1E3A8A));
        expect(materialColor[500], equals(const Color(0xFF1E3A8A)));
        expect(materialColor[50], equals(const Color(0xFFE8F0FF)));
        expect(materialColor[900], equals(const Color(0xFF122252)));
      });

      test('should return correct slate normal hover MaterialColor', () {
        final materialColor = appColors.slateNormalHover;
        expect(materialColor.toARGB32(), equals(0xFF1B3474));
        expect(materialColor[500], equals(const Color(0xFF1B3474)));
      });

      test('should return correct slate normal active MaterialColor', () {
        final materialColor = appColors.slateNormalActive;
        expect(materialColor.toARGB32(), equals(0xFF182E5E));
        expect(materialColor[500], equals(const Color(0xFF182E5E)));
      });

      test('should return correct slate dark MaterialColor', () {
        final materialColor = appColors.slateDark;
        expect(materialColor.toARGB32(), equals(0xFF152848));
        expect(materialColor[500], equals(const Color(0xFF152848)));
      });

      test('should return correct slate dark hover MaterialColor', () {
        final materialColor = appColors.slateDarkHover;
        expect(materialColor.toARGB32(), equals(0xFF122233));
        expect(materialColor[500], equals(const Color(0xFF122233)));
      });

      test('should return correct slate dark active MaterialColor', () {
        final materialColor = appColors.slateDarkActive;
        expect(materialColor.toARGB32(), equals(0xFF0F1C2E));
        expect(materialColor[500], equals(const Color(0xFF0F1C2E)));
      });

      test('should return correct slate darker MaterialColor', () {
        final materialColor = appColors.slateDarker;
        expect(materialColor.toARGB32(), equals(0xFF0C1629));
        expect(materialColor[500], equals(const Color(0xFF0C1629)));
      });
    });

    group('Slate Palette Direct Color Access Tests', () {
      test('should return correct slate light color', () {
        expect(appColors.slateLight.toARGB32(), equals(0xFFE8F0FF));
      });

      test('should return correct slate light hover color', () {
        expect(appColors.slateLightHover.toARGB32(), equals(0xFFD1E2FF));
      });

      test('should return correct slate light active color', () {
        expect(appColors.slateLightActive.toARGB32(), equals(0xFFA3C7FF));
      });

      test('should return correct slate normal color', () {
        expect(appColors.slateNormal.toARGB32(), equals(0xFF1E3A8A));
      });

      test('should return correct slate normal hover color', () {
        expect(appColors.slateNormalHover.toARGB32(), equals(0xFF1B3474));
      });

      test('should return correct slate normal active color', () {
        expect(appColors.slateNormalActive.toARGB32(), equals(0xFF182E5E));
      });

      test('should return correct slate dark color', () {
        expect(appColors.slateDark.toARGB32(), equals(0xFF152848));
      });

      test('should return correct slate dark hover color', () {
        expect(appColors.slateDarkHover.toARGB32(), equals(0xFF122233));
      });

      test('should return correct slate dark active color', () {
        expect(appColors.slateDarkActive.toARGB32(), equals(0xFF0F1C2E));
      });

      test('should return correct slate darker color', () {
        expect(appColors.slateDarker.toARGB32(), equals(0xFF0C1629));
      });
    });

    // === GREEN PALETTE TESTS ===

    group('Green Palette MaterialColor Tests', () {
      test('should return correct green light MaterialColor', () {
        final materialColor = appColors.greenLight;
        expect(materialColor.toARGB32(), equals(0xFFECFDF5));
        expect(materialColor[500], equals(const Color(0xFFECFDF5)));
        expect(materialColor[50], equals(const Color(0xFFECFDF5)));
        expect(materialColor[900], equals(const Color(0xFFC4F5DD)));
      });

      test('should return correct green light hover MaterialColor', () {
        final materialColor = appColors.greenLightHover;
        expect(materialColor.toARGB32(), equals(0xFFD1FAE5));
        expect(materialColor[500], equals(const Color(0xFFD1FAE5)));
      });

      test('should return correct green light active MaterialColor', () {
        final materialColor = appColors.greenLightActive;
        expect(materialColor.toARGB32(), equals(0xFFA7F3D0));
        expect(materialColor[500], equals(const Color(0xFFA7F3D0)));
      });

      test('should return correct green normal MaterialColor', () {
        final materialColor = appColors.greenNormal;
        expect(materialColor.toARGB32(), equals(0xFF10B981));
        expect(materialColor[500], equals(const Color(0xFF10B981)));
        expect(materialColor[50], equals(const Color(0xFFECFDF5)));
        expect(materialColor[900], equals(const Color(0xFF0C7151)));
      });

      test('should return correct green normal hover MaterialColor', () {
        final materialColor = appColors.greenNormalHover;
        expect(materialColor.toARGB32(), equals(0xFF059669));
        expect(materialColor[500], equals(const Color(0xFF059669)));
      });

      test('should return correct green normal active MaterialColor', () {
        final materialColor = appColors.greenNormalActive;
        expect(materialColor.toARGB32(), equals(0xFF047857));
        expect(materialColor[500], equals(const Color(0xFF047857)));
      });

      test('should return correct green dark MaterialColor', () {
        final materialColor = appColors.greenDark;
        expect(materialColor.toARGB32(), equals(0xFF065F46));
        expect(materialColor[500], equals(const Color(0xFF065F46)));
      });

      test('should return correct green dark hover MaterialColor', () {
        final materialColor = appColors.greenDarkHover;
        expect(materialColor.toARGB32(), equals(0xFF064E3B));
        expect(materialColor[500], equals(const Color(0xFF064E3B)));
      });

      test('should return correct green dark active MaterialColor', () {
        final materialColor = appColors.greenDarkActive;
        expect(materialColor.toARGB32(), equals(0xFF022C22));
        expect(materialColor[500], equals(const Color(0xFF022C22)));
      });

      test('should return correct green darker MaterialColor', () {
        final materialColor = appColors.greenDarker;
        expect(materialColor.toARGB32(), equals(0xFF012A20));
        expect(materialColor[500], equals(const Color(0xFF012A20)));
      });
    });

    group('Green Palette Direct Color Access Tests', () {
      test('should return correct green light color', () {
        expect(appColors.greenLight.toARGB32(), equals(0xFFECFDF5));
      });

      test('should return correct green light hover color', () {
        expect(appColors.greenLightHover.toARGB32(), equals(0xFFD1FAE5));
      });

      test('should return correct green light active color', () {
        expect(appColors.greenLightActive.toARGB32(), equals(0xFFA7F3D0));
      });

      test('should return correct green normal color', () {
        expect(appColors.greenNormal.toARGB32(), equals(0xFF10B981));
      });

      test('should return correct green normal hover color', () {
        expect(appColors.greenNormalHover.toARGB32(), equals(0xFF059669));
      });

      test('should return correct green normal active color', () {
        expect(appColors.greenNormalActive.toARGB32(), equals(0xFF047857));
      });

      test('should return correct green dark color', () {
        expect(appColors.greenDark.toARGB32(), equals(0xFF065F46));
      });

      test('should return correct green dark hover color', () {
        expect(appColors.greenDarkHover.toARGB32(), equals(0xFF064E3B));
      });

      test('should return correct green dark active color', () {
        expect(appColors.greenDarkActive.toARGB32(), equals(0xFF022C22));
      });

      test('should return correct green darker color', () {
        expect(appColors.greenDarker.toARGB32(), equals(0xFF012A20));
      });
    });

    // === PINK PALETTE TESTS ===

    group('Pink Palette MaterialColor Tests', () {
      test('should return correct pink light MaterialColor', () {
        final materialColor = appColors.pinkLight;
        expect(materialColor.toARGB32(), equals(0xFFFDF2F8));
        expect(materialColor[500], equals(const Color(0xFFFDF2F8)));
        expect(materialColor[50], equals(const Color(0xFFFDF2F8)));
        expect(materialColor[900], equals(const Color(0xFFFAE2E8)));
      });

      test('should return correct pink light hover MaterialColor', () {
        final materialColor = appColors.pinkLightHover;
        expect(materialColor.toARGB32(), equals(0xFFFCE7F3));
        expect(materialColor[500], equals(const Color(0xFFFCE7F3)));
      });

      test('should return correct pink light active MaterialColor', () {
        final materialColor = appColors.pinkLightActive;
        expect(materialColor.toARGB32(), equals(0xFFF9A8D4));
        expect(materialColor[500], equals(const Color(0xFFF9A8D4)));
      });

      test('should return correct pink normal MaterialColor', () {
        final materialColor = appColors.pinkNormal;
        expect(materialColor.toARGB32(), equals(0xFFEC4899));
        expect(materialColor[500], equals(const Color(0xFFEC4899)));
        expect(materialColor[50], equals(const Color(0xFFFDF2F8)));
        expect(materialColor[900], equals(const Color(0xFF9D174D)));
      });

      test('should return correct pink normal hover MaterialColor', () {
        final materialColor = appColors.pinkNormalHover;
        expect(materialColor.toARGB32(), equals(0xFFDB2777));
        expect(materialColor[500], equals(const Color(0xFFDB2777)));
      });

      test('should return correct pink normal active MaterialColor', () {
        final materialColor = appColors.pinkNormalActive;
        expect(materialColor.toARGB32(), equals(0xFFBE185D));
        expect(materialColor[500], equals(const Color(0xFFBE185D)));
      });

      test('should return correct pink dark MaterialColor', () {
        final materialColor = appColors.pinkDark;
        expect(materialColor.toARGB32(), equals(0xFF9D174D));
        expect(materialColor[500], equals(const Color(0xFF9D174D)));
      });

      test('should return correct pink dark hover MaterialColor', () {
        final materialColor = appColors.pinkDarkHover;
        expect(materialColor.toARGB32(), equals(0xFF831843));
        expect(materialColor[500], equals(const Color(0xFF831843)));
      });

      test('should return correct pink dark active MaterialColor', () {
        final materialColor = appColors.pinkDarkActive;
        expect(materialColor.toARGB32(), equals(0xFF701A43));
        expect(materialColor[500], equals(const Color(0xFF701A43)));
      });

      test('should return correct pink darker MaterialColor', () {
        final materialColor = appColors.pinkDarker;
        expect(materialColor.toARGB32(), equals(0xFF4C1D2E));
        expect(materialColor[500], equals(const Color(0xFF4C1D2E)));
      });
    });

    group('Pink Palette Direct Color Access Tests', () {
      test('should return correct pink light color', () {
        expect(appColors.pinkLight.toARGB32(), equals(0xFFFDF2F8));
      });

      test('should return correct pink light hover color', () {
        expect(appColors.pinkLightHover.toARGB32(), equals(0xFFFCE7F3));
      });

      test('should return correct pink light active color', () {
        expect(appColors.pinkLightActive.toARGB32(), equals(0xFFF9A8D4));
      });

      test('should return correct pink normal color', () {
        expect(appColors.pinkNormal.toARGB32(), equals(0xFFEC4899));
      });

      test('should return correct pink normal hover color', () {
        expect(appColors.pinkNormalHover.toARGB32(), equals(0xFFDB2777));
      });

      test('should return correct pink normal active color', () {
        expect(appColors.pinkNormalActive.toARGB32(), equals(0xFFBE185D));
      });

      test('should return correct pink dark color', () {
        expect(appColors.pinkDark.toARGB32(), equals(0xFF9D174D));
      });

      test('should return correct pink dark hover color', () {
        expect(appColors.pinkDarkHover.toARGB32(), equals(0xFF831843));
      });

      test('should return correct pink dark active color', () {
        expect(appColors.pinkDarkActive.toARGB32(), equals(0xFF701A43));
      });

      test('should return correct pink darker color', () {
        expect(appColors.pinkDarker.toARGB32(), equals(0xFF4C1D2E));
      });
    });

    // === ORANGE PALETTE TESTS ===

    group('Orange Palette MaterialColor Tests', () {
      test('should return correct orange light MaterialColor', () {
        final materialColor = appColors.orangeLight;
        expect(materialColor.toARGB32(), equals(0xFFFFF5E6));
        expect(materialColor[500], equals(const Color(0xFFFFF5E6)));
        expect(materialColor[50], equals(const Color(0xFFFFF5E6)));
        expect(materialColor[900], equals(const Color(0xFFFFE5CE)));
      });

      test('should return correct orange light hover MaterialColor', () {
        final materialColor = appColors.orangeLightHover;
        expect(materialColor.toARGB32(), equals(0xFFFFEDCC));
        expect(materialColor[500], equals(const Color(0xFFFFEDCC)));
      });

      test('should return correct orange light active MaterialColor', () {
        final materialColor = appColors.orangeLightActive;
        expect(materialColor.toARGB32(), equals(0xFFFFE0B3));
        expect(materialColor[500], equals(const Color(0xFFFFE0B3)));
      });

      test('should return correct orange normal MaterialColor', () {
        final materialColor = appColors.orangeNormal;
        expect(materialColor.toARGB32(), equals(0xFFFF7F00));
        expect(materialColor[500], equals(const Color(0xFFFF7F00)));
        expect(materialColor[50], equals(const Color(0xFFFFF5E6)));
        expect(materialColor[900], equals(const Color(0xFF994D00)));
      });

      test('should return correct orange normal hover MaterialColor', () {
        final materialColor = appColors.orangeNormalHover;
        expect(materialColor.toARGB32(), equals(0xFFE67300));
        expect(materialColor[500], equals(const Color(0xFFE67300)));
      });

      test('should return correct orange normal active MaterialColor', () {
        final materialColor = appColors.orangeNormalActive;
        expect(materialColor.toARGB32(), equals(0xFFCC6600));
        expect(materialColor[500], equals(const Color(0xFFCC6600)));
      });

      test('should return correct orange dark MaterialColor', () {
        final materialColor = appColors.orangeDark;
        expect(materialColor.toARGB32(), equals(0xFFB35900));
        expect(materialColor[500], equals(const Color(0xFFB35900)));
      });

      test('should return correct orange dark hover MaterialColor', () {
        final materialColor = appColors.orangeDarkHover;
        expect(materialColor.toARGB32(), equals(0xFF994D00));
        expect(materialColor[500], equals(const Color(0xFF994D00)));
      });

      test('should return correct orange dark active MaterialColor', () {
        final materialColor = appColors.orangeDarkActive;
        expect(materialColor.toARGB32(), equals(0xFF804000));
        expect(materialColor[500], equals(const Color(0xFF804000)));
      });

      test('should return correct orange darker MaterialColor', () {
        final materialColor = appColors.orangeDarker;
        expect(materialColor.toARGB32(), equals(0xFF663300));
        expect(materialColor[500], equals(const Color(0xFF663300)));
      });
    });

    group('Orange Palette Direct Color Access Tests', () {
      test('should return correct orange light color', () {
        expect(appColors.orangeLight.toARGB32(), equals(0xFFFFF5E6));
      });

      test('should return correct orange light hover color', () {
        expect(appColors.orangeLightHover.toARGB32(), equals(0xFFFFEDCC));
      });

      test('should return correct orange light active color', () {
        expect(appColors.orangeLightActive.toARGB32(), equals(0xFFFFE0B3));
      });

      test('should return correct orange normal color', () {
        expect(appColors.orangeNormal.toARGB32(), equals(0xFFFF7F00));
      });

      test('should return correct orange normal hover color', () {
        expect(appColors.orangeNormalHover.toARGB32(), equals(0xFFE67300));
      });

      test('should return correct orange normal active color', () {
        expect(appColors.orangeNormalActive.toARGB32(), equals(0xFFCC6600));
      });

      test('should return correct orange dark color', () {
        expect(appColors.orangeDark.toARGB32(), equals(0xFFB35900));
      });

      test('should return correct orange dark hover color', () {
        expect(appColors.orangeDarkHover.toARGB32(), equals(0xFF994D00));
      });

      test('should return correct orange dark active color', () {
        expect(appColors.orangeDarkActive.toARGB32(), equals(0xFF804000));
      });

      test('should return correct orange darker color', () {
        expect(appColors.orangeDarker.toARGB32(), equals(0xFF663300));
      });
    });

    // === RED PALETTE TESTS ===

    group('Red Palette MaterialColor Tests', () {
      test('should return correct red light MaterialColor', () {
        final materialColor = appColors.redLight;
        expect(materialColor.toARGB32(), equals(0xFFFEF2F2));
        expect(materialColor[50], equals(const Color(0xFFFEF2F2)));
        expect(materialColor[500], equals(const Color(0xFFFEF2F2)));
      });

      test('should return correct red light hover MaterialColor', () {
        final materialColor = appColors.redLightHover;
        expect(materialColor.toARGB32(), equals(0xFFFCE7E7));
        expect(materialColor[50], equals(const Color(0xFFFDF0F0)));
        expect(materialColor[500], equals(const Color(0xFFFCE7E7)));
      });

      test('should return correct red light active MaterialColor', () {
        final materialColor = appColors.redLightActive;
        expect(materialColor.toARGB32(), equals(0xFFF8D7DA));
        expect(materialColor[50], equals(const Color(0xFFF9E8E8)));
        expect(materialColor[500], equals(const Color(0xFFF8D7DA)));
      });

      test('should return correct red normal MaterialColor', () {
        final materialColor = appColors.redNormal;
        expect(materialColor.toARGB32(), equals(0xFFDC3545));
        expect(materialColor[50], equals(const Color(0xFFFEF2F2)));
        expect(materialColor[500], equals(const Color(0xFFDC3545)));
      });

      test('should return correct red normal hover MaterialColor', () {
        final materialColor = appColors.redNormalHover;
        expect(materialColor.toARGB32(), equals(0xFFC82333));
        expect(materialColor[50], equals(const Color(0xFFFCF0F1)));
        expect(materialColor[500], equals(const Color(0xFFC82333)));
      });

      test('should return correct red normal active MaterialColor', () {
        final materialColor = appColors.redNormalActive;
        expect(materialColor.toARGB32(), equals(0xFFB21E2F));
        expect(materialColor[50], equals(const Color(0xFFFAEEF0)));
        expect(materialColor[500], equals(const Color(0xFFB21E2F)));
      });

      test('should return correct red dark MaterialColor', () {
        final materialColor = appColors.redDark;
        expect(materialColor.toARGB32(), equals(0xFF9C1A2B));
        expect(materialColor[50], equals(const Color(0xFFF8ECF0)));
        expect(materialColor[500], equals(const Color(0xFF9C1A2B)));
      });

      test('should return correct red dark hover MaterialColor', () {
        final materialColor = appColors.redDarkHover;
        expect(materialColor.toARGB32(), equals(0xFF861727));
        expect(materialColor[50], equals(const Color(0xFFF6EAED)));
        expect(materialColor[500], equals(const Color(0xFF861727)));
      });

      test('should return correct red dark active MaterialColor', () {
        final materialColor = appColors.redDarkActive;
        expect(materialColor.toARGB32(), equals(0xFF701323));
        expect(materialColor[50], equals(const Color(0xFFF4E8EA)));
        expect(materialColor[500], equals(const Color(0xFF701323)));
      });

      test('should return correct red darker MaterialColor', () {
        final materialColor = appColors.redDarker;
        expect(materialColor.toARGB32(), equals(0xFF5A0F1F));
        expect(materialColor[50], equals(const Color(0xFFF2E6E9)));
        expect(materialColor[500], equals(const Color(0xFF5A0F1F)));
      });
    });

    group('Red Palette Direct Color Access Tests', () {
      test('should return correct red light color', () {
        expect(appColors.redLight.toARGB32(), equals(0xFFFEF2F2));
      });

      test('should return correct red light hover color', () {
        expect(appColors.redLightHover.toARGB32(), equals(0xFFFCE7E7));
      });

      test('should return correct red light active color', () {
        expect(appColors.redLightActive.toARGB32(), equals(0xFFF8D7DA));
      });

      test('should return correct red normal color', () {
        expect(appColors.redNormal.toARGB32(), equals(0xFFDC3545));
      });

      test('should return correct red normal hover color', () {
        expect(appColors.redNormalHover.toARGB32(), equals(0xFFC82333));
      });

      test('should return correct red normal active color', () {
        expect(appColors.redNormalActive.toARGB32(), equals(0xFFB21E2F));
      });

      test('should return correct red dark color', () {
        expect(appColors.redDark.toARGB32(), equals(0xFF9C1A2B));
      });

      test('should return correct red dark hover color', () {
        expect(appColors.redDarkHover.toARGB32(), equals(0xFF861727));
      });

      test('should return correct red dark active color', () {
        expect(appColors.redDarkActive.toARGB32(), equals(0xFF701323));
      });

      test('should return correct red darker color', () {
        expect(appColors.redDarker.toARGB32(), equals(0xFF5A0F1F));
      });
    });
  });
}
