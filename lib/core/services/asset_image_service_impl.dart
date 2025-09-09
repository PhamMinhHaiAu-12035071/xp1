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
    // Pure Flutter implementation with built-in optimizations
    return Image.asset(
      imagePath,
      width: width?.w, // Responsive sizing via ScreenUtil
      height: height?.h,
      fit: fit,
      // Built-in error handling
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ??
          Icon(
            Icons.broken_image,
            size: width?.w ?? height?.h ?? 24.w,
            color: Colors.grey[400],
          ),
      // Built-in loading states
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return placeholder ??
            SizedBox(
              width: width?.w ?? 24.w,
              height: height?.h ?? 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: Colors.grey[600],
              ),
            );
      },
      // Automatic caching via built-in ImageCache
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }
}
