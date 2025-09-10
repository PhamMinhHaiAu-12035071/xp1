import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/assets/app_icons.dart';
import 'package:xp1/core/services/svg_icon_service.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Utility class for creating animated paths.
///
/// Based on the implementation from https://github.com/mahdices/flutter_animated_textfield
/// Provides methods to extract portions of a path for smooth animations.
class _PathAnimationUtils {
  /// Creates an animated path that progresses based on animation percentage.
  ///
  /// [originalPath] The complete path to animate.
  /// [animationPercent] Progress from 0.0 to 1.0.
  static Path createAnimatedPath(
    Path originalPath,
    double animationPercent,
  ) {
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
  static Path _extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
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

/// Modern login form widget with pixel-perfect design.
///
/// Provides email/password authentication with proper validation
/// and responsive design following the app's design system.
class LoginForm extends StatefulWidget {
  /// Creates a login form with modern design.
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

/// Field configuration for input fields.
class _FieldConfig {
  const _FieldConfig(
    this.keyboardType, {
    required this.controller,
    required this.focusNode,
    required this.animationController,
    required this.animation,
    required this.prefixIcon,
    required this.label,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AnimationController animationController;
  final Animation<double> animation;
  final Widget prefixIcon;
  final String label;
  final String? Function(String?) validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _usernameBorderAnimationController;
  late AnimationController _passwordBorderAnimationController;
  late Animation<double> _usernameBorderAnimation;
  late Animation<double> _passwordBorderAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize border animation controllers with shared configuration
    _usernameBorderAnimationController = _createAnimationController();
    _passwordBorderAnimationController = _createAnimationController();

    // Create border animations with shared configuration
    _usernameBorderAnimation = _createBorderAnimation(
      _usernameBorderAnimationController,
    );
    _passwordBorderAnimation = _createBorderAnimation(
      _passwordBorderAnimationController,
    );

    // Add listeners
    _usernameFocusNode.addListener(
      () => _onFocusChange(
        _usernameBorderAnimationController,
        _usernameFocusNode,
      ),
    );
    _passwordFocusNode.addListener(
      () => _onFocusChange(
        _passwordBorderAnimationController,
        _passwordFocusNode,
      ),
    );
    _usernameController.addListener(_onTextChange);
    _passwordController.addListener(_onTextChange);
  }

  /// Creates an animation controller with standard configuration.
  AnimationController _createAnimationController() {
    return AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  /// Creates a border animation with standard configuration.
  Animation<double> _createBorderAnimation(AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onTextChange);
    _passwordController.removeListener(_onTextChange);
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameBorderAnimationController.dispose();
    _passwordBorderAnimationController.dispose();
    super.dispose();
  }

  /// Handles login form submission.
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate login process
    await Future<void>.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to main app on success
      // context.router.replaceAll([const MainWrapperRoute()]);
    }
  }

  /// Handles focus changes for border animation.
  void _onFocusChange(AnimationController controller, FocusNode focusNode) {
    if (focusNode.hasFocus) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  /// Handles text changes to trigger label animation rebuild.
  void _onTextChange() {
    setState(() {
      // Trigger rebuild for label animation
    });
  }

  /// Calculates responsive spacing based on screen height.
  ///
  /// [baseSpacing] The base spacing value to scale.
  /// Returns a spacing value that adapts to different screen heights.
  double _getResponsiveSpacing(double baseSpacing) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Apply scaling factor with constraints
    // - Large screens (>= 800px): 100% spacing
    // - Medium screens (600-800px): 80-95% spacing
    // - Small screens (< 600px): 70-85% spacing
    double scaleFactor;
    if (screenHeight >= 800) {
      scaleFactor = 1.0;
    } else if (screenHeight >= 600) {
      // Linear interpolation between 0.8 and 1.0
      scaleFactor = 0.8 + (0.2 * (screenHeight - 600) / 200);
    } else {
      // Linear interpolation between 0.7 and 0.8
      scaleFactor = 0.7 + (0.1 * (screenHeight - 400) / 200);
    }

    // Ensure minimum and maximum bounds
    scaleFactor = scaleFactor.clamp(0.7, 1.0);

    return baseSpacing * scaleFactor;
  }

  /// Builds a prefix icon with consistent styling.
  Widget _buildPrefixIcon(String iconPath, String semanticLabel) {
    final iconService = GetIt.instance<SvgIconService>();

    return Container(
      padding: EdgeInsets.all(context.sizes.r12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(context.sizes.r8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14919EAB),
            offset: Offset(0, 8),
            blurRadius: 32,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color(0x1F919EAB),
            blurRadius: 2,
          ),
        ],
      ),
      child: iconService.svgIcon(
        iconPath,
        size: context.sizes.r8,
        color: context.colors.orangeNormal,
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Builds the eye visibility toggle icon using SVG service with ripple
  /// effect.
  Widget _buildEyeIcon() {
    final iconService = GetIt.instance<SvgIconService>();
    final appIcons = GetIt.instance<AppIcons>();

    return IconButton(
      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      icon: iconService.svgIcon(
        _obscurePassword ? appIcons.eye : appIcons.eyeOff,
        size: context.sizes.r8,
        color: context.colors.blueNormal,
        semanticLabel: _obscurePassword
            ? t.pages.login.semantic.showPassword
            : t.pages.login.semantic.hidePassword,
      ),
      splashRadius: context.sizes.r16,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
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
        BoxShadow(
          color: Color(0x1F919EAB),
          blurRadius: 2,
        ),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.sizes.r8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.sizes.r16,
        vertical: context.sizes.r16,
      ),
    );
  }

  /// Builds a unified animated input field with consistent styling.
  Widget _buildAnimatedField(_FieldConfig config) {
    return Container(
      decoration: _createFieldDecoration(),
      child: AnimatedBuilder(
        animation: config.animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Border animation layer (behind)
              Positioned.fill(
                child: CustomPaint(
                  painter: _CustomAnimatedBorderPainter(
                    animationPercent: config.animation.value,
                    borderColor: context.colors.amberNormal,
                    borderRadius: context.sizes.r8,
                  ),
                ),
              ),
              // TextField layer without label
              TextFormField(
                controller: config.controller,
                focusNode: config.focusNode,
                obscureText: config.obscureText,
                keyboardType: config.keyboardType,
                textInputAction: config.textInputAction,
                onFieldSubmitted: config.onFieldSubmitted,
                decoration: _createInputDecoration(
                  config.prefixIcon,
                  config.suffixIcon,
                ),
                style:
                    (config.focusNode.hasFocus ||
                        config.controller.text.isNotEmpty)
                    ? context.textStyles.bodyMedium().copyWith(
                        color: context.colors.greyNormal,
                      )
                    : context.textStyles.bodyMedium().copyWith(
                        color: context.colors.blueNormal,
                      ),
                validator: config.validator,
              ),
              // Custom positioned label with animation
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: context.sizes.r56,
                top:
                    (config.focusNode.hasFocus ||
                        config.controller.text.isNotEmpty)
                    ? context.sizes.r4
                    : context.sizes.r16,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style:
                      (config.focusNode.hasFocus ||
                          config.controller.text.isNotEmpty)
                      ? context.textStyles.bodySmall().copyWith(
                          color: context.colors.amberNormal,
                        )
                      : context.textStyles.bodySmall().copyWith(
                          color: context.colors.blueNormal,
                        ),
                  child: Text(config.label),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appIcons = GetIt.instance<AppIcons>();

    // Create field configurations to eliminate duplication
    final usernameConfig = _FieldConfig(
      TextInputType.text,
      controller: _usernameController,
      focusNode: _usernameFocusNode,
      animationController: _usernameBorderAnimationController,
      animation: _usernameBorderAnimation,
      prefixIcon: _buildPrefixIcon(
        appIcons.account,
        t.pages.login.semantic.usernameIcon,
      ),
      label: t.pages.login.form.username,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return t.pages.login.validation.usernameRequired;
        }
        if (value.length < 3) {
          return t.pages.login.validation.usernameMinLength;
        }
        return null;
      },
    );

    final passwordConfig = _FieldConfig(
      TextInputType.visiblePassword,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      animationController: _passwordBorderAnimationController,
      animation: _passwordBorderAnimation,
      prefixIcon: _buildPrefixIcon(
        appIcons.password,
        t.pages.login.semantic.passwordIcon,
      ),
      suffixIcon: _buildEyeIcon(),
      label: t.pages.login.form.password,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return t.pages.login.validation.passwordRequired;
        }
        if (value.length < 6) {
          return t.pages.login.validation.passwordMinLength;
        }
        return null;
      },
    );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome header section
            const _LoginWelcomeHeader(),

            SizedBox(height: _getResponsiveSpacing(context.sizes.v16)),

            // Username field
            _buildAnimatedField(usernameConfig),

            SizedBox(height: _getResponsiveSpacing(context.sizes.v20)),

            // Password field
            _buildAnimatedField(passwordConfig),

            SizedBox(height: _getResponsiveSpacing(context.sizes.v12)),

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.sizes.r8,
                    vertical: context.sizes.r4,
                  ),
                ),
                child: Text(
                  t.pages.login.forgotPassword,
                  style: context.textStyles.bodySmall().copyWith(
                    color: context.colors.blueNormal,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            SizedBox(height: _getResponsiveSpacing(context.sizes.v32)),

            // Login button
            _buildLoginButton(),

            SizedBox(height: _getResponsiveSpacing(context.sizes.v24)),
          ],
        ),
      ),
    );
  }

  /// Builds the login button with loading state.
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: context.sizes.r48,
      decoration: BoxDecoration(
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
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.amberNormal,
          foregroundColor: Colors.white,
          disabledBackgroundColor: context.colors.greyLight,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.sizes.r8),
          ),
          padding: EdgeInsets.symmetric(
            vertical: context.sizes.r16,
            horizontal: context.sizes.r12,
          ),
          minimumSize: Size(double.infinity, context.sizes.r48),
        ),
        child: _isLoading
            ? SizedBox(
                height: context.sizes.r20,
                width: context.sizes.r20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                t.pages.login.signInButton,
                style: context.textStyles.buttonText(),
              ),
      ),
    );
  }
}

/// Welcome header component for login screen.
///
/// Displays the main welcome title and subtitle with proper spacing
/// and typography following the design system.
class _LoginWelcomeHeader extends StatelessWidget {
  /// Creates a login welcome header.
  const _LoginWelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main welcome title
        Text(
          t.pages.login.welcome.title,
          style: context.textStyles.bodyMedium().copyWith(
            color: context.colors.greyNormal,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),

        SizedBox(height: context.sizes.v4),

        // Subtitle description
        Text(
          t.pages.login.welcome.subtitle,
          style: context.textStyles.headingMedium().copyWith(
            color: context.colors.greyNormal,
            fontWeight: FontWeight.w700,
            height: 1, // 100% line height
            letterSpacing: 0.2, // 1% of 20px = 0.2px
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
