import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:xp1/core/themes/app_theme.dart';

import 'widgetbook.directories.g.dart';

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Skip ScreenUtil on web to avoid layout issues
    if (kIsWeb) {
      return _buildWidgetbook();
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => _buildWidgetbook(),
    );
  }

  Widget _buildWidgetbook() {
    return Widgetbook.material(
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.lightTheme()),
            WidgetbookTheme(name: 'Dark', data: AppTheme.darkTheme()),
          ],
        ),
        TextScaleAddon(
          min: 0.8,
        ),
      ],
    );
  }
}
