import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/features/authentication/presentation/widgets/login_carousel.dart';
import 'package:xp1/features/authentication/presentation/widgets/login_form.dart';

/// Modern login page with carousel and authentication form.
///
/// Features a responsive layout with informational carousel and
/// functional login form over a background image.
/// Includes keyboard-aware animation that translates the entire layout.
@RoutePage()
class LoginPage extends StatefulWidget {
  /// Creates a complete login page with carousel and form integration.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _keyboardAnimationController;
  late Animation<double> _keyboardAnimation;
  late KeyboardVisibilityController _keyboardVisibilityController;
  late StreamSubscription<bool> _keyboardSubscription;

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize keyboard animation controller
    _keyboardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create keyboard animation
    _keyboardAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _keyboardAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Initialize keyboard visibility controller
    _keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe to keyboard visibility changes
    _keyboardSubscription = _keyboardVisibilityController.onChange.listen(
      _onKeyboardVisibilityChanged,
    );
  }

  /// Handles keyboard visibility changes with proper animation.
  void _onKeyboardVisibilityChanged(bool isVisible) {
    if (!mounted) return;

    setState(() {
      _isKeyboardVisible = isVisible;
    });

    if (isVisible) {
      _keyboardAnimationController.forward();
    } else {
      _keyboardAnimationController.reverse();
    }

    if (kDebugMode) {
      print('Keyboard visibility changed: $isVisible');
    }
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    _keyboardAnimationController.dispose();
    super.dispose();
  }

  /// Calculates dynamic heights and spacing based on screen size and keyboard
  /// state.
  ({double carouselHeight, double formMinHeight, double middleSpacing})
  _calculateHeights(
    BuildContext context,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // Calculate middle spacing responsive to screen size
    // Design spec: 92px for 393x852 device
    const designHeight = 852.0;
    const designSpacing = 92.0;
    final middleSpacing = (screenHeight / designHeight) * designSpacing;

    // Available height after accounting for safe areas, keyboard, and all
    // spacing
    final availableHeight =
        screenHeight -
        safeAreaTop -
        safeAreaBottom -
        keyboardHeight -
        context.sizes.r48 - // Top spacing
        middleSpacing - // Middle spacing between carousel and form
        context.sizes.v32; // Bottom spacing

    // When keyboard is visible, prioritize form space
    if (keyboardHeight > 0) {
      return (
        carouselHeight: availableHeight * 0.20, // 20% for carousel
        formMinHeight: availableHeight * 0.80, // 80% for form
        middleSpacing: middleSpacing * 0.5, // Reduce spacing when keyboard
      );
    } else {
      // Default split based on design specs: 248px:434px ratio
      return (
        carouselHeight: availableHeight * 0.364, // 36.4% for carousel (248/682)
        formMinHeight: availableHeight * 0.636, // 63.6% for form (434/682)
        middleSpacing: middleSpacing, // Full spacing when keyboard hidden
      );
    }
  }

  double getKeyboardHeight(BuildContext context) {
    final viewInsets = EdgeInsets.fromViewPadding(
      View.of(context).viewInsets,
      View.of(context).devicePixelRatio,
    );
    return viewInsets.bottom;
  }

  @override
  Widget build(BuildContext context) {
    final heights = _calculateHeights(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Allow layout to resize when keyboard appears
      resizeToAvoidBottomInset: true,
      body: KeyboardDismissOnTap(
        child: Stack(
          children: [
            // Background image with keyboard-aware animation
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _keyboardAnimation,
                builder: (context, child) {
                  // Get keyboard height for translation calculation
                  final keyboardHeight = getKeyboardHeight(context);

                  // Calculate translation offset for background
                  final translationOffset = _isKeyboardVisible
                      ? -keyboardHeight * _keyboardAnimation.value
                      : 0.0;

                  return Transform.translate(
                    offset: Offset(0, translationOffset),
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
                  );
                },
              ),
            ),

            // Main content with keyboard-aware animation
            SafeArea(
              child: AnimatedBuilder(
                animation: _keyboardAnimation,
                builder: (context, child) {
                  // Get keyboard height for translation calculation
                  final keyboardHeight = getKeyboardHeight(context);

                  // Calculate translation offset based on keyboard height
                  // and animation. Only translate when keyboard is visible
                  final translationOffset = _isKeyboardVisible
                      ? -keyboardHeight * _keyboardAnimation.value
                      : 0.0;

                  return Transform.translate(
                    offset: Offset(0, translationOffset),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: context.sizes.r48),

                                // Carousel with dynamic height
                                SizedBox(
                                  height: heights.carouselHeight,
                                  child: const LoginCarousel(),
                                ),

                                // Middle spacing between carousel and form
                                SizedBox(height: heights.middleSpacing),

                                // Form with minimum height
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: heights.formMinHeight,
                                  ),
                                  child: const ColoredBox(
                                    color: Colors.transparent,
                                    child: LoginForm(),
                                  ),
                                ),

                                SizedBox(height: context.sizes.v32),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
