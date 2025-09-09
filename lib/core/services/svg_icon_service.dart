import 'package:flutter/material.dart';

/// Abstract contract for SVG icon service following codebase pattern.
mixin SvgIconService {
  /// Displays SVG icon with responsive sizing and optional tap handling.
  Widget svgIcon(
    String assetPath, {
    double size = 24,
    Color? color,
    String? semanticLabel,
    VoidCallback? onTap,
  });
}
