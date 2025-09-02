import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/main_navigation/presentation/pages/main_wrapper_page.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('MainWrapperPage', () {
    setUpAll(() async {
      await TestDependencyContainer.setupTestDependencies();
    });

    tearDownAll(() async {
      await TestDependencyContainer.resetTestDependencies();
    });

    testWidgets('should create const constructor', (tester) async {
      const page = MainWrapperPage();
      expect(page, isA<MainWrapperPage>());
    });

    testWidgets('should support custom key', (tester) async {
      const key = Key('main_wrapper');
      const page = MainWrapperPage(key: key);
      expect(page.key, key);
    });

    testWidgets('should be a StatelessWidget', (tester) async {
      const page = MainWrapperPage();
      expect(page, isA<StatelessWidget>());
    });

    test('should have correct widget properties', () {
      const page = MainWrapperPage();
      expect(page.runtimeType, MainWrapperPage);
    });

    test('should have const constructor without key', () {
      const page = MainWrapperPage();
      expect(page.key, isNull);
    });

    test('should have const constructor with key', () {
      const key = Key('test_key');
      const page = MainWrapperPage(key: key);
      expect(page.key, key);
    });

    test('should be instance of StatelessWidget', () {
      const page = MainWrapperPage();
      expect(page, isA<StatelessWidget>());
    });

    test('should have proper type hierarchy', () {
      const page = MainWrapperPage();
      expect(page, isA<Widget>());
      expect(page, isA<StatelessWidget>());
      expect(page, isA<MainWrapperPage>());
    });
  });
}
