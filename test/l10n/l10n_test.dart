import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/l10n/l10n.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppLocalizationsX', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
    });

    testWidgets('should provide l10n extension on BuildContext', (
      tester,
    ) async {
      late AppLocalizations? localizations;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              localizations = context.l10n;
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      expect(localizations, isNotNull);
      expect(localizations, isA<AppLocalizations>());
    });

    testWidgets('should return AppLocalizations from context', (tester) async {
      late AppLocalizations contextLocalizations;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              contextLocalizations = context.l10n;
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      expect(contextLocalizations, isA<AppLocalizations>());
      expect(contextLocalizations.localeName, equals('en'));
    });

    testWidgets('should work with different locales', (tester) async {
      late AppLocalizations localizations;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              localizations = context.l10n;
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      expect(localizations.localeName, equals('es'));
    });

    testWidgets('should provide same instance as AppLocalizations.of', (
      tester,
    ) async {
      late AppLocalizations extensionLocalizations;
      late AppLocalizations staticLocalizations;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              extensionLocalizations = context.l10n;
              staticLocalizations = AppLocalizations.of(context);
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      expect(
        extensionLocalizations.localeName,
        equals(staticLocalizations.localeName),
      );
      expect(
        extensionLocalizations.runtimeType,
        equals(staticLocalizations.runtimeType),
      );
    });

    test('should export AppLocalizations', () {
      // This test ensures the export statement works
      expect(AppLocalizations, isNotNull);
    });

    testWidgets('should handle multiple context uses', (tester) async {
      final localizations = <AppLocalizations>[];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              localizations.add(context.l10n);
              return Builder(
                builder: (innerContext) {
                  localizations.add(innerContext.l10n);
                  return const Scaffold(
                    body: Text('Test'),
                  );
                },
              );
            },
          ),
        ),
      );

      expect(localizations.length, equals(2));
      expect(localizations[0].localeName, equals(localizations[1].localeName));
    });
  });
}
