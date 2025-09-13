import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Forgot password page for password recovery.
@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  /// Creates a forgot password page.
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.forgotPassword.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: Center(
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
    );
  }
}
