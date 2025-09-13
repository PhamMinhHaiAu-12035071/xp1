import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xp1/core/constants/design_constants.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/atoms/responsive_image_atom.dart';

/// Positioned splash image molecule component with design ratio constraints.
///
/// A molecule that combines positioning logic with responsive image display
/// while maintaining the exact design proportions. This molecule composes an
/// Align widget with Padding and ResponsiveImageAtom to create positioned
/// splash screen images with responsive padding and consistent ratio.
///
/// The image width is constrained to maintain the design ratio of 247px based
/// on the design screen width for consistent proportions across all devices.
class PositionedSplashImage extends StatelessWidget {
  /// Creates a positioned splash image molecule with design ratio constraints.
  ///
  /// [imagePath] The asset path to the image file.
  /// [alignment] The alignment within the parent container.
  /// [horizontalPadding] Horizontal padding value that will be made responsive.
  const PositionedSplashImage({
    required this.imagePath,
    required this.alignment,
    required this.horizontalPadding,
    super.key,
  });

  /// The asset path to the image file.
  final String imagePath;

  /// The alignment within the parent container.
  final Alignment alignment;

  /// Horizontal padding value that will be made responsive.
  final double horizontalPadding;

  /// Design ratio constant based on design specifications.
  ///
  /// Calculated as 247px (image width) / DesignConstants.designWidth = 0.6285
  /// This ensures consistent proportions across all device sizes.
  static const double _designImageRatio = 247 / DesignConstants.designWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding.r),
        child: SizedBox(
          // Apply design ratio constraint to maintain consistent proportions
          // across all iPhone and iPad devices
          width: 1.sw,
          child: Transform.scale(
            scale: _designImageRatio, // Use calculated design ratio
            child: ResponsiveImageAtom(
              imagePath: imagePath,
              fit: BoxFit.contain,
              // Image auto-sizes to fit within the ratio-constrained container
            ),
          ),
        ),
      ),
    );
  }
}
