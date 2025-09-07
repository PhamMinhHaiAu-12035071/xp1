import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';

/// Theme extension with custom colors
@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  /// Creates an AppColorExtension
  const AppColorExtension({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
  });

  /// Factory to create instance for dark theme
  factory AppColorExtension.dark() {
    final colors = GetIt.I<AppColors>();
    return AppColorExtension(
      primary: colors.primaryDark,
      secondary: colors.secondaryDark,
      accent: colors.accentDark,
      textPrimary: colors.textPrimaryDark,
      textSecondary: colors.textSecondaryDark,
    );
  }

  /// Factory to create instance for light theme
  factory AppColorExtension.light() {
    final colors = GetIt.I<AppColors>();
    return AppColorExtension(
      primary: colors.primary,
      secondary: colors.secondary,
      accent: colors.accent,
      textPrimary: colors.textPrimary,
      textSecondary: colors.textSecondary,
    );
  }

  /// Primary color for the theme
  final Color primary;

  /// Secondary color for the theme
  final Color secondary;

  /// Accent color for the theme
  final Color accent;

  /// Primary text color for the theme
  final Color textPrimary;

  /// Secondary text color for the theme
  final Color textSecondary;

  @override
  ThemeExtension<AppColorExtension> copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppColorExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  ThemeExtension<AppColorExtension> lerp(
    covariant ThemeExtension<AppColorExtension>? other,
    double t,
  ) {
    if (other is! AppColorExtension) {
      return this;
    }

    return AppColorExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}
