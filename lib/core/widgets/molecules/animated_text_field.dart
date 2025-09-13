import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';

/// Configuration for an animated text field.
class AnimatedTextFieldConfig {
  /// Creates a configuration for an animated text field.
  const AnimatedTextFieldConfig({
    required this.controller,
    required this.focusNode,
    required this.animationController,
    required this.animation,
    required this.prefixIcon,
    required this.label,
    required this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onChanged,
  });

  /// Controller for the text field.
  final TextEditingController controller;

  /// Focus node for the text field.
  final FocusNode focusNode;

  /// Animation controller for border animation.
  final AnimationController animationController;

  /// Animation for the border effect.
  final Animation<double> animation;

  /// Widget to display as prefix icon.
  final Widget prefixIcon;

  /// Label text for the field.
  final String label;

  /// Whether to obscure text (for passwords).
  final bool obscureText;

  /// Optional suffix icon widget.
  final Widget? suffixIcon;

  /// Keyboard type for the input.
  final TextInputType keyboardType;

  /// Text input action for the field.
  final TextInputAction textInputAction;

  /// Callback when field is submitted.
  final void Function(String)? onFieldSubmitted;

  /// Callback when text changes.
  final void Function(String)? onChanged;
}

/// Utility class for creating animated paths.
///
/// Based on the implementation from https://github.com/mahdices/flutter_animated_textfield
/// Provides methods to extract portions of a path for smooth animations.
class _PathAnimationUtils {
  /// Creates an animated path that progresses based on animation percentage.
  ///
  /// [originalPath] The complete path to animate.
  /// [animationPercent] Progress from 0.0 to 1.0.
  static Path createAnimatedPath(Path originalPath, double animationPercent) {
    // ComputeMetrics can only be iterated once!
    final totalLength = originalPath.computeMetrics().fold<double>(
      0,
      (double prev, ui.PathMetric metric) => prev + metric.length,
    );

    final currentLength = totalLength * animationPercent;

    return _extractPathUntilLength(originalPath, currentLength);
  }

  /// Extracts a portion of the path up to the specified length.
  ///
  /// [originalPath] The complete path to extract from.
  /// [length] The length to extract up to.
  static Path _extractPathUntilLength(Path originalPath, double length) {
    var currentLength = 0.0;
    final path = Path();
    final metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      final nextLength = currentLength + metric.length;
      final isLastSegment = nextLength > length;

      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0, remainingLength);
        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        final pathSegment = metric.extractPath(0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }
}

/// Custom painter for animated border effect on TextField.
///
/// Creates a smooth border fill animation using split paths (top and bottom).
/// Based on the implementation from https://github.com/mahdices/flutter_animated_textfield
/// Used to provide modern visual feedback when user interacts with input
/// fields.
class _CustomAnimatedBorderPainter extends CustomPainter {
  /// Creates a custom animated border painter.
  ///
  /// [animationPercent] Controls the animation progress from 0.0 to 1.0.
  /// [borderColor] The color of the animated border.
  /// [borderRadius] The border radius for rounded corners.
  const _CustomAnimatedBorderPainter({
    required this.animationPercent,
    required this.borderColor,
    required this.borderRadius,
  });

  /// Animation progress from 0.0 (no border) to 1.0 (full border).
  final double animationPercent;

  /// Color of the animated border.
  final Color borderColor;

  /// Border radius for rounded corners.
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = borderColor
      ..style = PaintingStyle.stroke;

    // Create top half path (left center -> top edge -> right center)
    final topPath = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(0, borderRadius)
      ..quadraticBezierTo(0, 0, borderRadius, 0)
      ..lineTo(size.width - borderRadius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, borderRadius)
      ..lineTo(size.width, size.height / 2);

    // Create bottom half path (left center -> bottom edge -> right center)
    final bottomPath = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(0, size.height - borderRadius)
      ..quadraticBezierTo(0, size.height, borderRadius, size.height)
      ..lineTo(size.width - borderRadius, size.height)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width,
        size.height - borderRadius,
      )
      ..lineTo(size.width, size.height / 2);

    // Create animated paths using utility function
    final animatedTopPath = _PathAnimationUtils.createAnimatedPath(
      topPath,
      animationPercent,
    );
    final animatedBottomPath = _PathAnimationUtils.createAnimatedPath(
      bottomPath,
      animationPercent,
    );

    // Draw both animated paths
    canvas
      ..drawPath(animatedTopPath, paint)
      ..drawPath(animatedBottomPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CustomAnimatedBorderPainter oldDelegate) {
    return animationPercent != oldDelegate.animationPercent ||
        borderColor != oldDelegate.borderColor ||
        borderRadius != oldDelegate.borderRadius;
  }
}

/// Reusable animated text field with modern design and focus animations.
///
/// Provides a unified text input experience with:
/// - Smooth border animation on focus
/// - Floating label animation
/// - Consistent styling and theming
/// - Support for prefix and suffix icons
/// - Loading state handling
/// - Platform-optimized rendering
class AnimatedTextField extends StatefulWidget {
  /// Creates an animated text field.
  const AnimatedTextField({
    required this.config,
    required this.isLoading,
    super.key,
  });

  /// Configuration for the text field including controllers and styling.
  final AnimatedTextFieldConfig config;

  /// Whether the field should be in loading state (disabled).
  final bool isLoading;

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  bool _hasSubmitted = false;

  /// Calculates precise left position for label alignment using LayoutBuilder.
  ///
  /// This method ensures the label is perfectly aligned with the text input
  /// by using LayoutBuilder to measure the actual prefix icon dimensions
  /// and calculate the exact position.
  ///
  /// [prefixIconWidth] The actual measured width of the prefix icon.
  /// Returns the calculated left position for the label.
  double _calculateLabelLeftPosition(double prefixIconWidth) {
    // Base calculation: prefix icon width + content padding + small offset
    final basePosition = prefixIconWidth + context.sizes.r16 + context.sizes.r4;

    // Platform-specific adjustments
    if (kIsWeb) {
      // Web platform may need different offset for better alignment
      // Reduce the offset slightly for web
      return basePosition - context.sizes.r2;
    } else {
      // Mobile platforms (Android, iOS)
      return basePosition;
    }
  }

  /// Measures the prefix icon width using calculated dimensions.
  ///
  /// This method calculates the prefix icon width based on its known
  /// dimensions: padding (r12) + icon size (r8) + padding (r12) = r32.
  /// This approach is more reliable than GlobalKey measurement across
  /// different platforms.
  double _measurePrefixIconWidth() {
    // Base calculation: padding (r12) + icon size (r8) + padding (r12) = r32
    final baseWidth = context.sizes.r12 + context.sizes.r8 + context.sizes.r12;

    // Platform-specific adjustments
    if (kIsWeb) {
      // Web platform may have different rendering, adjust accordingly
      // Reduce the width slightly for better alignment on web
      return baseWidth - context.sizes.r8;
    } else {
      // Mobile platforms (Android, iOS)
      return baseWidth;
    }
  }

  /// Creates consistent container decoration for input fields.
  BoxDecoration _createFieldDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(context.sizes.r8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14919EAB),
          offset: Offset(0, 8),
          blurRadius: 32,
          spreadRadius: 2,
        ),
        BoxShadow(color: Color(0x1F919EAB), blurRadius: 2),
      ],
    );
  }

  /// Creates consistent input decoration for text fields.
  InputDecoration _createInputDecoration(
    Widget prefixIcon, [
    Widget? suffixIcon,
  ]) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon != null
          ? Padding(
              padding: EdgeInsets.all(context.sizes.r12),
              child: suffixIcon,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.sizes.r8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.sizes.r8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.sizes.r8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      contentPadding: EdgeInsets.fromLTRB(
        context.sizes.r16, // left
        context.sizes.r24, // top - more space for label
        context.sizes.r16, // right
        context.sizes.r12, // bottom - less space to push text further down
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.sizes.r48,
      decoration: _createFieldDecoration(),
      child: AnimatedBuilder(
        animation: widget.config.animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Border animation layer (behind)
              Positioned.fill(
                child: CustomPaint(
                  painter: _CustomAnimatedBorderPainter(
                    animationPercent: widget.config.animation.value,
                    borderColor: context.colors.amberNormal,
                    borderRadius: context.sizes.r8,
                  ),
                ),
              ),
              // TextField layer without label
              TextFormField(
                controller: widget.config.controller,
                focusNode: widget.config.focusNode,
                enabled: !widget.isLoading,
                obscureText: widget.config.obscureText,
                keyboardType: widget.config.keyboardType,
                textInputAction: widget.config.textInputAction,
                textAlignVertical: TextAlignVertical.bottom,
                onFieldSubmitted: widget.config.onFieldSubmitted,
                onChanged: (value) {
                  // Clear submit state when user types to hide errors
                  if (_hasSubmitted) {
                    setState(() => _hasSubmitted = false);
                  }
                  // Call the specific field's onChanged callback
                  widget.config.onChanged?.call(value);
                },
                decoration: _createInputDecoration(
                  widget.config.prefixIcon,
                  widget.config.suffixIcon,
                ),
                style:
                    (widget.config.focusNode.hasFocus ||
                        widget.config.controller.text.isNotEmpty)
                    ? context.textStyles.bodyMedium().copyWith(
                        color: context.colors.greyNormal,
                      )
                    : context.textStyles.bodyMedium().copyWith(
                        color: context.colors.blueNormal,
                      ),
              ),
              // Custom positioned label with calculated alignment
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: _calculateLabelLeftPosition(_measurePrefixIconWidth()),
                top:
                    (widget.config.focusNode.hasFocus ||
                        widget.config.controller.text.isNotEmpty)
                    ? context.sizes.r4
                    : context.sizes.r16,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style:
                      (widget.config.focusNode.hasFocus ||
                          widget.config.controller.text.isNotEmpty)
                      ? context.textStyles.bodySmall().copyWith(
                          color: context.colors.amberNormal,
                          fontWeight: FontWeight.w300,
                        )
                      : context.textStyles.bodyMedium().copyWith(
                          color: context.colors.blueNormal,
                          fontWeight: FontWeight.w500,
                        ),
                  child: Text(widget.config.label),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
