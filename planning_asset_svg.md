# Planning: TDD Flutter SVG Asset Management - Red-Green-Refactor

## 🚨 TDD Philosophy First

**"Write tests first, code second. No exceptions."** - Following the current codebase pattern of abstract classes + implementations for 100% test coverage.

### TDD Benefits for SVG Asset Management:

- ✅ **Guaranteed testability** from day one
- ✅ **Clear contracts** defined by tests
- ✅ **Refactor confidence** with test safety net
- ✅ **No untestable code** (eliminates private constructor pattern)
- ✅ **Consistent with image assets** (same TDD pattern)

---

## 🔴 **PHASE 1: RED - Write Failing Tests First**

### 1.1 Test Requirements Analysis

Based on current codebase patterns and image asset TDD approach:

- Abstract contract for dependency injection (like AppImages)
- Implementation for production use (like AppImagesImpl)
- Service for SVG rendering with parameters
- Type-safe SVG icon path access

### 1.2 Failing Tests (Write These FIRST!)

```dart
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
      // ❌ FAILS: Constructor doesn't exist
      const appIcons1 = AppIconsImpl();
      const appIcons2 = AppIconsImpl();
      expect(appIcons1.logo, equals(appIcons2.logo));
    });
  });
}
```

```dart
// test/core/services/svg_icon_service_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/services/svg_icon_service.dart';
import 'package:xp1/core/services/svg_icon_service_impl.dart';

void main() {
  group('SvgIconService Tests (RED PHASE)', () {
    late SvgIconService service;

    setUp(() {
      // ❌ This will fail initially - no service exists
      service = const SvgIconServiceImpl();
    });

    testWidgets('should implement SvgIconService interface', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            // ❌ FAILS: Interface doesn't exist
            expect(service, isA<SvgIconService>());
            return Container();
          },
        ),
      );
    });

    testWidgets('should display SVG icon with responsive sizing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No svgIcon method
              return service.svgIcon(
                'assets/icons/test/icon.svg',
                size: 24,
                color: Colors.blue,
              );
            },
          ),
        ),
      );

      // ❌ FAILS: No SvgPicture widget rendered
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should handle tap events when provided', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No onTap support
              return service.svgIcon(
                'assets/icons/test/icon.svg',
                onTap: () => tapped = true,
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('should not wrap in GestureDetector when onTap is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No conditional wrapping
              return service.svgIcon('assets/icons/test/icon.svg');
            },
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
```

### 1.3 Run Tests - Confirm RED State

```bash
# These commands MUST fail initially
flutter test test/core/assets/app_icons_test.dart
flutter test test/core/services/svg_icon_service_test.dart

# Expected output:
# ❌ FileSystemException: Cannot open file 'lib/core/assets/app_icons.dart'
# ❌ Multiple compilation errors
# ❌ All tests FAIL - This is GOOD in RED phase!
```

---

## 🟢 **PHASE 2: GREEN - Minimal Code to Pass Tests**

### 2.1 Create Abstract Contracts (Minimal Interface)

```dart
// lib/core/assets/app_icons.dart
/// Abstract contract for SVG icon paths following codebase DI pattern.
///
/// This abstract class enables dependency injection and mocking in tests,
/// following the same pattern as AppImages for 100% test coverage.
abstract class AppIcons {
  // UI Navigation Icons
  /// Back arrow navigation icon path
  String get arrowBack;

  /// Search functionality icon path
  String get search;

  /// Menu hamburger icon path
  String get menu;

  /// Notification bell icon path
  String get notification;

  /// Close X icon path
  String get close;

  // Status Icons
  /// Success checkmark icon path
  String get success;

  /// Error warning icon path
  String get error;

  /// Warning alert icon path
  String get warning;

  /// Information icon path
  String get info;

  // Action Icons
  /// Edit pencil icon path
  String get edit;

  /// Delete trash icon path
  String get delete;

  /// Add plus icon path
  String get add;

  /// Filter funnel icon path
  String get filter;

  // Brand Assets
  /// Company logo icon path
  String get logo;

  /// Company logo with text path
  String get logoText;

  // Critical icons for preloading
  /// List of critical SVG icon paths for preloading
  List<String> get criticalIcons;
}
```

### 2.2 Minimal Implementation (Just Enough to Pass)

```dart
// lib/core/assets/app_icons_impl.dart
import 'package:injectable/injectable.dart';
import 'package:xp1/core/assets/app_icons.dart';

/// Minimal implementation of AppIcons to pass RED tests.
///
/// Uses dependency injection pattern following AppImages example.
@LazySingleton(as: AppIcons)
class AppIconsImpl implements AppIcons {
  /// Creates app icons implementation.
  const AppIconsImpl();

  // Minimal implementation - just enough to pass tests
  @override
  String get arrowBack => 'assets/icons/ui/arrow_back.svg';

  @override
  String get search => 'assets/icons/ui/search.svg';

  @override
  String get menu => 'assets/icons/ui/menu.svg';

  @override
  String get notification => 'assets/icons/ui/notification.svg';

  @override
  String get close => 'assets/icons/ui/close.svg';

  @override
  String get success => 'assets/icons/status/success.svg';

  @override
  String get error => 'assets/icons/status/error.svg';

  @override
  String get warning => 'assets/icons/status/warning.svg';

  @override
  String get info => 'assets/icons/status/info.svg';

  @override
  String get edit => 'assets/icons/action/edit.svg';

  @override
  String get delete => 'assets/icons/action/delete.svg';

  @override
  String get add => 'assets/icons/action/add.svg';

  @override
  String get filter => 'assets/icons/action/filter.svg';

  @override
  String get logo => 'assets/icons/brand/logo.svg';

  @override
  String get logoText => 'assets/icons/brand/logo_text.svg';

  @override
  List<String> get criticalIcons => [
    logo,
    arrowBack,
    search,
    menu,
  ];
}
```

### 2.3 Minimal Service Implementation

```dart
// lib/core/services/svg_icon_service.dart
import 'package:flutter/material.dart';

/// Abstract contract for SVG icon service following codebase pattern.
abstract class SvgIconService {
  /// Displays SVG icon with responsive sizing and optional tap handling.
  Widget svgIcon(
    String assetPath, {
    double size = 24,
    Color? color,
    String? semanticLabel,
    VoidCallback? onTap,
  });
}
```

```dart
// lib/core/services/svg_icon_service_impl.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/core/services/svg_icon_service.dart';

/// Minimal implementation to pass GREEN tests.
@LazySingleton(as: SvgIconService)
class SvgIconServiceImpl implements SvgIconService {
  /// Creates SVG icon service implementation.
  const SvgIconServiceImpl();

  @override
  Widget svgIcon(
    String assetPath, {
    double size = 24,
    Color? color,
    String? semanticLabel,
    VoidCallback? onTap,
  }) {
    // Minimal implementation - just enough to pass tests
    Widget svg = SvgPicture.asset(
      assetPath,
      width: size.w,
      height: size.w,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticLabel,
      placeholderBuilder: (_) => SizedBox(
        width: size.w,
        height: size.w,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    );

    if (onTap != null) {
      svg = GestureDetector(onTap: onTap, child: svg);
    }

    return svg;
  }
}
```

### 2.4 Run Tests - Confirm GREEN State

```bash
# These commands MUST pass now
flutter test test/core/assets/app_icons_test.dart
flutter test test/core/services/svg_icon_service_test.dart

# Expected output:
# ✅ All tests passing
# ✅ 100% test coverage achieved
# ✅ GREEN phase complete!
```

---

## 🔄 **PHASE 3: REFACTOR - Improve Code Quality**

### 3.1 Add Icon Size Constants (Test-Driven)

**First, add failing test:**

```dart
// Add to test/core/assets/app_icons_test.dart
test('should provide consistent icon size constants', () {
  // ❌ FAILS: No iconSizes property yet
  expect(appIcons.iconSizes.small, equals(16.0));
  expect(appIcons.iconSizes.medium, equals(24.0));
  expect(appIcons.iconSizes.large, equals(32.0));
  expect(appIcons.iconSizes.xLarge, equals(48.0));
});
```

**Then implement to pass:**

```dart
// Add to lib/core/assets/app_icons.dart
abstract class AppIcons {
  // ... existing getters ...

  /// Standard icon size constants for consistency
  IconSizeConstants get iconSizes;
}

/// Icon size constants for consistent sizing
class IconSizeConstants {
  const IconSizeConstants();

  double get small => 16.0;
  double get medium => 24.0;
  double get large => 32.0;
  double get xLarge => 48.0;
}
```

```dart
// Add to lib/core/assets/app_icons_impl.dart
class AppIconsImpl implements AppIcons {
  // ... existing getters ...

  @override
  IconSizeConstants get iconSizes => const IconSizeConstants();
}
```

### 3.2 Add Enhanced Semantic Support (Test-Driven)

**First, add failing test:**

```dart
// Add to test/core/services/svg_icon_service_test.dart
testWidgets('should provide default semantic labels based on icon path', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          ScreenUtil.init(context, designSize: const Size(375, 812));
          // ❌ FAILS: No automatic semantic label generation
          return service.svgIcon(
            'assets/icons/ui/search.svg',
            useAutoSemantics: true,
          );
        },
      ),
    ),
  );

  final svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
  expect(svgWidget.semanticsLabel, equals('Search'));
});
```

**Then implement enhanced service:**

```dart
// Update lib/core/services/svg_icon_service.dart
abstract class SvgIconService {
  Widget svgIcon(
    String assetPath, {
    double size = 24,
    Color? color,
    String? semanticLabel,
    VoidCallback? onTap,
    bool useAutoSemantics = false,  // New parameter
  });
}
```

### 3.3 Run Tests - Confirm REFACTOR Success

```bash
# Tests must still pass after refactoring
flutter test test/core/assets/app_icons_test.dart
flutter test test/core/services/svg_icon_service_test.dart

# Expected output:
# ✅ All tests still passing
# ✅ New functionality tested
# ✅ Code quality improved
# ✅ REFACTOR phase complete!
```

---

## 🔁 **PHASE 4: REPEAT - Next Feature Cycle**

### 4.1 Next Feature: SVG Preloading Service (RED Phase)

**Write failing test first:**

```dart
// test/core/services/svg_preloader_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/services/svg_preloader_service.dart';
import 'package:xp1/core/services/svg_preloader_service_impl.dart';

void main() {
  group('SvgPreloaderService (NEXT RED PHASE)', () {
    late SvgPreloaderService service;

    setUp(() {
      // ❌ This will fail - new feature doesn't exist yet
      service = const SvgPreloaderServiceImpl();
    });

    test('should preload critical SVG icons', () async {
      // ❌ FAILS: No preloadCriticalIcons method
      final result = await service.preloadCriticalIcons(['logo.svg']);
      expect(result.success, isTrue);
    });
  });
}
```

### 4.2 Implementation Timeline (TDD Cycles)

**Week 1: Basic SVG Management**

- Day 1: RED - Write SVG contract tests
- Day 2: GREEN - Minimal implementation
- Day 3: REFACTOR - Add size constants and semantics

**Week 2: Enhanced Features**

- Day 1: RED - Write preloader tests
- Day 2: GREEN - Basic preloader implementation
- Day 3: REFACTOR - Theme integration and performance

**Week 3: Integration**

- Day 1: RED - Write integration tests
- Day 2: GREEN - Connect to bootstrap
- Day 3: REFACTOR - Final optimizations

---

## 🏁 **TDD Summary: Complete Red-Green-Refactor Cycle**

### ✅ **What We Achieved:**

1. **RED Phase**: ❌ Started with failing tests that defined clear contracts
2. **GREEN Phase**: ✅ Implemented minimal code to pass all tests
3. **REFACTOR Phase**: 🔄 Enhanced code quality while maintaining green tests
4. **REPEAT Phase**: 🔁 Showed how to continue TDD cycle for new features

### ✅ **TDD Benefits Realized:**

- **100% Test Coverage**: Guaranteed from day one
- **Clear Contracts**: Tests define exactly what the code should do
- **Refactor Safety**: Can improve code without breaking functionality
- **Design Guidance**: Tests drive the API design
- **Consistent with Image Assets**: Same pattern as AppImages

### ✅ **Production Usage:**

```dart
// In production - use DI (same as AppSizes/AppImages pattern)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIt<AppIcons>();
    final iconService = getIt<SvgIconService>();

    return Scaffold(
      appBar: AppBar(
        leading: iconService.svgIcon(
          icons.arrowBack,
          size: icons.iconSizes.medium,
          onTap: () => Navigator.pop(context),
        ),
        actions: [
          iconService.svgIcon(
            icons.search,
            size: icons.iconSizes.medium,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
```

### ✅ **Testing - Direct Instantiation:**

```dart
// In tests - direct instantiation (same as AppSizes/AppImages pattern)
testWidgets('should display navigation icons', (tester) async {
  final icons = const AppIconsImpl();  // ✅ Testable!
  final service = const SvgIconServiceImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: service.svgIcon(icons.search),
    ),
  );

  expect(find.byType(SvgPicture), findsOneWidget);
});
```

---

## 📋 **TDD Implementation Checklist**

**Day 1: RED Phase**

- [ ] Write failing tests for AppIcons contract
- [ ] Write failing tests for SvgIconService
- [ ] Confirm all tests fail (RED state)
- [ ] Run `flutter test` - expect compilation errors

**Day 2: GREEN Phase**

- [ ] Create minimal AppIcons abstract class
- [ ] Create minimal AppIconsImpl implementation
- [ ] Create minimal SvgIconService interface
- [ ] Create minimal SvgIconServiceImpl
- [ ] Run tests - all should pass (GREEN state)

**Day 3: REFACTOR Phase**

- [ ] Add icon size constants (test-first)
- [ ] Enhance semantic support (test-first)
- [ ] Improve service API (test-first)
- [ ] Run tests - all still pass (REFACTOR complete)

**Week 2+: REPEAT Phase**

- [ ] Identify next feature (preloading)
- [ ] Write failing tests (RED)
- [ ] Implement minimal code (GREEN)
- [ ] Enhance implementation (REFACTOR)

---

## 🎯 **Why This TDD Approach is "Good Taste"**

1. **Eliminates Special Cases**: No untestable private constructors
2. **Tests Drive Design**: API shaped by actual usage needs
3. **Consistent Pattern**: Follows existing codebase (AppSizes, AppImages)
4. **No Over-Engineering**: Only implements what tests require
5. **Refactor Safety**: Changes backed by comprehensive test suite
6. **Unified Asset Management**: SVG and Image follow same patterns

### 🚀 **Integration with Image Assets (Consistent API)**

```dart
// Both follow identical TDD patterns:

// Image Assets (AppImages + AssetImageService)
final images = getIt<AppImages>();
final imageService = getIt<AssetImageService>();

// SVG Assets (AppIcons + SvgIconService)
final icons = getIt<AppIcons>();
final iconService = getIt<SvgIconService>();

// Both testable the same way:
const images = AppImagesImpl();    // ✅ Direct instantiation
const icons = AppIconsImpl();      // ✅ Direct instantiation
```

**"Tests first, code second. This is the way."** 🚀
