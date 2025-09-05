import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Login page for user authentication.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a login page.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.login.title),
      ),
      body: Center(
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
    );
  }
}
