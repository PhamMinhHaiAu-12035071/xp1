import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/constants/design_constants.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/core/widgets/atoms/primary_button.dart';
import 'package:xp1/core/widgets/molecules/animated_text_field.dart';
import 'package:xp1/core/widgets/molecules/glassmorphism_app_bar.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Forgot password page for password recovery.
@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  /// Creates a forgot password page.
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with TickerProviderStateMixin {
  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;
  late final AnimationController _emailAnimationController;
  late final Animation<double> _emailAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
    _emailAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _emailAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _emailAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    // Listen to focus changes to trigger animation
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _emailAnimationController.forward();
      } else {
        _emailAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _emailAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlassmorphismAppBar(
        title: t.pages.forgotPassword.title,
      ),
      body: ColoredBox(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Vùng 1: Spacing đầu (flex 60 - có thể thu nhỏ)
            const Flexible(
              flex: 60,
              child: SizedBox(),
            ),

            /// Vùng 2: Forgot password illustration image (Expanded 157)
            Expanded(
              flex: 157,
              child: SizedBox.expand(
                child: _buildForgotPasswordImage(context),
              ),
            ),

            /// Vùng 3: Spacing giữa (flex 80 - có thể thu nhỏ)
            const Flexible(
              flex: 80,
              child: SizedBox.expand(),
            ),

            /// Vùng 4: Form content (Expanded 412)
            Expanded(
              flex: 412,
              child: SizedBox.expand(child: _buildForm(context)),
            ),

            /// Vùng 5: Spacing cuối (flex 40 - có thể thu nhỏ)
            const Flexible(
              flex: 40,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInputSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildEmailInstructionText(context),
        _buildEmailInputField(context),
      ],
    );
  }

  /// Builds the animated email input field.
  Widget _buildEmailInputField(BuildContext context) {
    return AnimatedTextField(
      config: AnimatedTextFieldConfig(
        controller: _emailController,
        focusNode: _emailFocusNode,
        animationController: _emailAnimationController,
        animation: _emailAnimation,
        prefixIcon: _buildPrefixIcon(
          context.appIcons.email,
          t.pages.forgotPassword.semantic.emailIcon,
        ),
        label: t.pages.forgotPassword.emailLabel,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _handleSubmit(),
        onChanged: (_) {
          // Clear any previous errors when user types
          setState(() {});
        },
      ),
      isLoading: _isLoading,
    );
  }

  Widget _buildSubmitActionSection(BuildContext context) {
    return PrimaryButton(
      text: t.pages.forgotPassword.sendButton,
      onTap: _handleSubmit,
      isLoading: _isLoading,
    );
  }

  /// Handles the submit action for forgot password.
  void _handleSubmit() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      // Show error or focus the field
      _emailFocusNode.requestFocus();
      return;
    }

    // Add email validation
    if (!_isValidEmail(email)) {
      // Show error message
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Implement actual forgot password logic
    // For now, just simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to verification page or show success message
      }
    });
  }

  /// Validates email format.
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Builds a prefix icon with consistent styling matching login form.
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
          BoxShadow(color: Color(0x1F919EAB), blurRadius: 2),
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

  /// Builds the form content for forgot password page.
  ///
  /// Contains email instruction text and will include form elements
  /// for email input and submit button.
  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.sizes.h24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Vùng 1: Email input section (flex 3)
          Expanded(flex: 316, child: _buildEmailInputSection(context)),

          /// Vùng 2: Spacing giữa (flex 6)
          const Flexible(flex: 569, child: SizedBox.expand()),

          /// Vùng 3: Submit action section (flex 1)
          Expanded(flex: 117, child: _buildSubmitActionSection(context)),
        ],
      ),
    );
  }

  /// Builds the email instruction text for forgot password page.
  ///
  /// Displays instructions for users to enter their email address
  /// to receive verification code.
  Widget _buildEmailInstructionText(BuildContext context) {
    return Text(
      t.pages.forgotPassword.emailInstruction,
      style: context.textStyles
          .bodyMedium(
            color: context.colors.greyNormal,
          )
          .copyWith(
            fontWeight: FontWeight.w400,
          ),
      textAlign: TextAlign.center,
    );
  }

  /// Builds the forgot password illustration image with responsive sizing.
  ///
  /// Calculates width based on Figma design ratio (241px / 393px) and
  /// automatically calculates height to maintain aspect ratio.
  Widget _buildForgotPasswordImage(BuildContext context) {
    // Calculate responsive width based on Figma design ratio
    // Figma image width: 241px, Figma design width: 393px
    const figmaImageWidth = 241.0;
    const figmaDesignWidth = DesignConstants.designWidth;
    const widthRatio = figmaImageWidth / figmaDesignWidth;

    // Get current screen width and calculate responsive width
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveWidth = screenWidth * widthRatio;

    return context.imageService.assetImage(
      context.images.forgotPasswordImage,
      width: responsiveWidth,
      // Height will be auto-calculated to maintain aspect ratio
    );
  }
}
