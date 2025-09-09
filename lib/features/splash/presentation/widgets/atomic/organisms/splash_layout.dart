import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/atoms/fullscreen_container.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/atoms/orange_background.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/molecules/positioned_splash_image.dart';

/// Splash layout organism component.
///
/// This organism composes atoms and molecules to create the complete splash
/// screen layout. It combines OrangeBackground, FullScreenContainer, and
/// PositionedSplashImage molecules to recreate the original splash design
/// using atomic design principles.
class SplashLayout extends StatelessWidget {
  /// Creates a splash layout organism.
  const SplashLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final appImages = GetIt.instance<AppImages>();

    return FullScreenContainer(
      child: Stack(
        children: [
          // Orange background using atom
          const OrangeBackground(),

          // Background image positioned at 12.5% from top
          PositionedSplashImage(
            imagePath: appImages.splashBackground,
            alignment: const Alignment(
              0,
              -0.75,
            ), // 12.5% from top (75% above center)
            horizontalPadding: 0, // No horizontal padding
          ),
        ],
      ),
    );
  }
}
