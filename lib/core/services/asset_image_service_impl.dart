import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/core/services/asset_image_service.dart';

/// Pure Flutter implementation using built-in capabilities.
///
/// Uses Image.asset() + ImageCache + flutter_screenutil for optimal
/// asset management without external dependencies.
@LazySingleton(as: AssetImageService)
class AssetImageServiceImpl implements AssetImageService {
  /// Creates asset image service implementation.
  const AssetImageServiceImpl();

  @override
  Widget assetImage(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // Responsive sizing using ScreenUtil
    final safeWidth = _safeResponsiveWidth(width);
    final safeHeight = _safeResponsiveHeight(height);

    // Pure Flutter implementation with built-in optimizations
    return Image.asset(
      imagePath,
      width: safeWidth,
      height: safeHeight,
      fit: fit,
      // Built-in error handling
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ??
          Icon(
            Icons.broken_image,
            size: safeWidth ?? safeHeight ?? 24,
            color: Colors.grey[400],
          ),
      // Built-in loading states
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return placeholder ??
            SizedBox(
              width: safeWidth ?? 24,
              height: safeHeight ?? 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey[600],
              ),
            );
      },
      // Automatic caching via built-in ImageCache
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }

  /// Applies responsive width using ScreenUtil
  double? _safeResponsiveWidth(double? value) {
    if (value == null) return null;
    return value.w;
  }

  /// Applies responsive height using ScreenUtil
  double? _safeResponsiveHeight(double? value) {
    if (value == null) return null;
    return value.h;
  }
}
