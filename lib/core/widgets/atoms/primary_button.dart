import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';

/// A reusable primary button widget with loading state and consistent styling.
///
/// This button provides sophisticated visual feedback including:
/// - Loading state with circular progress indicator
/// - Disabled state with reduced opacity
/// - Gradient background overlay
/// - Smooth animations for state changes
/// - Tap ripple effects
/// - Responsive sizing
///
/// Used across the app for primary actions like login, submit, etc.
class PrimaryButton extends StatelessWidget {
  /// Creates a primary button with consistent styling.
  ///
  /// [text] The button text to display.
  /// [onTap] Callback function when button is pressed. If null, button is
  /// disabled.
  /// [isLoading] Whether to show loading indicator instead of text.
  /// [isDisabled] Whether the button should be disabled regardless of onTap.
  const PrimaryButton({
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  /// The text displayed on the button.
  final String text;

  /// Callback function executed when button is tapped.
  /// If null, the button will be disabled.
  final VoidCallback? onTap;

  /// Whether to show loading indicator instead of text.
  /// When true, the button shows a circular progress indicator.
  final bool isLoading;

  /// Whether the button should be disabled.
  /// When true, the button is disabled regardless of onTap being null.
  final bool isDisabled;

  /// Determines if the button should be disabled based on state.
  bool get _isButtonDisabled => isDisabled || isLoading || onTap == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.sizes.r48,
      decoration: BoxDecoration(
        // 2px border with gradient (border-image-source equivalent)
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(255, 255, 255, 0.72),
            Color.fromRGBO(255, 255, 255, 0.8),
          ],
          stops: [0.0, 0.4],
        ),
        borderRadius: BorderRadius.circular(context.sizes.r8),
      ),
      child: Container(
        // Inner container with 2px padding to create border effect
        margin: EdgeInsets.all(context.sizes.r2), // 2px border width
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isButtonDisabled
                ? context.colors.blueNormal
                : context.colors.amberNormal,
            borderRadius: BorderRadius.circular(
              context.sizes.r8 - context.sizes.r2,
            ), // r8 - r2 = r6
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(
              context.sizes.r8 - context.sizes.r2,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(
                context.sizes.r8 - context.sizes.r2,
              ),
              onTap: _isButtonDisabled ? null : onTap,
              child: Container(
                width: double.infinity,
                height: context.sizes.r48 - context.sizes.r4, // r48 - r4 = r44
                padding: EdgeInsets.symmetric(
                  // r16 - r2 = r14 to account for border
                  vertical: context.sizes.r16 - context.sizes.r2,
                  horizontal: context.sizes.r12,
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          height: context.sizes.r20,
                          width: context.sizes.r20,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: context.textStyles.bodyMedium().copyWith(
                            fontWeight: FontWeight.w700,
                            color: _isButtonDisabled
                                ? Colors.white.withValues(alpha: 0.6)
                                : Colors.white,
                          ),
                          child: Text(text),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
