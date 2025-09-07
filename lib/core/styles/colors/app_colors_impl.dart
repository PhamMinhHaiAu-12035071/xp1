import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';

/// Implementation of AppColors for the application
@LazySingleton(as: AppColors)
class AppColorsImpl implements AppColors {
  /// Creates an instance of AppColorsImpl with predefined color values
  const AppColorsImpl();

  @override
  MaterialColor get primary => const MaterialColor(
    0xFF013773,
    <int, Color>{
      10: Color(0xFFEBF0F7),
      20: Color(0xFFE3E8F0),
      30: Color(0xFFD5DFE9),
      40: Color(0xFFC7D1E1),
      50: Color(0xFFE3E8F0),
      100: Color(0xFFC7D1E1),
      200: Color(0xFF8FA3C3),
      300: Color(0xFF5775A5),
      400: Color(0xFF2A4C8C),
      500: Color(0xFF013773),
      600: Color(0xFF013262),
      700: Color(0xFF012A4F),
      800: Color(0xFF01223D),
      900: Color(0xFF011A2B),
    },
  );

  @override
  MaterialColor get secondary => const MaterialColor(
    0xFF4F46E5,
    <int, Color>{
      10: Color(0xFFF9F9FE),
      20: Color(0xFFF5F4FD),
      30: Color(0xFFF1F0FC),
      40: Color(0xFFEFEEFC),
      50: Color(0xFFEFEEFC),
      100: Color(0xFFD7D5F8),
      200: Color(0xFFB6B3F1),
      300: Color(0xFF938FEB),
      400: Color(0xFF7974E7),
      500: Color(0xFF4F46E5),
      600: Color(0xFF4840C5),
      700: Color(0xFF3C35A3),
      800: Color(0xFF312A82),
      900: Color(0xFF252069),
    },
  );

  @override
  MaterialColor get black => const MaterialColor(
    0xFF000000,
    <int, Color>{
      10: Color(0xFFF9F9F9),
      20: Color(0xFFF2F2F2),
      30: Color(0xFFECECEC),
      40: Color(0xFFE6E6E6),
      50: Color(0xFFE6E6E6),
      100: Color(0xFFCCCCCC),
      200: Color(0xFF999999),
      300: Color(0xFF666666),
      400: Color(0xFF333333),
      500: Color(0xFF000000),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  @override
  MaterialColor get white => const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      10: Color(0xFFFFFFFF),
      20: Color(0xFFFFFFFF),
      30: Color(0xFFFFFFFF),
      40: Color(0xFFFFFFFF),
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFF7F7F7),
      700: Color(0xFFE6E6E6),
      800: Color(0xFFD6D6D6),
      900: Color(0xFFC4C4C4),
    },
  );

  @override
  MaterialColor get grey => const MaterialColor(
    0xFF9E9E9E,
    <int, Color>{
      10: Color(0xFFFDFDFD),
      20: Color(0xFFFCFCFC),
      30: Color(0xFFFAFAFA),
      40: Color(0xFFF8F8F8),
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFBDBDBD),
      500: Color(0xFF9E9E9E),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      900: Color(0xFF212121),
    },
  );

  @override
  MaterialColor get onboardingBlue => const MaterialColor(
    0xFF7384A2,
    <int, Color>{
      10: Color(0xFFF7F8FA),
      20: Color(0xFFF4F6F9),
      30: Color(0xFFF2F4F7),
      40: Color(0xFFF0F2F6),
      50: Color(0xFFF0F2F6),
      100: Color(0xFFD9DEE7),
      200: Color(0xFFBFC8D8),
      300: Color(0xFFA5B2C9),
      400: Color(0xFF8A9BB8),
      500: Color(0xFF7384A2),
      600: Color(0xFF607395),
      700: Color(0xFF4C5C78),
      800: Color(0xFF3B475C),
      900: Color(0xFF2A3240),
    },
  );

  @override
  Color get bgMain => const Color(0xFFFFFFFF);
  @override
  Color get accent => const Color(0xFFE0E7FF);
  @override
  Color get textPrimary => const Color(0xFF1E293B);
  @override
  Color get textSecondary => const Color(0xFF64748B);

  @override
  Color get slateBlue => const Color(0xFF607395);
  @override
  Color get onboardingBackground => const Color(0xFFE9F0F2);
  @override
  Color get onboardingGradientStart => const Color(0xFF00B3C6);
  @override
  Color get onboardingGradientEnd => const Color(0xFF5D84B4);

  @override
  Color get bgMainDark => const Color(0xFF121212);
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
  Color get transparent => Colors.transparent;

  @override
  MaterialColor get error => const MaterialColor(
    0xFFDC3545,
    <int, Color>{
      10: Color(0xFFFEF6F7),
      20: Color(0xFFFCEDEF),
      30: Color(0xFFFCE6E8),
      40: Color(0xFFFBE9EB),
      50: Color(0xFFFBE9EB),
      100: Color(0xFFF5D3D7),
      200: Color(0xFFEEB7BE),
      300: Color(0xFFE69BA5),
      400: Color(0xFFDF7F8C),
      500: Color(0xFFDC3545),
      600: Color(0xFFC62E3D),
      700: Color(0xFFB02735),
      800: Color(0xFF9A202D),
      900: Color(0xFF841925),
    },
  );

  @override
  MaterialColor get title => const MaterialColor(
    0xFF333333,
    <int, Color>{
      10: Color(0xFFF9F9F9),
      20: Color(0xFFF2F2F2),
      30: Color(0xFFECECEC),
      40: Color(0xFFE6E6E6),
      50: Color(0xFFE6E6E6),
      100: Color(0xFFCCCCCC),
      200: Color(0xFFB3B3B3),
      300: Color(0xFF999999),
      400: Color(0xFF808080),
      500: Color(0xFF333333),
      600: Color(0xFF292929),
      700: Color(0xFF1F1F1F),
      800: Color(0xFF141414),
      900: Color(0xFF0A0A0A),
    },
  );

  @override
  MaterialColor get placeholder => const MaterialColor(
    0xFFB0B0B0,
    <int, Color>{
      10: Color(0xFFFEFEFE),
      20: Color(0xFFFAFAFA),
      30: Color(0xFFF6F6F6),
      40: Color(0xFFF2F2F2),
      50: Color(0xFFF2F2F2),
      100: Color(0xFFE6E6E6),
      200: Color(0xFFD9D9D9),
      300: Color(0xFFCCCCCC),
      400: Color(0xFFBFBFBF),
      500: Color(0xFFB0B0B0),
      600: Color(0xFF9E9E9E),
      700: Color(0xFF8C8C8C),
      800: Color(0xFF7A7A7A),
      900: Color(0xFF686868),
    },
  );

  @override
  MaterialColor get neutral => const MaterialColor(
    0xFFE6E6E6,
    <int, Color>{
      10: Color(0xFFFAFAFA),
      20: Color(0xFFF4F4F4), // Neutral/20 (#F4F4F4) from screenshot
      30: Color(0xFFEEEEEE),
      40: Color(0xFFE8E8E8),
      50: Color(0xFFE6E6E6),
      100: Color(0xFFCCCCCC),
      200: Color(0xFFB3B3B3),
      300: Color(0xFF999999),
      400: Color(0xFF808080),
      500: Color(0xFF666666),
      600: Color(0xFF4D4D4D),
      700: Color(0xFF333333),
      800: Color(0xFF1A1A1A),
      900: Color(0xFF000000),
    },
  );

  @override
  MaterialColor get button => const MaterialColor(
    0xFF013773,
    <int, Color>{
      10: Color(0xFFEBF0F7),
      20: Color(0xFFE6EBF2),
      30: Color(0xFFDFE5ED),
      40: Color(0xFFD8DEE8),
      50: Color(0xFFE6EBF2),
      100: Color(0xFFCCD7E5),
      200: Color(0xFFB3C3D8),
      300: Color(0xFF99AFCC),
      400: Color(0xFF809BBF),
      500: Color(0xFF013773),
      600: Color(0xFF012F5C),
      700: Color(0xFF012745),
      800: Color(0xFF001F2E),
      900: Color(0xFF001717),
    },
  );

  @override
  MaterialColor get bodyText => const MaterialColor(
    0xFF545454,
    <int, Color>{
      10: Color(0xFFFEFEFE),
      20: Color(0xFFFAFAFA),
      30: Color(0xFFF6F6F6),
      40: Color(0xFFF2F2F2),
      50: Color(0xFFF2F2F2),
      100: Color(0xFFE6E6E6),
      200: Color(0xFFD9D9D9),
      300: Color(0xFFCCCCCC),
      400: Color(0xFFBFBFBF),
      500: Color(0xFF545454),
      600: Color(0xFF4A4A4A),
      700: Color(0xFF404040),
      800: Color(0xFF363636),
      900: Color(0xFF2C2C2C),
    },
  );

  @override
  MaterialColor get red => const MaterialColor(
    0xFFF4C0C5,
    <int, Color>{
      10: Color(0xFFFFFDFD),
      20: Color(0xFFFFFAFB),
      30: Color(0xFFFFF8F9),
      40: Color(0xFFFFF5F6),
      50: Color(0xFFFFF5F6),
      100: Color(0xFFFFE6E8),
      200: Color(0xFFFAD1D5),
      300: Color(0xFFF4C0C5), // matches #F4C0C5 from screenshot
      400: Color(0xFFE89CA3),
      500: Color(0xFFD86B75),
      600: Color(0xFFC94B57),
      700: Color(0xFFB22B38),
      800: Color(0xFF8C1F29),
      900: Color(0xFF66151B),
    },
  );

  @override
  MaterialColor get delete => const MaterialColor(
    0xFFDC3545,
    <int, Color>{
      10: Color(0xFFFFF5F5),
      20: Color(0xFFFFF0F0),
      30: Color(0xFFFEF7F7),
      40: Color(0xFFFEF2F2),
      50: Color(0xFFFEF2F2),
      100: Color(0xFFFEE2E2),
      200: Color(0xFFFECACA),
      300: Color(0xFFFCA5A5),
      400: Color(0xFFF87171),
      500: Color(0xFFDC3545),
      600: Color(0xFFB91C1C),
      700: Color(0xFF991B1B),
      800: Color(0xFF7F1D1D),
      900: Color(0xFF63171B),
    },
  );

  /// MaterialColor blue as shown in the screenshot (#F7FBFF for 50)
  @override
  MaterialColor get blue => const MaterialColor(
    0xFF2196F3,
    <int, Color>{
      10: Color(0xFFFDFEFF),
      20: Color(0xFFFAFCFF),
      30: Color(0xFFF8FBFF),
      40: Color(0xFFF7FAFF),
      50: Color(0xFFF7FBFF), // from screenshot
      100: Color(0xFFE6F2FF), // updated
      200: Color(0xFFD1E8FF), // adjusted
      300: Color(0xFFB1D6FF), // updated
      400: Color(0xFF8CC3FF), // adjusted
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  @override
  MaterialColor get divider => const MaterialColor(
    0xFFB0B0B0,
    <int, Color>{
      10: Color(0xFFF7F7F7),
      20: Color(0xFFEFEFEF),
      30: Color(0xFFE7E7E7),
      40: Color(0xFFDFDFDF),
      50: Color(0xFFD7D7D7),
      100: Color(0xFFCFCFCF),
      200: Color(0xFFC7C7C7),
      300: Color(0xFFBFBFBF),
      400: Color(0xFFB7B7B7),
      500: Color(0xFFB0B0B0),
      600: Color(0xFFA8A8A8),
      700: Color(0xFFA0A0A0),
      800: Color(0xFF989898),
      900: Color(0xFF909090),
    },
  );

  @override
  MaterialColor get green => const MaterialColor(
    0xFF28A745,
    <int, Color>{
      10: Color(0xFFF0F9F2),
      20: Color(0xFFE1F3E5),
      30: Color(0xFFD2EDD8),
      40: Color(0xFFC3E7CB),
      50: Color(0xFFB4E1BE),
      100: Color(0xFFA5DBB1),
      200: Color(0xFF96D5A4),
      300: Color(0xFF87CF97),
      400: Color(0xFF78C98A),
      500: Color(0xFF28A745),
      600: Color(0xFF24963E),
      700: Color(0xFF208537),
      800: Color(0xFF1C7430),
      900: Color(0xFF186329),
    },
  );

  // === AMBER PALETTE IMPLEMENTATION (Based on Figma Design System) ===

  @override
  MaterialColor get amberLight => const MaterialColor(
    0xFFFF9575,
    <int, Color>{
      50: Color(0xFFFFF7F4), // Very light
      100: Color(0xFFFFEDE7), // Light
      200: Color(0xFFFFDBCF), // Medium light
      300: Color(0xFFFFC8B7), // Medium
      400: Color(0xFFFFB696), // Medium dark
      500: Color(0xFFFF9575), // Light base
      600: Color(0xFFE6845F), // Darker
      700: Color(0xFFCC7349), // Much darker
      800: Color(0xFFB36233), // Deep
      900: Color(0xFF99511D), // Darkest
    },
  );

  @override
  MaterialColor get amberLightHover => const MaterialColor(
    0xFFFF8C5C,
    <int, Color>{
      50: Color(0xFFFFF6F2), // Very light
      100: Color(0xFFFFEBE3), // Light
      200: Color(0xFFFFD7C7), // Medium light
      300: Color(0xFFFFC3AB), // Medium
      400: Color(0xFFFFAF8F), // Medium dark
      500: Color(0xFFFF8C5C), // Light hover base
      600: Color(0xFFE67B49), // Darker
      700: Color(0xFFCC6A36), // Much darker
      800: Color(0xFFB35923), // Deep
      900: Color(0xFF994810), // Darkest
    },
  );

  @override
  MaterialColor get amberLightActive => const MaterialColor(
    0xFFFF8347,
    <int, Color>{
      50: Color(0xFFFFF5F1), // Very light
      100: Color(0xFFFFE9E0), // Light
      200: Color(0xFFFFD3C1), // Medium light
      300: Color(0xFFFFBDA2), // Medium
      400: Color(0xFFFFA783), // Medium dark
      500: Color(0xFFFF8347), // Light active base
      600: Color(0xFFE6723A), // Darker
      700: Color(0xFFCC612D), // Much darker
      800: Color(0xFFB35020), // Deep
      900: Color(0xFF993F13), // Darkest
    },
  );

  @override
  MaterialColor get amberNormal => const MaterialColor(
    0xFFFF6B35,
    <int, Color>{
      50: Color(0xFFFFF4F0), // Very light
      100: Color(0xFFFFE4D4), // Light
      200: Color(0xFFFFC4A4), // Medium light
      300: Color(0xFFFF9C7E), // Medium
      400: Color(0xFFFF835A), // Medium dark
      500: Color(0xFFFF6B35), // Normal base (main brand)
      600: Color(0xFFE55A2B), // Darker
      700: Color(0xFFCC4921), // Much darker
      800: Color(0xFFB33817), // Deep
      900: Color(0xFF99270D), // Darkest
    },
  );

  @override
  MaterialColor get amberNormalHover => const MaterialColor(
    0xFFFF5A1F,
    <int, Color>{
      50: Color(0xFFFFF3EE), // Very light
      100: Color(0xFFFFE2D0), // Light
      200: Color(0xFFFFBE9C), // Medium light
      300: Color(0xFFFF9A68), // Medium
      400: Color(0xFFFF7634), // Medium dark
      500: Color(0xFFFF5A1F), // Normal hover base
      600: Color(0xFFE54918), // Darker
      700: Color(0xFFCC3811), // Much darker
      800: Color(0xFFB2270A), // Deep
      900: Color(0xFF991603), // Darkest
    },
  );

  @override
  MaterialColor get amberNormalActive => const MaterialColor(
    0xFFE55A2B,
    <int, Color>{
      50: Color(0xFFFEF2F0), // Very light
      100: Color(0xFFFFDDD3), // Light
      200: Color(0xFFFFB8A3), // Medium light
      300: Color(0xFFFF9373), // Medium
      400: Color(0xFFFF764F), // Medium dark
      500: Color(0xFFE55A2B), // Normal active base
      600: Color(0xFFCF4F24), // Darker
      700: Color(0xFFB8441D), // Much darker
      800: Color(0xFFA23916), // Deep
      900: Color(0xFF8B2E0F), // Darkest
    },
  );

  @override
  MaterialColor get amberDark => const MaterialColor(
    0xFFCC5429,
    <int, Color>{
      50: Color(0xFFFDF1ED), // Very light
      100: Color(0xFFF9DDD2), // Light
      200: Color(0xFFF3BFA5), // Medium light
      300: Color(0xFFEDA178), // Medium
      400: Color(0xFFE7834B), // Medium dark
      500: Color(0xFFCC5429), // Dark base
      600: Color(0xFFB94A24), // Darker
      700: Color(0xFFA63F1F), // Much darker
      800: Color(0xFF93351A), // Deep
      900: Color(0xFF802B15), // Darkest
    },
  );

  @override
  MaterialColor get amberDarkHover => const MaterialColor(
    0xFFB8481F,
    <int, Color>{
      50: Color(0xFFFCEFEA), // Very light
      100: Color(0xFFF7D9CA), // Light
      200: Color(0xFFEFB595), // Medium light
      300: Color(0xFFE79160), // Medium
      400: Color(0xFFDF6D2B), // Medium dark
      500: Color(0xFFB8481F), // Dark hover base
      600: Color(0xFFA73E1C), // Darker
      700: Color(0xFF963419), // Much darker
      800: Color(0xFF852A16), // Deep
      900: Color(0xFF742013), // Darkest
    },
  );

  @override
  MaterialColor get amberDarkActive => const MaterialColor(
    0xFFA53D1A,
    <int, Color>{
      50: Color(0xFFFBEDE7), // Very light
      100: Color(0xFFF5D5C5), // Light
      200: Color(0xFFEAAB8B), // Medium light
      300: Color(0xFFDF8151), // Medium
      400: Color(0xFFD45717), // Medium dark
      500: Color(0xFFA53D1A), // Dark active base
      600: Color(0xFF943717), // Darker
      700: Color(0xFF833114), // Much darker
      800: Color(0xFF722B11), // Deep
      900: Color(0xFF61250E), // Darkest
    },
  );

  @override
  MaterialColor get amberDarker => const MaterialColor(
    0xFF923315,
    <int, Color>{
      50: Color(0xFFF9EBE5), // Very light
      100: Color(0xFFF2D1C2), // Light
      200: Color(0xFFE59F80), // Medium light
      300: Color(0xFFD86D3E), // Medium
      400: Color(0xFFCB3B00), // Medium dark
      500: Color(0xFF923315), // Darker base
      600: Color(0xFF822E13), // Darker
      700: Color(0xFF722911), // Much darker
      800: Color(0xFF62240F), // Deep
      900: Color(0xFF521F0D), // Darkest
    },
  );

  // === BACKWARD COMPATIBILITY ===

  @override
  MaterialColor get amberPale => const MaterialColor(
    0xFFFFF4F0,
    <int, Color>{
      50: Color(0xFFFFF4F0), // Pale base
      100: Color(0xFFFFF2ED), // Slightly darker
      200: Color(0xFFFFF0EA), // Medium light
      300: Color(0xFFFFEEE7), // Medium
      400: Color(0xFFFFECE4), // Medium dark
      500: Color(0xFFFFEAE1), // Base
      600: Color(0xFFFFE8DE), // Darker
      700: Color(0xFFFFE6DB), // Much darker
      800: Color(0xFFFFE4D8), // Deep
      900: Color(0xFFFFE2D5), // Darkest
    },
  );

  // === COMPLEMENTARY COLORS ===

  @override
  MaterialColor get blueComplement => const MaterialColor(
    0xFF357DFF,
    <int, Color>{
      50: Color(0xFFE9F1FF), // Very light blue
      100: Color(0xFFD3E3FF), // Light blue
      200: Color(0xFFA8C7FF), // Medium light blue
      300: Color(0xFF7DABFF), // Medium blue
      400: Color(0xFF5694FF), // Medium dark blue
      500: Color(0xFF357DFF), // Blue base
      600: Color(0xFF2965CC), // Darker blue
      700: Color(0xFF1F4D99), // Much darker blue
      800: Color(0xFF173566), // Deep blue
      900: Color(0xFF0F1D33), // Darkest blue
    },
  );

  @override
  MaterialColor get tealAccent => const MaterialColor(
    0xFF35FFB8,
    <int, Color>{
      50: Color(0xFFE6FFF4), // Very light teal
      100: Color(0xFFCCFFE9), // Light teal
      200: Color(0xFF99FFD3), // Medium light teal
      300: Color(0xFF66FFBD), // Medium teal
      400: Color(0xFF4DFFB0), // Medium dark teal
      500: Color(0xFF35FFB8), // Teal base
      600: Color(0xFF2BE6A3), // Darker teal
      700: Color(0xFF21CC8E), // Much darker teal
      800: Color(0xFF17B379), // Deep teal
      900: Color(0xFF0D9964), // Darkest teal
    },
  );

  // === NEUTRAL COLORS ===

  @override
  MaterialColor get charcoal => const MaterialColor(
    0xFF2D3436,
    <int, Color>{
      50: Color(0xFFF7F8F8), // Very light gray
      100: Color(0xFFEFF1F1), // Light gray
      200: Color(0xFFDFE3E3), // Medium light gray
      300: Color(0xFFCFD5D5), // Medium gray
      400: Color(0xFFBFC7C7), // Medium dark gray
      500: Color(0xFF2D3436), // Charcoal base
      600: Color(0xFF292F31), // Darker charcoal
      700: Color(0xFF252A2C), // Much darker charcoal
      800: Color(0xFF212527), // Deep charcoal
      900: Color(0xFF1D2022), // Darkest charcoal
    },
  );

  @override
  MaterialColor get warmGray => const MaterialColor(
    0xFF8B7355,
    <int, Color>{
      50: Color(0xFFF9F8F6), // Very light warm gray
      100: Color(0xFFF3F0EC), // Light warm gray
      200: Color(0xFFE7E1D9), // Medium light warm gray
      300: Color(0xFFDBD2C6), // Medium warm gray
      400: Color(0xFFCFC3B3), // Medium dark warm gray
      500: Color(0xFF8B7355), // Warm gray base
      600: Color(0xFF7D654C), // Darker warm gray
      700: Color(0xFF6F5743), // Much darker warm gray
      800: Color(0xFF61493A), // Deep warm gray
      900: Color(0xFF533B31), // Darkest warm gray
    },
  );

  @override
  MaterialColor get lightGray => const MaterialColor(
    0xFFF8F9FA,
    <int, Color>{
      50: Color(0xFFF8F9FA), // Light gray base
      100: Color(0xFFF6F7F8), // Slightly darker
      200: Color(0xFFF4F5F6), // Medium light
      300: Color(0xFFF2F3F4), // Medium
      400: Color(0xFFF0F1F2), // Medium dark
      500: Color(0xFFEEEFF0), // Darker
      600: Color(0xFFECEDEE), // Much darker
      700: Color(0xFFEAEBEC), // Deep
      800: Color(0xFFE8E9EA), // Deeper
      900: Color(0xFFE6E7E8), // Darkest
    },
  );

  // === DIRECT COLOR ACCESS ===

  /// Direct access to amber light color value
  Color get amberLightColor => const Color(0xFFFF9575);

  /// Direct access to amber light hover color value
  Color get amberLightHoverColor => const Color(0xFFFF8C5C);

  /// Direct access to amber light active color value
  Color get amberLightActiveColor => const Color(0xFFFF8347);

  /// Direct access to amber normal color value
  Color get amberNormalColor => const Color(0xFFFF6B35);

  /// Direct access to amber normal hover color value
  Color get amberNormalHoverColor => const Color(0xFFFF5A1F);

  /// Direct access to amber normal active color value
  Color get amberNormalActiveColor => const Color(0xFFE55A2B);

  /// Direct access to amber dark color value
  Color get amberDarkColor => const Color(0xFFCC5429);

  /// Direct access to amber dark hover color value
  Color get amberDarkHoverColor => const Color(0xFFB8481F);

  /// Direct access to amber dark active color value
  Color get amberDarkActiveColor => const Color(0xFFA53D1A);

  /// Direct access to amber darker color value
  Color get amberDarkerColor => const Color(0xFF923315);

  /// Direct access to blue complement color value
  Color get blueComplementColor => const Color(0xFF357DFF);

  /// Direct access to teal accent color value
  Color get tealAccentColor => const Color(0xFF35FFB8);

  /// Direct access to charcoal color value
  Color get charcoalColor => const Color(0xFF2D3436);

  // === GREY PALETTE IMPLEMENTATION (Based on Figma Design System) ===

  @override
  MaterialColor get greyLight => const MaterialColor(
    0xFFE9E9E9,
    <int, Color>{
      50: Color(0xFFFBFBFB), // Very light
      100: Color(0xFFF7F7F7), // Light
      200: Color(0xFFF3F3F3), // Medium light
      300: Color(0xFFEFEFEF), // Medium
      400: Color(0xFFECECEC), // Medium dark
      500: Color(0xFFE9E9E9), // Light base
      600: Color(0xFFE5E5E5), // Darker
      700: Color(0xFFE1E1E1), // Much darker
      800: Color(0xFFDDDDDD), // Deep
      900: Color(0xFFD9D9D9), // Darkest
    },
  );

  @override
  MaterialColor get greyLightHover => const MaterialColor(
    0xFFDEDEDE,
    <int, Color>{
      50: Color(0xFFF9F9F9), // Very light
      100: Color(0xFFF4F4F4), // Light
      200: Color(0xFFEFEFEF), // Medium light
      300: Color(0xFFEAEAEA), // Medium
      400: Color(0xFFE5E5E5), // Medium dark
      500: Color(0xFFDEDEDE), // Light hover base
      600: Color(0xFFD8D8D8), // Darker
      700: Color(0xFFD2D2D2), // Much darker
      800: Color(0xFFCCCCCC), // Deep
      900: Color(0xFFC6C6C6), // Darkest
    },
  );

  @override
  MaterialColor get greyLightActive => const MaterialColor(
    0xFFBBBBBB,
    <int, Color>{
      50: Color(0xFFF5F5F5), // Very light
      100: Color(0xFFEEEEEE), // Light
      200: Color(0xFFE6E6E6), // Medium light
      300: Color(0xFFDEDEDE), // Medium
      400: Color(0xFFD6D6D6), // Medium dark
      500: Color(0xFFBBBBBB), // Light active base
      600: Color(0xFFB2B2B2), // Darker
      700: Color(0xFFA9A9A9), // Much darker
      800: Color(0xFFA0A0A0), // Deep
      900: Color(0xFF979797), // Darkest
    },
  );

  @override
  MaterialColor get greyNormal => const MaterialColor(
    0xFF242424,
    <int, Color>{
      50: Color(0xFFEBEBEB), // Very light
      100: Color(0xFFCCCCCC), // Light
      200: Color(0xFFADADAD), // Medium light
      300: Color(0xFF8E8E8E), // Medium
      400: Color(0xFF6F6F6F), // Medium dark
      500: Color(0xFF242424), // Normal base (main neutral)
      600: Color(0xFF212121), // Darker
      700: Color(0xFF1E1E1E), // Much darker
      800: Color(0xFF1B1B1B), // Deep
      900: Color(0xFF181818), // Darkest
    },
  );

  @override
  MaterialColor get greyNormalHover => const MaterialColor(
    0xFF202020,
    <int, Color>{
      50: Color(0xFFE9E9E9), // Very light
      100: Color(0xFFC8C8C8), // Light
      200: Color(0xFFA7A7A7), // Medium light
      300: Color(0xFF868686), // Medium
      400: Color(0xFF656565), // Medium dark
      500: Color(0xFF202020), // Normal hover base
      600: Color(0xFF1E1E1E), // Darker
      700: Color(0xFF1C1C1C), // Much darker
      800: Color(0xFF1A1A1A), // Deep
      900: Color(0xFF181818), // Darkest
    },
  );

  @override
  MaterialColor get greyNormalActive => const MaterialColor(
    0xFF1D1D1D,
    <int, Color>{
      50: Color(0xFFE7E7E7), // Very light
      100: Color(0xFFC4C4C4), // Light
      200: Color(0xFFA1A1A1), // Medium light
      300: Color(0xFF7E7E7E), // Medium
      400: Color(0xFF5B5B5B), // Medium dark
      500: Color(0xFF1D1D1D), // Normal active base
      600: Color(0xFF1B1B1B), // Darker
      700: Color(0xFF191919), // Much darker
      800: Color(0xFF171717), // Deep
      900: Color(0xFF151515), // Darkest
    },
  );

  @override
  MaterialColor get greyDark => const MaterialColor(
    0xFF1B1B1B,
    <int, Color>{
      50: Color(0xFFE5E5E5), // Very light
      100: Color(0xFFC0C0C0), // Light
      200: Color(0xFF9B9B9B), // Medium light
      300: Color(0xFF767676), // Medium
      400: Color(0xFF515151), // Medium dark
      500: Color(0xFF1B1B1B), // Dark base
      600: Color(0xFF191919), // Darker
      700: Color(0xFF171717), // Much darker
      800: Color(0xFF151515), // Deep
      900: Color(0xFF131313), // Darkest
    },
  );

  @override
  MaterialColor get greyDarkHover => const MaterialColor(
    0xFF161616,
    <int, Color>{
      50: Color(0xFFE2E2E2), // Very light
      100: Color(0xFFBABABA), // Light
      200: Color(0xFF929292), // Medium light
      300: Color(0xFF6A6A6A), // Medium
      400: Color(0xFF424242), // Medium dark
      500: Color(0xFF161616), // Dark hover base
      600: Color(0xFF141414), // Darker
      700: Color(0xFF121212), // Much darker
      800: Color(0xFF101010), // Deep
      900: Color(0xFF0E0E0E), // Darkest
    },
  );

  @override
  MaterialColor get greyDarkActive => const MaterialColor(
    0xFF101010,
    <int, Color>{
      50: Color(0xFFDFDFDF), // Very light
      100: Color(0xFFB4B4B4), // Light
      200: Color(0xFF898989), // Medium light
      300: Color(0xFF5E5E5E), // Medium
      400: Color(0xFF333333), // Medium dark
      500: Color(0xFF101010), // Dark active base
      600: Color(0xFF0F0F0F), // Darker
      700: Color(0xFF0E0E0E), // Much darker
      800: Color(0xFF0D0D0D), // Deep
      900: Color(0xFF0C0C0C), // Darkest
    },
  );

  @override
  MaterialColor get greyDarker => const MaterialColor(
    0xFF0D0D0D,
    <int, Color>{
      50: Color(0xFFDCDCDC), // Very light
      100: Color(0xFFAEAEAE), // Light
      200: Color(0xFF808080), // Medium light
      300: Color(0xFF525252), // Medium
      400: Color(0xFF242424), // Medium dark
      500: Color(0xFF0D0D0D), // Darker base
      600: Color(0xFF0C0C0C), // Darker
      700: Color(0xFF0B0B0B), // Much darker
      800: Color(0xFF0A0A0A), // Deep
      900: Color(0xFF090909), // Darkest
    },
  );

  // === DIRECT GREY COLOR ACCESS ===

  /// Direct access to grey light color value
  Color get greyLightColor => const Color(0xFFE9E9E9);

  /// Direct access to grey light hover color value
  Color get greyLightHoverColor => const Color(0xFFDEDEDE);

  /// Direct access to grey light active color value
  Color get greyLightActiveColor => const Color(0xFFBBBBBB);

  /// Direct access to grey normal color value
  Color get greyNormalColor => const Color(0xFF242424);

  /// Direct access to grey normal hover color value
  Color get greyNormalHoverColor => const Color(0xFF202020);

  /// Direct access to grey normal active color value
  Color get greyNormalActiveColor => const Color(0xFF1D1D1D);

  /// Direct access to grey dark color value
  Color get greyDarkColor => const Color(0xFF1B1B1B);

  /// Direct access to grey dark hover color value
  Color get greyDarkHoverColor => const Color(0xFF161616);

  /// Direct access to grey dark active color value
  Color get greyDarkActiveColor => const Color(0xFF101010);

  /// Direct access to grey darker color value
  Color get greyDarkerColor => const Color(0xFF0D0D0D);

  // === BLUE PALETTE IMPLEMENTATION (Complete Design System) ===

  @override
  MaterialColor get blueLight => const MaterialColor(
    0xFFEBF3FF,
    <int, Color>{
      50: Color(0xFFEBF3FF), // Light base
      100: Color(0xFFE6F0FF), // Slightly darker
      200: Color(0xFFE1EDFF), // Medium light
      300: Color(0xFFDCEAFF), // Medium
      400: Color(0xFFD7E7FF), // Medium dark
      500: Color(0xFFEBF3FF), // Base
      600: Color(0xFFD2E4FF), // Darker
      700: Color(0xFFCDE1FF), // Much darker
      800: Color(0xFFC8DEFF), // Deep
      900: Color(0xFFC3DBFF), // Darkest
    },
  );

  @override
  MaterialColor get blueLightHover => const MaterialColor(
    0xFFD7E7FF,
    <int, Color>{
      50: Color(0xFFE6F0FF), // Very light
      100: Color(0xFFE1EDFF), // Light
      200: Color(0xFFDCEAFF), // Medium light
      300: Color(0xFFD7E7FF), // Medium
      400: Color(0xFFD2E4FF), // Medium dark
      500: Color(0xFFD7E7FF), // Light hover base
      600: Color(0xFFCDE1FF), // Darker
      700: Color(0xFFC8DEFF), // Much darker
      800: Color(0xFFC3DBFF), // Deep
      900: Color(0xFFBED8FF), // Darkest
    },
  );

  @override
  MaterialColor get blueLightActive => const MaterialColor(
    0xFFAFCFFF,
    <int, Color>{
      50: Color(0xFFD7E7FF), // Very light
      100: Color(0xFFD2E4FF), // Light
      200: Color(0xFFCDE1FF), // Medium light
      300: Color(0xFFC8DEFF), // Medium
      400: Color(0xFFC3DBFF), // Medium dark
      500: Color(0xFFAFCFFF), // Light active base
      600: Color(0xFFA5CBFF), // Darker
      700: Color(0xFF9BC7FF), // Much darker
      800: Color(0xFF91C3FF), // Deep
      900: Color(0xFF87BFFF), // Darkest
    },
  );

  @override
  MaterialColor get blueNormal => const MaterialColor(
    0xFF357DFF,
    <int, Color>{
      50: Color(0xFFEBF3FF), // Very light
      100: Color(0xFFD7E7FF), // Light
      200: Color(0xFFAFCFFF), // Medium light
      300: Color(0xFF87BFFF), // Medium
      400: Color(0xFF5F9FFF), // Medium dark
      500: Color(0xFF357DFF), // Normal base (main blue)
      600: Color(0xFF2E70E6), // Darker
      700: Color(0xFF2763CC), // Much darker
      800: Color(0xFF2056B3), // Deep
      900: Color(0xFF194999), // Darkest
    },
  );

  @override
  MaterialColor get blueNormalHover => const MaterialColor(
    0xFF2366E6,
    <int, Color>{
      50: Color(0xFFE9F1FF), // Very light
      100: Color(0xFFD3E3FF), // Light
      200: Color(0xFFA7C7FF), // Medium light
      300: Color(0xFF7BABFF), // Medium
      400: Color(0xFF4F8FFF), // Medium dark
      500: Color(0xFF2366E6), // Normal hover base
      600: Color(0xFF1F5CCC), // Darker
      700: Color(0xFF1B52B3), // Much darker
      800: Color(0xFF174899), // Deep
      900: Color(0xFF133E80), // Darkest
    },
  );

  @override
  MaterialColor get blueNormalActive => const MaterialColor(
    0xFF1C57CC,
    <int, Color>{
      50: Color(0xFFE7EFFF), // Very light
      100: Color(0xFFCFDFFF), // Light
      200: Color(0xFF9FBFFF), // Medium light
      300: Color(0xFF6F9FFF), // Medium
      400: Color(0xFF3F7FFF), // Medium dark
      500: Color(0xFF1C57CC), // Normal active base
      600: Color(0xFF194EB8), // Darker
      700: Color(0xFF1645A3), // Much darker
      800: Color(0xFF133C8F), // Deep
      900: Color(0xFF10337A), // Darkest
    },
  );

  @override
  MaterialColor get blueDark => const MaterialColor(
    0xFF1548B3,
    <int, Color>{
      50: Color(0xFFE5F0FF), // Very light
      100: Color(0xFFCBE1FF), // Light
      200: Color(0xFF97C3FF), // Medium light
      300: Color(0xFF63A5FF), // Medium
      400: Color(0xFF2F87FF), // Medium dark
      500: Color(0xFF1548B3), // Dark base
      600: Color(0xFF1240A0), // Darker
      700: Color(0xFF0F388D), // Much darker
      800: Color(0xFF0C307A), // Deep
      900: Color(0xFF092867), // Darkest
    },
  );

  @override
  MaterialColor get blueDarkHover => const MaterialColor(
    0xFF0E3999,
    <int, Color>{
      50: Color(0xFFE3EDFF), // Very light
      100: Color(0xFFC7DBFF), // Light
      200: Color(0xFF8FB7FF), // Medium light
      300: Color(0xFF5793FF), // Medium
      400: Color(0xFF1F6FFF), // Medium dark
      500: Color(0xFF0E3999), // Dark hover base
      600: Color(0xFF0C3389), // Darker
      700: Color(0xFF0A2D79), // Much darker
      800: Color(0xFF082769), // Deep
      900: Color(0xFF062159), // Darkest
    },
  );

  @override
  MaterialColor get blueDarkActive => const MaterialColor(
    0xFF0A2D80,
    <int, Color>{
      50: Color(0xFFE1EAFF), // Very light
      100: Color(0xFFC3D5FF), // Light
      200: Color(0xFF87ABFF), // Medium light
      300: Color(0xFF4B81FF), // Medium
      400: Color(0xFF0F57FF), // Medium dark
      500: Color(0xFF0A2D80), // Dark active base
      600: Color(0xFF092873), // Darker
      700: Color(0xFF082366), // Much darker
      800: Color(0xFF071E59), // Deep
      900: Color(0xFF06194C), // Darkest
    },
  );

  @override
  MaterialColor get blueDarker => const MaterialColor(
    0xFF072166,
    <int, Color>{
      50: Color(0xFFDFE7FF), // Very light
      100: Color(0xFFBFCFFF), // Light
      200: Color(0xFF7F9FFF), // Medium light
      300: Color(0xFF3F6FFF), // Medium
      400: Color(0xFF003FFF), // Medium dark
      500: Color(0xFF072166), // Darker base
      600: Color(0xFF061E5C), // Darker
      700: Color(0xFF051B52), // Much darker
      800: Color(0xFF041848), // Deep
      900: Color(0xFF03153E), // Darkest
    },
  );

  // === DIRECT BLUE COLOR ACCESS ===

  /// Direct access to blue light color value
  Color get blueLightColor => const Color(0xFFEBF3FF);

  /// Direct access to blue light hover color value
  Color get blueLightHoverColor => const Color(0xFFD7E7FF);

  /// Direct access to blue light active color value
  Color get blueLightActiveColor => const Color(0xFFAFCFFF);

  /// Direct access to blue normal color value
  Color get blueNormalColor => const Color(0xFF357DFF);

  /// Direct access to blue normal hover color value
  Color get blueNormalHoverColor => const Color(0xFF2366E6);

  /// Direct access to blue normal active color value
  Color get blueNormalActiveColor => const Color(0xFF1C57CC);

  /// Direct access to blue dark color value
  Color get blueDarkColor => const Color(0xFF1548B3);

  /// Direct access to blue dark hover color value
  Color get blueDarkHoverColor => const Color(0xFF0E3999);

  /// Direct access to blue dark active color value
  Color get blueDarkActiveColor => const Color(0xFF0A2D80);

  /// Direct access to blue darker color value
  Color get blueDarkerColor => const Color(0xFF072166);

  // === SLATE PALETTE IMPLEMENTATION (Dark Blue System) ===

  @override
  MaterialColor get slateLight => const MaterialColor(
    0xFFE8F0FF,
    <int, Color>{
      50: Color(0xFFE8F0FF), // Light base
      100: Color(0xFFE3EDFF), // Slightly darker
      200: Color(0xFFDEEAFF), // Medium light
      300: Color(0xFFD9E7FF), // Medium
      400: Color(0xFFD4E4FF), // Medium dark
      500: Color(0xFFE8F0FF), // Base
      600: Color(0xFFCFE1FF), // Darker
      700: Color(0xFFCADEFF), // Much darker
      800: Color(0xFFC5DBFF), // Deep
      900: Color(0xFFC0D8FF), // Darkest
    },
  );

  @override
  MaterialColor get slateLightHover => const MaterialColor(
    0xFFD1E2FF,
    <int, Color>{
      50: Color(0xFFE3EDFF), // Very light
      100: Color(0xFFDEEAFF), // Light
      200: Color(0xFFD9E7FF), // Medium light
      300: Color(0xFFD4E4FF), // Medium
      400: Color(0xFFCFE1FF), // Medium dark
      500: Color(0xFFD1E2FF), // Light hover base
      600: Color(0xFFCADEFF), // Darker
      700: Color(0xFFC5DBFF), // Much darker
      800: Color(0xFFC0D8FF), // Deep
      900: Color(0xFFBBD5FF), // Darkest
    },
  );

  @override
  MaterialColor get slateLightActive => const MaterialColor(
    0xFFA3C7FF,
    <int, Color>{
      50: Color(0xFFD4E4FF), // Very light
      100: Color(0xFFCFE1FF), // Light
      200: Color(0xFFCADEFF), // Medium light
      300: Color(0xFFC5DBFF), // Medium
      400: Color(0xFFC0D8FF), // Medium dark
      500: Color(0xFFA3C7FF), // Light active base
      600: Color(0xFF99C3FF), // Darker
      700: Color(0xFF8FBFFF), // Much darker
      800: Color(0xFF85BBFF), // Deep
      900: Color(0xFF7BB7FF), // Darkest
    },
  );

  @override
  MaterialColor get slateNormal => const MaterialColor(
    0xFF1E3A8A,
    <int, Color>{
      50: Color(0xFFE8F0FF), // Very light
      100: Color(0xFFD1E2FF), // Light
      200: Color(0xFFA3C7FF), // Medium light
      300: Color(0xFF75ACFF), // Medium
      400: Color(0xFF4791FF), // Medium dark
      500: Color(0xFF1E3A8A), // Normal base (main slate)
      600: Color(0xFF1B347C), // Darker
      700: Color(0xFF182E6E), // Much darker
      800: Color(0xFF152860), // Deep
      900: Color(0xFF122252), // Darkest
    },
  );

  @override
  MaterialColor get slateNormalHover => const MaterialColor(
    0xFF1B3474,
    <int, Color>{
      50: Color(0xFFE6EFFF), // Very light
      100: Color(0xFFCDDFFF), // Light
      200: Color(0xFF9BBFFF), // Medium light
      300: Color(0xFF699FFF), // Medium
      400: Color(0xFF377FFF), // Medium dark
      500: Color(0xFF1B3474), // Normal hover base
      600: Color(0xFF182F68), // Darker
      700: Color(0xFF15295C), // Much darker
      800: Color(0xFF122450), // Deep
      900: Color(0xFF0F1F44), // Darkest
    },
  );

  @override
  MaterialColor get slateNormalActive => const MaterialColor(
    0xFF182E5E,
    <int, Color>{
      50: Color(0xFFE4EDFF), // Very light
      100: Color(0xFFC9DBFF), // Light
      200: Color(0xFF93B7FF), // Medium light
      300: Color(0xFF5D93FF), // Medium
      400: Color(0xFF276FFF), // Medium dark
      500: Color(0xFF182E5E), // Normal active base
      600: Color(0xFF162A54), // Darker
      700: Color(0xFF14254A), // Much darker
      800: Color(0xFF122140), // Deep
      900: Color(0xFF101D36), // Darkest
    },
  );

  @override
  MaterialColor get slateDark => const MaterialColor(
    0xFF152848,
    <int, Color>{
      50: Color(0xFFE2EBFF), // Very light
      100: Color(0xFFC5D7FF), // Light
      200: Color(0xFF8BAFFF), // Medium light
      300: Color(0xFF5187FF), // Medium
      400: Color(0xFF175FFF), // Medium dark
      500: Color(0xFF152848), // Dark base
      600: Color(0xFF132441), // Darker
      700: Color(0xFF11203A), // Much darker
      800: Color(0xFF0F1C33), // Deep
      900: Color(0xFF0D182C), // Darkest
    },
  );

  @override
  MaterialColor get slateDarkHover => const MaterialColor(
    0xFF122233,
    <int, Color>{
      50: Color(0xFFE0E9FF), // Very light
      100: Color(0xFFC1D3FF), // Light
      200: Color(0xFF83A7FF), // Medium light
      300: Color(0xFF457BFF), // Medium
      400: Color(0xFF074FFF), // Medium dark
      500: Color(0xFF122233), // Dark hover base
      600: Color(0xFF101F2E), // Darker
      700: Color(0xFF0E1B29), // Much darker
      800: Color(0xFF0C1824), // Deep
      900: Color(0xFF0A151F), // Darkest
    },
  );

  @override
  MaterialColor get slateDarkActive => const MaterialColor(
    0xFF0F1C2E,
    <int, Color>{
      50: Color(0xFFDEE7FF), // Very light
      100: Color(0xFFBDCFFF), // Light
      200: Color(0xFF7B9FFF), // Medium light
      300: Color(0xFF396FFF), // Medium
      400: Color(0xFF003FFF), // Medium dark
      500: Color(0xFF0F1C2E), // Dark active base
      600: Color(0xFF0D1A29), // Darker
      700: Color(0xFF0B1724), // Much darker
      800: Color(0xFF09151F), // Deep
      900: Color(0xFF07121A), // Darkest
    },
  );

  @override
  MaterialColor get slateDarker => const MaterialColor(
    0xFF0C1629,
    <int, Color>{
      50: Color(0xFFDCE5FF), // Very light
      100: Color(0xFFB9CBFF), // Light
      200: Color(0xFF7397FF), // Medium light
      300: Color(0xFF2D63FF), // Medium
      400: Color(0xFF002FFF), // Medium dark
      500: Color(0xFF0C1629), // Darker base
      600: Color(0xFF0B1424), // Darker
      700: Color(0xFF0A121F), // Much darker
      800: Color(0xFF09101A), // Deep
      900: Color(0xFF080E15), // Darkest
    },
  );

  // === DIRECT SLATE COLOR ACCESS ===

  /// Direct access to slate light color value
  Color get slateLightColor => const Color(0xFFE8F0FF);

  /// Direct access to slate light hover color value
  Color get slateLightHoverColor => const Color(0xFFD1E2FF);

  /// Direct access to slate light active color value
  Color get slateLightActiveColor => const Color(0xFFA3C7FF);

  /// Direct access to slate normal color value
  Color get slateNormalColor => const Color(0xFF1E3A8A);

  /// Direct access to slate normal hover color value
  Color get slateNormalHoverColor => const Color(0xFF1B3474);

  /// Direct access to slate normal active color value
  Color get slateNormalActiveColor => const Color(0xFF182E5E);

  /// Direct access to slate dark color value
  Color get slateDarkColor => const Color(0xFF152848);

  /// Direct access to slate dark hover color value
  Color get slateDarkHoverColor => const Color(0xFF122233);

  /// Direct access to slate dark active color value
  Color get slateDarkActiveColor => const Color(0xFF0F1C2E);

  /// Direct access to slate darker color value
  Color get slateDarkerColor => const Color(0xFF0C1629);

  // === GREEN PALETTE IMPLEMENTATION (Complete Design System) ===

  @override
  MaterialColor get greenLight => const MaterialColor(
    0xFFECFDF5,
    <int, Color>{
      50: Color(0xFFECFDF5), // Light base
      100: Color(0xFFE7FCF2), // Slightly darker
      200: Color(0xFFE2FBEF), // Medium light
      300: Color(0xFFDDFAEC), // Medium
      400: Color(0xFFD8F9E9), // Medium dark
      500: Color(0xFFECFDF5), // Base
      600: Color(0xFFD3F8E6), // Darker
      700: Color(0xFFCEF7E3), // Much darker
      800: Color(0xFFC9F6E0), // Deep
      900: Color(0xFFC4F5DD), // Darkest
    },
  );

  @override
  MaterialColor get greenLightHover => const MaterialColor(
    0xFFD1FAE5,
    <int, Color>{
      50: Color(0xFFE7FCF2), // Very light
      100: Color(0xFFE2FBEF), // Light
      200: Color(0xFFDDFAEC), // Medium light
      300: Color(0xFFD8F9E9), // Medium
      400: Color(0xFFD3F8E6), // Medium dark
      500: Color(0xFFD1FAE5), // Light hover base
      600: Color(0xFFCEF7E3), // Darker
      700: Color(0xFFC9F6E0), // Much darker
      800: Color(0xFFC4F5DD), // Deep
      900: Color(0xFFBFF4DA), // Darkest
    },
  );

  @override
  MaterialColor get greenLightActive => const MaterialColor(
    0xFFA7F3D0,
    <int, Color>{
      50: Color(0xFFD8F9E9), // Very light
      100: Color(0xFFD3F8E6), // Light
      200: Color(0xFFCEF7E3), // Medium light
      300: Color(0xFFC9F6E0), // Medium
      400: Color(0xFFC4F5DD), // Medium dark
      500: Color(0xFFA7F3D0), // Light active base
      600: Color(0xFF9DF1CB), // Darker
      700: Color(0xFF93EFC6), // Much darker
      800: Color(0xFF89EDC1), // Deep
      900: Color(0xFF7FEBBC), // Darkest
    },
  );

  @override
  MaterialColor get greenNormal => const MaterialColor(
    0xFF10B981,
    <int, Color>{
      50: Color(0xFFECFDF5), // Very light
      100: Color(0xFFD1FAE5), // Light
      200: Color(0xFFA7F3D0), // Medium light
      300: Color(0xFF7DEBBB), // Medium
      400: Color(0xFF53E3A6), // Medium dark
      500: Color(0xFF10B981), // Normal base (main green)
      600: Color(0xFF0FA775), // Darker
      700: Color(0xFF0E9569), // Much darker
      800: Color(0xFF0D835D), // Deep
      900: Color(0xFF0C7151), // Darkest
    },
  );

  @override
  MaterialColor get greenNormalHover => const MaterialColor(
    0xFF059669,
    <int, Color>{
      50: Color(0xFFEAFCF3), // Very light
      100: Color(0xFFCDF8E1), // Light
      200: Color(0xFF9BF1C3), // Medium light
      300: Color(0xFF69EAA5), // Medium
      400: Color(0xFF37E387), // Medium dark
      500: Color(0xFF059669), // Normal hover base
      600: Color(0xFF05875F), // Darker
      700: Color(0xFF047855), // Much darker
      800: Color(0xFF04694B), // Deep
      900: Color(0xFF035A41), // Darkest
    },
  );

  @override
  MaterialColor get greenNormalActive => const MaterialColor(
    0xFF047857,
    <int, Color>{
      50: Color(0xFFE8FBF1), // Very light
      100: Color(0xFFC9F6DD), // Light
      200: Color(0xFF93EDBB), // Medium light
      300: Color(0xFF5DE499), // Medium
      400: Color(0xFF27DB77), // Medium dark
      500: Color(0xFF047857), // Normal active base
      600: Color(0xFF046C4F), // Darker
      700: Color(0xFF036047), // Much darker
      800: Color(0xFF03543F), // Deep
      900: Color(0xFF024837), // Darkest
    },
  );

  @override
  MaterialColor get greenDark => const MaterialColor(
    0xFF065F46,
    <int, Color>{
      50: Color(0xFFE6F9F1), // Very light
      100: Color(0xFFC5F3DD), // Light
      200: Color(0xFF8BE7BB), // Medium light
      300: Color(0xFF51DB99), // Medium
      400: Color(0xFF17CF77), // Medium dark
      500: Color(0xFF065F46), // Dark base
      600: Color(0xFF055641), // Darker
      700: Color(0xFF054D3C), // Much darker
      800: Color(0xFF044437), // Deep
      900: Color(0xFF043B32), // Darkest
    },
  );

  @override
  MaterialColor get greenDarkHover => const MaterialColor(
    0xFF064E3B,
    <int, Color>{
      50: Color(0xFFE4F8EF), // Very light
      100: Color(0xFFC1F1D9), // Light
      200: Color(0xFF83E3B3), // Medium light
      300: Color(0xFF45D58D), // Medium
      400: Color(0xFF07C767), // Medium dark
      500: Color(0xFF064E3B), // Dark hover base
      600: Color(0xFF054635), // Darker
      700: Color(0xFF053E2F), // Much darker
      800: Color(0xFF043629), // Deep
      900: Color(0xFF032E23), // Darkest
    },
  );

  @override
  MaterialColor get greenDarkActive => const MaterialColor(
    0xFF022C22,
    <int, Color>{
      50: Color(0xFFE2F6ED), // Very light
      100: Color(0xFFBDEDD5), // Light
      200: Color(0xFF7BDBAB), // Medium light
      300: Color(0xFF39C981), // Medium
      400: Color(0xFF00B757), // Medium dark
      500: Color(0xFF022C22), // Dark active base
      600: Color(0xFF022820), // Darker
      700: Color(0xFF01241E), // Much darker
      800: Color(0xFF01201C), // Deep
      900: Color(0xFF011C1A), // Darkest
    },
  );

  @override
  MaterialColor get greenDarker => const MaterialColor(
    0xFF012A20,
    <int, Color>{
      50: Color(0xFFE0F4EB), // Very light
      100: Color(0xFFB9E9D1), // Light
      200: Color(0xFF73D3A3), // Medium light
      300: Color(0xFF2DBD75), // Medium
      400: Color(0xFF00A747), // Medium dark
      500: Color(0xFF012A20), // Darker base
      600: Color(0xFF01261E), // Darker
      700: Color(0xFF01221C), // Much darker
      800: Color(0xFF011E1A), // Deep
      900: Color(0xFF011A18), // Darkest
    },
  );

  // === DIRECT GREEN COLOR ACCESS ===

  /// Direct access to green light color value
  Color get greenLightColor => const Color(0xFFECFDF5);

  /// Direct access to green light hover color value
  Color get greenLightHoverColor => const Color(0xFFD1FAE5);

  /// Direct access to green light active color value
  Color get greenLightActiveColor => const Color(0xFFA7F3D0);

  /// Direct access to green normal color value
  Color get greenNormalColor => const Color(0xFF10B981);

  /// Direct access to green normal hover color value
  Color get greenNormalHoverColor => const Color(0xFF059669);

  /// Direct access to green normal active color value
  Color get greenNormalActiveColor => const Color(0xFF047857);

  /// Direct access to green dark color value
  Color get greenDarkColor => const Color(0xFF065F46);

  /// Direct access to green dark hover color value
  Color get greenDarkHoverColor => const Color(0xFF064E3B);

  /// Direct access to green dark active color value
  Color get greenDarkActiveColor => const Color(0xFF022C22);

  /// Direct access to green darker color value
  Color get greenDarkerColor => const Color(0xFF012A20);

  // === PINK PALETTE IMPLEMENTATION (Complete Design System) ===

  @override
  MaterialColor get pinkLight => const MaterialColor(
    0xFFFDF2F8,
    <int, Color>{
      50: Color(0xFFFDF2F8), // Light base
      100: Color(0xFFFDF0F6), // Slightly darker
      200: Color(0xFFFCEEF4), // Medium light
      300: Color(0xFFFCECF2), // Medium
      400: Color(0xFFFCEAF0), // Medium dark
      500: Color(0xFFFDF2F8), // Base
      600: Color(0xFFFCE8EE), // Darker
      700: Color(0xFFFBE6EC), // Much darker
      800: Color(0xFFFBE4EA), // Deep
      900: Color(0xFFFAE2E8), // Darkest
    },
  );

  @override
  MaterialColor get pinkLightHover => const MaterialColor(
    0xFFFCE7F3,
    <int, Color>{
      50: Color(0xFFFDF0F6), // Very light
      100: Color(0xFFFCEEF4), // Light
      200: Color(0xFFFCECF2), // Medium light
      300: Color(0xFFFCEAF0), // Medium
      400: Color(0xFFFCE8EE), // Medium dark
      500: Color(0xFFFCE7F3), // Light hover base
      600: Color(0xFFFBE6EC), // Darker
      700: Color(0xFFFBE4EA), // Much darker
      800: Color(0xFFFAE2E8), // Deep
      900: Color(0xFFFAE0E6), // Darkest
    },
  );

  @override
  MaterialColor get pinkLightActive => const MaterialColor(
    0xFFF9A8D4,
    <int, Color>{
      50: Color(0xFFFCE8EE), // Very light
      100: Color(0xFFFBE6EC), // Light
      200: Color(0xFFFBE4EA), // Medium light
      300: Color(0xFFFAE2E8), // Medium
      400: Color(0xFFFAE0E6), // Medium dark
      500: Color(0xFFF9A8D4), // Light active base
      600: Color(0xFFF89DC9), // Darker
      700: Color(0xFFF892BE), // Much darker
      800: Color(0xFFF787B3), // Deep
      900: Color(0xFFF67CA8), // Darkest
    },
  );

  @override
  MaterialColor get pinkNormal => const MaterialColor(
    0xFFEC4899,
    <int, Color>{
      50: Color(0xFFFDF2F8), // Very light
      100: Color(0xFFFCE7F3), // Light
      200: Color(0xFFF9A8D4), // Medium light
      300: Color(0xFFF472B6), // Medium
      400: Color(0xFFEF4493), // Medium dark
      500: Color(0xFFEC4899), // Normal base (main pink)
      600: Color(0xFFD946EF), // Darker
      700: Color(0xFFDB2777), // Much darker
      800: Color(0xFFBE185D), // Deep
      900: Color(0xFF9D174D), // Darkest
    },
  );

  @override
  MaterialColor get pinkNormalHover => const MaterialColor(
    0xFFDB2777,
    <int, Color>{
      50: Color(0xFFFBF1F5), // Very light
      100: Color(0xFFF9E2ED), // Light
      200: Color(0xFFF395C7), // Medium light
      300: Color(0xFFED64A6), // Medium
      400: Color(0xFFE73185), // Medium dark
      500: Color(0xFFDB2777), // Normal hover base
      600: Color(0xFFD21D6B), // Darker
      700: Color(0xFFC9135F), // Much darker
      800: Color(0xFFC00953), // Deep
      900: Color(0xFFB70047), // Darkest
    },
  );

  @override
  MaterialColor get pinkNormalActive => const MaterialColor(
    0xFFBE185D,
    <int, Color>{
      50: Color(0xFFF9F0F3), // Very light
      100: Color(0xFFF5DAE3), // Light
      200: Color(0xFFE882B0), // Medium light
      300: Color(0xFFDB2A7D), // Medium
      400: Color(0xFFCE004A), // Medium dark
      500: Color(0xFFBE185D), // Normal active base
      600: Color(0xFFB21556), // Darker
      700: Color(0xFFA6124F), // Much darker
      800: Color(0xFF9A0F48), // Deep
      900: Color(0xFF8E0C41), // Darkest
    },
  );

  @override
  MaterialColor get pinkDark => const MaterialColor(
    0xFF9D174D,
    <int, Color>{
      50: Color(0xFFF7EEF2), // Very light
      100: Color(0xFFEFDCE5), // Light
      200: Color(0xFFDEBACB), // Medium light
      300: Color(0xFFCD98B1), // Medium
      400: Color(0xFFBC7697), // Medium dark
      500: Color(0xFF9D174D), // Dark base
      600: Color(0xFF921548), // Darker
      700: Color(0xFF871343), // Much darker
      800: Color(0xFF7C113E), // Deep
      900: Color(0xFF710F39), // Darkest
    },
  );

  @override
  MaterialColor get pinkDarkHover => const MaterialColor(
    0xFF831843,
    <int, Color>{
      50: Color(0xFFF5ECF0), // Very light
      100: Color(0xFFEBD9E1), // Light
      200: Color(0xFFD7B3C3), // Medium light
      300: Color(0xFFC38DA5), // Medium
      400: Color(0xFFAF6787), // Medium dark
      500: Color(0xFF831843), // Dark hover base
      600: Color(0xFF7A163F), // Darker
      700: Color(0xFF71143B), // Much darker
      800: Color(0xFF681237), // Deep
      900: Color(0xFF5F1033), // Darkest
    },
  );

  @override
  MaterialColor get pinkDarkActive => const MaterialColor(
    0xFF701A43,
    <int, Color>{
      50: Color(0xFFF3EAEE), // Very light
      100: Color(0xFFE7D5DD), // Light
      200: Color(0xFFCFABBB), // Medium light
      300: Color(0xFFB78199), // Medium
      400: Color(0xFF9F5777), // Medium dark
      500: Color(0xFF701A43), // Dark active base
      600: Color(0xFF68183F), // Darker
      700: Color(0xFF60163B), // Much darker
      800: Color(0xFF581437), // Deep
      900: Color(0xFF501233), // Darkest
    },
  );

  @override
  MaterialColor get pinkDarker => const MaterialColor(
    0xFF4C1D2E,
    <int, Color>{
      50: Color(0xFFF1E8EC), // Very light
      100: Color(0xFFE3D1D9), // Light
      200: Color(0xFFC7A3B3), // Medium light
      300: Color(0xFFAB758D), // Medium
      400: Color(0xFF8F4767), // Medium dark
      500: Color(0xFF4C1D2E), // Darker base
      600: Color(0xFF461B2B), // Darker
      700: Color(0xFF401928), // Much darker
      800: Color(0xFF3A1725), // Deep
      900: Color(0xFF341522), // Darkest
    },
  );

  // === DIRECT PINK COLOR ACCESS ===

  /// Direct access to pink light color value
  Color get pinkLightColor => const Color(0xFFFDF2F8);

  /// Direct access to pink light hover color value
  Color get pinkLightHoverColor => const Color(0xFFFCE7F3);

  /// Direct access to pink light active color value
  Color get pinkLightActiveColor => const Color(0xFFF9A8D4);

  /// Direct access to pink normal color value
  Color get pinkNormalColor => const Color(0xFFEC4899);

  /// Direct access to pink normal hover color value
  Color get pinkNormalHoverColor => const Color(0xFFDB2777);

  /// Direct access to pink normal active color value
  Color get pinkNormalActiveColor => const Color(0xFFBE185D);

  /// Direct access to pink dark color value
  Color get pinkDarkColor => const Color(0xFF9D174D);

  /// Direct access to pink dark hover color value
  Color get pinkDarkHoverColor => const Color(0xFF831843);

  /// Direct access to pink dark active color value
  Color get pinkDarkActiveColor => const Color(0xFF701A43);

  /// Direct access to pink darker color value
  Color get pinkDarkerColor => const Color(0xFF4C1D2E);

  // === ORANGE PALETTE IMPLEMENTATION (Complete Design System) ===

  @override
  MaterialColor get orangeLight => const MaterialColor(
    0xFFFFF5E6,
    <int, Color>{
      50: Color(0xFFFFF5E6), // Light base
      100: Color(0xFFFFF3E3), // Slightly darker
      200: Color(0xFFFFF1E0), // Medium light
      300: Color(0xFFFFEFDD), // Medium
      400: Color(0xFFFFEDDA), // Medium dark
      500: Color(0xFFFFF5E6), // Base
      600: Color(0xFFFFEBD7), // Darker
      700: Color(0xFFFFE9D4), // Much darker
      800: Color(0xFFFFE7D1), // Deep
      900: Color(0xFFFFE5CE), // Darkest
    },
  );

  @override
  MaterialColor get orangeLightHover => const MaterialColor(
    0xFFFFEDCC,
    <int, Color>{
      50: Color(0xFFFFF3E3), // Very light
      100: Color(0xFFFFF1E0), // Light
      200: Color(0xFFFFEFDD), // Medium light
      300: Color(0xFFFFEDDA), // Medium
      400: Color(0xFFFFEBD7), // Medium dark
      500: Color(0xFFFFEDCC), // Light hover base
      600: Color(0xFFFFE9D4), // Darker
      700: Color(0xFFFFE7D1), // Much darker
      800: Color(0xFFFFE5CE), // Deep
      900: Color(0xFFFFE3CB), // Darkest
    },
  );

  @override
  MaterialColor get orangeLightActive => const MaterialColor(
    0xFFFFE0B3,
    <int, Color>{
      50: Color(0xFFFFEBD7), // Very light
      100: Color(0xFFFFE9D4), // Light
      200: Color(0xFFFFE7D1), // Medium light
      300: Color(0xFFFFE5CE), // Medium
      400: Color(0xFFFFE3CB), // Medium dark
      500: Color(0xFFFFE0B3), // Light active base
      600: Color(0xFFFFDDAA), // Darker
      700: Color(0xFFFFDBA1), // Much darker
      800: Color(0xFFFFD998), // Deep
      900: Color(0xFFFFD78F), // Darkest
    },
  );

  @override
  MaterialColor get orangeNormal => const MaterialColor(
    0xFFFF7F00,
    <int, Color>{
      50: Color(0xFFFFF5E6), // Very light
      100: Color(0xFFFFEDCC), // Light
      200: Color(0xFFFFE0B3), // Medium light
      300: Color(0xFFFFCC80), // Medium
      400: Color(0xFFFFB84D), // Medium dark
      500: Color(0xFFFF7F00), // Normal base (main orange)
      600: Color(0xFFE67300), // Darker
      700: Color(0xFFCC6600), // Much darker
      800: Color(0xFFB35900), // Deep
      900: Color(0xFF994D00), // Darkest
    },
  );

  @override
  MaterialColor get orangeNormalHover => const MaterialColor(
    0xFFE67300,
    <int, Color>{
      50: Color(0xFFFFF3E0), // Very light
      100: Color(0xFFFFEBC2), // Light
      200: Color(0xFFFFDD9E), // Medium light
      300: Color(0xFFFFCA6A), // Medium
      400: Color(0xFFFFB036), // Medium dark
      500: Color(0xFFE67300), // Normal hover base
      600: Color(0xFFD36800), // Darker
      700: Color(0xFFC05D00), // Much darker
      800: Color(0xFFAD5200), // Deep
      900: Color(0xFF9A4700), // Darkest
    },
  );

  @override
  MaterialColor get orangeNormalActive => const MaterialColor(
    0xFFCC6600,
    <int, Color>{
      50: Color(0xFFFFF1DB), // Very light
      100: Color(0xFFFFE8B8), // Light
      200: Color(0xFFFFDA89), // Medium light
      300: Color(0xFFFFCA5A), // Medium
      400: Color(0xFFFFB02B), // Medium dark
      500: Color(0xFFCC6600), // Normal active base
      600: Color(0xFFBB5D00), // Darker
      700: Color(0xFFAA5400), // Much darker
      800: Color(0xFF994B00), // Deep
      900: Color(0xFF884200), // Darkest
    },
  );

  @override
  MaterialColor get orangeDark => const MaterialColor(
    0xFFB35900,
    <int, Color>{
      50: Color(0xFFFEEFD6), // Very light
      100: Color(0xFFFEE5AD), // Light
      200: Color(0xFFFDD684), // Medium light
      300: Color(0xFFFCC75B), // Medium
      400: Color(0xFFFBB832), // Medium dark
      500: Color(0xFFB35900), // Dark base
      600: Color(0xFFA35100), // Darker
      700: Color(0xFF934900), // Much darker
      800: Color(0xFF834100), // Deep
      900: Color(0xFF733900), // Darkest
    },
  );

  @override
  MaterialColor get orangeDarkHover => const MaterialColor(
    0xFF994D00,
    <int, Color>{
      50: Color(0xFFFDECD1), // Very light
      100: Color(0xFFFCE1A3), // Light
      200: Color(0xFFFBD175), // Medium light
      300: Color(0xFFFAC147), // Medium
      400: Color(0xFFF9B119), // Medium dark
      500: Color(0xFF994D00), // Dark hover base
      600: Color(0xFF8C4600), // Darker
      700: Color(0xFF7F3F00), // Much darker
      800: Color(0xFF723800), // Deep
      900: Color(0xFF653100), // Darkest
    },
  );

  @override
  MaterialColor get orangeDarkActive => const MaterialColor(
    0xFF804000,
    <int, Color>{
      50: Color(0xFFFCE9CC), // Very light
      100: Color(0xFFFBDD99), // Light
      200: Color(0xFFFACC66), // Medium light
      300: Color(0xFFF9BB33), // Medium
      400: Color(0xFFF8AA00), // Medium dark
      500: Color(0xFF804000), // Dark active base
      600: Color(0xFF753A00), // Darker
      700: Color(0xFF6A3400), // Much darker
      800: Color(0xFF5F2E00), // Deep
      900: Color(0xFF542800), // Darkest
    },
  );

  @override
  MaterialColor get orangeDarker => const MaterialColor(
    0xFF663300,
    <int, Color>{
      50: Color(0xFFFBE6C7), // Very light
      100: Color(0xFFF9D98F), // Light
      200: Color(0xFFF7CC57), // Medium light
      300: Color(0xFFF5BF1F), // Medium
      400: Color(0xFFF3B200), // Medium dark
      500: Color(0xFF663300), // Darker base
      600: Color(0xFF5E2F00), // Darker
      700: Color(0xFF562B00), // Much darker
      800: Color(0xFF4E2700), // Deep
      900: Color(0xFF462300), // Darkest
    },
  );

  // === DIRECT ORANGE COLOR ACCESS ===

  /// Direct access to orange light color value
  Color get orangeLightColor => const Color(0xFFFFF5E6);

  /// Direct access to orange light hover color value
  Color get orangeLightHoverColor => const Color(0xFFFFEDCC);

  /// Direct access to orange light active color value
  Color get orangeLightActiveColor => const Color(0xFFFFE0B3);

  /// Direct access to orange normal color value
  Color get orangeNormalColor => const Color(0xFFFF7F00);

  /// Direct access to orange normal hover color value
  Color get orangeNormalHoverColor => const Color(0xFFE67300);

  /// Direct access to orange normal active color value
  Color get orangeNormalActiveColor => const Color(0xFFCC6600);

  /// Direct access to orange dark color value
  Color get orangeDarkColor => const Color(0xFFB35900);

  /// Direct access to orange dark hover color value
  Color get orangeDarkHoverColor => const Color(0xFF994D00);

  /// Direct access to orange dark active color value
  Color get orangeDarkActiveColor => const Color(0xFF804000);

  /// Direct access to orange darker color value
  Color get orangeDarkerColor => const Color(0xFF663300);

  // === RED PALETTE IMPLEMENTATION (Complete Design System) ===

  @override
  MaterialColor get redLight => const MaterialColor(
    0xFFFEF2F2,
    <int, Color>{
      50: Color(0xFFFEF2F2), // Light base
      100: Color(0xFFFDF0F0), // Slightly darker
      200: Color(0xFFFCEEEE), // Medium light
      300: Color(0xFFFBECEC), // Medium
      400: Color(0xFFFAEAEA), // Medium dark
      500: Color(0xFFFEF2F2), // Base
      600: Color(0xFFF9E8E8), // Darker
      700: Color(0xFFF8E6E6), // Much darker
      800: Color(0xFFF7E4E4), // Deep
      900: Color(0xFFF6E2E2), // Darkest
    },
  );

  @override
  MaterialColor get redLightHover => const MaterialColor(
    0xFFFCE7E7,
    <int, Color>{
      50: Color(0xFFFDF0F0), // Very light
      100: Color(0xFFFCEEEE), // Light
      200: Color(0xFFFBECEC), // Medium light
      300: Color(0xFFFAEAEA), // Medium
      400: Color(0xFFF9E8E8), // Medium dark
      500: Color(0xFFFCE7E7), // Light hover base
      600: Color(0xFFF8E6E6), // Darker
      700: Color(0xFFF7E4E4), // Much darker
      800: Color(0xFFF6E2E2), // Deep
      900: Color(0xFFF5E0E0), // Darkest
    },
  );

  @override
  MaterialColor get redLightActive => const MaterialColor(
    0xFFF8D7DA,
    <int, Color>{
      50: Color(0xFFF9E8E8), // Very light
      100: Color(0xFFF8E6E6), // Light
      200: Color(0xFFF7E4E4), // Medium light
      300: Color(0xFFF6E2E2), // Medium
      400: Color(0xFFF5E0E0), // Medium dark
      500: Color(0xFFF8D7DA), // Light active base
      600: Color(0xFFF4DCDF), // Darker
      700: Color(0xFFF0D1D4), // Much darker
      800: Color(0xFFECC6C9), // Deep
      900: Color(0xFFE8BBBE), // Darkest
    },
  );

  @override
  MaterialColor get redNormal => const MaterialColor(
    0xFFDC3545,
    <int, Color>{
      50: Color(0xFFFEF2F2), // Very light
      100: Color(0xFFFCE7E7), // Light
      200: Color(0xFFF8D7DA), // Medium light
      300: Color(0xFFF2A8AE), // Medium
      400: Color(0xFFED7882), // Medium dark
      500: Color(0xFFDC3545), // Normal base (main red)
      600: Color(0xFFC82333), // Darker
      700: Color(0xFFB21E2F), // Much darker
      800: Color(0xFF9C1A2B), // Deep
      900: Color(0xFF861727), // Darkest
    },
  );

  @override
  MaterialColor get redNormalHover => const MaterialColor(
    0xFFC82333,
    <int, Color>{
      50: Color(0xFFFCF0F1), // Very light
      100: Color(0xFFF9E1E3), // Light
      200: Color(0xFFF3C3C7), // Medium light
      300: Color(0xFFEDA5AB), // Medium
      400: Color(0xFFE7878F), // Medium dark
      500: Color(0xFFC82333), // Normal hover base
      600: Color(0xFFB71F2F), // Darker
      700: Color(0xFFA61B2B), // Much darker
      800: Color(0xFF951727), // Deep
      900: Color(0xFF841323), // Darkest
    },
  );

  @override
  MaterialColor get redNormalActive => const MaterialColor(
    0xFFB21E2F,
    <int, Color>{
      50: Color(0xFFFAEEF0), // Very light
      100: Color(0xFFF5DDE1), // Light
      200: Color(0xFFEBBBC3), // Medium light
      300: Color(0xFFE199A5), // Medium
      400: Color(0xFFD77787), // Medium dark
      500: Color(0xFFB21E2F), // Normal active base
      600: Color(0xFFA21B2B), // Darker
      700: Color(0xFF921827), // Much darker
      800: Color(0xFF821523), // Deep
      900: Color(0xFF72121F), // Darkest
    },
  );

  @override
  MaterialColor get redDark => const MaterialColor(
    0xFF9C1A2B,
    <int, Color>{
      50: Color(0xFFF8ECF0), // Very light
      100: Color(0xFFF1D9E1), // Light
      200: Color(0xFFE3B3C3), // Medium light
      300: Color(0xFFD58DA5), // Medium
      400: Color(0xFFC76787), // Medium dark
      500: Color(0xFF9C1A2B), // Dark base
      600: Color(0xFF8E1827), // Darker
      700: Color(0xFF801623), // Much darker
      800: Color(0xFF72141F), // Deep
      900: Color(0xFF64121B), // Darkest
    },
  );

  @override
  MaterialColor get redDarkHover => const MaterialColor(
    0xFF861727,
    <int, Color>{
      50: Color(0xFFF6EAED), // Very light
      100: Color(0xFFEDD5DB), // Light
      200: Color(0xFFDBABB7), // Medium light
      300: Color(0xFFC98193), // Medium
      400: Color(0xFFB7576F), // Medium dark
      500: Color(0xFF861727), // Dark hover base
      600: Color(0xFF7A1523), // Darker
      700: Color(0xFF6E131F), // Much darker
      800: Color(0xFF62111B), // Deep
      900: Color(0xFF560F17), // Darkest
    },
  );

  @override
  MaterialColor get redDarkActive => const MaterialColor(
    0xFF701323,
    <int, Color>{
      50: Color(0xFFF4E8EA), // Very light
      100: Color(0xFFE9D1D5), // Light
      200: Color(0xFFD3A3AB), // Medium light
      300: Color(0xFFBD7581), // Medium
      400: Color(0xFFA74757), // Medium dark
      500: Color(0xFF701323), // Dark active base
      600: Color(0xFF661120), // Darker
      700: Color(0xFF5C0F1D), // Much darker
      800: Color(0xFF520D1A), // Deep
      900: Color(0xFF480B17), // Darkest
    },
  );

  @override
  MaterialColor get redDarker => const MaterialColor(
    0xFF5A0F1F,
    <int, Color>{
      50: Color(0xFFF2E6E9), // Very light
      100: Color(0xFFE5CDD3), // Light
      200: Color(0xFFCB9BA7), // Medium light
      300: Color(0xFFB1697B), // Medium
      400: Color(0xFF97374F), // Medium dark
      500: Color(0xFF5A0F1F), // Darker base
      600: Color(0xFF510E1C), // Darker
      700: Color(0xFF480D19), // Much darker
      800: Color(0xFF3F0C16), // Deep
      900: Color(0xFF360B13), // Darkest
    },
  );

  // === DIRECT RED COLOR ACCESS ===

  /// Direct access to red light color value
  Color get redLightColor => const Color(0xFFFEF2F2);

  /// Direct access to red light hover color value
  Color get redLightHoverColor => const Color(0xFFFCE7E7);

  /// Direct access to red light active color value
  Color get redLightActiveColor => const Color(0xFFF8D7DA);

  /// Direct access to red normal color value
  Color get redNormalColor => const Color(0xFFDC3545);

  /// Direct access to red normal hover color value
  Color get redNormalHoverColor => const Color(0xFFC82333);

  /// Direct access to red normal active color value
  Color get redNormalActiveColor => const Color(0xFFB21E2F);

  /// Direct access to red dark color value
  Color get redDarkColor => const Color(0xFF9C1A2B);

  /// Direct access to red dark hover color value
  Color get redDarkHoverColor => const Color(0xFF861727);

  /// Direct access to red dark active color value
  Color get redDarkActiveColor => const Color(0xFF701323);

  /// Direct access to red darker color value
  Color get redDarkerColor => const Color(0xFF5A0F1F);

  // === BACKWARD COMPATIBILITY IMPLEMENTATIONS ===
  // Amber pale implementation for background usage
}
