import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_color_extension.dart';

/// Application theme management class
abstract class AppTheme {
  /// Constructor
  factory AppTheme() => throw UnsupportedError('Cannot create instance');

  /// Initialize dark mode theme
  static ThemeData darkTheme([ThemeData? data]) => _buildAppTheme(
    themeData: data,
    extensions: [
      AppColorExtension.dark(),
    ],
    brightness: Brightness.dark,
  );

  /// Initialize light mode theme
  static ThemeData lightTheme([ThemeData? data]) => _buildAppTheme(
    themeData: data,
    extensions: [
      AppColorExtension.light(),
    ],
    brightness: Brightness.light,
  );

  /// Build theme with extensions
  static ThemeData _buildAppTheme({
    required List<ThemeExtension<dynamic>> extensions,
    required Brightness brightness,
    ThemeData? themeData,
  }) {
    final defaultTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
    );

    final theme = (themeData ?? defaultTheme).copyWith(
      extensions: extensions,
    );

    return theme;
  }
}
