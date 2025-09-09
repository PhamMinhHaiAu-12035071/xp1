import 'package:flutter/material.dart';

/// Abstract contract for asset image service following codebase pattern.
///
/// Simple single-method interface following KISS principle.
// ignore: one_member_abstracts
abstract class AssetImageService {
  /// Displays asset image with responsive sizing and error handling.
  Widget assetImage(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
  });
}
