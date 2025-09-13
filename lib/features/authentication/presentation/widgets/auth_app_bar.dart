import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';

/// Custom AppBar widget for authentication screens.
///
/// Provides a consistent AppBar design with left icon and center title
/// following the app's design system and responsive layout principles.
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an AuthAppBar with title and optional left icon.
  ///
  /// [title] - The title text to display in the center
  /// [leftIcon] - Optional custom left icon path (defaults to back arrow)
  /// [onLeftIconTap] - Callback when left icon is tapped
  /// [backgroundColor] - Optional background color (defaults to transparent)
  /// [elevation] - Optional elevation (defaults to 0)
  const AuthAppBar({
    required this.title,
    super.key,
    this.leftIcon,
    this.onLeftIconTap,
    this.backgroundColor,
    this.elevation = 0,
  });

  /// The title text to display in the center of the AppBar.
  final String title;

  /// Optional custom left icon path.
  /// If null, defaults to back arrow icon.
  final String? leftIcon;

  /// Callback when left icon is tapped.
  /// If null, defaults to Navigator.pop().
  final VoidCallback? onLeftIconTap;

  /// Optional background color.
  /// If null, defaults to transparent.
  final Color? backgroundColor;

  /// AppBar elevation.
  /// Defaults to 0 for flat design.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final iconService = context.iconService;
    final appIcons = context.appIcons;

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: context.textStyles.headingMedium().copyWith(
          color: context.colors.greyNormal,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: _buildLeftIcon(context, iconService, appIcons),
    );
  }

  /// Builds the left icon with proper styling and tap handling.
  Widget _buildLeftIcon(
    BuildContext context,
    dynamic iconService,
    dynamic appIcons,
  ) {
    final iconPath = leftIcon ?? (appIcons as dynamic).arrowBack;
    final onTap = onLeftIconTap ?? () => Navigator.of(context).pop();

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(context.sizes.r8),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.sizes.r8),
        onTap: onTap,
        child: Container(
          width: context.sizes.r48,
          height: context.sizes.r48,
          padding: EdgeInsets.all(context.sizes.r12),
          child: Center(
            child:
                (iconService as dynamic).svgIcon(
                      iconPath,
                      size: context.sizes.r24,
                      color: context.colors.greyNormal,
                      semanticLabel: 'Back',
                    )
                    as Widget,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
