import 'dart:async';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:xp1/core/constants/design_constants.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/features/authentication/presentation/widgets/login_carousel.dart';
import 'package:xp1/features/authentication/presentation/widgets/login_form.dart'
    show LoginForm;

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

  late AnimationController _entranceAnimationController;
  late Animation<double> _slideAnimation1;
  late Animation<double> _slideAnimation2;
  late Animation<double> _slideAnimation3;
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;
  late Animation<double> _fadeAnimation3;

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

    // Initialize entrance animation controller for orange curved elements
    _entranceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered slide animations for each element
    _slideAnimation1 =
        Tween<double>(
          begin: -1, // Start from left/top outside
          end: 0, // End at normal position
        ).animate(
          CurvedAnimation(
            parent: _entranceAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _slideAnimation2 =
        Tween<double>(
          begin: 1, // Start from right outside
          end: 0, // End at normal position
        ).animate(
          CurvedAnimation(
            parent: _entranceAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _slideAnimation3 =
        Tween<double>(
          begin: -1, // Start from left/bottom outside
          end: 0, // End at normal position
        ).animate(
          CurvedAnimation(
            parent: _entranceAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Create staggered fade animations for each element
    _fadeAnimation1 =
        Tween<double>(
          begin: 0, // Start transparent
          end: 1, // End opaque
        ).animate(
          CurvedAnimation(
            parent: _entranceAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _fadeAnimation2 =
        Tween<double>(
          begin: 0, // Start transparent
          end: 1, // End opaque
        ).animate(
          CurvedAnimation(
            parent: _entranceAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _fadeAnimation3 =
        Tween<double>(
          begin: 0, // Start transparent
          end: 1, // End opaque
        ).animate(
          CurvedAnimation(
            parent: _entranceAnimationController,
            curve: Curves.easeOut,
          ),
        );

    // Start entrance animation immediately when page loads
    _entranceAnimationController.forward();
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
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    _keyboardAnimationController.dispose();
    _entranceAnimationController.dispose();
    super.dispose();
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
    final screenWidth = MediaQuery.of(context).size.width;
    const designWidth = 393;
    final scaleFactor = screenWidth / designWidth;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true, // Extend body behind bottom navigation
      resizeToAvoidBottomInset: true,
      body: KeyboardDismissOnTap(
        child: Stack(
          children: [
            // Lớp background phủ toàn màn hình, kể cả status bar
            Positioned.fill(
              child: Container(
                color: context.colors.orangeLight,
              ),
            ),

            /// Render SVG Orange Curved with entrance animation
            AnimatedBuilder(
              animation: _entranceAnimationController,
              builder: (context, child) {
                // Tính lại công thức theo tỉ lệ
                const orangeCurvedWidth = 207.0; // width của SVG gốc
                const orangeCurvedHeight = 184.0; // height của SVG gốc
                final scaledOrangeCurvedWidth = orangeCurvedWidth * scaleFactor;
                final scaledOrangeCurvedHeight =
                    orangeCurvedHeight * scaleFactor;
                final translateX = -0.8 * scaledOrangeCurvedWidth;
                final translateY = -0.3 * scaledOrangeCurvedHeight;

                // Add entrance animation offsets
                final animatedTranslateX =
                    translateX +
                    (_slideAnimation1.value * scaledOrangeCurvedWidth);
                final animatedTranslateY =
                    translateY +
                    (_slideAnimation1.value * scaledOrangeCurvedHeight);

                return Positioned(
                  left: 0,
                  top: 0,
                  child: Transform.translate(
                    offset: Offset(animatedTranslateX, animatedTranslateY),
                    child: Opacity(
                      opacity: _fadeAnimation1.value,
                      child: const _LoginTopLeftAccent(),
                    ),
                  ),
                );
              },
            ),

            /// Render New Curved Layout with entrance animation
            AnimatedBuilder(
              animation: _entranceAnimationController,
              builder: (context, child) {
                const orangeCurvedWidth = 313.0; // width của SVG gốc
                const orangeCurvedHeight = 443.0; // height của SVG gốc
                final scaledOrangeCurvedWidth = orangeCurvedWidth * scaleFactor;
                final scaledOrangeCurvedHeight =
                    orangeCurvedHeight * scaleFactor;
                final translateX = 0.9 * scaledOrangeCurvedWidth;
                final translateY = -0.3 * scaledOrangeCurvedHeight;

                // Add entrance animation offsets (from right)
                final animatedTranslateX =
                    translateX +
                    (_slideAnimation2.value * scaledOrangeCurvedWidth);
                final animatedTranslateY =
                    translateY +
                    (_slideAnimation2.value * scaledOrangeCurvedHeight * 0.2);

                return Positioned(
                  right: 0,
                  top: 0,
                  child: Transform.translate(
                    offset: Offset(animatedTranslateX, animatedTranslateY),
                    child: Opacity(
                      opacity: _fadeAnimation2.value,
                      child: const _LoginTopRightAccent(),
                    ),
                  ),
                );
              },
            ),

            /// Render Final Curved Layout with entrance animation
            AnimatedBuilder(
              animation: _entranceAnimationController,
              builder: (context, child) {
                const finalCurvedWidth = 192.0; // width của SVG gốc
                const finalCurvedHeight = 273.0; // height của SVG gốc
                final scaledFinalCurvedWidth = finalCurvedWidth * scaleFactor;
                final scaledFinalCurvedHeight = finalCurvedHeight * scaleFactor;
                final translateX = -0.5 * scaledFinalCurvedWidth;
                final translateY = 0.8 * scaledFinalCurvedHeight;

                // Add entrance animation offsets (from left/bottom)
                final animatedTranslateX =
                    translateX +
                    (_slideAnimation3.value * scaledFinalCurvedWidth);
                final animatedTranslateY =
                    translateY -
                    (_slideAnimation3.value * scaledFinalCurvedHeight * 0.3);

                return Positioned(
                  left: 0,
                  top: 0,
                  child: Transform.translate(
                    offset: Offset(animatedTranslateX, animatedTranslateY),
                    child: Opacity(
                      opacity: _fadeAnimation3.value,
                      child: const _LoginCenterLeftAccent(),
                    ),
                  ),
                );
              },
            ),

            // Main content với SafeArea và keyboard animation
            SafeArea(
              child: AnimatedBuilder(
                animation: _keyboardAnimation,
                builder: (context, child) {
                  // Get keyboard height for translation calculation
                  final keyboardHeight = getKeyboardHeight(context);

                  // Calculate translation offset when keyboard is visible
                  final translationOffset = _isKeyboardVisible
                      ? -keyboardHeight * _keyboardAnimation.value * 0.8
                      : 0.0;

                  return Transform.translate(
                    offset: Offset(0, translationOffset),
                    child: const Column(
                      children: [
                        /// Spacer Top
                        Flexible(flex: 22, child: SizedBox.expand()),

                        /// Carousel
                        Expanded(flex: 295, child: LoginCarousel()),

                        /// Spacer Middle
                        Flexible(flex: 70, child: SizedBox.expand()),

                        /// Spacer Bottom
                        Flexible(flex: 36, child: SizedBox.expand()),

                        /// Login Form
                        Expanded(
                          flex: 511,
                          child: _LoginFormLayout(),
                        ),
                        Flexible(flex: 36, child: SizedBox.expand()),
                      ],
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

class _LoginFormLayout extends StatelessWidget {
  const _LoginFormLayout();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / DesignConstants.designWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Apply responsive scaling similar to curved elements
        const baseFormWidth = 369.0; // Base form width from design
        const baseFormHeight = 434.0; // Base form height from design

        final scaledFormWidth = baseFormWidth * scaleFactor;
        final scaledFormHeight = baseFormHeight * scaleFactor;

        return Transform.translate(
          offset: Offset((screenWidth - scaledFormWidth) * 0.06 * -1, 0),
          child: Stack(
            clipBehavior: Clip.none, // Allow children to overflow
            children: [
              CustomPaint(
                size: Size(scaledFormWidth, scaledFormHeight),
                painter: _LoginFormPainter(),
              ),
              // Center logo positioned at top-center with responsive scaling
              Positioned(
                top: -30 * scaleFactor, // Position above the form background
                left: scaledFormWidth / 2 - (76 * scaleFactor) / 2,
                child: const _LoginCenterLogo(),
              ),

              // Login form positioned to match the form background
              Positioned(
                top: 0,
                left: 0,
                width: scaledFormWidth,
                height: scaledFormHeight,
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: (76 * scaleFactor * 0.5) + 12,
                      left: context.sizes.r20,
                      right: context.sizes.r20,
                    ),
                    child: const LoginForm(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Top-left decorative accent for login screen.
///
/// Uses SvgIconService to render SVG from external asset file
/// with responsive scaling based on design screen size (393x852).
class _LoginTopLeftAccent extends StatelessWidget {
  const _LoginTopLeftAccent();

  @override
  Widget build(BuildContext context) {
    final iconService = context.iconService;
    final appIcons = context.appIcons;
    final screenWidth = MediaQuery.of(context).size.width;

    const designElementWidth = 207.0; // Element width in design
    const designElementHeight = 184.0; // Element height in design

    // Calculate responsive scaling factor
    final scaleFactor = screenWidth / DesignConstants.designWidth;
    final responsiveWidth = designElementWidth * scaleFactor;
    final responsiveHeight = designElementHeight * scaleFactor;

    return SizedBox(
      width: responsiveWidth,
      height: responsiveHeight,
      child: iconService.svgIcon(
        appIcons.loginTopLeftAccent,
        size: responsiveWidth,
      ),
    );
  }
}

/// Top-right decorative accent for login screen.
///
/// Uses SvgIconService to render SVG from external asset file
/// with responsive scaling based on design screen size (393x852).
class _LoginTopRightAccent extends StatelessWidget {
  const _LoginTopRightAccent();

  @override
  Widget build(BuildContext context) {
    final iconService = context.iconService;
    final appIcons = context.appIcons;
    final screenWidth = MediaQuery.of(context).size.width;

    const designElementWidth = 313.0; // Element width in design
    const designElementHeight = 443.0; // Element height in design

    // Calculate responsive scaling factor
    final scaleFactor = screenWidth / DesignConstants.designWidth;
    final responsiveWidth = designElementWidth * scaleFactor;
    final responsiveHeight = designElementHeight * scaleFactor;

    return SizedBox(
      width: responsiveWidth,
      height: responsiveHeight,
      child: iconService.svgIcon(
        appIcons.loginTopRightAccent,
        size: responsiveWidth,
      ),
    );
  }
}

/// Center-left decorative accent for login screen.
///
/// Uses SvgIconService to render SVG from external asset file
/// with responsive scaling based on design screen size (393x852).
class _LoginCenterLeftAccent extends StatelessWidget {
  const _LoginCenterLeftAccent();

  @override
  Widget build(BuildContext context) {
    final iconService = context.iconService;
    final appIcons = context.appIcons;
    final screenWidth = MediaQuery.of(context).size.width;

    const designElementWidth = 192.0; // Element width in design
    const designElementHeight = 273.0; // Element height in design

    // Calculate responsive scaling factor
    final scaleFactor = screenWidth / DesignConstants.designWidth;
    final responsiveWidth = designElementWidth * scaleFactor;
    final responsiveHeight = designElementHeight * scaleFactor;

    return SizedBox(
      width: responsiveWidth,
      height: responsiveHeight,
      child: iconService.svgIcon(
        appIcons.loginCenterLeftAccent,
        size: responsiveWidth,
      ),
    );
  }
}

/// Center logo decorative element for login screen.
///
/// Uses SvgIconService to render SVG from external asset file
/// with responsive scaling based on design screen size (393x852).
class _LoginCenterLogo extends StatelessWidget {
  const _LoginCenterLogo();

  @override
  Widget build(BuildContext context) {
    final iconService = context.iconService;
    final appIcons = context.appIcons;
    final screenWidth = MediaQuery.of(context).size.width;

    const designElementWidth = 76.0; // Element width in design
    const designElementHeight = 76.0; // Element height in design

    // Calculate responsive scaling factor
    final scaleFactor = screenWidth / DesignConstants.designWidth;
    final responsiveWidth = designElementWidth * scaleFactor;
    final responsiveHeight = designElementHeight * scaleFactor;

    return SizedBox(
      width: responsiveWidth,
      height: responsiveHeight,
      child: iconService.svgIcon(
        appIcons.loginCenterLogo,
        size: responsiveWidth,
      ),
    );
  }
}

class _LoginFormPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path0 = Path()
      ..moveTo(size.width * 0.8699187, size.height)
      ..cubicTo(
        size.width * 0.9312385,
        size.height,
        size.width * 0.9618997,
        size.height,
        size.width * 0.9809512,
        size.height * 0.9838041,
      )
      ..cubicTo(
        size.width,
        size.height * 0.9676060,
        size.width,
        size.height * 0.9415369,
        size.width,
        size.height * 0.8894009,
      )
      ..lineTo(size.width, size.height * 0.1080196)
      ..cubicTo(
        size.width,
        size.height * 0.05606982,
        size.width,
        size.height * 0.03009470,
        size.width * 0.9794146,
        size.height * 0.01370613,
      )
      ..cubicTo(
        size.width * 0.9588266,
        size.height * -0.002682512,
        size.width * 0.9309350,
        size.height * -0.001121200,
        size.width * 0.8751545,
        size.height * 0.002001417,
      )
      ..cubicTo(
        size.width * 0.7767832,
        size.height * 0.007508111,
        size.width * 0.6808266,
        size.height * 0.03000046,
        size.width * 0.5844309,
        size.height * 0.09928986,
      )
      ..cubicTo(
        size.width * 0.5365393,
        size.height * 0.1337147,
        size.width * 0.4636911,
        size.height * 0.1337915,
        size.width * 0.4169919,
        size.height * 0.09820300,
      )
      ..cubicTo(
        size.width * 0.3148211,
        size.height * 0.02034097,
        size.width * 0.2259618,
        size.height * 0.004465046,
        size.width * 0.1250195,
        size.height * 0.003653433,
      )
      ..cubicTo(
        size.width * 0.06736369,
        size.height * 0.003189862,
        size.width * 0.03853577,
        size.height * 0.002958088,
        size.width * 0.01926794,
        size.height * 0.01918606,
      )
      ..cubicTo(
        0,
        size.height * 0.03541406,
        0,
        size.height * 0.06132373,
        0,
        size.height * 0.1131429,
      )
      ..lineTo(0, size.height * 0.8894009)
      ..cubicTo(
        0,
        size.height * 0.9415369,
        0,
        size.height * 0.9676060,
        size.width * 0.01904997,
        size.height * 0.9838041,
      )
      ..cubicTo(
        size.width * 0.03810000,
        size.height,
        size.width * 0.06876043,
        size.height,
        size.width * 0.1300813,
        size.height,
      )
      ..lineTo(size.width * 0.8699187, size.height)
      ..close();

    final paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(size.width * -0.5150000, size.height * 2.300002),
        Offset(size.width * 0.3988916, size.height * -0.3073355),
        [
          Colors.white.withValues(alpha: 1),
          Colors.white.withValues(alpha: 0.9),
        ],
        [0, 1],
      );
    canvas.drawPath(path0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
