import 'package:flutter/material.dart';

/// Defines standard text style contracts for the application.
///
/// Implements the typography system based on design specifications with
/// Public Sans font family and consistent scaling. All text styles use
/// font weight 400 (Regular), line height 120%, and letter spacing 0%.
abstract class AppTextStyles {
  /// Display Large typography style (36px).
  ///
  /// Used for hero text, main page titles, and prominent call-to-action text.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle displayLarge({Color? color});

  /// Display Medium typography style (32px).
  ///
  /// Used for section headings and important announcements.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle displayMedium({Color? color});

  /// Heading Large typography style (24px).
  ///
  /// Used for page titles and major section headers.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle headingLarge({Color? color});

  /// Heading Medium typography style (20px).
  ///
  /// Used for subsection headings and card titles.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle headingMedium({Color? color});

  /// Body Large typography style (16px).
  ///
  /// Used for primary body text, paragraphs, and main content.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle bodyLarge({Color? color});

  /// Body Medium typography style (14px).
  ///
  /// Used for secondary text, descriptions, and supporting content.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle bodyMedium({Color? color});

  /// Body Small typography style (12px).
  ///
  /// Used for small text, metadata, and less important information.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle bodySmall({Color? color});

  /// Caption typography style (10px).
  ///
  /// Used for fine print, legal text, and minimal labels.
  /// Uses Public Sans Regular with 120% line height.
  ///
  /// [color] Optional text color to override the default.
  TextStyle caption({Color? color});

  /// Button text typography style (14px).
  ///
  /// Used for button text with bold weight and 100% line height.
  /// Uses Public Sans Bold (700) with 0% letter spacing.
  ///
  /// [color] Optional text color to override the default (defaults to white).
  TextStyle buttonText({Color? color});
}
