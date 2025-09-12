import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

import '../helpers/helpers.dart';

void main() {
  group('Slang Translations', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
      // Ensure English locale for consistent testing
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
      // Reset to English to prevent interference with other tests
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    testWidgets('should provide global t access to translations', (
      tester,
    ) async {
      // Ensure English locale for this test
      LocaleSettings.setLocaleSync(AppLocale.en);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) {
                // Test global t access
                final appTitle = t.app.title;
                final homeTitle = t.pages.home.title;

                return Scaffold(
                  body: Column(
                    children: [
                      Text(appTitle),
                      Text(homeTitle),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify translations are accessible
      expect(find.text('XP1'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should provide context-based translations', (tester) async {
      // Ensure English locale for this test
      LocaleSettings.setLocaleSync(AppLocale.en);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) {
                final translations = Translations.of(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text(translations.app.title),
                      Text(translations.navigation.home),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('XP1'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should work with different locales', (tester) async {
      // Set Vietnamese locale
      LocaleSettings.setLocaleSync(AppLocale.vi);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            locale: const Locale('vi'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text(t.app.title),
                      Text(t.navigation.home),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Should show Vietnamese translations
      expect(find.text('XP1'), findsOneWidget); // App title same in both
      expect(find.text('Trang chủ'), findsOneWidget); // Vietnamese for Home

      // Reset to English
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    testWidgets('should handle parameterized translations', (tester) async {
      // Ensure English locale for this test
      LocaleSettings.setLocaleSync(AppLocale.en);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) {
                final welcomeMessage = t.pages.home.welcomeMessage.replaceAll(
                  '{pageName}',
                  'Test Page',
                );

                return Scaffold(
                  body: Text(welcomeMessage),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome to Test Page'), findsOneWidget);
    });

    test('should export slang translations', () {
      // This test ensures the export statement works
      expect(Translations, isNotNull);
      expect(LocaleSettings, isNotNull);
      expect(AppLocale.values, isNotEmpty);
    });

    testWidgets('should provide consistent translations across contexts', (
      tester,
    ) async {
      // Ensure English locale for this test
      LocaleSettings.setLocaleSync(AppLocale.en);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) {
                final outerTitle = t.app.title;

                return Builder(
                  builder: (innerContext) {
                    final innerTitle = t.app.title;

                    return Scaffold(
                      body: Column(
                        children: [
                          Text('Outer: $outerTitle'),
                          Text('Inner: $innerTitle'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Outer: XP1'), findsOneWidget);
      expect(find.text('Inner: XP1'), findsOneWidget);
    });

    testWidgets('should support all defined locales', (tester) async {
      for (final locale in AppLocale.values) {
        LocaleSettings.setLocaleSync(locale);

        await tester.pumpWidget(
          TranslationProvider(
            child: MaterialApp(
              locale: Locale(locale.languageCode),
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: Builder(
                builder: (context) {
                  return Scaffold(
                    body: Text(t.app.title),
                  );
                },
              ),
            ),
          ),
        );

        // All locales should have app title
        expect(find.text('XP1'), findsOneWidget);

        await tester.pumpAndSettle();
      }

      // Reset to English
      LocaleSettings.setLocaleSync(AppLocale.en);
    });
  });
}
