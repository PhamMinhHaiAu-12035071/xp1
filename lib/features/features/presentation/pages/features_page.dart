import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:xp1/l10n/gen/strings.g.dart';

/// Features page showing available application features.
@RoutePage()
class FeaturesPage extends StatelessWidget {
  /// Creates a features page.
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.pages.features.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.pages.features.welcomeMessage.replaceAll(
                '{pageName}',
                t.pages.features.title,
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
                      t.pages.features.availableFeatures,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.pages.features.comingSoon,
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
