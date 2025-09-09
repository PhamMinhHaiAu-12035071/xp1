import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Login page for user authentication.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a login page.
  const LoginPage({super.key});

  /// Builds the error widget displayed when the background image fails to load
  @visibleForTesting
  Widget buildErrorWidget(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: Colors.grey[300],
      child: const Icon(
        Icons.broken_image,
        size: 48,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen background image (includes status bar and app bar area)
        Positioned.fill(
          child: Image.asset(
            context.images.loginBackground,
            fit: BoxFit.cover,
            // Simple error handling without service dependency
            errorBuilder: buildErrorWidget,
          ),
        ),
        // Scaffold with transparent background for content
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t.pages.login.welcomeMessage.replaceAll(
                      '{pageName}',
                      t.pages.login.title,
                    ),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.pages.login.instruction,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.router.replaceAll([
                        const MainWrapperRoute(),
                      ]);
                    },
                    child: Text(t.auth.loginButton),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(t.pages.login.forgotPassword),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
