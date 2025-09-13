import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/assets/app_icons.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/core/services/svg_icon_service.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';

/// Elegant BuildContext extension for clean DI access
/// Eliminates verbose GetIt.I`<T>`() calls throughout widgets
extension AppThemeContext on BuildContext {
  /// Access to responsive sizes
  AppSizes get sizes => GetIt.I<AppSizes>();

  /// Access to application colors
  AppColors get colors => GetIt.I<AppColors>();

  /// Access to text styles
  AppTextStyles get textStyles => GetIt.I<AppTextStyles>();

  /// Access to image assets
  AppImages get images => GetIt.I<AppImages>();

  /// Access to SVG icon rendering service
  SvgIconService get iconService => GetIt.I<SvgIconService>();

  /// Access to application icons
  AppIcons get appIcons => GetIt.I<AppIcons>();
}
