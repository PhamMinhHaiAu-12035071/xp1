/// Design system constants following Figma specifications.
///
/// Centralizes design dimensions and UI constants to ensure consistency
/// across the application. As Linus says: "Good taste eliminates
/// special cases."
library;

import 'package:flutter/animation.dart';

/// Figma design system constants for responsive design.
///
/// These constants define the base design dimensions from Figma artboards
/// and are used by flutter_screenutil for responsive scaling across
/// different device sizes and orientations.
abstract final class DesignConstants {
  /// Base design width from Figma artboard (393px).
  ///
  /// This is the reference width used for responsive calculations.
  /// All horizontal measurements should scale relative to this value.
  static const double designWidth = 393;

  /// Base design height from Figma artboard (852px).
  ///
  /// This is the reference height used for responsive calculations.
  /// All vertical measurements should scale relative to this value.
  static const double designHeight = 852;

  /// Design aspect ratio (width/height).
  ///
  /// Calculated from the base design dimensions for responsive layouts
  /// that need to maintain proportional scaling.
  static const double designAspectRatio = designWidth / designHeight;

  /// Minimum text adaptation for flutter_screenutil.
  ///
  /// Ensures text remains readable on smaller devices by preventing
  /// excessive scaling down of text elements.
  static const bool minTextAdapt = true;

  /// Split screen adaptation for flutter_screenutil.
  ///
  /// Enables proper responsive behavior on tablets and foldable devices
  /// with split screen or multi-window modes.
  static const bool splitScreenMode = true;
}

/// Responsive breakpoint constants for adaptive layouts.
///
/// Defines standard breakpoints for responsive design patterns based on
/// Material Design guidelines and common device categories.
abstract final class ResponsiveBreakpoints {
  /// Mobile portrait breakpoint (max width: 599px).
  ///
  /// Used for phones in portrait orientation and small devices.
  static const double mobilePortrait = 599;

  /// Mobile landscape breakpoint (600px - 839px).
  ///
  /// Used for phones in landscape orientation and small tablets.
  static const double mobileLandscape = 839;

  /// Tablet breakpoint (840px - 1199px).
  ///
  /// Used for tablets in both orientations and medium-sized devices.
  static const double tablet = 1199;

  /// Desktop breakpoint (1200px and above).
  ///
  /// Used for desktop computers, large tablets, and wide displays.
  static const double desktop = 1200;

  /// Compact layout threshold.
  ///
  /// Below this width, use compact layout patterns with minimal spacing.
  static const double compactLayout = 360;
}

/// Animation and timing constants for consistent motion design.
///
/// Follows Material Design motion principles for smooth and natural
/// user interface animations throughout the application.
abstract final class AnimationConstants {
  /// Standard animation duration for most UI transitions.
  ///
  /// Used for page transitions, dialog animations, and general UI changes.
  static const Duration standardDuration = Duration(milliseconds: 300);

  /// Fast animation duration for quick feedback.
  ///
  /// Used for button presses, hover effects, and immediate responses.
  static const Duration fastDuration = Duration(milliseconds: 150);

  /// Slow animation duration for complex transitions.
  ///
  /// Used for page slides, complex transformations, and emphasis.
  static const Duration slowDuration = Duration(milliseconds: 500);

  /// Standard animation curve for natural motion.
  ///
  /// Provides smooth acceleration and deceleration for most animations.
  static const Curve standardCurve = Curves.easeInOut;

  /// Emphasis animation curve for attention-grabbing effects.
  ///
  /// Creates more pronounced motion for important state changes.
  static const Curve emphasisCurve = Curves.elasticOut;
}
