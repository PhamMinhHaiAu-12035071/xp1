import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';

/// Unit tests for AppColorsImpl class
///
/// This test file ensures 100% coverage of all color getters
/// and validates that all color values are correctly defined.
void main() {
  group('AppColorsImpl', () {
    late AppColorsImpl appColors;

    setUp(() {
      appColors = const AppColorsImpl();
    });

    group('MaterialColor Properties', () {
      test('primary should return correct MaterialColor', () {
        expect(appColors.primary, isA<MaterialColor>());
        expect(appColors.primary.toARGB32(), equals(0xFF013773));
      });

      test('secondary should return correct MaterialColor', () {
        expect(appColors.secondary, isA<MaterialColor>());
        expect(appColors.secondary.toARGB32(), equals(0xFF4F46E5));
      });

      test('black should return correct MaterialColor', () {
        expect(appColors.black, isA<MaterialColor>());
        expect(appColors.black.toARGB32(), equals(0xFF000000));
      });

      test('white should return correct MaterialColor', () {
        expect(appColors.white, isA<MaterialColor>());
        expect(appColors.white.toARGB32(), equals(0xFFFFFFFF));
      });

      test('grey should return correct MaterialColor', () {
        expect(appColors.grey, isA<MaterialColor>());
        expect(appColors.grey.toARGB32(), equals(0xFF9E9E9E));
      });

      test('onboardingBlue should return correct MaterialColor', () {
        expect(appColors.onboardingBlue, isA<MaterialColor>());
        expect(appColors.onboardingBlue.toARGB32(), equals(0xFF7384A2));
      });

      test('error should return correct MaterialColor', () {
        expect(appColors.error, isA<MaterialColor>());
        expect(appColors.error.toARGB32(), equals(0xFFDC3545));
      });

      test('title should return correct MaterialColor', () {
        expect(appColors.title, isA<MaterialColor>());
        expect(appColors.title.toARGB32(), equals(0xFF333333));
      });

      test('placeholder should return correct MaterialColor', () {
        expect(appColors.placeholder, isA<MaterialColor>());
        expect(appColors.placeholder.toARGB32(), equals(0xFFB0B0B0));
      });

      test('neutral should return correct MaterialColor', () {
        expect(appColors.neutral, isA<MaterialColor>());
        expect(appColors.neutral.toARGB32(), equals(0xFFE6E6E6));
      });

      test('button should return correct MaterialColor', () {
        expect(appColors.button, isA<MaterialColor>());
        expect(appColors.button.toARGB32(), equals(0xFF013773));
      });

      test('bodyText should return correct MaterialColor', () {
        expect(appColors.bodyText, isA<MaterialColor>());
        expect(appColors.bodyText.toARGB32(), equals(0xFF545454));
      });

      test('red should return correct MaterialColor', () {
        expect(appColors.red, isA<MaterialColor>());
        expect(appColors.red.toARGB32(), equals(0xFFF4C0C5));
      });

      test('delete should return correct MaterialColor', () {
        expect(appColors.delete, isA<MaterialColor>());
        expect(appColors.delete.toARGB32(), equals(0xFFDC3545));
      });

      test('blue should return correct MaterialColor', () {
        expect(appColors.blue, isA<MaterialColor>());
        expect(appColors.blue.toARGB32(), equals(0xFF2196F3));
      });

      test('divider should return correct MaterialColor', () {
        expect(appColors.divider, isA<MaterialColor>());
        expect(appColors.divider.toARGB32(), equals(0xFFB0B0B0));
      });

      test('green should return correct MaterialColor', () {
        expect(appColors.green, isA<MaterialColor>());
        expect(appColors.green.toARGB32(), equals(0xFF28A745));
      });

      test('blueComplement should return correct MaterialColor', () {
        expect(appColors.blueComplement, isA<MaterialColor>());
        expect(appColors.blueComplement.toARGB32(), equals(0xFF357DFF));
      });

      test('tealAccent should return correct MaterialColor', () {
        expect(appColors.tealAccent, isA<MaterialColor>());
        expect(appColors.tealAccent.toARGB32(), equals(0xFF35FFB8));
      });
    });

    group('Direct Color Properties', () {
      test('bgMain should return correct Color', () {
        expect(appColors.bgMain, isA<Color>());
        expect(appColors.bgMain.toARGB32(), equals(0xFFFFFFFF));
      });

      test('accent should return correct Color', () {
        expect(appColors.accent, isA<Color>());
        expect(appColors.accent.toARGB32(), equals(0xFFE0E7FF));
      });

      test('textPrimary should return correct Color', () {
        expect(appColors.textPrimary, isA<Color>());
        expect(appColors.textPrimary.toARGB32(), equals(0xFF1E293B));
      });

      test('textSecondary should return correct Color', () {
        expect(appColors.textSecondary, isA<Color>());
        expect(appColors.textSecondary.toARGB32(), equals(0xFF64748B));
      });

      test('slateBlue should return correct Color', () {
        expect(appColors.slateBlue, isA<Color>());
        expect(appColors.slateBlue.toARGB32(), equals(0xFF607395));
      });

      test('onboardingBackground should return correct Color', () {
        expect(appColors.onboardingBackground, isA<Color>());
        expect(appColors.onboardingBackground.toARGB32(), equals(0xFFE9F0F2));
      });

      test('onboardingGradientStart should return correct color', () {
        expect(
          appColors.onboardingGradientStart.toARGB32(),
          equals(0xFF00B3C6),
        );
        expect(appColors.onboardingGradientStart, isA<Color>());
      });

      test('onboardingGradientEnd should return correct color', () {
        expect(appColors.onboardingGradientEnd.toARGB32(), equals(0xFF5D84B4));
        expect(appColors.onboardingGradientEnd, isA<Color>());
      });

      test('bgMainDark should return correct Color', () {
        expect(appColors.bgMainDark, isA<Color>());
        expect(appColors.bgMainDark.toARGB32(), equals(0xFF121212));
      });

      test('primaryDark should return correct Color', () {
        expect(appColors.primaryDark, isA<Color>());
        expect(appColors.primaryDark.toARGB32(), equals(0xFF3B82F6));
      });

      test('secondaryDark should return correct Color', () {
        expect(appColors.secondaryDark, isA<Color>());
        expect(appColors.secondaryDark.toARGB32(), equals(0xFF6366F1));
      });

      test('accentDark should return correct Color', () {
        expect(appColors.accentDark, isA<Color>());
        expect(appColors.accentDark.toARGB32(), equals(0xFF1E293B));
      });

      test('textPrimaryDark should return correct Color', () {
        expect(appColors.textPrimaryDark, isA<Color>());
        expect(appColors.textPrimaryDark.toARGB32(), equals(0xFFF1F5F9));
      });

      test('textSecondaryDark should return correct Color', () {
        expect(appColors.textSecondaryDark, isA<Color>());
        expect(appColors.textSecondaryDark.toARGB32(), equals(0xFFCBD5E1));
      });

      test('transparent should return correct color', () {
        expect(
          appColors.transparent.toARGB32(),
          equals(Colors.transparent.toARGB32()),
        );
        expect(appColors.transparent, isA<Color>());
      });
    });

    group('MaterialColor Shades', () {
      test('primary MaterialColor shades should be accessible', () {
        final primary = appColors.primary;
        expect(primary[10]?.toARGB32(), equals(0xFFEBF0F7));
        expect(primary[10], isA<Color>());
        expect(primary[500]?.toARGB32(), equals(0xFF013773));
        expect(primary[500], isA<Color>());
      });

      test('secondary MaterialColor shades should be accessible', () {
        final secondary = appColors.secondary;
        expect(secondary[10]?.toARGB32(), equals(0xFFF9F9FE));
        expect(secondary[10], isA<Color>());
        expect(secondary[500]?.toARGB32(), equals(0xFF4F46E5));
        expect(secondary[500], isA<Color>());
      });
    });

    group('Amber Palette', () {
      test('amberLight should return correct MaterialColor', () {
        expect(appColors.amberLight, isA<MaterialColor>());
        expect(appColors.amberLight.toARGB32(), equals(0xFFFF9575));
      });

      test('amberLightHover should return correct MaterialColor', () {
        expect(appColors.amberLightHover, isA<MaterialColor>());
        expect(appColors.amberLightHover.toARGB32(), equals(0xFFFF8C5C));
      });

      test('amberNormal should return correct MaterialColor', () {
        expect(appColors.amberNormal, isA<MaterialColor>());
        expect(appColors.amberNormal.toARGB32(), equals(0xFFFF6B35));
      });

      test('amberDark should return correct MaterialColor', () {
        expect(appColors.amberDark, isA<MaterialColor>());
        expect(appColors.amberDark.toARGB32(), equals(0xFFCC5429));
      });
    });

    group('Grey Palette', () {
      test('greyLight should return correct MaterialColor', () {
        expect(appColors.greyLight, isA<MaterialColor>());
        expect(appColors.greyLight.toARGB32(), equals(0xFFE9E9E9));
      });

      test('greyNormal should return correct MaterialColor', () {
        expect(appColors.greyNormal, isA<MaterialColor>());
        expect(appColors.greyNormal.toARGB32(), equals(0xFF242424));
      });

      test('greyDark should return correct MaterialColor', () {
        expect(appColors.greyDark, isA<MaterialColor>());
        expect(appColors.greyDark.toARGB32(), equals(0xFF1B1B1B));
      });
    });

    group('Blue Palette', () {
      test('blueLight should return correct MaterialColor', () {
        expect(appColors.blueLight, isA<MaterialColor>());
        expect(appColors.blueLight.toARGB32(), equals(0xFFEBF3FF));
      });

      test('blueNormal should return correct MaterialColor', () {
        expect(appColors.blueNormal, isA<MaterialColor>());
        expect(appColors.blueNormal.toARGB32(), equals(0xFF8B95A7));
      });

      test('blueDark should return correct MaterialColor', () {
        expect(appColors.blueDark, isA<MaterialColor>());
        expect(appColors.blueDark.toARGB32(), equals(0xFF1548B3));
      });
    });

    group('Slate Palette', () {
      test('slateLight should return correct MaterialColor', () {
        expect(appColors.slateLight, isA<MaterialColor>());
        expect(appColors.slateLight.toARGB32(), equals(0xFFE8F0FF));
      });

      test('slateNormal should return correct MaterialColor', () {
        expect(appColors.slateNormal, isA<MaterialColor>());
        expect(appColors.slateNormal.toARGB32(), equals(0xFF1E3A8A));
      });

      test('slateDark should return correct MaterialColor', () {
        expect(appColors.slateDark, isA<MaterialColor>());
        expect(appColors.slateDark.toARGB32(), equals(0xFF152848));
      });
    });

    group('Green Palette', () {
      test('greenLight should return correct MaterialColor', () {
        expect(appColors.greenLight, isA<MaterialColor>());
        expect(appColors.greenLight.toARGB32(), equals(0xFFECFDF5));
      });

      test('greenNormal should return correct MaterialColor', () {
        expect(appColors.greenNormal, isA<MaterialColor>());
        expect(appColors.greenNormal.toARGB32(), equals(0xFF10B981));
      });

      test('greenDark should return correct MaterialColor', () {
        expect(appColors.greenDark, isA<MaterialColor>());
        expect(appColors.greenDark.toARGB32(), equals(0xFF065F46));
      });
    });

    group('Pink Palette', () {
      test('pinkLight should return correct MaterialColor', () {
        expect(appColors.pinkLight, isA<MaterialColor>());
        expect(appColors.pinkLight.toARGB32(), equals(0xFFFDF2F8));
      });

      test('pinkNormal should return correct MaterialColor', () {
        expect(appColors.pinkNormal, isA<MaterialColor>());
        expect(appColors.pinkNormal.toARGB32(), equals(0xFFEC4899));
      });

      test('pinkDark should return correct MaterialColor', () {
        expect(appColors.pinkDark, isA<MaterialColor>());
        expect(appColors.pinkDark.toARGB32(), equals(0xFF9D174D));
      });
    });

    group('Orange Palette', () {
      test('orangeLight should return correct MaterialColor', () {
        expect(appColors.orangeLight, isA<MaterialColor>());
        expect(appColors.orangeLight.toARGB32(), equals(0xFFFFF5E6));
      });

      test('orangeNormal should return correct MaterialColor', () {
        expect(appColors.orangeNormal, isA<MaterialColor>());
        expect(appColors.orangeNormal.toARGB32(), equals(0xFFFF7F00));
      });

      test('orangeDark should return correct MaterialColor', () {
        expect(appColors.orangeDark, isA<MaterialColor>());
        expect(appColors.orangeDark.toARGB32(), equals(0xFFB35900));
      });
    });

    group('Red Palette', () {
      test('redLight should return correct MaterialColor', () {
        expect(appColors.redLight, isA<MaterialColor>());
        expect(appColors.redLight.toARGB32(), equals(0xFFFEF2F2));
      });

      test('redNormal should return correct MaterialColor', () {
        expect(appColors.redNormal, isA<MaterialColor>());
        expect(appColors.redNormal.toARGB32(), equals(0xFFDC3545));
      });

      test('redDark should return correct MaterialColor', () {
        expect(appColors.redDark, isA<MaterialColor>());
        expect(appColors.redDark.toARGB32(), equals(0xFF9C1A2B));
      });
    });

    group('Direct Color Access Methods', () {
      test('amberLightColor should return correct color', () {
        expect(appColors.amberLightColor.toARGB32(), equals(0xFFFF9575));
      });

      test('amberNormalColor should return correct color', () {
        expect(appColors.amberNormalColor.toARGB32(), equals(0xFFFF6B35));
      });

      test('amberDarkColor should return correct color', () {
        expect(appColors.amberDarkColor.toARGB32(), equals(0xFFCC5429));
      });

      test('blueComplementColor should return correct color', () {
        expect(appColors.blueComplementColor.toARGB32(), equals(0xFF357DFF));
      });

      test('tealAccentColor should return correct color', () {
        expect(appColors.tealAccentColor.toARGB32(), equals(0xFF35FFB8));
      });

      test('greyLightColor should return correct color', () {
        expect(appColors.greyLightColor.toARGB32(), equals(0xFFE9E9E9));
      });

      test('greyNormalColor should return correct color', () {
        expect(appColors.greyNormalColor.toARGB32(), equals(0xFF242424));
      });

      test('greyDarkColor should return correct color', () {
        expect(appColors.greyDarkColor.toARGB32(), equals(0xFF1B1B1B));
      });

      test('blueLightColor should return correct color', () {
        expect(appColors.blueLightColor.toARGB32(), equals(0xFFEBF3FF));
      });

      test('blueNormalColor should return correct color', () {
        expect(appColors.blueNormalColor.toARGB32(), equals(0xFF8B95A7));
      });

      test('blueDarkColor should return correct color', () {
        expect(appColors.blueDarkColor.toARGB32(), equals(0xFF1548B3));
      });

      test('slateLightColor should return correct color', () {
        expect(appColors.slateLightColor.toARGB32(), equals(0xFFE8F0FF));
      });

      test('slateNormalColor should return correct color', () {
        expect(appColors.slateNormalColor.toARGB32(), equals(0xFF1E3A8A));
      });

      test('slateDarkColor should return correct color', () {
        expect(appColors.slateDarkColor.toARGB32(), equals(0xFF152848));
      });

      test('greenLightColor should return correct color', () {
        expect(appColors.greenLightColor.toARGB32(), equals(0xFFECFDF5));
      });

      test('greenNormalColor should return correct color', () {
        expect(appColors.greenNormalColor.toARGB32(), equals(0xFF10B981));
      });

      test('greenDarkColor should return correct color', () {
        expect(appColors.greenDarkColor.toARGB32(), equals(0xFF065F46));
      });

      test('pinkLightColor should return correct color', () {
        expect(appColors.pinkLightColor.toARGB32(), equals(0xFFFDF2F8));
      });

      test('pinkNormalColor should return correct color', () {
        expect(appColors.pinkNormalColor.toARGB32(), equals(0xFFEC4899));
      });

      test('pinkDarkColor should return correct color', () {
        expect(appColors.pinkDarkColor.toARGB32(), equals(0xFF9D174D));
      });

      test('orangeLightColor should return correct color', () {
        expect(appColors.orangeLightColor.toARGB32(), equals(0xFFFFF5E6));
      });

      test('orangeNormalColor should return correct color', () {
        expect(appColors.orangeNormalColor.toARGB32(), equals(0xFFFF7F00));
      });

      test('orangeDarkColor should return correct color', () {
        expect(appColors.orangeDarkColor.toARGB32(), equals(0xFFB35900));
      });

      test('redLightColor should return correct color', () {
        expect(appColors.redLightColor.toARGB32(), equals(0xFFFEF2F2));
      });

      test('redNormalColor should return correct color', () {
        expect(appColors.redNormalColor.toARGB32(), equals(0xFFDC3545));
      });

      test('redDarkColor should return correct color', () {
        expect(appColors.redDarkColor.toARGB32(), equals(0xFF9C1A2B));
      });
    });

    // === COMPREHENSIVE PALETTE MATERIAL COLOR TESTS ===
    group('Extended Palette MaterialColor Tests', () {
      group('Amber Palette MaterialColors', () {
        test('amberLight MaterialColor should have correct values', () {
          expect(appColors.amberLight, isA<MaterialColor>());
          expect(appColors.amberLight.toARGB32(), equals(0xFFFF9575));
        });

        test('amberLightHover MaterialColor should have correct values', () {
          expect(appColors.amberLightHover, isA<MaterialColor>());
          expect(appColors.amberLightHover.toARGB32(), equals(0xFFFF8C5C));
        });

        test('amberLightActive MaterialColor should have correct values', () {
          expect(appColors.amberLightActive, isA<MaterialColor>());
          expect(appColors.amberLightActive.toARGB32(), equals(0xFFFF8347));
        });

        test('amberNormal MaterialColor should have correct values', () {
          expect(appColors.amberNormal, isA<MaterialColor>());
          expect(appColors.amberNormal.toARGB32(), equals(0xFFFF6B35));
        });

        test('amberNormalHover MaterialColor should have correct values', () {
          expect(appColors.amberNormalHover, isA<MaterialColor>());
          expect(appColors.amberNormalHover.toARGB32(), equals(0xFFFF5A1F));
        });

        test('amberNormalActive MaterialColor should have correct values', () {
          expect(appColors.amberNormalActive, isA<MaterialColor>());
          expect(appColors.amberNormalActive.toARGB32(), equals(0xFFE55A2B));
        });

        test('amberDark MaterialColor should have correct values', () {
          expect(appColors.amberDark, isA<MaterialColor>());
          expect(appColors.amberDark.toARGB32(), equals(0xFFCC5429));
        });

        test('amberDarkHover MaterialColor should have correct values', () {
          expect(appColors.amberDarkHover, isA<MaterialColor>());
          expect(appColors.amberDarkHover.toARGB32(), equals(0xFFB8481F));
        });

        test('amberDarkActive MaterialColor should have correct values', () {
          expect(appColors.amberDarkActive, isA<MaterialColor>());
          expect(appColors.amberDarkActive.toARGB32(), equals(0xFFA53D1A));
        });

        test('amberDarker MaterialColor should have correct values', () {
          expect(appColors.amberDarker, isA<MaterialColor>());
          expect(appColors.amberDarker.toARGB32(), equals(0xFF923315));
        });

        test('amberPale MaterialColor should have correct values', () {
          expect(appColors.amberPale, isA<MaterialColor>());
          expect(appColors.amberPale.toARGB32(), equals(0xFFFFF4F0));
        });
      });

      group('Grey Extended Palette MaterialColors', () {
        test('greyLight MaterialColor should have correct values', () {
          expect(appColors.greyLight, isA<MaterialColor>());
          expect(appColors.greyLight.toARGB32(), equals(0xFFE9E9E9));
        });

        test('greyLightHover MaterialColor should have correct values', () {
          expect(appColors.greyLightHover, isA<MaterialColor>());
          expect(appColors.greyLightHover.toARGB32(), equals(0xFFDEDEDE));
        });

        test('greyLightActive MaterialColor should have correct values', () {
          expect(appColors.greyLightActive, isA<MaterialColor>());
          expect(appColors.greyLightActive.toARGB32(), equals(0xFFBBBBBB));
        });

        test('greyNormal MaterialColor should have correct values', () {
          expect(appColors.greyNormal, isA<MaterialColor>());
          expect(appColors.greyNormal.toARGB32(), equals(0xFF242424));
        });

        test('greyNormalHover MaterialColor should have correct values', () {
          expect(appColors.greyNormalHover, isA<MaterialColor>());
          expect(appColors.greyNormalHover.toARGB32(), equals(0xFF202020));
        });

        test('greyNormalActive MaterialColor should have correct values', () {
          expect(appColors.greyNormalActive, isA<MaterialColor>());
          expect(appColors.greyNormalActive.toARGB32(), equals(0xFF1D1D1D));
        });

        test('greyDark MaterialColor should have correct values', () {
          expect(appColors.greyDark, isA<MaterialColor>());
          expect(appColors.greyDark.toARGB32(), equals(0xFF1B1B1B));
        });

        test('greyDarkHover MaterialColor should have correct values', () {
          expect(appColors.greyDarkHover, isA<MaterialColor>());
          expect(appColors.greyDarkHover.toARGB32(), equals(0xFF161616));
        });

        test('greyDarkActive MaterialColor should have correct values', () {
          expect(appColors.greyDarkActive, isA<MaterialColor>());
          expect(appColors.greyDarkActive.toARGB32(), equals(0xFF101010));
        });

        test('greyDarker MaterialColor should have correct values', () {
          expect(appColors.greyDarker, isA<MaterialColor>());
          expect(appColors.greyDarker.toARGB32(), equals(0xFF0D0D0D));
        });
      });

      group('Blue Extended Palette MaterialColors', () {
        test('blueLight MaterialColor should have correct values', () {
          expect(appColors.blueLight, isA<MaterialColor>());
          expect(appColors.blueLight.toARGB32(), equals(0xFFEBF3FF));
        });

        test('blueLightHover MaterialColor should have correct values', () {
          expect(appColors.blueLightHover, isA<MaterialColor>());
          expect(appColors.blueLightHover.toARGB32(), equals(0xFFD7E7FF));
        });

        test('blueLightActive MaterialColor should have correct values', () {
          expect(appColors.blueLightActive, isA<MaterialColor>());
          expect(appColors.blueLightActive.toARGB32(), equals(0xFFAFCFFF));
        });

        test('blueNormal MaterialColor should have correct values', () {
          expect(appColors.blueNormal, isA<MaterialColor>());
          expect(appColors.blueNormal.toARGB32(), equals(0xFF8B95A7));
        });

        test('blueNormalHover MaterialColor should have correct values', () {
          expect(appColors.blueNormalHover, isA<MaterialColor>());
          expect(appColors.blueNormalHover.toARGB32(), equals(0xFF2366E6));
        });

        test('blueNormalActive MaterialColor should have correct values', () {
          expect(appColors.blueNormalActive, isA<MaterialColor>());
          expect(appColors.blueNormalActive.toARGB32(), equals(0xFF1C57CC));
        });

        test('blueDark MaterialColor should have correct values', () {
          expect(appColors.blueDark, isA<MaterialColor>());
          expect(appColors.blueDark.toARGB32(), equals(0xFF1548B3));
        });

        test('blueDarkHover MaterialColor should have correct values', () {
          expect(appColors.blueDarkHover, isA<MaterialColor>());
          expect(appColors.blueDarkHover.toARGB32(), equals(0xFF0E3999));
        });

        test('blueDarkActive MaterialColor should have correct values', () {
          expect(appColors.blueDarkActive, isA<MaterialColor>());
          expect(appColors.blueDarkActive.toARGB32(), equals(0xFF0A2D80));
        });

        test('blueDarker MaterialColor should have correct values', () {
          expect(appColors.blueDarker, isA<MaterialColor>());
          expect(appColors.blueDarker.toARGB32(), equals(0xFF072166));
        });
      });

      group('Slate Palette MaterialColors', () {
        test('slateLight MaterialColor should have correct values', () {
          expect(appColors.slateLight, isA<MaterialColor>());
          expect(appColors.slateLight.toARGB32(), equals(0xFFE8F0FF));
        });

        test('slateLightHover MaterialColor should have correct values', () {
          expect(appColors.slateLightHover, isA<MaterialColor>());
          expect(appColors.slateLightHover.toARGB32(), equals(0xFFD1E2FF));
        });

        test('slateLightActive MaterialColor should have correct values', () {
          expect(appColors.slateLightActive, isA<MaterialColor>());
          expect(appColors.slateLightActive.toARGB32(), equals(0xFFA3C7FF));
        });

        test('slateNormal MaterialColor should have correct values', () {
          expect(appColors.slateNormal, isA<MaterialColor>());
          expect(appColors.slateNormal.toARGB32(), equals(0xFF1E3A8A));
        });

        test('slateNormalHover MaterialColor should have correct values', () {
          expect(appColors.slateNormalHover, isA<MaterialColor>());
          expect(appColors.slateNormalHover.toARGB32(), equals(0xFF1B3474));
        });

        test('slateNormalActive MaterialColor should have correct values', () {
          expect(appColors.slateNormalActive, isA<MaterialColor>());
          expect(appColors.slateNormalActive.toARGB32(), equals(0xFF182E5E));
        });

        test('slateDark MaterialColor should have correct values', () {
          expect(appColors.slateDark, isA<MaterialColor>());
          expect(appColors.slateDark.toARGB32(), equals(0xFF152848));
        });

        test('slateDarkHover MaterialColor should have correct values', () {
          expect(appColors.slateDarkHover, isA<MaterialColor>());
          expect(appColors.slateDarkHover.toARGB32(), equals(0xFF122233));
        });

        test('slateDarkActive MaterialColor should have correct values', () {
          expect(appColors.slateDarkActive, isA<MaterialColor>());
          expect(appColors.slateDarkActive.toARGB32(), equals(0xFF0F1C2E));
        });

        test('slateDarker MaterialColor should have correct values', () {
          expect(appColors.slateDarker, isA<MaterialColor>());
          expect(appColors.slateDarker.toARGB32(), equals(0xFF0C1629));
        });
      });

      group('Green Palette MaterialColors', () {
        test('greenLight MaterialColor should have correct values', () {
          expect(appColors.greenLight, isA<MaterialColor>());
          expect(appColors.greenLight.toARGB32(), equals(0xFFECFDF5));
        });

        test('greenLightHover MaterialColor should have correct values', () {
          expect(appColors.greenLightHover, isA<MaterialColor>());
          expect(appColors.greenLightHover.toARGB32(), equals(0xFFD1FAE5));
        });

        test('greenLightActive MaterialColor should have correct values', () {
          expect(appColors.greenLightActive, isA<MaterialColor>());
          expect(appColors.greenLightActive.toARGB32(), equals(0xFFA7F3D0));
        });

        test('greenNormal MaterialColor should have correct values', () {
          expect(appColors.greenNormal, isA<MaterialColor>());
          expect(appColors.greenNormal.toARGB32(), equals(0xFF10B981));
        });

        test('greenNormalHover MaterialColor should have correct values', () {
          expect(appColors.greenNormalHover, isA<MaterialColor>());
          expect(appColors.greenNormalHover.toARGB32(), equals(0xFF059669));
        });

        test('greenNormalActive MaterialColor should have correct values', () {
          expect(appColors.greenNormalActive, isA<MaterialColor>());
          expect(appColors.greenNormalActive.toARGB32(), equals(0xFF047857));
        });

        test('greenDark MaterialColor should have correct values', () {
          expect(appColors.greenDark, isA<MaterialColor>());
          expect(appColors.greenDark.toARGB32(), equals(0xFF065F46));
        });

        test('greenDarkHover MaterialColor should have correct values', () {
          expect(appColors.greenDarkHover, isA<MaterialColor>());
          expect(appColors.greenDarkHover.toARGB32(), equals(0xFF064E3B));
        });

        test('greenDarkActive MaterialColor should have correct values', () {
          expect(appColors.greenDarkActive, isA<MaterialColor>());
          expect(appColors.greenDarkActive.toARGB32(), equals(0xFF022C22));
        });

        test('greenDarker MaterialColor should have correct values', () {
          expect(appColors.greenDarker, isA<MaterialColor>());
          expect(appColors.greenDarker.toARGB32(), equals(0xFF012A20));
        });
      });

      group('Pink Palette MaterialColors', () {
        test('pinkLight MaterialColor should have correct values', () {
          expect(appColors.pinkLight, isA<MaterialColor>());
          expect(appColors.pinkLight.toARGB32(), equals(0xFFFDF2F8));
        });

        test('pinkLightHover MaterialColor should have correct values', () {
          expect(appColors.pinkLightHover, isA<MaterialColor>());
          expect(appColors.pinkLightHover.toARGB32(), equals(0xFFFCE7F3));
        });

        test('pinkLightActive MaterialColor should have correct values', () {
          expect(appColors.pinkLightActive, isA<MaterialColor>());
          expect(appColors.pinkLightActive.toARGB32(), equals(0xFFF9A8D4));
        });

        test('pinkNormal MaterialColor should have correct values', () {
          expect(appColors.pinkNormal, isA<MaterialColor>());
          expect(appColors.pinkNormal.toARGB32(), equals(0xFFEC4899));
        });

        test('pinkNormalHover MaterialColor should have correct values', () {
          expect(appColors.pinkNormalHover, isA<MaterialColor>());
          expect(appColors.pinkNormalHover.toARGB32(), equals(0xFFDB2777));
        });

        test('pinkNormalActive MaterialColor should have correct values', () {
          expect(appColors.pinkNormalActive, isA<MaterialColor>());
          expect(appColors.pinkNormalActive.toARGB32(), equals(0xFFBE185D));
        });

        test('pinkDark MaterialColor should have correct values', () {
          expect(appColors.pinkDark, isA<MaterialColor>());
          expect(appColors.pinkDark.toARGB32(), equals(0xFF9D174D));
        });

        test('pinkDarkHover MaterialColor should have correct values', () {
          expect(appColors.pinkDarkHover, isA<MaterialColor>());
          expect(appColors.pinkDarkHover.toARGB32(), equals(0xFF831843));
        });

        test('pinkDarkActive MaterialColor should have correct values', () {
          expect(appColors.pinkDarkActive, isA<MaterialColor>());
          expect(appColors.pinkDarkActive.toARGB32(), equals(0xFF701A43));
        });

        test('pinkDarker MaterialColor should have correct values', () {
          expect(appColors.pinkDarker, isA<MaterialColor>());
          expect(appColors.pinkDarker.toARGB32(), equals(0xFF4C1D2E));
        });
      });

      group('Orange Palette MaterialColors', () {
        test('orangeLight MaterialColor should have correct values', () {
          expect(appColors.orangeLight, isA<MaterialColor>());
          expect(appColors.orangeLight.toARGB32(), equals(0xFFFFF5E6));
        });

        test('orangeLightHover MaterialColor should have correct values', () {
          expect(appColors.orangeLightHover, isA<MaterialColor>());
          expect(appColors.orangeLightHover.toARGB32(), equals(0xFFFFEDCC));
        });

        test('orangeLightActive MaterialColor should have correct values', () {
          expect(appColors.orangeLightActive, isA<MaterialColor>());
          expect(appColors.orangeLightActive.toARGB32(), equals(0xFFFFE0B3));
        });

        test('orangeNormal MaterialColor should have correct values', () {
          expect(appColors.orangeNormal, isA<MaterialColor>());
          expect(appColors.orangeNormal.toARGB32(), equals(0xFFFF7F00));
        });

        test('orangeNormalHover MaterialColor should have correct values', () {
          expect(appColors.orangeNormalHover, isA<MaterialColor>());
          expect(appColors.orangeNormalHover.toARGB32(), equals(0xFFE67300));
        });

        test('orangeNormalActive MaterialColor should have correct values', () {
          expect(appColors.orangeNormalActive, isA<MaterialColor>());
          expect(appColors.orangeNormalActive.toARGB32(), equals(0xFFCC6600));
        });

        test('orangeDark MaterialColor should have correct values', () {
          expect(appColors.orangeDark, isA<MaterialColor>());
          expect(appColors.orangeDark.toARGB32(), equals(0xFFB35900));
        });

        test('orangeDarkHover MaterialColor should have correct values', () {
          expect(appColors.orangeDarkHover, isA<MaterialColor>());
          expect(appColors.orangeDarkHover.toARGB32(), equals(0xFF994D00));
        });

        test('orangeDarkActive MaterialColor should have correct values', () {
          expect(appColors.orangeDarkActive, isA<MaterialColor>());
          expect(appColors.orangeDarkActive.toARGB32(), equals(0xFF804000));
        });

        test('orangeDarker MaterialColor should have correct values', () {
          expect(appColors.orangeDarker, isA<MaterialColor>());
          expect(appColors.orangeDarker.toARGB32(), equals(0xFF663300));
        });
      });

      group('Red Extended Palette MaterialColors', () {
        test('redLight MaterialColor should have correct values', () {
          expect(appColors.redLight, isA<MaterialColor>());
          expect(appColors.redLight.toARGB32(), equals(0xFFFEF2F2));
        });

        test('redLightHover MaterialColor should have correct values', () {
          expect(appColors.redLightHover, isA<MaterialColor>());
          expect(appColors.redLightHover.toARGB32(), equals(0xFFFCE7E7));
        });

        test('redLightActive MaterialColor should have correct values', () {
          expect(appColors.redLightActive, isA<MaterialColor>());
          expect(appColors.redLightActive.toARGB32(), equals(0xFFF8D7DA));
        });

        test('redNormal MaterialColor should have correct values', () {
          expect(appColors.redNormal, isA<MaterialColor>());
          expect(appColors.redNormal.toARGB32(), equals(0xFFDC3545));
        });

        test('redNormalHover MaterialColor should have correct values', () {
          expect(appColors.redNormalHover, isA<MaterialColor>());
          expect(appColors.redNormalHover.toARGB32(), equals(0xFFC82333));
        });

        test('redNormalActive MaterialColor should have correct values', () {
          expect(appColors.redNormalActive, isA<MaterialColor>());
          expect(appColors.redNormalActive.toARGB32(), equals(0xFFB21E2F));
        });

        test('redDark MaterialColor should have correct values', () {
          expect(appColors.redDark, isA<MaterialColor>());
          expect(appColors.redDark.toARGB32(), equals(0xFF9C1A2B));
        });

        test('redDarkHover MaterialColor should have correct values', () {
          expect(appColors.redDarkHover, isA<MaterialColor>());
          expect(appColors.redDarkHover.toARGB32(), equals(0xFF861727));
        });

        test('redDarkActive MaterialColor should have correct values', () {
          expect(appColors.redDarkActive, isA<MaterialColor>());
          expect(appColors.redDarkActive.toARGB32(), equals(0xFF701323));
        });

        test('redDarker MaterialColor should have correct values', () {
          expect(appColors.redDarker, isA<MaterialColor>());
          expect(appColors.redDarker.toARGB32(), equals(0xFF5A0F1F));
        });
      });

      group('Additional Palette MaterialColors', () {
        test('blueComplement MaterialColor should have correct values', () {
          expect(appColors.blueComplement, isA<MaterialColor>());
          expect(appColors.blueComplement.toARGB32(), equals(0xFF357DFF));
        });

        test('tealAccent MaterialColor should have correct values', () {
          expect(appColors.tealAccent, isA<MaterialColor>());
          expect(appColors.tealAccent.toARGB32(), equals(0xFF35FFB8));
        });

        test('charcoal MaterialColor should have correct values', () {
          expect(appColors.charcoal, isA<MaterialColor>());
          expect(appColors.charcoal.toARGB32(), equals(0xFF2D3436));
        });

        test('warmGray MaterialColor should have correct values', () {
          expect(appColors.warmGray, isA<MaterialColor>());
          expect(appColors.warmGray.toARGB32(), equals(0xFF8B7355));
        });

        test('lightGray MaterialColor should have correct values', () {
          expect(appColors.lightGray, isA<MaterialColor>());
          expect(appColors.lightGray.toARGB32(), equals(0xFFF8F9FA));
        });
      });

      // === DIRECT COLOR ACCESS TESTS ===
      group('Direct Color Access Methods', () {
        group('Amber Direct Colors', () {
          test('amberLightColor should return correct Color', () {
            expect(appColors.amberLightColor.toARGB32(), equals(0xFFFF9575));
          });
          test('amberLightHoverColor should return correct Color', () {
            expect(
              appColors.amberLightHoverColor.toARGB32(),
              equals(0xFFFF8C5C),
            );
          });
          test('amberLightActiveColor should return correct Color', () {
            expect(
              appColors.amberLightActiveColor.toARGB32(),
              equals(0xFFFF8347),
            );
          });
          test('amberNormalColor should return correct Color', () {
            expect(appColors.amberNormalColor.toARGB32(), equals(0xFFFF6B35));
          });
          test('amberNormalHoverColor should return correct Color', () {
            expect(
              appColors.amberNormalHoverColor.toARGB32(),
              equals(0xFFFF5A1F),
            );
          });
          test('amberNormalActiveColor should return correct Color', () {
            expect(
              appColors.amberNormalActiveColor.toARGB32(),
              equals(0xFFE55A2B),
            );
          });
          test('amberDarkColor should return correct Color', () {
            expect(appColors.amberDarkColor.toARGB32(), equals(0xFFCC5429));
          });
          test('amberDarkHoverColor should return correct Color', () {
            expect(
              appColors.amberDarkHoverColor.toARGB32(),
              equals(0xFFB8481F),
            );
          });
          test('amberDarkActiveColor should return correct Color', () {
            expect(
              appColors.amberDarkActiveColor.toARGB32(),
              equals(0xFFA53D1A),
            );
          });
          test('amberDarkerColor should return correct Color', () {
            expect(appColors.amberDarkerColor.toARGB32(), equals(0xFF923315));
          });
        });

        group('Grey Direct Colors', () {
          test('greyLightColor should return correct Color', () {
            expect(appColors.greyLightColor.toARGB32(), equals(0xFFE9E9E9));
          });
          test('greyLightHoverColor should return correct Color', () {
            expect(
              appColors.greyLightHoverColor.toARGB32(),
              equals(0xFFDEDEDE),
            );
          });
          test('greyLightActiveColor should return correct Color', () {
            expect(
              appColors.greyLightActiveColor.toARGB32(),
              equals(0xFFBBBBBB),
            );
          });
          test('greyNormalColor should return correct Color', () {
            expect(appColors.greyNormalColor.toARGB32(), equals(0xFF242424));
          });
          test('greyNormalHoverColor should return correct Color', () {
            expect(
              appColors.greyNormalHoverColor.toARGB32(),
              equals(0xFF202020),
            );
          });
          test('greyNormalActiveColor should return correct Color', () {
            expect(
              appColors.greyNormalActiveColor.toARGB32(),
              equals(0xFF1D1D1D),
            );
          });
          test('greyDarkColor should return correct Color', () {
            expect(appColors.greyDarkColor.toARGB32(), equals(0xFF1B1B1B));
          });
          test('greyDarkHoverColor should return correct Color', () {
            expect(appColors.greyDarkHoverColor.toARGB32(), equals(0xFF161616));
          });
          test('greyDarkActiveColor should return correct Color', () {
            expect(
              appColors.greyDarkActiveColor.toARGB32(),
              equals(0xFF101010),
            );
          });
          test('greyDarkerColor should return correct Color', () {
            expect(appColors.greyDarkerColor.toARGB32(), equals(0xFF0D0D0D));
          });
        });

        group('Blue Direct Colors', () {
          test('blueLightColor should return correct Color', () {
            expect(appColors.blueLightColor.toARGB32(), equals(0xFFEBF3FF));
          });
          test('blueLightHoverColor should return correct Color', () {
            expect(
              appColors.blueLightHoverColor.toARGB32(),
              equals(0xFFD7E7FF),
            );
          });
          test('blueLightActiveColor should return correct Color', () {
            expect(
              appColors.blueLightActiveColor.toARGB32(),
              equals(0xFFAFCFFF),
            );
          });
          test('blueNormalColor should return correct Color', () {
            expect(appColors.blueNormalColor.toARGB32(), equals(0xFF8B95A7));
          });
          test('blueNormalHoverColor should return correct Color', () {
            expect(
              appColors.blueNormalHoverColor.toARGB32(),
              equals(0xFF2366E6),
            );
          });
          test('blueNormalActiveColor should return correct Color', () {
            expect(
              appColors.blueNormalActiveColor.toARGB32(),
              equals(0xFF1C57CC),
            );
          });
          test('blueDarkColor should return correct Color', () {
            expect(appColors.blueDarkColor.toARGB32(), equals(0xFF1548B3));
          });
          test('blueDarkHoverColor should return correct Color', () {
            expect(appColors.blueDarkHoverColor.toARGB32(), equals(0xFF0E3999));
          });
          test('blueDarkActiveColor should return correct Color', () {
            expect(
              appColors.blueDarkActiveColor.toARGB32(),
              equals(0xFF0A2D80),
            );
          });
          test('blueDarkerColor should return correct Color', () {
            expect(appColors.blueDarkerColor.toARGB32(), equals(0xFF072166));
          });
        });

        group('Slate Direct Colors', () {
          test('slateLightColor should return correct Color', () {
            expect(appColors.slateLightColor.toARGB32(), equals(0xFFE8F0FF));
          });
          test('slateLightHoverColor should return correct Color', () {
            expect(
              appColors.slateLightHoverColor.toARGB32(),
              equals(0xFFD1E2FF),
            );
          });
          test('slateLightActiveColor should return correct Color', () {
            expect(
              appColors.slateLightActiveColor.toARGB32(),
              equals(0xFFA3C7FF),
            );
          });
          test('slateNormalColor should return correct Color', () {
            expect(appColors.slateNormalColor.toARGB32(), equals(0xFF1E3A8A));
          });
          test('slateNormalHoverColor should return correct Color', () {
            expect(
              appColors.slateNormalHoverColor.toARGB32(),
              equals(0xFF1B3474),
            );
          });
          test('slateNormalActiveColor should return correct Color', () {
            expect(
              appColors.slateNormalActiveColor.toARGB32(),
              equals(0xFF182E5E),
            );
          });
          test('slateDarkColor should return correct Color', () {
            expect(appColors.slateDarkColor.toARGB32(), equals(0xFF152848));
          });
          test('slateDarkHoverColor should return correct Color', () {
            expect(
              appColors.slateDarkHoverColor.toARGB32(),
              equals(0xFF122233),
            );
          });
          test('slateDarkActiveColor should return correct Color', () {
            expect(
              appColors.slateDarkActiveColor.toARGB32(),
              equals(0xFF0F1C2E),
            );
          });
          test('slateDarkerColor should return correct Color', () {
            expect(appColors.slateDarkerColor.toARGB32(), equals(0xFF0C1629));
          });
        });

        group('Green Direct Colors', () {
          test('greenLightColor should return correct Color', () {
            expect(appColors.greenLightColor.toARGB32(), equals(0xFFECFDF5));
          });
          test('greenLightHoverColor should return correct Color', () {
            expect(
              appColors.greenLightHoverColor.toARGB32(),
              equals(0xFFD1FAE5),
            );
          });
          test('greenLightActiveColor should return correct Color', () {
            expect(
              appColors.greenLightActiveColor.toARGB32(),
              equals(0xFFA7F3D0),
            );
          });
          test('greenNormalColor should return correct Color', () {
            expect(appColors.greenNormalColor.toARGB32(), equals(0xFF10B981));
          });
          test('greenNormalHoverColor should return correct Color', () {
            expect(
              appColors.greenNormalHoverColor.toARGB32(),
              equals(0xFF059669),
            );
          });
          test('greenNormalActiveColor should return correct Color', () {
            expect(
              appColors.greenNormalActiveColor.toARGB32(),
              equals(0xFF047857),
            );
          });
          test('greenDarkColor should return correct Color', () {
            expect(appColors.greenDarkColor.toARGB32(), equals(0xFF065F46));
          });
          test('greenDarkHoverColor should return correct Color', () {
            expect(
              appColors.greenDarkHoverColor.toARGB32(),
              equals(0xFF064E3B),
            );
          });
          test('greenDarkActiveColor should return correct Color', () {
            expect(
              appColors.greenDarkActiveColor.toARGB32(),
              equals(0xFF022C22),
            );
          });
          test('greenDarkerColor should return correct Color', () {
            expect(appColors.greenDarkerColor.toARGB32(), equals(0xFF012A20));
          });
        });

        group('Pink Direct Colors', () {
          test('pinkLightColor should return correct Color', () {
            expect(appColors.pinkLightColor.toARGB32(), equals(0xFFFDF2F8));
          });
          test('pinkLightHoverColor should return correct Color', () {
            expect(
              appColors.pinkLightHoverColor.toARGB32(),
              equals(0xFFFCE7F3),
            );
          });
          test('pinkLightActiveColor should return correct Color', () {
            expect(
              appColors.pinkLightActiveColor.toARGB32(),
              equals(0xFFF9A8D4),
            );
          });
          test('pinkNormalColor should return correct Color', () {
            expect(appColors.pinkNormalColor.toARGB32(), equals(0xFFEC4899));
          });
          test('pinkNormalHoverColor should return correct Color', () {
            expect(
              appColors.pinkNormalHoverColor.toARGB32(),
              equals(0xFFDB2777),
            );
          });
          test('pinkNormalActiveColor should return correct Color', () {
            expect(
              appColors.pinkNormalActiveColor.toARGB32(),
              equals(0xFFBE185D),
            );
          });
          test('pinkDarkColor should return correct Color', () {
            expect(appColors.pinkDarkColor.toARGB32(), equals(0xFF9D174D));
          });
          test('pinkDarkHoverColor should return correct Color', () {
            expect(appColors.pinkDarkHoverColor.toARGB32(), equals(0xFF831843));
          });
          test('pinkDarkActiveColor should return correct Color', () {
            expect(
              appColors.pinkDarkActiveColor.toARGB32(),
              equals(0xFF701A43),
            );
          });
          test('pinkDarkerColor should return correct Color', () {
            expect(appColors.pinkDarkerColor.toARGB32(), equals(0xFF4C1D2E));
          });
        });

        group('Orange Direct Colors', () {
          test('orangeLightColor should return correct Color', () {
            expect(appColors.orangeLightColor.toARGB32(), equals(0xFFFFF5E6));
          });
          test('orangeLightHoverColor should return correct Color', () {
            expect(
              appColors.orangeLightHoverColor.toARGB32(),
              equals(0xFFFFEDCC),
            );
          });
          test('orangeLightActiveColor should return correct Color', () {
            expect(
              appColors.orangeLightActiveColor.toARGB32(),
              equals(0xFFFFE0B3),
            );
          });
          test('orangeNormalColor should return correct Color', () {
            expect(appColors.orangeNormalColor.toARGB32(), equals(0xFFFF7F00));
          });
          test('orangeNormalHoverColor should return correct Color', () {
            expect(
              appColors.orangeNormalHoverColor.toARGB32(),
              equals(0xFFE67300),
            );
          });
          test('orangeNormalActiveColor should return correct Color', () {
            expect(
              appColors.orangeNormalActiveColor.toARGB32(),
              equals(0xFFCC6600),
            );
          });
          test('orangeDarkColor should return correct Color', () {
            expect(appColors.orangeDarkColor.toARGB32(), equals(0xFFB35900));
          });
          test('orangeDarkHoverColor should return correct Color', () {
            expect(
              appColors.orangeDarkHoverColor.toARGB32(),
              equals(0xFF994D00),
            );
          });
          test('orangeDarkActiveColor should return correct Color', () {
            expect(
              appColors.orangeDarkActiveColor.toARGB32(),
              equals(0xFF804000),
            );
          });
          test('orangeDarkerColor should return correct Color', () {
            expect(appColors.orangeDarkerColor.toARGB32(), equals(0xFF663300));
          });
        });

        group('Red Direct Colors', () {
          test('redLightColor should return correct Color', () {
            expect(appColors.redLightColor.toARGB32(), equals(0xFFFEF2F2));
          });
          test('redLightHoverColor should return correct Color', () {
            expect(appColors.redLightHoverColor.toARGB32(), equals(0xFFFCE7E7));
          });
          test('redLightActiveColor should return correct Color', () {
            expect(
              appColors.redLightActiveColor.toARGB32(),
              equals(0xFFF8D7DA),
            );
          });
          test('redNormalColor should return correct Color', () {
            expect(appColors.redNormalColor.toARGB32(), equals(0xFFDC3545));
          });
          test('redNormalHoverColor should return correct Color', () {
            expect(
              appColors.redNormalHoverColor.toARGB32(),
              equals(0xFFC82333),
            );
          });
          test('redNormalActiveColor should return correct Color', () {
            expect(
              appColors.redNormalActiveColor.toARGB32(),
              equals(0xFFB21E2F),
            );
          });
          test('redDarkColor should return correct Color', () {
            expect(appColors.redDarkColor.toARGB32(), equals(0xFF9C1A2B));
          });
          test('redDarkHoverColor should return correct Color', () {
            expect(appColors.redDarkHoverColor.toARGB32(), equals(0xFF861727));
          });
          test('redDarkActiveColor should return correct Color', () {
            expect(appColors.redDarkActiveColor.toARGB32(), equals(0xFF701323));
          });
          test('redDarkerColor should return correct Color', () {
            expect(appColors.redDarkerColor.toARGB32(), equals(0xFF5A0F1F));
          });
        });

        group('Additional Direct Colors', () {
          test('blueComplementColor should return correct Color', () {
            expect(
              appColors.blueComplementColor.toARGB32(),
              equals(0xFF357DFF),
            );
          });
          test('tealAccentColor should return correct Color', () {
            expect(appColors.tealAccentColor.toARGB32(), equals(0xFF35FFB8));
          });
          test('charcoalColor should return correct Color', () {
            expect(appColors.charcoalColor.toARGB32(), equals(0xFF2D3436));
          });
        });
      });
    });
  });
}
