import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/core/services/svg_icon_service.dart';

/// Minimal implementation to pass GREEN tests.
@LazySingleton(as: SvgIconService)
class SvgIconServiceImpl implements SvgIconService {
  /// Creates SVG icon service implementation.
  const SvgIconServiceImpl();

  @override
  Widget svgIcon(
    String assetPath, {
    double size = 24,
    Color? color,
    String? semanticLabel,
    VoidCallback? onTap,
  }) {
    // Minimal implementation - just enough to pass tests
    Widget svg = SvgPicture.asset(
      assetPath,
      width: size.w,
      height: size.w,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticLabel,
      placeholderBuilder: (_) => SizedBox(
        width: size.w,
        height: size.w,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    );

    if (onTap != null) {
      svg = GestureDetector(onTap: onTap, child: svg);
    }

    return svg;
  }
}
