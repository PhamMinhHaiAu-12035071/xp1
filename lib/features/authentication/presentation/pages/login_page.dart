import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/features/authentication/presentation/widgets/login_carousel.dart';
import 'package:xp1/features/authentication/presentation/widgets/login_form.dart';

/// Modern login page with carousel and authentication form.
///
/// Features a split layout with informational carousel (60%) and
/// functional login form (40%) over a background image.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a complete login page with carousel and form integration.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              context.images.loginBackground,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: context.colors.greyLight,
                  child: Icon(
                    Icons.broken_image,
                    size: context.sizes.r48,
                    color: context.colors.greyNormal,
                  ),
                );
              },
            ),
          ),

          // Main content with carousel and login form
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: context.sizes.r48),
                // Carousel section - 60% of available space
                const Expanded(
                  flex: 5,
                  child: LoginCarousel(),
                ),

                const Expanded(child: SizedBox()),

                // Login form section - 40% of available space
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: context.sizes.r32,
                      left: context.sizes.r32,
                      right: context.sizes.r32,
                    ),
                    child: const LoginForm(),
                  ),
                ),

                SizedBox(height: context.sizes.v32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
