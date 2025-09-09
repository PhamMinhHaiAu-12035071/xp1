# Xp1

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

---

## Getting Started 🚀

### Prerequisites

Before running this project, ensure you have the following system dependencies installed:

- **lcov**: Required for generating HTML coverage reports
  - **macOS**: `brew install lcov`
  - **Ubuntu/Debian**: `sudo apt-get install lcov`
  - **Windows**: Install via [Chocolatey](https://chocolatey.org/) with `choco install lcov` or download from [lcov releases](https://github.com/linux-test-project/lcov/releases)

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Xp1 works on iOS, Android, Web, and Windows._

---

## Project Structure 🏗️

This project follows a **layered architecture** with **Atomic Design principles** for widget organization:

```
lib/
├── core/                           # 🔧 INFRASTRUCTURE LAYER
│   ├── widgets/                    # Framework & app-wide utilities
│   │   ├── responsive_initializer.dart  # Global responsive setup
│   │   ├── base_scaffold.dart          # Framework utilities
│   │   └── loading_overlay.dart        # App-wide utilities
│   ├── styles/                     # Design system
│   ├── themes/                     # Theme configuration
│   └── infrastructure/             # Cross-cutting concerns
├── shared/                         # 🧱 BUSINESS LAYER
│   ├── widgets/                    # Reusable business components
│   │   ├── atoms/                  # Basic UI elements
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_input.dart
│   │   │   └── custom_card.dart
│   │   ├── molecules/              # Composite components
│   │   │   ├── search_bar.dart
│   │   │   ├── user_avatar.dart
│   │   │   └── stats_card.dart
│   │   └── organisms/              # Complex UI sections
│   │       ├── navigation_drawer.dart
│   │       └── header_section.dart
│   └── utilities/                  # Business utilities
├── features/                       # 📱 FEATURE LAYER
│   ├── splash/                     # 🚀 Splash screen feature
│   │   └── presentation/
│   │       ├── cubit/              # State management
│   │       ├── pages/              # SplashPage
│   │       └── widgets/            # Atomic design components
│   │           ├── atomic/
│   │           │   ├── atoms/      # Basic splash elements
│   │           │   ├── molecules/  # Composite splash components
│   │           │   └── organisms/  # Complex splash layouts
│   │           └── splash_content.dart
│   ├── home/
│   │   └── presentation/
│   │       ├── pages/              # 📄 Full-screen pages
│   │       └── widgets/            # 🏠 Feature-specific widgets
│   ├── authentication/
│   └── profile/
└── l10n/                          # 🌐 Internationalization
```

### Widget Organization Strategy

#### 1. **Core Widgets** (`lib/core/widgets/`)

- **Purpose**: Infrastructure and framework-level widgets
- **Examples**: `ResponsiveInitializer`, `BaseScaffold`, `LoadingOverlay`
- **When to use**: App-wide utilities, framework extensions, global setup

#### 2. **Shared Widgets** (`lib/shared/widgets/`)

- **Purpose**: Reusable business components following Atomic Design
- **Structure**:
  - **Atoms**: Basic UI building blocks (buttons, inputs, cards)
  - **Molecules**: Composite components (search bars, user avatars)
  - **Organisms**: Complex UI sections (navigation drawers, headers)
- **When to use**: Components used across multiple features

#### 3. **Feature Widgets** (`lib/features/*/widgets/`)

- **Purpose**: Feature-specific components
- **Examples**: `HomeCarousel`, `ProfileForm`, `LoginButton`
- **When to use**: Components specific to one feature only

---

## Tech Stack 🛠️

### State Management & Architecture

- **BLoC Pattern**: Advanced state management with business logic separation
- **Hydrated BLoC**: Persistent state management with automatic restoration
- **Replay BLoC**: Undo/Redo functionality for enhanced user experience

### Data Modeling & Serialization

- **Freezed**: Type-safe immutable data classes with code generation
- **JSON Serialization**: Automatic JSON handling with json_serializable
- **Functional Programming**: Error handling with Either types (fpdart)

### Navigation & User Experience

- **Auto Route**: Type-safe navigation with declarative route configuration
- **Native Splash Screen**: Professional splash screens with `flutter_native_splash`
- **Simplified Splash Architecture**: Optimized 2-second splash with automatic navigation

### Development Tools

- **Code Generation**: Automatic model and serialization generation
- **Very Good Analysis**: 130+ strict linting rules for code quality
- **Multi-Environment**: Development, staging, and production configurations

---

## Quality Assurance 🛡️

This project enforces strict quality standards to prevent production failures:

- **License Compliance**: Blocks GPL/copyleft dependencies that could create legal issues
- **Dependency Validation**: Catches unused/missing dependencies before they break builds
- **Semantic Commits**: Ensures clean changelog generation and proper versioning

See `.github/workflows/main.yaml` for implementation details.

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project uses [Slang](https://pub.dev/packages/slang) for type-safe internationalization with compile-time translation safety and better IDE support.

### File Structure

```
lib/l10n/
├── i18n/                     # Translation source files
│   ├── en.i18n.json          # English translations (base locale)
│   └── vi.i18n.json          # Vietnamese translations
└── gen/                      # Generated slang code
    └── strings.g.dart        # Generated translation classes
```

### Adding Strings

1. Edit the JSON translation files in `lib/l10n/i18n/`:

**English (`en.i18n.json`):**

```json
{
  "hello": "Hello",
  "welcome": "Welcome {name}",
  "pages": {
    "home": {
      "title": "Home",
      "subtitle": "Welcome to the home page"
    }
  }
}
```

**Vietnamese (`vi.i18n.json`):**

```json
{
  "hello": "Xin chào",
  "welcome": "Chào mừng {name}",
  "pages": {
    "home": {
      "title": "Trang chủ",
      "subtitle": "Chào mừng đến trang chủ"
    }
  }
}
```

2. Generate the updated Dart classes:

```sh
make i18n-generate
# Or: dart run slang
```

3. Use the new translations with full type safety:

```dart
import 'package:xp1/l10n/gen/strings.g.dart';

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text(t.hello),                          // "Hello" / "Xin chào"
      Text(t.welcome(name: 'John')),          // "Welcome John" / "Chào mừng John"
      Text(t.pages.home.title),               // "Home" / "Trang chủ"

      // Or use context extension
      Text(context.t.hello),
    ],
  );
}
```

### Translation Commands

```sh
# Essential commands
make i18n-generate           # Generate translations from JSON files
make i18n-watch              # Auto-generate during development (recommended)
make i18n-analyze            # Check translation coverage
make i18n-validate           # Validate translation files

# Maintenance
make i18n-clean              # Clean generated files
make i18n-help               # Show detailed help
```

### Development Workflow

1. **Live Development**: Use `make i18n-watch` for automatic code generation while editing translation files
2. **Adding Translations**: Edit JSON files → Run `make i18n-generate` → Use with full type safety
3. **Validation**: Use `make i18n-analyze` to check for missing translations

### Advanced Features

- **Parameterized strings**: `"greeting": "Hello {name}"`
- **Pluralization**: Automatic plural forms based on count
- **Nested translations**: Organize translations hierarchically
- **Rich text support**: For complex formatted text
- **Compile-time safety**: No more runtime translation errors!

---

## Asset Management 🖼️

### Complete Asset Management System

This project implements a comprehensive asset management system supporting both **images** and **SVG icons** with contract-service architecture patterns:

#### 🖼️ Image Asset Management (Pure Flutter)

- **🚀 Pure Flutter Approach**: No external image libraries - uses built-in `Image.asset()` + `ImageCache`
- **📱 Responsive Sizing**: Automatic integration with `flutter_screenutil` for responsive design
- **🛡️ Error Handling**: Built-in error fallbacks with customizable error widgets
- **⏳ Loading States**: Automatic loading indicators with placeholder support
- **🏗️ Architecture**: Clean DI pattern with `AppImages` contract + `AssetImageService`
- **✅ Test Coverage**: 100% test coverage with TDD approach

#### 🎯 SVG Icon Management (flutter_svg)

- **🎨 SVG Support**: Full SVG rendering with `flutter_svg` package integration
- **🌈 Color Filtering**: Dynamic color theming and interaction states
- **📐 Responsive Icons**: Automatic sizing with predefined size constants
- **👆 Interactive Icons**: Built-in tap handling with visual feedback
- **♿ Accessibility**: Semantic labels and ARIA support
- **🔧 Service Pattern**: `AppIcons` contract + `SvgIconService` architecture

### Quick Usage

#### Image Assets

```dart
// Inject image services
final imageService = GetIt.instance<AssetImageService>();

// Display responsive image with error handling and placeholder
Widget buildSplashImage() {
  return imageService.renderImage(
    assetPath: AppImages.welcomeImage,
    width: 300,    // Responsive width
    height: 200,   // Responsive height
    fit: BoxFit.contain,
    semanticLabel: 'App welcome logo',
    placeholder: Container(
      width: 300.w,
      height: 200.h,
      color: Colors.grey.shade200,
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
}

// Precache images for performance
await imageService.precacheImage(AppImages.welcomeImage, context);
```

#### SVG Icons

```dart
// Inject SVG services
final svgService = GetIt.instance<SvgIconService>();

// Display interactive SVG icon with color theming
Widget buildNavigationIcon({required bool isSelected}) {
  return svgService.renderIcon(
    assetPath: AppIcons.homeIcon,
    size: AppIcons.medium,           // Predefined size constants
    color: isSelected ? Colors.blue : Colors.grey,
    onTap: () => handleNavigation(),
    semanticLabel: 'Home navigation',
  );
}

// Use predefined icon sizes
final iconSize = AppIcons.large; // 32.0
```

### Asset Organization

```
assets/
├── images/                    # 🖼️ Image Assets
│   ├── common/                # Shared images (logo.png)
│   ├── splash/                # Splash screen assets (welcome.png)
│   ├── login/                 # Login screen assets
│   ├── employee/              # Employee-related assets
│   └── placeholders/          # Placeholder images
└── icons/                     # 🎯 SVG Icon Assets
    ├── navigation/            # Navigation icons (home.svg, profile.svg)
    ├── action/                # Action icons (edit.svg, delete.svg, save.svg)
    ├── status/                # Status icons (success.svg, error.svg)
    └── ui/                    # UI icons (search.svg, filter.svg, menu.svg)
```

### Key Benefits

#### Images

- **Performance**: Built-in `ImageCache` handles caching automatically
- **Reliability**: Error states never fail - always shows fallback widgets
- **Responsive**: Automatic responsive sizing with `flutter_screenutil`
- **Loading States**: Built-in placeholder support for smooth UX

#### SVG Icons

- **Scalability**: Vector graphics scale perfectly at any size
- **Theming**: Dynamic color filtering for consistent design systems
- **Interactivity**: Built-in tap handling with visual feedback
- **Accessibility**: Semantic labels for screen readers

#### Architecture

- **Type Safety**: No magic strings - all paths are typed constants
- **Maintainability**: Centralized asset path management with contracts
- **Testability**: 100% test coverage with mocked services
- **Consistency**: Unified patterns across all asset types

---

## Splash Screen System 🚀

### Native + Flutter Splash Integration

This project implements a comprehensive splash screen system combining **native splash screens** with **Flutter-based splash functionality**:

#### 🏃‍♂️ Native Splash Screen (flutter_native_splash)

- **⚡ Instant Loading**: Native splash displays immediately on app launch
- **🎨 Platform Optimized**: Automatically generates platform-specific assets
- **🌈 Consistent Branding**: Orange background (#FF9800) across all platforms
- **📱 Multi-Platform**: Android, iOS, and Web support with Android 12 compatibility

#### 🛠️ Flutter Splash Feature

- **🏗️ Simplified Architecture**: Clean cubit-based state management
- **⏱️ Timed Navigation**: Automatic 2-second delay with error handling
- **🧱 Atomic Design**: Components organized as atoms, molecules, and organisms
- **🎯 Type-Safe**: Freezed states with comprehensive error handling

### Quick Implementation

#### Native Splash Configuration

```yaml
# flutter_native_splash.yaml
flutter_native_splash:
  color: "#FF9800" # Orange background
  color_dark: "#FF9800" # Dark mode support

  android_12: # Android 12 compatibility
    color: "#FF9800"
    color_dark: "#FF9800"

  web: true # Multi-platform support
  android: true
  ios: true

  remove_after_delay: true # Auto-remove native splash
```

#### Flutter Splash Usage

```dart
// Simple cubit-based splash with automatic navigation
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future<void> initialize() async {
    emit(const SplashState.loading());

    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(const SplashState.completed());
    } catch (error) {
      emit(SplashState.error(error.toString()));
    }
  }
}

// Atomic design splash components
Widget buildSplashContent() {
  return const SplashLayout(        // Organism: Complete layout
    child: SplashContent(           // Molecule: Content grouping
      logo: SplashLogo(),           // Atom: Logo element
      indicator: CircularProgressIndicator(),
    ),
  );
}
```

### Development Commands

```sh
# Native splash setup and testing
make splash-setup            # Generate native splash assets
make splash-test             # Test splash configuration
make splash-clean            # Clean generated splash files

# Development workflow
make run-dev                 # Run with splash in development mode
make build-release           # Build with optimized splash
```

### Architecture Benefits

- **Performance**: Native splash eliminates loading delays
- **User Experience**: Seamless transition from native to Flutter splash
- **Maintainability**: Simplified architecture with clear responsibilities
- **Testing**: Full test coverage with both unit and widget tests
- **Cross-Platform**: Consistent experience across all platforms

---

## Design System & Styling 🎨

### Comprehensive Design System

This project implements a **complete design system** with colors, typography, spacing, and theming following established architectural patterns:

- **🎨 Color System**: Complete color palettes with light/normal/dark/hover/active variants
- **✍️ Typography Scale**: 8-level typography system with Public Sans font family
- **📏 Responsive Sizing**: Comprehensive sizing system with responsive variants (r/v/h)
- **🌙 Theme Support**: Full light/dark mode with custom theme extensions
- **🏗️ Architecture**: Clean DI pattern with abstract + implementation
- **📱 Material 3**: Full Material Design 3 integration with custom extensions

### Quick Usage

```dart
// Inject design system services
final appColors = GetIt.instance<AppColors>();
final appTextStyles = GetIt.instance<AppTextStyles>();
final appSizes = GetIt.instance<AppSizes>();

// Use comprehensive color system
Widget buildBrandButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColors.amberNormal,  // Main brand color
      foregroundColor: appColors.charcoal,    // Primary text
    ),
    onPressed: () {},
    child: Text(
      'Brand Button',
      style: appTextStyles.bodyLarge(),       // Typography system
    ),
  );
}

// Responsive layout with consistent spacing
Widget buildResponsiveCard() {
  return Container(
    width: appSizes.r120,                     // 120px responsive
    padding: EdgeInsets.all(appSizes.r16),   // 16px responsive padding
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(appSizes.borderRadiusMd),
      color: appColors.lightGray,
    ),
    child: Text(
      'Responsive Card',
      style: appTextStyles.headingMedium(color: appColors.charcoal),
    ),
  );
}
```

### Color System

Complete color palettes with semantic naming and interaction states:

- **Brand Colors**: Amber palette (light, normal, dark, hover, active)
- **Neutral Colors**: Grey palette with comprehensive variations
- **Semantic Colors**: Blue (info), Green (success), Red (error), Pink, Orange
- **Theme Colors**: Automatic light/dark mode support
- **Interactive States**: Hover and active states for all colors

### Typography System

8-level typography scale based on Public Sans:

- **Display Large** (36px) - Hero text, main titles
- **Display Medium** (32px) - Section headings
- **Heading Large** (24px) - Page titles
- **Heading Medium** (20px) - Subsection headers
- **Body Large** (16px) - Primary body text
- **Body Medium** (14px) - Secondary text
- **Body Small** (12px) - Metadata
- **Caption** (10px) - Fine print

### Responsive Sizing

Three variants for every dimension:

- **r** (responsive) - Both width and height
- **v** (vertical) - Height only
- **h** (horizontal) - Width only

Comprehensive scale: 2px → 680px with specialized sizes for common use cases.

### Key Benefits

- **Consistency**: Type-safe design tokens prevent inconsistent styling
- **Performance**: Centralized styling with dependency injection
- **Maintainability**: Single source of truth for all design decisions
- **Accessibility**: Semantic color naming and proper contrast ratios
- **Developer Experience**: IntelliSense support with comprehensive documentation

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
