// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
    });

    testWidgets('should render login page', (tester) async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Login'), findsOneWidget);
    });

    testWidgets('should have MaterialApp with router', (tester) async {
      await tester.pumpWidget(App());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.routerConfig, isNotNull);
    });
  });
}
