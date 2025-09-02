import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Profile page for user account and settings.
@RoutePage()
class ProfilePage extends StatelessWidget {
  /// Creates a profile page.
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello World - Profile',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
