import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:xp1/l10n/gen/strings.g.dart';

/// Statistics page showing analytics and data.
@RoutePage()
class StatisticsPage extends StatelessWidget {
  /// Creates a statistics page.
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.statistics.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.pages.statistics.welcomeMessage.replaceAll(
                '{pageName}',
                t.pages.statistics.title,
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
                      t.pages.statistics.viewReport,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.pages.statistics.exportData,
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
