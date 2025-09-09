import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive image atom component.
///
/// A basic atom that provides an image display with automatic responsive sizing
/// using ScreenUtil. This atom wraps the standard Image.asset widget with
/// responsive dimensions and error handling.
class ResponsiveImageAtom extends StatelessWidget {
  /// Creates a responsive image atom.
  ///
  /// [imagePath] The asset path to the image file.
  /// [width] Optional width that will be made responsive with .w.
  /// [height] Optional height that will be made responsive with .h.
  /// [fit] How the image should be inscribed into the box.
  /// [semanticLabel] A semantic description for accessibility.
  const ResponsiveImageAtom({
    required this.imagePath,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.semanticLabel,
  });

  /// The asset path to the image file.
  final String imagePath;

  /// Optional width that will be made responsive.
  final double? width;

  /// Optional height that will be made responsive.
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit? fit;

  /// A semantic description for accessibility.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width?.w, // Make responsive if width provided
      height: height?.h, // Make responsive if height provided
      fit: fit,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) {
        // Provide fallback error widget with responsive sizing
        return Icon(
          Icons.broken_image,
          size: width?.w ?? 24.w, // Use width if available, else default
          color: Colors.grey[400],
        );
      },
    );
  }
}
