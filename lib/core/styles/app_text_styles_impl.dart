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
@LazySingleton(as: AppTextStyles)
class AppTextStylesImpl implements AppTextStyles {
  /// Creates an instance of AppTextStylesImpl.
  const AppTextStylesImpl();

  /// Base text style factory with design system specifications.
  ///
  /// Creates text styles using Public Sans font family with consistent
  /// typography properties as defined in the design specifications.
  /// Falls back to system fonts when Google Fonts network loading fails.
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
      // Attempt to load Google Fonts
      return GoogleFonts.publicSans(
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      );
    } on Exception catch (_) {
      // Network error: Fall back to system fonts immediately
      // This prevents the app from crashing when Google Fonts can't load
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

  @override
  TextStyle buttonText({Color? color}) => _base(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: color ?? Colors.white,
    height: 1, // 100% line height
    letterSpacing: 0, // 0% letter spacing
  );
}
