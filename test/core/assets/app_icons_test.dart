// test/core/assets/app_icons_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/assets/app_icons.dart';
import 'package:xp1/core/assets/app_icons_impl.dart';

void main() {
  group('AppIcons Contract Tests (RED PHASE)', () {
    late AppIcons appIcons;

    setUp(() {
      // ❌ This will fail initially - no implementation exists yet
      appIcons = const AppIconsImpl();
    });

    test('should implement AppIcons interface', () {
      // ❌ FAILS: AppIcons interface doesn't exist
      expect(appIcons, isA<AppIcons>());
    });

    test('should provide UI navigation icons', () {
      // ❌ FAILS: No UI icon properties
      expect(appIcons.arrowBack, isNotEmpty);
      expect(appIcons.arrowBack, startsWith('assets/icons/'));
      expect(appIcons.search, contains('.svg'));
      expect(appIcons.menu, isNotEmpty);
      expect(appIcons.notification, isNotEmpty);
      expect(appIcons.close, isNotEmpty);
    });

    test('should provide status icons', () {
      // ❌ FAILS: No status icons
      expect(appIcons.success, startsWith('assets/icons/status/'));
      expect(appIcons.error, contains('error'));
      expect(appIcons.warning, contains('warning'));
      expect(appIcons.info, contains('info'));
    });

    test('should provide action icons', () {
      // ❌ FAILS: No action icons
      expect(appIcons.edit, isNotEmpty);
      expect(appIcons.delete, isNotEmpty);
      expect(appIcons.add, isNotEmpty);
      expect(appIcons.filter, isNotEmpty);
    });

    test('should provide brand assets', () {
      // ❌ FAILS: No brand assets
      expect(appIcons.logo, contains('brand'));
      expect(appIcons.logoText, contains('logo_text'));
    });

    test('should provide critical icons list', () {
      // ❌ FAILS: No criticalIcons property
      expect(appIcons.criticalIcons, isNotEmpty);
      expect(appIcons.criticalIcons, contains(appIcons.logo));
      expect(appIcons.criticalIcons, contains(appIcons.arrowBack));
    });

    test('should be const constructible for testing', () {
      const appIcons1 = AppIconsImpl();
      const appIcons2 = AppIconsImpl();
      expect(appIcons1.logo, equals(appIcons2.logo));
    });

    test('should provide consistent icon size constants', () {
      expect(appIcons.iconSizes.small, equals(16.0));
      expect(appIcons.iconSizes.medium, equals(24.0));
      expect(appIcons.iconSizes.large, equals(32.0));
      expect(appIcons.iconSizes.xLarge, equals(48.0));
    });
  });
}
