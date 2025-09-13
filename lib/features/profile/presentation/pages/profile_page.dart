import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:xp1/l10n/gen/strings.g.dart';

/// Profile page for user account and settings.
@RoutePage()
class ProfilePage extends StatelessWidget {
  /// Creates a profile page.
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.pages.profile.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.pages.profile.welcomeMessage.replaceAll(
                '{pageName}',
                t.pages.profile.title,
              ),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: Text(t.pages.profile.editProfile),
                      onTap: () {
                        // Handle edit profile
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(t.pages.profile.settings),
                      onTap: () {
                        // Handle settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.tune),
                      title: Text(t.pages.profile.preferences),
                      onTap: () {
                        // Handle preferences
                      },
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
