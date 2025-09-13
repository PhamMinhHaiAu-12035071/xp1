import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Forgot password page for password recovery.
@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  /// Creates a forgot password page.
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t.pages.forgotPassword.title,
          style: context.textStyles.bodyLarge(
            color: context.colors.greyNormal,
          ),
          textAlign: TextAlign.center,
        ),
        leading: SizedBox.expand(
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              Container(
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
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                child: IconButton(
                  iconSize: context.sizes.r24,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.router.maybePop(),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello World',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                t.pages.forgotPassword.welcomeMessage.replaceAll(
                  '{pageName}',
                  t.pages.forgotPassword.title,
                ),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lock_reset,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.pages.forgotPassword.comingSoon,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.pages.forgotPassword.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
