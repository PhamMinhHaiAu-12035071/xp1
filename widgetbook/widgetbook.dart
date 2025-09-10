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
        // 📱 DEVICE FRAME ADDON - Multi-Device Testing
        // ignore: deprecated_member_use
        DeviceFrameAddon(
          devices: [
            // === MOBILE DEVICES ===
            Devices.ios.iPhone13,
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone12ProMax,

            // === ANDROID DEVICES ===
            DeviceInfo.genericPhone(
              id: 'design-size',
              name: 'Design Size',
              platform: TargetPlatform.android,
              screenSize: const Size(393, 852),
            ),

            // === TABLETS ===
            Devices.ios.iPadAir4,
            Devices.ios.iPadPro11Inches,

            // === DESKTOP ===
            Devices.macOS.macBookPro,
          ],
          initialDevice: Devices.ios.iPhone13,
        ),

        // 🎨 THEME ADDON - Light/Dark Mode
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.lightTheme()),
            WidgetbookTheme(name: 'Dark', data: AppTheme.darkTheme()),
          ],
        ),

        // 📏 TEXT SCALE ADDON - Accessibility Testing
        TextScaleAddon(
          min: 0.8,
        ),

        // 📐 ALIGNMENT ADDON - Widget Positioning
        AlignmentAddon(),

        // 🎛️ INSPECTOR ADDON - Widget Debug Info (Disabled for cleaner UI)
        InspectorAddon(),

        // 📐 GRID ADDON - Layout Guidelines
        GridAddon(),

        // ⏰ TIME DILATION ADDON - Animation Speed Control
        TimeDilationAddon(),

        // 🔧 ACCESSIBILITY - Use accessibility_tools package directly
        // Note: AccessibilityAddon is deprecated. Use BuilderAddon with
        // accessibility_tools package for accessibility testing
      ],
    );
  }
}
