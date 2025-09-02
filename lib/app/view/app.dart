import 'package:flutter/material.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/l10n.dart';

/// Main application widget with Material theme and localization setup.
class App extends StatelessWidget {
  /// Creates app widget.
  const App({super.key});

  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _appRouter.config(),
    );
  }
}
