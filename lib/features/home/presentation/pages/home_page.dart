import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:xp1/l10n/gen/strings.g.dart';

/// Home page showing main dashboard content.
@RoutePage()
class HomePage extends StatelessWidget {
  /// Creates a home page.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.home.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.pages.home.welcomeMessage.replaceAll(
                '{pageName}',
                t.pages.home.title,
              ),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      t.pages.home.todayStats,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.pages.home.quickActions,
                      style: Theme.of(context).textTheme.titleMedium,
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
