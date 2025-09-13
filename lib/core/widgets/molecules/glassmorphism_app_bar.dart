import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';

/// A reusable AppBar with glassmorphism back button effect.
///
/// Provides a consistent AppBar design across the application with:
/// - Glassmorphism back button with dual shadow effects
/// - Configurable title text and styling
/// - Responsive design using project's sizing system
/// - Proper theme integration
/// - Auto-route navigation integration
///
/// Example usage:
/// ```dart
/// GlassmorphismAppBar(
///   title: 'Page Title',
///   onBackPressed: () => context.router.maybePop(),
/// )
/// ```
class GlassmorphismAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a glassmorphism AppBar.
  const GlassmorphismAppBar({
    required this.title,
    this.titleStyle,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor = Colors.white,
    this.centerTitle = true,
    super.key,
  });

  /// The title text to display in the AppBar.
  final String title;

  /// Optional custom style for the title text.
  /// If null, uses theme's bodyLarge style with greyNormal color.
  final TextStyle? titleStyle;

  /// Whether to show the glassmorphism back button.
  /// Defaults to true.
  final bool showBackButton;

  /// Optional callback for back button press.
  /// If null and showBackButton is true, uses context.router.maybePop().
  final VoidCallback? onBackPressed;

  /// Background color of the AppBar.
  /// Defaults to Colors.white.
  final Color backgroundColor;

  /// Whether to center the title.
  /// Defaults to true.
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      title: Text(
        title,
        style:
            titleStyle ??
            context.textStyles.bodyLarge(
              color: context.colors.greyNormal,
            ),
        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
      ),
      leading: showBackButton ? _buildGlassmorphismBackButton(context) : null,
    );
  }

  /// Builds the glassmorphism back button with dual shadow effects.
  ///
  /// Implements the exact styling from Figma specifications:
  /// - First shadow: 0px 12px 24px -4px #919EAB1F
  /// - Second shadow: 0px 0px 2px 0px #919EAB33
  /// - Gradient background: 180deg, rgba(255, 255, 255, 0.72) 0%,
  ///   rgba(255, 255, 255, 0.8) 40%
  /// - Circular border with white opacity
  Widget _buildGlassmorphismBackButton(BuildContext context) {
    return SizedBox.expand(
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Container(
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.72),
                  Color.fromRGBO(255, 255, 255, 0.8),
                ],
                stops: [0.0, 0.4],
              ),
              shape: CircleBorder(
                side: BorderSide(
                  // Gradient border effect - using white with opacity
                  // Note: Flutter doesn't support gradient borders
                  // directly on CircleBorder
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              shadows: const [
                // First shadow: 0px 12px 24px -4px #919EAB1F
                BoxShadow(
                  color: Color(0x1F919EAB),
                  offset: Offset(0, 12),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
                // Second shadow: 0px 0px 2px 0px #919EAB33
                BoxShadow(
                  color: Color(0x33919EAB),
                  blurRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              iconSize: context.sizes.r24,
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => context.router.maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
