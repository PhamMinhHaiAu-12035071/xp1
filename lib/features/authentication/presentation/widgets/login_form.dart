import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:xp1/core/constants/design_constants.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/core/widgets/loading_overlay.dart';
import 'package:xp1/features/authentication/application/blocs/auth_bloc.dart';
import 'package:xp1/features/authentication/application/blocs/auth_event.dart';
import 'package:xp1/features/authentication/application/blocs/auth_state.dart';
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
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AnimationController animationController;
  final Animation<double> animation;
  final Widget prefixIcon;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _hasSubmitted = false;
  bool _hasShownErrorDialog = false;
  late AnimationController _usernameBorderAnimationController;
  late AnimationController _passwordBorderAnimationController;
  late Animation<double> _usernameBorderAnimation;
  late Animation<double> _passwordBorderAnimation;

  late AnimationController _eyeIconAnimationController;
  late Animation<double> _eyeIconFadeAnimation;
  late Animation<double> _eyeIconScaleAnimation;

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

    // Initialize eye icon animation controller
    _eyeIconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );

    // Create eye icon animations
    _eyeIconFadeAnimation =
        Tween<double>(
          begin: 1,
          end: 0, // Fade out then fade in
        ).animate(
          CurvedAnimation(
            parent: _eyeIconAnimationController,
            curve: Curves.easeInCubic,
          ),
        );

    _eyeIconScaleAnimation =
        Tween<double>(
          begin: 1,
          end: 0.8,
        ).animate(
          CurvedAnimation(
            parent: _eyeIconAnimationController,
            curve: Curves.easeInCubic,
          ),
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
    _eyeIconAnimationController.dispose();
    super.dispose();
  }

  /// Handles login form submission.
  void _handleLogin() {
    setState(() {
      _hasSubmitted = true;
      // Reset error dialog flag to allow new errors to be shown on submit
      _hasShownErrorDialog = false;
    });

    // Dispatch form submission event to AuthBloc for validation and login
    context.read<AuthBloc>().add(const AuthEvent.formSubmitted());
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
      // Clear submit state when user types to hide errors
      _hasSubmitted = false;
      // Reset error dialog flag to allow new errors to be shown
      _hasShownErrorDialog = false;
    });
  }

  /// Handles username field changes and dispatches to BLoC
  void _onUsernameChanged(String value) {
    context.read<AuthBloc>().add(AuthEvent.usernameChanged(username: value));
    _onTextChange();
  }

  /// Handles password field changes and dispatches to BLoC
  void _onPasswordChanged(String value) {
    context.read<AuthBloc>().add(AuthEvent.passwordChanged(password: value));
    _onTextChange();
  }

  /// Calculates responsive spacing based on design ratio.
  ///
  /// [baseSpacing] The base spacing value to scale.
  /// Returns a spacing value that adapts proportionally to screen size
  /// based on the 393x852 Figma design dimensions.
  double _getResponsiveSpacing(double baseSpacing) {
    final screenSize = MediaQuery.of(context).size;

    // Design base dimensions from Figma - using centralized constants

    // Calculate scale factors for both dimensions
    final widthScale = screenSize.width / DesignConstants.designWidth;
    final heightScale = screenSize.height / DesignConstants.designHeight;

    // Use the smaller scale factor to maintain proportions
    // This ensures content doesn't become too large on wide screens
    final scale = (widthScale < heightScale) ? widthScale : heightScale;

    // Apply reasonable bounds for extreme screen sizes
    // - Minimum 0.8 for very small screens (maintain usability)
    // - Maximum 1.3 for very large screens (prevent oversized spacing)
    final boundedScale = scale.clamp(0.8, 1.3);

    return baseSpacing * boundedScale;
  }

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

  /// Builds a prefix icon with consistent styling.
  Widget _buildPrefixIcon(String iconPath, String semanticLabel) {
    final iconService = context.iconService;

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

  /// Shows error dialog with consistent styling and actions.
  /// Displays authentication errors in a modal dialog instead of inline text.
  Future<void> _showErrorDialog(String errorMessage) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.sizes.r12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: context.sizes.r24,
              ),
              SizedBox(width: context.sizes.r8),
              Text(
                t.pages.login.error.title,
                style: context.textStyles.headingMedium().copyWith(
                  color: context.colors.greyNormal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            errorMessage,
            style: context.textStyles.bodyMedium().copyWith(
              color: context.colors.greyNormal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: context.sizes.r16,
                  vertical: context.sizes.r8,
                ),
              ),
              child: Text(
                t.pages.login.error.okButton,
                style: context.textStyles.bodyMedium().copyWith(
                  color: context.colors.amberNormal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Safely hides the loading overlay with error handling.
  ///
  /// This method ensures that the loading overlay is properly hidden
  /// and handles edge cases where the overlay might not be showing.
  void _safeHideLoading() {
    if (LoadingOverlay.isShowing) {
      final success = LoadingOverlay.hide(context);
      if (!success) {
        // If normal hide failed, try force hide as fallback
        LoadingOverlay.forceHide(context);
      }
    }
  }

  /// Handles password visibility toggle with smooth fade animation.
  void _togglePasswordVisibility() {
    // Start fade out animation
    _eyeIconAnimationController.forward().then((_) {
      // Change icon state at the middle of animation (fully faded out)
      setState(() {
        _obscurePassword = !_obscurePassword;
      });
      // Fade back in with new icon
      _eyeIconAnimationController.reverse();
    });
  }

  /// Builds the eye visibility toggle icon using SVG service with ripple
  /// effect.
  Widget _buildEyeIcon() {
    final iconService = context.iconService;
    final appIcons = context.appIcons;

    // Sử dụng Material + InkWell để ripple là hình chữ nhật thay vì hình tròn
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(context.sizes.r32),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.sizes.r32),
        onTap: _togglePasswordVisibility,
        child: SizedBox(
          width: context.sizes.r32,
          height: context.sizes.r32,
          child: Center(
            child: AnimatedBuilder(
              animation: _eyeIconAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _eyeIconScaleAnimation.value,
                  child: Opacity(
                    opacity: _eyeIconFadeAnimation.value,
                    child: iconService.svgIcon(
                      _obscurePassword ? appIcons.eye : appIcons.eyeOff,
                      size: context.sizes.r24,
                      color: context.colors.blueNormal,
                      semanticLabel: _obscurePassword
                          ? t.pages.login.semantic.showPassword
                          : t.pages.login.semantic.hidePassword,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
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

  /// Builds a unified animated input field with consistent styling.
  Widget _buildAnimatedField(_FieldConfig config, {required bool isLoading}) {
    return Container(
      height: context.sizes.r48,
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
                enabled: !isLoading,
                obscureText: config.obscureText,
                keyboardType: config.keyboardType,
                textInputAction: config.textInputAction,
                textAlignVertical: TextAlignVertical.bottom,
                onFieldSubmitted: config.onFieldSubmitted,
                onChanged: (value) {
                  // Clear submit state when user types to hide errors
                  if (_hasSubmitted) {
                    setState(() => _hasSubmitted = false);
                  }
                  // Call the specific field's onChanged callback
                  config.onChanged?.call(value);
                },
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
              ),
              // Custom positioned label with calculated alignment
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: _calculateLabelLeftPosition(_measurePrefixIconWidth()),
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.authStatus) {
          case AuthenticationStatus.initial:
          // No action needed for initial state
          case AuthenticationStatus.loading:
            // Only show loading overlay during actual login, not auth check
            if (state.status == FormzSubmissionStatus.inProgress) {
              LoadingOverlay.show(context);
            }
          case AuthenticationStatus.authenticated:
            // Hide loading overlay and navigate to main app area
            // Only navigate if we're on login page (not splash)
            _safeHideLoading();
            if (context.router.current.name == LoginRoute.name) {
              context.router.replaceAll([const MainWrapperRoute()]);
            }
          case AuthenticationStatus.unauthenticated:
            // Hide loading overlay on unauthenticated state
            _safeHideLoading();
          case AuthenticationStatus.error:
            // Hide loading overlay on error
            _safeHideLoading();
            // Only show error dialog if it hasn't been shown yet for this error
            // and only when form has been submitted (not during field input)
            // and only if we're on login page (not splash)
            if (!_hasShownErrorDialog &&
                _hasSubmitted &&
                context.router.current.name == LoginRoute.name) {
              setState(() {
                _hasShownErrorDialog = true;
              });
              final message =
                  state.errorMessage ??
                  'An unexpected error occurred. Please try again.';
              _showErrorDialog(message);
            }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Only show loading during actual login submission, not auth check
          final isLoading =
              state.authStatus == AuthenticationStatus.loading &&
              state.status == FormzSubmissionStatus.inProgress;

          return _buildLoginForm(isLoading);
        },
      ),
    );
  }

  Widget _buildLoginForm(bool isLoading) {
    final appIcons = context.appIcons;

    // Local loading state is now derived from AuthBloc state

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
      onChanged: _onUsernameChanged,
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
      onChanged: _onPasswordChanged,
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome header section
          const _LoginWelcomeHeader(),

          SizedBox(height: _getResponsiveSpacing(context.sizes.v40)),

          // Username field
          _buildAnimatedField(usernameConfig, isLoading: isLoading),

          SizedBox(height: _getResponsiveSpacing(context.sizes.v20)),

          // Password field
          _buildAnimatedField(passwordConfig, isLoading: isLoading),

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

          SizedBox(height: _getResponsiveSpacing(context.sizes.v24)),

          // Login button
          _buildLoginButton(),

          SizedBox(height: _getResponsiveSpacing(context.sizes.v20)),
        ],
      ),
    );
  }

  /// Builds the login button with loading state and validation-based enable/disable.
  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Only show loading during actual authentication, not form validation
        final isLoading = state.authStatus == AuthenticationStatus.loading;

        // Button is disabled if either field is empty or if loading
        final isButtonDisabled =
            isLoading ||
            state.username.value.isEmpty ||
            state.password.value.isEmpty;

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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isButtonDisabled
                  ? context.colors.blueNormal
                  : context.colors.amberNormal,
              borderRadius: BorderRadius.circular(context.sizes.r8),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(context.sizes.r8),
              child: InkWell(
                borderRadius: BorderRadius.circular(context.sizes.r8),
                onTap: isButtonDisabled ? null : _handleLogin,
                child: Container(
                  width: double.infinity,
                  height: context.sizes.r48,
                  padding: EdgeInsets.symmetric(
                    vertical: context.sizes.r16,
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
                            style: context.textStyles.buttonText().copyWith(
                              color: isButtonDisabled
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : Colors.white,
                            ),
                            child: Text(t.pages.login.signInButton),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
