import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/features/authentication/presentation/widgets/login_carousel.dart';

/// Clean login page with simple carousel integration.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a minimal carousel-focused login page.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          // Tap anywhere to proceed to main app
          context.router.replaceAll([const MainWrapperRoute()]);
        },
        child: Stack(
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

            // Carousel content
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: context.sizes.r32),

                  // Simple carousel - no complexity
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.sizes.r64,
                        horizontal: context.sizes.r64,
                      ),
                      child: const LoginCarousel(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
