import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/core/themes/app_theme.dart';
import 'package:xp1/core/widgets/widgets.dart';
import 'package:xp1/l10n/gen/strings.g.dart';
import 'package:xp1/l10n/l10n.dart';

/// Main application widget with Material theme and localization setup.
class App extends StatelessWidget {
  /// Creates app widget.
  const App({super.key});

  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ResponsiveInitializer(
      builder: (context) => TranslationProvider(
        child: Builder(
          builder: (context) {
            final locale = TranslationProvider.of(context).flutterLocale;
            return MaterialApp.router(
              title: t.app.title,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
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
      ),
    );
  }
}
