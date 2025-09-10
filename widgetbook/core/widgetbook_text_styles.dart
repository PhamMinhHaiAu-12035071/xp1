import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xp1/core/styles/app_text_styles.dart';

/// Widgetbook-specific text styles that show actual pixel sizes.
///
/// This implementation does NOT use ScreenUtil scaling (.sp) to display
/// typography at their exact pixel sizes as specified in the design system.
/// This ensures accurate typography showcase in Widgetbook.
class WidgetbookTextStyles implements AppTextStyles {
  /// Creates an instance of WidgetbookTextStyles.
  const WidgetbookTextStyles();

  /// Base text style factory with exact pixel sizes.
  ///
  /// Uses actual pixel values without ScreenUtil scaling to show
  /// typography at their true design sizes in Widgetbook.
  ///
  /// [fontSize] The font size in exact pixels.
  /// [color] Optional text color to override the default.
  TextStyle _base({
    required double fontSize,
    Color? color,
  }) => GoogleFonts.publicSans(
    fontSize: fontSize, // No .sp scaling for accurate showcase
    color: color,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
  );

  @override
  TextStyle displayLarge({Color? color}) => _base(
    fontSize: 36,
    color: color,
  );

  @override
  TextStyle displayMedium({Color? color}) => _base(
    fontSize: 32,
    color: color,
  );

  @override
  TextStyle headingLarge({Color? color}) => _base(
    fontSize: 24,
    color: color,
  );

  @override
  TextStyle headingMedium({Color? color}) => _base(
    fontSize: 20,
    color: color,
  );

  @override
  TextStyle bodyLarge({Color? color}) => _base(
    fontSize: 16,
    color: color,
  );

  @override
  TextStyle bodyMedium({Color? color}) => _base(
    fontSize: 14,
    color: color,
  );

  @override
  TextStyle bodySmall({Color? color}) => _base(
    fontSize: 12,
    color: color,
  );

  @override
  TextStyle caption({Color? color}) => _base(
    fontSize: 10,
    color: color,
  );

  @override
  TextStyle buttonText({Color? color}) => GoogleFonts.publicSans(
    fontSize: 14, // No .sp scaling for accurate showcase
    fontWeight: FontWeight.w700,
    color: color ?? Colors.white,
    height: 1, // 100% line height
    letterSpacing: 0, // 0% letter spacing
  );
}
