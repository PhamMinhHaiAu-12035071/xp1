# Planning: TDD Flutter Image Asset Management - Red-Green-Refactor

## 🚨 TDD Philosophy First

**"Write tests first, code second. No exceptions."** - Following the current codebase pattern of abstract classes + implementations for 100% test coverage.

### TDD Benefits for Asset Management:

- ✅ **Guaranteed testability** from day one
- ✅ **Clear contracts** defined by tests
- ✅ **Refactor confidence** with test safety net
- ✅ **No untestable code** (eliminates private constructor pattern)

---

## 🔴 **PHASE 1: RED - Write Failing Tests First**

### 1.1 Test Requirements Analysis

Based on current codebase patterns (`AppSizes`, `AppColors`), we need:

- Abstract contract for dependency injection
- Implementation for production use
- Direct instantiation for testing
- Type-safe asset path access

### 1.2 Failing Tests (Write These FIRST!)

```dart
// test/core/assets/app_images_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/core/assets/app_images_impl.dart';

void main() {
  group('AppImages Contract Tests (RED PHASE)', () {
    late AppImages appImages;

    setUp(() {
      // ❌ This will fail initially - no implementation exists yet
      appImages = const AppImagesImpl();
    });

    test('should implement AppImages interface', () {
      // ❌ FAILS: AppImages interface doesn't exist
      expect(appImages, isA<AppImages>());
    });

    test('should provide splash screen assets', () {
      // ❌ FAILS: No splashLogo property
      expect(appImages.splashLogo, isNotEmpty);
      expect(appImages.splashLogo, startsWith('assets/images/'));
      expect(appImages.splashBackground, isNotEmpty);
    });

    test('should provide login screen assets', () {
      // ❌ FAILS: No login assets
      expect(appImages.loginLogo, isNotEmpty);
      expect(appImages.loginBackground, startsWith('assets/images/'));
    });

    test('should provide employee assets', () {
      // ❌ FAILS: No employee assets
      expect(appImages.employeeAvatar, isNotEmpty);
      expect(appImages.employeeBadge, contains('employee'));
    });

    test('should provide critical assets list', () {
      // ❌ FAILS: No criticalAssets property
      expect(appImages.criticalAssets, isNotEmpty);
      expect(appImages.criticalAssets, contains(appImages.splashLogo));
      expect(appImages.criticalAssets, contains(appImages.loginLogo));
    });

    test('should be const constructible for testing', () {
      // ❌ FAILS: Constructor doesn't exist
      const appImages1 = AppImagesImpl();
      const appImages2 = AppImagesImpl();
      expect(appImages1.splashLogo, equals(appImages2.splashLogo));
    });
  });
}
```

```dart
// test/core/services/asset_image_service_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/services/asset_image_service.dart';
import 'package:xp1/core/services/asset_image_service_impl.dart';

void main() {
  group('AssetImageService Tests (RED PHASE)', () {
    late AssetImageService service;

    setUp(() {
      // ❌ This will fail initially - no service exists
      service = const AssetImageServiceImpl();
    });

    testWidgets('should implement AssetImageService interface', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            // ❌ FAILS: Interface doesn't exist
            expect(service, isA<AssetImageService>());
            return Container();
          },
        ),
      );
    });

    testWidgets('should display image with responsive sizing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No assetImage method
              return service.assetImage(
                'assets/test/logo.png',
                width: 100,
                height: 100,
              );
            },
          ),
        ),
      );

      // ❌ FAILS: No Image widget rendered
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle error states', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No error handling
              return service.assetImage(
                'assets/nonexistent.png',
                errorWidget: const Icon(Icons.error),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });
}
```

### 1.3 Run Tests - Confirm RED State

```bash
# These commands MUST fail initially
flutter test test/core/assets/app_images_test.dart
flutter test test/core/services/asset_image_service_test.dart

# Expected output:
# ❌ FileSystemException: Cannot open file 'lib/core/assets/app_images.dart'
# ❌ Multiple compilation errors
# ❌ All tests FAIL - This is GOOD in RED phase!
```

---

## 🟢 **PHASE 2: GREEN - Minimal Code to Pass Tests**

### 2.1 Create Abstract Contracts (Minimal Interface)

```dart
// lib/core/assets/app_images.dart
/// Abstract contract for image asset paths following codebase DI pattern.
///
/// This abstract class enables dependency injection and mocking in tests,
/// following the same pattern as AppSizes for 100% test coverage.
abstract class AppImages {
  // Splash Assets
  /// Splash screen logo image path
  String get splashLogo;

  /// Splash screen background image path
  String get splashBackground;

  // Login Assets
  /// Login screen logo image path
  String get loginLogo;

  /// Login screen background image path
  String get loginBackground;

  // Employee Assets
  /// Default employee avatar image path
  String get employeeAvatar;

  /// Employee badge image path
  String get employeeBadge;

  // Critical assets for preloading
  /// List of critical image paths for preloading
  List<String> get criticalAssets;
}
```

### 2.2 Minimal Implementation (Just Enough to Pass)

```dart
// lib/core/assets/app_images_impl.dart
import 'package:injectable/injectable.dart';
import 'package:xp1/core/assets/app_images.dart';

/// Minimal implementation of AppImages to pass RED tests.
///
/// Uses dependency injection pattern following AppSizes example.
@LazySingleton(as: AppImages)
class AppImagesImpl implements AppImages {
  /// Creates app images implementation.
  const AppImagesImpl();

  // Minimal implementation - just enough to pass tests
  @override
  String get splashLogo => 'assets/images/splash/logo.png';

  @override
  String get splashBackground => 'assets/images/splash/background.png';

  @override
  String get loginLogo => 'assets/images/login/logo.png';

  @override
  String get loginBackground => 'assets/images/login/background.png';

  @override
  String get employeeAvatar => 'assets/images/employee/avatar.png';

  @override
  String get employeeBadge => 'assets/images/employee/badge.png';

  @override
  List<String> get criticalAssets => [
    splashLogo,
    loginLogo,
  ];
}
```

### 2.3 Minimal Service Implementation

```dart
// lib/core/services/asset_image_service.dart
import 'package:flutter/material.dart';

/// Abstract contract for asset image service following codebase pattern.
abstract class AssetImageService {
  /// Displays asset image with responsive sizing and error handling.
  Widget assetImage(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
  });
}
```

```dart
// lib/core/services/asset_image_service_impl.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/core/services/asset_image_service.dart';

/// Minimal implementation to pass GREEN tests.
@LazySingleton(as: AssetImageService)
class AssetImageServiceImpl implements AssetImageService {
  /// Creates asset image service implementation.
  const AssetImageServiceImpl();

  @override
  Widget assetImage(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // Minimal implementation - just enough to pass tests
    return Image.asset(
      imagePath,
      width: width?.w,
      height: height?.h,
      fit: fit,
      errorBuilder: (_, __, ___) =>
        errorWidget ?? const Icon(Icons.broken_image),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return placeholder ??
          SizedBox(
            width: width?.w ?? 24.w,
            height: height?.h ?? 24.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
      },
    );
  }
}
```

### 2.4 Run Tests - Confirm GREEN State

```bash
# These commands MUST pass now
flutter test test/core/assets/app_images_test.dart
flutter test test/core/services/asset_image_service_test.dart

# Expected output:
# ✅ All tests passing
# ✅ 100% test coverage achieved
# ✅ GREEN phase complete!
```

---

## 🔄 **PHASE 3: REFACTOR - Improve Code Quality**

### 3.1 Add Image Size Constants (Test-Driven)

**First, add failing test:**

```dart
// Add to test/core/assets/app_images_test.dart
test('should provide consistent image size constants', () {
  // ❌ FAILS: No imageSizes property yet
  expect(appImages.imageSizes.small, equals(48.0));
  expect(appImages.imageSizes.medium, equals(96.0));
  expect(appImages.imageSizes.large, equals(144.0));
  expect(appImages.imageSizes.xLarge, equals(192.0));
});
```

**Then implement to pass:**

```dart
// Add to lib/core/assets/app_images.dart
abstract class AppImages {
  // ... existing getters ...

  /// Standard image size constants for consistency
  ImageSizeConstants get imageSizes;
}

/// Image size constants for consistent sizing
class ImageSizeConstants {
  const ImageSizeConstants();

  double get small => 48.0;
  double get medium => 96.0;
  double get large => 144.0;
  double get xLarge => 192.0;
}
```

```dart
// Add to lib/core/assets/app_images_impl.dart
class AppImagesImpl implements AppImages {
  // ... existing getters ...

  @override
  ImageSizeConstants get imageSizes => const ImageSizeConstants();
}
```

### 3.2 Add Enhanced Error Handling (Test-Driven)

**First, add failing test:**

```dart
// Add to test/core/services/asset_image_service_test.dart
testWidgets('should provide detailed error information', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          ScreenUtil.init(context, designSize: const Size(375, 812));
          // ❌ FAILS: No detailed error widget
          return service.assetImage(
            'assets/nonexistent.png',
            showDetailedErrors: true,
          );
        },
      ),
    ),
  );

  await tester.pumpAndSettle();
  expect(find.text('Image not found'), findsOneWidget);
});
```

**Then implement enhanced service:**

```dart
// Update lib/core/services/asset_image_service.dart
abstract class AssetImageService {
  Widget assetImage(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
    bool showDetailedErrors = false,  // New parameter
  });
}
```

### 3.3 Run Tests - Confirm REFACTOR Success

```bash
# Tests must still pass after refactoring
flutter test test/core/assets/app_images_test.dart
flutter test test/core/services/asset_image_service_test.dart

# Expected output:
# ✅ All tests still passing
# ✅ New functionality tested
# ✅ Code quality improved
# ✅ REFACTOR phase complete!
```

---

## 🔁 **PHASE 4: REPEAT - Next Feature Cycle**

### 4.1 Next Feature: Preloading Service (RED Phase)

**Write failing test first:**

```dart
// test/core/services/image_preloader_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/services/image_preloader_service.dart';
import 'package:xp1/core/services/image_preloader_service_impl.dart';

void main() {
  group('ImagePreloaderService (NEXT RED PHASE)', () {
    late ImagePreloaderService service;

    setUp(() {
      // ❌ This will fail - new feature doesn't exist yet
      service = const ImagePreloaderServiceImpl();
    });

    test('should preload critical images', () async {
      // ❌ FAILS: No preloadCriticalImages method
      final result = await service.preloadCriticalImages(['logo.png']);
      expect(result.success, isTrue);
    });
  });
}
```

### 4.2 Implementation Timeline (TDD Cycles)

**Week 1: Basic Asset Management**

- Day 1: RED - Write asset contract tests
- Day 2: GREEN - Minimal implementation
- Day 3: REFACTOR - Add size constants

**Week 2: Enhanced Features**

- Day 1: RED - Write preloader tests
- Day 2: GREEN - Basic preloader implementation
- Day 3: REFACTOR - Performance optimizations

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

### ✅ **Production Usage:**

```dart
// In production - use DI (same as AppSizes pattern)
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = getIt<AppImages>();
    final imageService = getIt<AssetImageService>();

    return Scaffold(
      body: Center(
        child: imageService.assetImage(
          images.splashLogo,
          width: images.imageSizes.large,
          height: images.imageSizes.large,
        ),
      ),
    );
  }
}
```

### ✅ **Testing - Direct Instantiation:**

```dart
// In tests - direct instantiation (same as AppSizes pattern)
testWidgets('should display splash logo', (tester) async {
  final images = const AppImagesImpl();  // ✅ Testable!
  final service = const AssetImageServiceImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: service.assetImage(images.splashLogo),
    ),
  );

  expect(find.byType(Image), findsOneWidget);
});
```

---

## 📋 **TDD Implementation Checklist**

**Day 1: RED Phase**

- [ ] Write failing tests for AppImages contract
- [ ] Write failing tests for AssetImageService
- [ ] Confirm all tests fail (RED state)
- [ ] Run `flutter test` - expect compilation errors

**Day 2: GREEN Phase**

- [ ] Create minimal AppImages abstract class
- [ ] Create minimal AppImagesImpl implementation
- [ ] Create minimal AssetImageService interface
- [ ] Create minimal AssetImageServiceImpl
- [ ] Run tests - all should pass (GREEN state)

**Day 3: REFACTOR Phase**

- [ ] Add image size constants (test-first)
- [ ] Enhance error handling (test-first)
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
3. **Consistent Pattern**: Follows existing codebase (AppSizes)
4. **No Over-Engineering**: Only implements what tests require
5. **Refactor Safety**: Changes backed by comprehensive test suite

**"Tests first, code second. This is the way."** 🚀
