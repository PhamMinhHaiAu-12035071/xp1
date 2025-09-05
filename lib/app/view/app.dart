import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/gen/strings.g.dart';
import 'package:xp1/l10n/l10n.dart';

/// Main application widget with Material theme and localization setup.
class App extends StatelessWidget {
  /// Creates app widget.
  const App({super.key});

  static final _appRouter = AppRouter();
  static final _logger = LoggerService();

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          final locale = TranslationProvider.of(context).flutterLocale;
          _logger.info('Locale changed to ${locale.languageCode}');
          return MaterialApp.router(
            title: t.app.title,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            locale: locale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _appRouter.config(),
          );
        },
      ),
    );
  }
}
