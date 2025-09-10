import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';

/// Configuration constants for login carousel.
///
/// Centralized configuration following Single Responsibility principle.
/// Uses type-safe image access through AppImages service to prevent typos.
///
/// Uses Dart 3+ abstract final class pattern for better testability
/// and 100% coverage.
abstract final class LoginCarouselConfig {
  /// Gets default carousel images from AppImages service.
  ///
  /// This uses the type-safe image access pattern to prevent spelling errors
  /// and ensures images are properly managed through the asset system.
  static List<String> getDefaultImages(BuildContext context) => [
    context.images.loginCarouselSlide1,
    context.images.loginCarouselSlide2,
    context.images.loginCarouselSlide3,
  ];

  /// Default auto-play interval.
  static const Duration defaultAutoPlayInterval = Duration(seconds: 3);

  /// Page transition animation duration.
  static const Duration animationDuration = Duration(milliseconds: 350);

  /// Animation curve for smooth transitions.
  static const Curve animationCurve = Curves.easeInOut;

  /// Fade animation duration for advanced customization.
  static const Duration fadeAnimationDuration = Duration(milliseconds: 500);

  /// Fade in curve for smooth appearance.
  static const Curve fadeInCurve = Curves.easeIn;

  /// Fade out curve for smooth disappearance.
  static const Curve fadeOutCurve = Curves.easeOut;

  /// Maximum visible dots in indicator.
  static const int maxVisibleDots = 5;

  /// Active dot scale factor.
  static const double activeDotScale = 1.3;

  /// Active dot stroke width.
  static const double activeStrokeWidth = 2;
}
