import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/assets/app_icons.dart';
import 'package:xp1/core/assets/app_icons_impl.dart';
import 'package:xp1/core/services/svg_icon_service.dart';
import 'package:xp1/core/services/svg_icon_service_impl.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/sizes/app_sizes_impl.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/app_text_styles_impl.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';

import 'widgetbook_text_styles.dart';

/// Widgetbook-specific DI setup with design system services only.
/// Excludes environment-specific services (APIs, locale, etc.)
///
/// Uses platform-appropriate text styles:
/// - Web: WidgetbookTextStyles (exact pixels, no ScreenUtil dependency)
/// - Mobile: AppTextStylesImpl (responsive scaling with ScreenUtil)
Future<void> configureWidgetbookDependencies() async {
  GetIt.instance
    ..registerLazySingleton<AppTextStyles>(
      () => kIsWeb ? const WidgetbookTextStyles() : const AppTextStylesImpl(),
    )
    ..registerLazySingleton<AppColors>(() => const AppColorsImpl())
    ..registerLazySingleton<AppSizes>(() => const AppSizesImpl())
    ..registerLazySingleton<AppIcons>(() => const AppIconsImpl())
    ..registerLazySingleton<SvgIconService>(() => const SvgIconServiceImpl());
}

/// Initialize Widgetbook with proper setup
Future<void> initWidgetbook() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureWidgetbookDependencies();

  // Initialize ScreenUtil for responsive design (mobile only)
  // Web skips ScreenUtil to avoid initialization issues
  if (!kIsWeb) {
    await ScreenUtil.ensureScreenSize();
  }
}
