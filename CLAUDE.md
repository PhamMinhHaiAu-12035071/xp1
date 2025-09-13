# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Essential Commands

```bash
# Complete local CI pipeline (equivalent to GitHub Actions)
make local-ci

# Quick development checks
make check                    # Format + analyze
make format                   # Format code only
make analyze                  # Analyze code only
make test                     # Run tests
make deps                     # Install dependencies

# Test coverage workflow
make test-coverage           # Run tests with coverage
make coverage-html          # Generate HTML report
make coverage-report        # Complete workflow: test + HTML
make coverage-open          # Open coverage report in browser

# Environment-specific commands
make run-dev                 # Development environment
make run-staging             # Staging environment
make run-prod                # Production environment

# Environment setup (required before first run)
make generate-env-dev        # Generate development config
make generate-env-staging    # Generate staging config
make generate-env-prod       # Generate production config

# Internationalization (i18n) commands using Slang
make i18n-generate           # Generate slang translations from JSON files
make i18n-watch              # Watch translation files and auto-generate
make i18n-analyze            # Analyze translation coverage
make i18n-validate           # Validate translation files
make i18n-clean              # Clean generated slang files
make i18n-help               # Show detailed i18n help

# Code Generation commands (Freezed, JSON, Routes)
dart run build_runner build --delete-conflicting-outputs  # Generate all code
dart run build_runner watch --delete-conflicting-outputs   # Auto-generate on changes
dart run build_runner clean                                # Clean generated files

# Navigation & Auto Route commands
dart run build_runner build        # Generate route files after route changes
dart run build_runner watch        # Auto-generate on route file changes
```

### Build Commands

```bash
# Multi-flavor builds
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor staging --target lib/main_staging.dart
flutter run --flavor production --target lib/main_production.dart

# Build variants
make build-dev               # Development build
make build-staging           # Staging build
make build-prod              # Production build
```

### Quality Assurance

```bash
# License compliance (business-safe only)
make license-check          # Strict business license validation
make license-report         # Detailed license analysis

# Naming conventions
make naming-check           # Validate naming conventions
make naming-fix             # Apply naming fixes

# Project setup
make setup                  # Complete project setup
```

## Code Architecture

### Navigation System with Auto Route

This project implements a sophisticated navigation system using auto_route for type-safe navigation:

- **Auto Route**: Type-safe navigation with code generation (`lib/core/routing/app_router.dart`)
- **Route Guards**: Authentication guards for protected routes (`lib/core/guards/auth_guard.dart`)
- **Nested Navigation**: Bottom navigation with nested routes (`lib/features/main_navigation/`)
- **Route Constants**: Centralized route definitions (`lib/core/constants/route_constants.dart`)

### Multi-Environment System

This project also implements environment management using sealed classes and factory patterns:

- **Environment Detection**: Compile-time environment switching via `--dart-define=ENVIRONMENT=<env>`
- **Sealed Classes**: Type-safe environment configurations (`lib/features/env/infrastructure/env_config_factory.dart:12`)
- **Factory Pattern**: Centralized configuration access (`lib/features/env/infrastructure/env_config_factory.dart:127`)
- **Generated Configs**: Environment-specific `.env` files processed by `envied_generator`

### Key Architecture Components

#### Environment Configuration

- **Domain Layer**: `lib/features/env/domain/env_config_repository.dart` - Repository interface
- **Infrastructure**: `lib/features/env/infrastructure/env_config_factory.dart` - Factory implementation
- **Environments**: Separate files for dev/staging/production configurations
- **Bootstrap Integration**: Environment logging at app startup (`lib/bootstrap.dart:35-40`)

#### Navigation Structure

- **Auto Route Configuration**: Centralized route configuration with type safety (`lib/core/routing/app_router.dart`)
- **Route Guards**: Authentication and authorization guards (`lib/core/guards/auth_guard.dart`)
- **Nested Routes**: Bottom navigation with nested child routes
- **Route Constants**: Centralized route path definitions (`lib/core/constants/route_constants.dart`)

#### Application Structure

- **Bootstrap Pattern**: Centralized app initialization with error handling and BLoC observation (`lib/bootstrap.dart`)
- **Multi-Entry Points**: Separate main files for each environment (`lib/main_*.dart`)
- **Feature-Based Organization**: Code organized by feature domains under `lib/features/`
- **Page Testing**: Standardized page testing with reusable helpers (`test/helpers/page_test_helpers.dart`)

#### State Management

- **BLoC Pattern**: Using flutter_bloc for state management
- **Hydrated BLoC**: Persistent state management with automatic serialization
- **Replay BLoC**: Undo/Redo functionality for state management
- **Observer Pattern**: Global BLoC observation for debugging (`lib/bootstrap.dart:9-24`)

#### Data Modeling

- **Freezed**: Immutable data classes with code generation
- **JSON Serialization**: Automatic JSON serialization with json_serializable
- **Functional Programming**: Error handling with Either types (fpdart)
- **Value Equality**: Object comparison with equatable

#### Image Asset Management

- **Pure Flutter Approach**: Zero external dependencies, using built-in `Image.asset()` + `ImageCache`
- **Service Layer**: `lib/core/services/asset_image_service.dart` - Abstract service interface
- **Implementation**: `lib/core/services/asset_image_service_impl.dart` - Pure Flutter implementation with DI
- **Asset Constants**: `lib/core/assets/app_images.dart` - Centralized asset path management
- **Asset Implementation**: `lib/core/assets/app_images_impl.dart` - Concrete asset paths with DI
- **Responsive Sizing**: Integration with `flutter_screenutil` for responsive image sizing
- **Error Handling**: Built-in `errorBuilder` with `Icon(Icons.broken_image)` fallback
- **Loading States**: Built-in `frameBuilder` with `CircularProgressIndicator` placeholder
- **Dependency Injection**: `@LazySingleton` pattern following existing codebase architecture
- **Test Coverage**: 100% coverage with TDD Red-Green-Refactor approach

#### SVG Asset Management

- **Flutter SVG Approach**: Essential `flutter_svg` package for vector graphics support (no built-in SVG support in Flutter)
- **Service Layer**: `lib/core/services/svg_icon_service.dart` - Abstract service interface with responsive sizing & tap handling
- **Implementation**: `lib/core/services/svg_icon_service_impl.dart` - Professional SVG implementation with DI
- **Asset Constants**: `lib/core/assets/app_icons.dart` - Centralized SVG icon path management with size constants
- **Asset Implementation**: `lib/core/assets/app_icons_impl.dart` - Concrete SVG paths with DI (`@LazySingleton`)
- **Organized Structure**: Category-based organization (`ui/`, `status/`, `action/`, `brand/`, `navigation/`)
- **Color Filtering**: Built-in theming support with `ColorFilter.mode()` for dynamic icon colors
- **Responsive Sizing**: `IconSizeConstants` class (16, 24, 32, 48px) with `flutter_screenutil` integration
- **Loading States**: Placeholder builders with `CircularProgressIndicator` during SVG loading
- **Accessibility**: Semantic labels support for screen readers
- **Tap Handling**: Optional `GestureDetector` wrapping with conditional rendering
- **Critical Assets**: Preloading list for performance optimization
- **Test Coverage**: 100% TDD coverage (Phase 0: Setup → Phase 1: RED → Phase 2: GREEN → Phase 3: REFACTOR)
- **Production Usage**: DI pattern `getIt<AppIcons>()` + `getIt<SvgIconService>()`, direct instantiation for tests

#### Design System & Styling

- **Color System**: `lib/core/styles/colors/app_colors.dart` - Abstract color contracts with comprehensive palettes
- **Color Implementation**: `lib/core/styles/colors/app_colors_impl.dart` - Concrete color values with DI
- **Typography System**: `lib/core/styles/app_text_styles.dart` - Abstract text style contracts
- **Typography Implementation**: `lib/core/styles/app_text_styles_impl.dart` - Public Sans typography with DI
- **Sizing System**: `lib/core/sizes/app_sizes.dart` - Abstract responsive sizing contracts
- **Sizing Implementation**: `lib/core/sizes/app_sizes_impl.dart` - Responsive values with `flutter_screenutil`
- **Theme Management**: `lib/core/themes/app_theme.dart` - Light/dark theme orchestration
- **Theme Extensions**: `lib/core/themes/extensions/` - Custom theme extensions with DI integration
- **Dependency Injection**: All design system components use `@LazySingleton` pattern
- **Material 3**: Full Material Design 3 integration with custom extensions
- **Responsive Design**: Automatic responsive sizing (r/v/h variants for each dimension)
- **Color Palettes**: Complete color systems (Amber, Grey, Blue, Slate, Green, Pink, Orange, Red)
- **Typography Scale**: 8-level typography system from caption (10px) to displayLarge (36px)

### Testing Strategy

- **Environment Testing**: Comprehensive tests for all three environments (`test/features/env/`)
- **Page Testing**: Standardized page testing with `PageTestHelpers` for DRY compliance
- **Navigation Testing**: Router-enabled testing for navigation flows
- **Integration Tests**: Full environment workflow validation
- **Repository Pattern Testing**: Mock implementations for testability

## Code Standards & Quality

### Linting & Analysis

- **Very Good Analysis**: Strict 130+ lint rules enforced
- **Zero Tolerance**: No warnings or errors allowed in CI
- **Line Length**: 80 characters maximum (strictly enforced)
- **Documentation**: All public APIs must be documented (mandatory for CI)

### Critical Patterns

- **Const Constructors**: Required for performance (`prefer_const_constructors`)
- **Cascade Operators**: Mandatory for multiple method calls (`cascade_invocations`)
- **Sealed Classes**: Used for type-safe environment switching
- **Repository Pattern**: Clean architecture with domain/infrastructure separation

### Flutter 3.27+ Color Deprecation Guidelines - MANDATORY

**CRITICAL**: Flutter 3.27.0+ deprecated `Color.value` and `Color.alpha` for wide gamut color support.

#### **Replace Color.value with toARGB32()**

```dart
// ❌ DEPRECATED: Color.value (Flutter 3.27+)
int colorValue = myColor.value;
expect(color.value, equals(0xFF2196F3));

// ✅ CORRECT: Use toARGB32() for explicit conversion
int colorValue = myColor.toARGB32();
expect(color.toARGB32(), equals(0xFF2196F3));
```

#### **Replace Color.alpha with Component Accessors**

```dart
// ❌ DEPRECATED: Color.alpha (Flutter 3.27+)
int alphaValue = color.alpha;
expect(color.alpha, equals(255));

// ✅ CORRECT: Use component accessor with conversion
int alphaValue = (color.a * 255.0).round() & 0xff;
expect((color.a * 255.0).round() & 0xff, equals(255));
```

#### **Replace withOpacity() with withValues()**

```dart
// ❌ DEPRECATED: withOpacity() (Flutter 3.27+)
Color semiTransparent = Colors.blue.withOpacity(0.5);
Color borderColor = Colors.white.withOpacity(0.7);

// ✅ CORRECT: Use withValues() to avoid precision loss
Color semiTransparent = Colors.blue.withValues(alpha: 0.5);
Color borderColor = Colors.white.withValues(alpha: 0.7);
```

#### **Use Component Accessors for Color Values**

```dart
// ❌ DEPRECATED: Color.red, Color.green, Color.blue (Flutter 3.27+)
int redValue = color.red;
int greenValue = color.green;
int blueValue = color.blue;

// ✅ CORRECT: Use floating-point component accessors
double redComponent = color.r;      // 0.0-1.0 range
double greenComponent = color.g;    // 0.0-1.0 range
double blueComponent = color.b;     // 0.0-1.0 range
double alphaComponent = color.a;    // 0.0-1.0 range

// Convert to integer if needed
int redInt = (color.r * 255.0).round() & 0xff;
int greenInt = (color.g * 255.0).round() & 0xff;
int blueInt = (color.b * 255.0).round() & 0xff;
```

#### **MaterialColor Creation with toARGB32()**

```dart
// ❌ DEPRECATED: Using Color.value in MaterialColor
MaterialColor primary = MaterialColor(color.value, swatch);

// ✅ CORRECT: Use toARGB32() for MaterialColor
MaterialColor primary = MaterialColor(color.toARGB32(), swatch);
```

#### **Testing Color Comparisons**

```dart
// ❌ DEPRECATED: Color.value in tests
expect(color.value, equals(0xFF2196F3));
expect(color.alpha, equals(255));

// ✅ CORRECT: Use toARGB32() and component accessors
expect(color.toARGB32(), equals(0xFF2196F3));
expect((color.a * 255.0).round() & 0xff, equals(255));

// For lerp tests with closeTo matcher
expect(
  lerpedColor.toARGB32(),
  closeTo(expectedColor.toARGB32(), 0x010101),
);
```

#### **Migration Checklist**

- [ ] Replace all `Color.value` with `Color.toARGB32()`
- [ ] Replace all `Color.alpha` with `(color.a * 255.0).round() & 0xff`
- [ ] Replace `Color.red/green/blue` with `Color.r/g/b` (floating-point)
- [ ] Replace all `withOpacity()` with `withValues(alpha: value)`
- [ ] Update MaterialColor constructors to use `toARGB32()`
- [ ] Update test expectations to use new methods
- [ ] Verify color precision in critical applications

#### **Why This Change?**

Flutter deprecated these properties to support **wide gamut color spaces** and improve color accuracy. The new methods provide explicit conversion with awareness of precision loss when converting from floating-point to 32-bit integer representation.

**Note**: `toARGB32()` may not produce identical results to `value` due to floating-point precision differences, but this is intentional for better color space support. Similarly, `withValues()` provides better precision control compared to `withOpacity()`.

### Environment Usage Patterns

**Navigation Usage (Most Common):**

```dart
// Declarative navigation with type safety
context.router.push(const HomeRoute());
context.router.pushAndClearStack(const LoginRoute());

// Route guard implementation
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isAuthenticated) {
      resolver.next();
    } else {
      router.pushAndClearStack(const LoginRoute());
    }
  }
}
```

**Data Modeling (Freezed + JSON):**

```dart
// Freezed model with JSON support
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    String? email,
    @Default(false) bool isActive,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}

// Freezed union types for state
@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserInitial;
  const factory UserState.loading() = UserLoading;
  const factory UserState.success(UserModel user) = UserSuccess;
  const factory UserState.failure(String message) = UserFailure;
}
```

**Functional Programming (Either Types):**

```dart
// Repository with Either for error handling
abstract class UserRepository {
  Future<Either<UserFailure, UserModel>> getUser(String id);
}

// BLoC integration with Either
Future<void> fetchUser(String id) async {
  emit(const UserState.loading());

  final result = await _userRepository.getUser(id);

  result.fold(
    (failure) => emit(UserState.failure(failure.message)),
    (user) => emit(UserState.success(user)),
  );
}
```

**Environment Access (Configuration):**

```dart
final apiUrl = EnvConfigFactory.apiUrl;
final appName = EnvConfigFactory.appName;
final isDebug = EnvConfigFactory.isDebugMode;
```

**Testing Patterns (DRY Compliance):**

```dart
// Standardized page testing
PageTestHelpers.testStandardPage<HomePage>(
  const HomePage(),
  'Hello World - Home',
  () => const HomePage(),
  (key) => HomePage(key: key),
);
```

**Image Asset Management (Pure Flutter):**

```dart
// Dependency injection (following existing patterns)
final assetService = GetIt.instance<AssetImageService>();
final appImages = GetIt.instance<AppImages>();

// Basic usage - responsive image with error handling
Widget buildProfileImage() {
  return assetService.assetImage(
    appImages.employeeAvatar,
    width: 96, // Automatically converted to 96.w
    height: 96, // Automatically converted to 96.h
    fit: BoxFit.cover,
  );
}

// Custom error and loading states
Widget buildSplashLogo() {
  return assetService.assetImage(
    appImages.splashLogo,
    width: appImages.imageSizes.large, // 144.0
    height: appImages.imageSizes.large,
    placeholder: const ShimmerLoading(),
    errorWidget: const Icon(Icons.error_outline),
  );
}

// Access to asset constants
Widget buildLoginBackground() {
  return assetService.assetImage(
    appImages.loginBackground,
    fit: BoxFit.cover,
  );
}

// Critical assets for preloading
Future<void> preloadCriticalAssets(BuildContext context) async {
  for (final assetPath in appImages.criticalAssets) {
    await precacheImage(AssetImage(assetPath), context);
  }
}

// Standard image sizes
final smallIcon = appImages.imageSizes.small;    // 48.0
final mediumIcon = appImages.imageSizes.medium;  // 96.0
final largeIcon = appImages.imageSizes.large;    // 144.0
final xLargeIcon = appImages.imageSizes.xLarge;  // 192.0
```

**Image Asset Testing (100% Coverage):**

```dart
// Test widget with image service
testWidgets('should display image with responsive sizing', (tester) async {
  final service = const AssetImageServiceImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          ScreenUtil.init(context, designSize: const Size(375, 812));
          return service.assetImage(
            'assets/images/test.png',
            width: 100,
            height: 100,
          );
        },
      ),
    ),
  );

  expect(find.byType(Image), findsOneWidget);
});

// Test error states
testWidgets('should handle error with default fallback', (tester) async {
  // Test triggers default Icon(Icons.broken_image) fallback
  expect(find.byIcon(Icons.broken_image), findsOneWidget);
});
```

**SVG Asset Management (flutter_svg Integration):**

```dart
// Dependency injection (following existing patterns)
final appIcons = GetIt.instance<AppIcons>();
final iconService = GetIt.instance<SvgIconService>();

// Basic usage - responsive SVG with theming support
Widget buildSearchIcon() {
  return iconService.svgIcon(
    appIcons.search,
    size: appIcons.iconSizes.medium, // 24px
    color: Theme.of(context).primaryColor,
  );
}

// Interactive SVG with tap handling
Widget buildNavigationIcon() {
  return iconService.svgIcon(
    appIcons.arrowBack,
    size: appIcons.iconSizes.large, // 32px
    color: Colors.white,
    onTap: () => Navigator.pop(context),
    semanticLabel: 'Go back',
  );
}

// Status indicators with color coding
Widget buildStatusIcon(AppState state) {
  final (iconPath, color) = switch (state) {
    AppState.success => (appIcons.success, Colors.green),
    AppState.error => (appIcons.error, Colors.red),
    AppState.warning => (appIcons.warning, Colors.orange),
    AppState.info => (appIcons.info, Colors.blue),
  };

  return iconService.svgIcon(iconPath, color: color);
}

// Critical SVG preloading for performance
Future<void> preloadCriticalSvgIcons(BuildContext context) async {
  for (final iconPath in appIcons.criticalIcons) {
    // SVGs are cached automatically by flutter_svg
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, iconPath),
      context,
    );
  }
}

// Standard icon sizes
final smallIcon = appIcons.iconSizes.small;    // 16px
final mediumIcon = appIcons.iconSizes.medium;  // 24px
final largeIcon = appIcons.iconSizes.large;    // 32px
final xLargeIcon = appIcons.iconSizes.xLarge;  // 48px
```

**SVG Asset Testing (100% TDD Coverage):**

```dart
// Test SVG service with responsive sizing
testWidgets('should display SVG icon with responsive sizing', (tester) async {
  final service = const SvgIconServiceImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          ScreenUtil.init(context, designSize: const Size(375, 812));
          return service.svgIcon(
            'assets/icons/ui/search.svg',
            color: Colors.blue,
          );
        },
      ),
    ),
  );

  expect(find.byType(SvgPicture), findsOneWidget);
});

// Test tap handling functionality
testWidgets('should handle tap events when provided', (tester) async {
  var tapped = false;
  final service = const SvgIconServiceImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: service.svgIcon(
        'assets/icons/ui/close.svg',
        onTap: () => tapped = true,
      ),
    ),
  );

  await tester.tap(find.byType(GestureDetector));
  expect(tapped, isTrue);
});

// Test icon size constants
test('should provide consistent icon size constants', () {
  final icons = const AppIconsImpl();
  expect(icons.iconSizes.small, equals(16));
  expect(icons.iconSizes.medium, equals(24));
  expect(icons.iconSizes.large, equals(32));
  expect(icons.iconSizes.xLarge, equals(48));
});
```

**Design System & Styling (Complete System):**

```dart
// Dependency injection (following existing patterns)
final appColors = GetIt.instance<AppColors>();
final appTextStyles = GetIt.instance<AppTextStyles>();
final appSizes = GetIt.instance<AppSizes>();

// Color usage - comprehensive palette system
Widget buildPrimaryButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColors.amberNormal,    // Main brand color
      foregroundColor: appColors.charcoal,      // Primary text color
    ),
    onPressed: () {},
    child: Text('Primary Button'),
  );
}

// Color variations - hover/active states
Container buildInteractiveCard({required bool isHovered, required bool isPressed}) {
  Color cardColor;
  if (isPressed) {
    cardColor = appColors.amberLightActive;    // Active state
  } else if (isHovered) {
    cardColor = appColors.amberLightHover;     // Hover state
  } else {
    cardColor = appColors.amberLight;          // Default state
  }

  return Container(
    color: cardColor,
    child: Text('Interactive Card'),
  );
}

// Typography system - consistent text styles
Widget buildTypographyExample() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Main Title', style: appTextStyles.displayLarge()),
      Text('Section Header', style: appTextStyles.headingLarge()),
      Text('Body content here', style: appTextStyles.bodyLarge()),
      Text('Small details', style: appTextStyles.bodySmall()),
      Text('Fine print', style: appTextStyles.caption()),
    ],
  );
}

// Responsive sizing - automatic responsive values
Widget buildResponsiveLayout() {
  return Container(
    width: appSizes.r120,      // 120px responsive (both width/height)
    height: appSizes.v80,      // 80px responsive height
    padding: EdgeInsets.all(appSizes.r16),  // 16px responsive padding
    margin: EdgeInsets.symmetric(
      horizontal: appSizes.h20,  // 20px responsive width
      vertical: appSizes.v12,    // 12px responsive height
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),
      color: appColors.lightGray,
    ),
  );
}

// Theme integration - light/dark mode support
Widget buildThemedWidget(BuildContext context) {
  final colorExtension = context.theme.extension<AppColorExtension>()!;

  return Container(
    color: colorExtension.primary,      // Automatically switches with theme
    child: Text(
      'Themed Content',
      style: appTextStyles.bodyLarge(
        color: colorExtension.textPrimary,  // Theme-aware text color
      ),
    ),
  );
}

// Complete color palette usage
Widget buildColorPaletteExample() {
  return Wrap(
    children: [
      // Amber palette (brand colors)
      Container(color: appColors.amberLight, width: 50, height: 50),
      Container(color: appColors.amberNormal, width: 50, height: 50),
      Container(color: appColors.amberDark, width: 50, height: 50),

      // Blue palette (informational)
      Container(color: appColors.blueLight, width: 50, height: 50),
      Container(color: appColors.blueNormal, width: 50, height: 50),
      Container(color: appColors.blueDark, width: 50, height: 50),

      // Green palette (success states)
      Container(color: appColors.greenLight, width: 50, height: 50),
      Container(color: appColors.greenNormal, width: 50, height: 50),
      Container(color: appColors.greenDark, width: 50, height: 50),

      // Red palette (error states)
      Container(color: appColors.redLight, width: 50, height: 50),
      Container(color: appColors.redNormal, width: 50, height: 50),
      Container(color: appColors.redDark, width: 50, height: 50),
    ],
  );
}

// State-based styling
Widget buildStatefulButton({
  required ButtonState state,
  required VoidCallback onPressed,
}) {
  final buttonColors = switch (state) {
    ButtonState.normal => appColors.amberNormal,
    ButtonState.hover => appColors.amberNormalHover,
    ButtonState.active => appColors.amberNormalActive,
    ButtonState.disabled => appColors.greyLight,
  };

  return ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: buttonColors),
    onPressed: state == ButtonState.disabled ? null : onPressed,
    child: Text(
      'Stateful Button',
      style: appTextStyles.bodyMedium(
        color: state == ButtonState.disabled
          ? appColors.greyNormal
          : appColors.charcoal,
      ),
    ),
  );
}
```

**Design System Testing (Type-Safe & Consistent):**

```dart
// Test design system integration
testWidgets('should use consistent colors throughout UI', (tester) async {
  final appColors = const AppColorsImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.amberNormal,
            ),
            onPressed: () {},
            child: Text('Test Button'),
          );
        },
      ),
    ),
  );

  expect(find.byType(ElevatedButton), findsOneWidget);

  final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
  final buttonStyle = button.style!;

  // Verify color consistency
  expect(
    buttonStyle.backgroundColor!.resolve({}),
    equals(appColors.amberNormal),
  );
});

// Test responsive sizing
testWidgets('should apply responsive sizing correctly', (tester) async {
  final appSizes = AppSizesImpl();

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          ScreenUtil.init(context, designSize: const Size(375, 812));
          return Container(
            width: appSizes.r100,  // Should be 100.w
            height: appSizes.v80,  // Should be 80.h
          );
        },
      ),
    ),
  );

  expect(find.byType(Container), findsOneWidget);
});
```

## ⚡ Quick Command Reference

**Most Used Commands (Copy-Paste Ready):**

```bash
# Daily workflow
make check && make test                    # Start of session
make format && make analyze                # After each edit
make pre-commit                            # Before commit

# Environment switching
make generate-env-dev && make run-dev
make generate-env-staging && make run-staging
make generate-env-prod && make run-prod

# Emergency fixes
flutter clean && flutter pub get && make generate-env-dev

# Navigation testing
flutter test test/features/*/presentation/pages/   # Test all page implementations
flutter test test/helpers/                        # Test page helpers
```

## Development Workflow

### Initial Setup

1. Run `make setup` for complete project initialization
2. Generate environment config: `make generate-env-dev`
3. Install dependencies: `make deps`
4. Verify setup: `make check`

### Environment Switching

Before running the app in a specific environment, generate the corresponding configuration:

```bash
# For development
make generate-env-dev && make run-dev

# For staging
make generate-env-staging && make run-staging

# For production
make generate-env-prod && make run-prod
```

### Pre-Commit Requirements

- **Format Check**: Code must be properly formatted
- **Analysis**: No warnings or errors from `dart analyze --fatal-infos`
- **i18n Generation**: Slang translation files must be generated (`dart run slang`)
- **License Validation**: Only business-safe licenses allowed (blocks GPL/copyleft)
- **Dependency Check**: No unused or missing dependencies

### CI/CD Requirements

The GitHub workflow automatically runs these steps in sequence:

1. Setup environment and dependencies (`flutter pub get`)
2. Generate environment config files
3. Generate code via build_runner
4. **Generate i18n files via slang** (`dart run slang`)
5. Format check and analysis
6. Run tests with coverage

⚠️ **Critical**: The `dart run slang` step is essential for CI success as it generates
`lib/l10n/gen/strings.g.dart` required by the analyze job. Without this step,
you'll get 136+ "Target of URI hasn't been generated" errors.

## Special Considerations

### License Compliance

This project enforces strict business-friendly license compliance:

- **Forbidden**: GPL, AGPL, LGPL, unknown licenses
- **Required**: MIT, BSD, Apache-2.0, ISC only
- **Validation**: Automatic blocking of problematic dependencies

### Build System

- **FVM**: Flutter version management (use `fvm` prefix for commands)
- **Very Good CLI**: Testing and coverage tooling
- **RPS Scripts**: Centralized script management via `rps.yaml`
- **Build Runner**: Code generation for environment configs

### Testing Requirements

- **Coverage**: Tests must maintain coverage standards
- **Environment Testing**: All environments must be tested
- **Integration Tests**: End-to-end environment workflow validation
- **Mock Testing**: Repository pattern enables comprehensive mocking

## 🚀 Mandatory Command Execution Protocol

**CRITICAL FOR CLAUDE CODE**: These commands MUST be executed during any coding session to prevent linting errors, warnings, and test failures. This is non-negotiable for code quality.

### 🎯 Before Making ANY Code Changes

**ALWAYS execute these commands first:**

```bash
# 1. Verify project health
make check                     # Format + analyze (2-3 seconds)
make test                      # Run all tests (10-15 seconds)

# Alternative commands
make check                    # Format + analyze
make test                     # Run tests
```

**Why**: Ensures you start with a clean baseline and don't introduce errors into already-broken code.

### 🔧 After Each Code Edit (MANDATORY)

**After EVERY code change, immediately run:**

```bash
# Quick validation loop (run after each file edit)
make format                   # Auto-fix formatting (1-2 seconds)
make analyze                  # Check for linting issues (2-3 seconds)

# If tests are affected, also run:
flutter test                  # Verify tests still pass (5-10 seconds)
```

**Integration with Code Changes:**

- Edit file → Save → Run `make format` → Run `make analyze`
- If tests affected → Run `flutter test`
- Fix any errors before continuing

### ✅ Before Final Response (NON-NEGOTIABLE)

**Before providing final code to user, MUST execute:**

```bash
# Complete validation pipeline
make pre-commit               # Format + analyze + test (full validation)

# Or step-by-step:
make format                   # 1. Fix formatting
make analyze                  # 2. Check linting
flutter test                  # 3. Verify tests pass
```

**If ANY command fails:**

- Fix the issues immediately
- Re-run the commands until all pass
- Only then provide the final response

### 🛡️ Error Prevention Strategy for Claude

#### **Level 1: Pre-Analysis Commands**

```bash
# Before analyzing user request
make check                    # Ensure current codebase is healthy
```

#### **Level 2: Continuous Validation**

```bash
# After each significant change
make format && make analyze
```

#### **Level 3: Final Validation**

```bash
# Before responding to user
make pre-commit               # Complete pipeline
```

### 🚨 Command Reference for Claude Code

| **When**            | **Commands**                   | **Purpose**           | **Time** |
| ------------------- | ------------------------------ | --------------------- | -------- |
| **Start Session**   | `make check && make test`      | Verify baseline       | 30s      |
| **After Each Edit** | `make format && make analyze`  | Continuous validation | 5s       |
| **Before Response** | `make pre-commit`              | Final validation      | 45s      |
| **Emergency**       | `make format` + `flutter test` | Minimum viable        | 10s      |

### 🎨 Tool Usage Priority for Claude

#### **1. Make Commands (Primary - Use These)**

```bash
make format                   # ⚡ Fastest formatting
make analyze                  # ⚡ Quick analysis
make test                     # ⚡ Test execution
make check                    # ⚡ Format + analyze combo
make pre-commit               # 🏆 Complete validation
```

#### **2. Makefile (CI Equivalent)**

```bash
make check                    # Quick health check
make test                     # Test execution
make local-ci                 # Full CI pipeline (when needed)
make test-coverage           # Coverage analysis
```

#### **3. Direct Commands (When Tools Fail)**

```bash
dart format lib/ test/ --set-exit-if-changed
dart analyze --fatal-infos
flutter test
very_good test --coverage
```

### ⚡ Emergency Protocols

#### **When Linting Fails:**

```bash
1. make format                  # Fix formatting first
2. dart analyze --fatal-infos   # See specific errors
3. Fix errors manually
4. make analyze                 # Verify fixes
```

#### **When Tests Fail:**

```bash
1. flutter clean && flutter pub get    # Reset environment
2. make generate-env-dev               # Regenerate configs
3. flutter test --dart-define=ENVIRONMENT=development
4. Fix failing tests
5. flutter test                        # Verify all pass
```

#### **When Environment Issues:**

```bash
1. make generate-env-dev               # Regenerate development
2. flutter pub get                     # Refresh dependencies
3. make check                          # Verify health
4. make test                           # Verify tests
```

### 🎯 Claude Code Success Checklist

**Before providing ANY code response:**

- [ ] ✅ `make format` - No formatting issues
- [ ] ✅ `make analyze` - No linting errors/warnings
- [ ] ✅ `flutter test` - All tests pass
- [ ] ✅ Code follows project patterns
- [ ] ✅ Documentation is complete (if public APIs)
- [ ] ✅ Environment-specific testing done (if needed)

**Zero Tolerance Items:**

- ❌ No linting errors or warnings
- ❌ No test failures
- ❌ No formatting inconsistencies
- ❌ No missing documentation on public APIs
- ❌ No license compliance violations
- ❌ No deprecated Color.value or Color.alpha usage (Flutter 3.27+)

### 📋 Claude Code Workflow Template

```bash
# 1. Start of coding session
make check && make test

# 2. For each code change iteration:
# Edit code → Save → Execute:
make format
make analyze
# Fix any issues → Repeat until clean

# 3. If tests affected:
flutter test
# Fix any failing tests

# 4. Before final response:
make pre-commit
# Must pass before providing code to user

# 5. For complex changes:
make coverage               # Verify coverage maintained
```

### 🔥 High-Speed Development Protocol

**For rapid iteration while maintaining quality:**

```bash
# Continuous validation loop (use during active coding)
make format && make analyze

# Parallel execution for speed
make format & make analyze & wait

# Quick test verification
flutter test --dart-define=ENVIRONMENT=development

# Final checkpoint
make pre-commit
```

### 🏆 Advanced Claude Workflows

#### **Multi-Environment Validation:**

```bash
# When environment changes are involved
make generate-env-dev && make test
make generate-env-staging && make test
make generate-env-prod && make test
```

#### **Coverage-Focused Development:**

```bash
# When adding new features
make coverage               # Generate coverage report
# Add tests for uncovered code
make coverage               # Verify improved coverage
```

#### **Performance Validation:**

```bash
# For performance-critical changes
flutter test --coverage --dart-define=ENVIRONMENT=development
make coverage
# Review performance impact in coverage report
```

## 🎖️ Claude Code Quality Standards

### **Command Execution Discipline:**

- **NEVER** provide code without running validation commands
- **ALWAYS** fix linting errors before responding
- **IMMEDIATELY** run tests after changing test-related code
- **CONTINUOUSLY** format and analyze during development

### **Response Standards:**

- Every code response must be preceded by successful command execution
- Any failing commands must be addressed and resolved
- Coverage should be maintained or improved
- All environments must be considered for environment-related changes

**Remember**: These commands are your quality assurance system. They prevent 95% of common issues and ensure professional-grade code delivery. Make them automatic and non-negotiable!

## 🌐 Internationalization with Slang

### Overview

This project uses [Slang](https://pub.dev/packages/slang) for type-safe internationalization instead of the traditional ARB-based approach. Slang provides compile-time translation safety, better IDE support, and more maintainable i18n code.

### File Structure

```
lib/l10n/
├── i18n/                     # Translation source files
│   ├── en.i18n.json          # English translations (base locale)
│   └── vi.i18n.json          # Vietnamese translations
└── gen/                      # Generated slang code
    └── strings.g.dart        # Generated translation classes
```

### Configuration (slang.yaml)

```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: lib/l10n/i18n
input_file_pattern: .i18n.json
output_directory: lib/l10n/gen
output_file_name: strings.g.dart
locale_handling: true
flutter_integration: true
translate_var: t
enum_name: AppLocale
class_name: Translations
```

### Essential Commands

```bash
# Development workflow
make i18n-generate           # Generate translations after editing JSON files
make i18n-watch              # Auto-generate during development (recommended)
make i18n-analyze            # Check translation coverage and completeness
make i18n-validate           # Validate translation files exist

# Maintenance
make i18n-clean              # Clean generated files when needed
make i18n-help               # Show detailed help and file locations
```

### Translation File Format

**English (en.i18n.json):**

```json
{
  "hello": "Hello",
  "welcome": "Welcome {name}",
  "items": {
    "one": "One item",
    "other": "{count} items"
  },
  "pages": {
    "home": {
      "title": "Home",
      "subtitle": "Welcome to the home page"
    }
  }
}
```

**Vietnamese (vi.i18n.json):**

```json
{
  "hello": "Xin chào",
  "welcome": "Chào mừng {name}",
  "items": {
    "other": "{count} mục"
  },
  "pages": {
    "home": {
      "title": "Trang chủ",
      "subtitle": "Chào mừng đến trang chủ"
    }
  }
}
```

### Usage in Code

```dart
// Import generated translations
import 'package:xp1/l10n/gen/strings.g.dart';

// Basic usage
Text(t.hello)                    // "Hello" / "Xin chào"
Text(t.welcome(name: 'John'))    // "Welcome John" / "Chào mừng John"

// Nested translations
Text(t.pages.home.title)         // "Home" / "Trang chủ"

// Pluralization
Text(t.items(count: 1))          // "One item" / "1 mục"
Text(t.items(count: 5))          // "5 items" / "5 mục"

// Context extension (with slang_flutter)
Widget build(BuildContext context) {
  return Text(context.t.hello);
}
```

### Locale Management

The project includes a complete DDD-based locale management system:

```dart
// Switch locale programmatically
await switchLocale(AppLocale.vi);

// Get current locale
final currentLocale = LocaleSettings.currentLocale;

// Available locales
final locales = AppLocaleUtils.supportedLocales;
```

### Development Workflow

#### 1. Adding New Translations

```bash
# 1. Edit JSON files in lib/l10n/i18n/
# Add new keys to en.i18n.json and vi.i18n.json

# 2. Generate updated Dart classes
make i18n-generate

# 3. Use in code with full type safety
Text(t.newKey)  # Auto-complete and type-safe!
```

#### 2. Live Development

```bash
# Start auto-generation (recommended during development)
make i18n-watch

# Edit translation files → Code regenerates automatically
# IDE will immediately show new translations with auto-complete
```

#### 3. Translation Validation

```bash
# Check for missing translations and coverage
make i18n-analyze

# Validate files exist and are valid JSON
make i18n-validate
```

### Git Hooks Integration

The project automatically validates i18n files on commit:

```yaml
# lefthook.yml - automatically validates translation changes
i18n-validation:
  glob: "lib/l10n/i18n/*.json"
  run: make i18n-validate
```

### Advanced Features

#### Parameterized Translations

```json
{
  "greeting": "Hello {name}, you have {count} messages",
  "formatted": "Today is {date}"
}
```

```dart
Text(t.greeting(name: 'Alice', count: 3))
Text(t.formatted(date: DateTime.now().toString()))
```

#### Rich Text Support

```json
{
  "richText": "Visit our {website(tap here)} for more info"
}
```

```dart
RichText(
  text: TextSpan(
    children: t.richText.richTextSpan(
      website: (text) => TextSpan(
        text: text,
        style: TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () => launchUrl(),
      ),
    ),
  ),
)
```

### Migration from ARB Files

If migrating from ARB-based i18n:

1. Convert ARB files to JSON format
2. Update imports from `AppLocalizations` to slang translations
3. Replace `context.l10n.key` with `t.key` or `context.t.key`
4. Run `make i18n-generate` to generate new classes
5. Update all usage sites with type-safe alternatives

### Troubleshooting

#### Common Issues

**1. Missing translations:**

```bash
make i18n-analyze  # Shows coverage report
```

**2. JSON syntax errors:**

```bash
make i18n-validate  # Validates JSON files
```

**3. Generated files out of sync:**

```bash
make i18n-clean && make i18n-generate  # Clean rebuild
```

**4. IDE not recognizing new translations:**

```bash
# Restart IDE after generation, or use:
make i18n-watch  # For auto-generation during development
```

## 🌐 Language Requirements - English Only Policy

### 📝 **MANDATORY: English Language for All Content**

**CRITICAL RULE**: All code, documentation, comments, and markdown files MUST be written in English only. This is non-negotiable for:

1. **Spell Check Compliance**: Prevents cspell errors in CI/CD
2. **International Collaboration**: Ensures global accessibility
3. **Professional Standards**: Maintains consistent codebase language
4. **Tool Compatibility**: Works with all development tools and IDEs

### 🚫 **What Must Be English**

#### **Code Content**

```dart
// ❌ WRONG: Non-English comments
/// [Non-English documentation example]
class CounterCubit extends Cubit<int> {
  /// [Non-English constructor documentation]
  CounterCubit() : super(0);

  /// [Non-English method documentation]
  void increment() => emit(state + 1); // [Non-English comment]
}

// ✅ CORRECT: English comments and documentation
/// Manages counter state with increment and decrement operations.
class CounterCubit extends Cubit<int> {
  /// Creates a CounterCubit with initial state of 0.
  CounterCubit() : super(0);

  /// Increments the counter value by 1.
  void increment() => emit(state + 1); // Increment the value
}
```

#### **Documentation Files**

```markdown
❌ WRONG: Non-English markdown content

# [Non-English Environment Configuration Title]

## [Non-English Overview Section]

[Non-English environment management description]...

✅ CORRECT: English markdown content

# Environment Configuration with Envied

## Overview

Multiple environment management system...
```

#### **Comments and Strings**

```dart
// ❌ WRONG: Non-English strings and comments
const appTitle = '[Non-English App Title]'; // [Non-English comment]
// TODO: [Non-English task description]

// ✅ CORRECT: English strings and comments
const appTitle = 'Counter Application'; // Application title
// TODO: Add counter reset feature
```

### ✅ **English Language Checklist**

Before any commit, verify:

- [ ] **All documentation** (README, guides, etc.) is in English
- [ ] **All code comments** are in English
- [ ] **All string literals** for UI are either in English or use i18n keys
- [ ] **All commit messages** follow conventional commits in English
- [ ] **All variable/method names** use English terminology
- [ ] **All test descriptions** are in English

### 🛠️ **Spell Check Integration**

Our cspell configuration enforces English-only content:

```json
{
  "language": "en",
  "dictionaries": ["vgv_allowed", "vgv_forbidden"]
}
```

**When spell check fails:**

1. Convert non-English content to English
2. Add technical terms to `cspell.json` words array if needed
3. Never suppress spell check with ignore comments

### 🎯 **Vibe Coding English Protocol**

#### **During Active Coding:**

```bash
# After creating any markdown or documentation
npx cspell doc/**/*.md --no-progress    # Verify English content

# After adding comments or strings
make analyze                            # Check for linting issues
```

#### **Content Creation Guidelines:**

1. **Documentation Files**: Always write in clear, professional English
2. **Code Comments**: Use concise English explanations
3. **Variable Names**: Follow English naming conventions
4. **Error Messages**: Use English for user-facing messages
5. **Test Descriptions**: Write test cases in English

#### **Common English Documentation Patterns:**

| English Term      | Usage                  | Context                     |
| ----------------- | ---------------------- | --------------------------- |
| `Overview`        | Documentation sections | High-level introductions    |
| `Configuration`   | Settings and setup     | System configuration guides |
| `Architecture`    | System design          | Technical architecture docs |
| `Usage`           | How-to guides          | Implementation instructions |
| `Troubleshooting` | Error resolution       | Problem-solving guides      |

### 🚨 **Pre-Commit English Validation**

Add to your workflow:

```bash
# Validate English content before commit
npx cspell doc/**/*.md README.md --no-progress
make analyze          # Includes comment validation
make format           # Ensures consistent formatting

# Full validation
make pre-commit       # Must pass for English compliance
```

### 📚 **English Documentation Standards**

#### **Markdown Files:**

- Use clear, professional English
- Follow standard technical writing conventions
- Prefer active voice over passive voice
- Use consistent terminology throughout

#### **Code Documentation:**

- Use complete sentences for class/method documentation
- Follow Dart documentation standards with `///`
- Include parameter descriptions with `[paramName]` syntax
- Provide usage examples in English

#### **Error Messages:**

```dart
// ❌ WRONG: Non-English error messages
throw Exception('[Non-English error message]');

// ✅ CORRECT: English error messages
throw ConfigurationException('Failed to load configuration');
```

### 🔧 **Tools for English Compliance**

#### **Editor Integration:**

- VS Code: Install "Code Spell Checker" extension
- Set language to English in editor settings
- Enable real-time spell checking

#### **Git Hooks:**

- Pre-commit hooks run spell check automatically
- Blocks commits with non-English content
- Provides immediate feedback on language issues

#### **CI/CD Integration:**

- GitHub Actions runs spell check on all markdown files
- Fails build if non-English content is detected
- Generates reports of language compliance issues

### 💡 **Best Practices Summary**

1. **Always Default to English**: When in doubt, use English
2. **Consistent Terminology**: Use the same English terms throughout the project
3. **Professional Tone**: Write documentation as if for international users
4. **Tool Integration**: Leverage spell check and linting tools
5. **Review Process**: Check English compliance during code reviews

This English-only policy ensures our codebase remains accessible, professional, and compatible with all development tools and international collaboration standards.

# important-instruction-reminders

Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (\*.md) or README files. Only create documentation files if explicitly requested by the User.

      IMPORTANT: this context may or may not be relevant to your tasks. You should not respond to this context unless it is highly relevant to your task.
