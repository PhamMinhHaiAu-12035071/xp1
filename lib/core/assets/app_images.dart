/// Abstract contract for image asset paths following codebase DI pattern.
///
/// This abstract class enables dependency injection and mocking in tests,
/// following the same pattern as AppSizes for 100% test coverage.
abstract class AppImages {
  // Splash Assets
  /// Splash screen logo image path
  String get splashLogo;

  /// Splash screen background image path
  String get splashBackground;

  // Login Assets
  /// Login screen logo image path
  String get loginLogo;

  /// Login screen background image path
  String get loginBackground;

  // Login Carousel Assets - REQUIRED for type-safe access
  /// Login carousel slide 1 image path
  String get loginCarouselSlide1;

  /// Login carousel slide 2 image path
  String get loginCarouselSlide2;

  /// Login carousel slide 3 image path
  String get loginCarouselSlide3;

  // Employee Assets
  /// Default employee avatar image path
  String get employeeAvatar;

  /// Employee badge image path
  String get employeeBadge;

  // Critical assets for preloading
  /// List of critical image paths for preloading
  List<String> get criticalAssets;

  /// Standard image size constants for consistency
  ImageSizeConstants get imageSizes;
}

/// Image size constants for consistent sizing
class ImageSizeConstants {
  /// Creates image size constants
  const ImageSizeConstants();

  /// Small image size (48 pixels)
  double get small => 48;

  /// Medium image size (96 pixels)
  double get medium => 96;

  /// Large image size (144 pixels)
  double get large => 144;

  /// Extra large image size (192 pixels)
  double get xLarge => 192;
}
