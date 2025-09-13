import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/core/styles/app_text_styles.dart';

/// Implementation of AppTextStyles using Public Sans font family.
///
/// Provides typography styles according to design system specifications
/// with consistent font weight (400), line height (120%), and letter
/// spacing (0%). All font sizes are responsive using flutter_screenutil.
///
/// This implementation prioritizes bundled fonts in assets/fonts/google_fonts/
/// over HTTP fetching for better performance and offline support.
@LazySingleton(as: AppTextStyles)
class AppTextStylesImpl implements AppTextStyles {
  /// Creates an instance of AppTextStylesImpl and configures Google Fonts.
  AppTextStylesImpl() {
    // Configure Google Fonts to allow runtime fetching as fallback
    // but prioritize bundled fonts in assets
    GoogleFonts.config.allowRuntimeFetching = true;
  }

  /// Base text style factory with design system specifications.
  ///
  /// Creates text styles using Public Sans font family with consistent
  /// typography properties as defined in the design specifications.
  ///
  /// Font loading priority:
  /// 1. Bundled fonts from assets/fonts/google_fonts/ (preferred)
  /// 2. Runtime HTTP fetching (fallback)
  /// 3. System fonts (emergency fallback)
  ///
  /// [fontSize] The font size in pixels.
  /// [color] Optional text color to override the default.
  TextStyle _base({
    required double fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    try {
      // Google Fonts automatically prioritizes bundled fonts from assets
      // before attempting HTTP fetching
      return GoogleFonts.publicSans(
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      );
    } on Exception catch (_) {
      // Emergency fallback: Use system fonts if both bundled and network
      // loading fail. This prevents app crashes in extreme scenarios.
      return TextStyle(
        fontFamily: _getFallbackFontFamily(),
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      );
    }
  }

  /// Provides system-appropriate fallback fonts for offline scenarios.
  ///
  /// Returns platform-specific system fonts that closely match Public Sans
  /// characteristics when Google Fonts cannot be loaded from the network.
  String _getFallbackFontFamily() {
    // Platform-specific system fonts that provide good alternatives to
    // Public Sans
    if (kIsWeb) {
      return 'system-ui'; // Web: Use system UI font
    } else if (Platform.isIOS) {
      return '.SF UI Text'; // iOS: Use San Francisco font
    } else if (Platform.isAndroid) {
      return 'Roboto'; // Android: Use Roboto (default system font)
    } else if (Platform.isMacOS) {
      return '.SF NS Text'; // macOS: Use San Francisco font
    } else if (Platform.isWindows) {
      return 'Segoe UI'; // Windows: Use Segoe UI
    } else if (Platform.isLinux) {
      return 'Ubuntu'; // Linux: Use Ubuntu font
    }

    // Fallback for unsupported platforms
    return 'sans-serif';
  }

  @override
  TextStyle displayLarge({Color? color}) => _base(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );

  @override
  TextStyle displayMedium({Color? color}) => _base(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );

  @override
  TextStyle headingLarge({Color? color}) => _base(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );

  @override
  TextStyle headingMedium({Color? color}) => _base(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );

  @override
  TextStyle bodyLarge({Color? color}) => _base(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );

  @override
  TextStyle bodyMedium({Color? color}) => _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );

  @override
  TextStyle bodySmall({Color? color}) => _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );

  @override
  TextStyle caption({Color? color}) => _base(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: color,
  );
}
