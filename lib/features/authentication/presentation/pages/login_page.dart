import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/routing/app_router.dart';

/// Login page for user authentication.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a login page.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello World - Login',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.router.replaceAll([
                  const MainWrapperRoute(),
                ]);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
