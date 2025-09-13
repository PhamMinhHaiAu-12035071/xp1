# Agent Instructions for Flutter XP1

## 📋 Table of Contents

- [Quick Reference](#-quick-reference)
- [AI Coding Guidelines](#-ai-coding-guidelines)
- [Project Overview](#project-overview)
- [Architecture & Repository Overview](#architecture--repository-overview)
- [Key Development Workflows](#key-development-workflows)
- [Communication Guidelines](#communication-guidelines)

## 🚀 Quick Reference

### Essential Commands

| Task                     | Command                                                    | Time | Notes               |
| ------------------------ | ---------------------------------------------------------- | ---- | ------------------- |
| **Quick Check**          | `make check`                                               | ~30s | Format + analyze    |
| **Run Tests**            | `make test`                                                | ~2m  | Unit tests only     |
| **Full Coverage**        | `make coverage`                                            | ~4m  | With HTML report    |
| **Code Generation**      | `dart run build_runner build --delete-conflicting-outputs` | ~2m  | After model changes |
| **Dev Environment**      | `make run-dev`                                             | ~1m  | Development flavor  |
| **Staging Environment**  | `make run-staging`                                         | ~1m  | QA testing          |
| **Production Build**     | `make run-prod`                                            | ~1m  | Production config   |
| **Complete CI Pipeline** | `make local-ci`                                            | ~8m  | Full validation     |
| **Translations**         | `make i18n-generate`                                       | ~30s | Update i18n classes |
| **License Check**        | `make license-check`                                       | ~15s | Business compliance |

### Quality Gates (Must Pass)

- ✅ **Zero linting errors** - `very_good_analysis` strict compliance
- ✅ **80%+ test coverage** - Exclude generated files only
- ✅ **All tests passing** - Unit, widget, and integration tests
- ✅ **License compliance** - Business-safe licenses only
- ✅ **Build success** - All environments (dev, staging, prod)

### Emergency Commands

```bash
# Clean and regenerate everything
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
flutter clean && flutter pub get

# Fix most common issues
make format
make check
make test
```

## 🤖 AI Coding Guidelines

### Code Generation Preferences

**Always Generate:**

- `final` for immutable variables, `const` constructors when possible
- Comprehensive error handling with `Either<Failure, Success>` pattern
- Logging for all business operations using `logger` package
- Public API documentation for all public members
- Corresponding tests for all business logic

**Code Style Requirements:**

- English only for all code, comments, and documentation
- Line length limit: 80 characters (strictly enforced)
- No `print()` statements - use `logger` package instead
- Cascade operators (..) for 2+ method calls on same object
- Alphabetical import sorting within categories
- Use `withValues(alpha: value)` instead of deprecated `withOpacity()`

### Common Patterns to Generate

#### 1. BLoC State Management Pattern

```dart
// Always use Freezed for states
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = FeatureInitial;
  const factory FeatureState.loading() = FeatureLoading;
  const factory FeatureState.loaded(List<Data> data) = FeatureLoaded;
  const factory FeatureState.error(String message) = FeatureError;
}

// Always use Injectable for cubits
@injectable
class FeatureCubit extends Cubit<FeatureState> {
  FeatureCubit(this._repository) : super(const FeatureState.initial());

  final FeatureRepository _repository;

  Future<void> loadData() async {
    emit(const FeatureState.loading());
    final result = await _repository.getData();
    result.fold(
      (failure) => emit(FeatureState.error(failure.message)),
      (data) => emit(FeatureState.loaded(data)),
    );
  }
}
```

#### 2. Repository Pattern with Error Handling

```dart
// Always use Either for repository returns
abstract class FeatureRepository {
  Future<Either<Failure, List<Data>>> getData();
}

@LazySingleton(as: FeatureRepository)
class FeatureRepositoryImpl implements FeatureRepository {
  FeatureRepositoryImpl(this._apiService);

  final FeatureApiService _apiService;

  @override
  Future<Either<Failure, List<Data>>> getData() async {
    try {
      final response = await _apiService.getData();
      return Right(response.body);
    } on Exception catch (error, stackTrace) {
      logger.e('Failed to get data', error: error, stackTrace: stackTrace);
      return Left(Failure('Failed to load data'));
    }
  }
}
```

#### 3. Chopper API Service Pattern

```dart
@ChopperApi(baseUrl: '/api/v1')
abstract class FeatureApiService extends ChopperService {
  @Get(path: '/features')
  Future<Response<List<FeatureModel>>> getFeatures();

  @Post(path: '/features')
  Future<Response<FeatureModel>> createFeature(
    @Body() CreateFeatureRequest request,
  );

  static FeatureApiService create([ChopperClient? client]) =>
      _$FeatureApiService(client);
}
```

#### 4. Widget Testing Pattern

```dart
testWidgets('renders correctly with loading state', (tester) async {
  // Arrange
  when(() => mockCubit.state).thenReturn(const FeatureState.loading());

  // Act
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: mockCubit,
        child: const FeatureView(),
      ),
    ),
  );

  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Loading...'), findsOneWidget);
});
```

### AI Decision Trees

**When to Use BLoC vs StatefulWidget:**

- ✅ **Use BLoC**: Business logic, API calls, complex state, shared state
- ✅ **Use StatefulWidget**: Simple UI state, animations, form controllers

**When to Use Repository vs Direct API:**

- ✅ **Use Repository**: All data access, business logic, testing isolation
- ❌ **Direct API**: Never - always abstract through repository

**When to Use Injectable vs Manual DI:**

- ✅ **Use Injectable**: All services, repositories, API clients
- ❌ **Manual DI**: Never - always use Injectable for consistency

### AI Agent Context

**Before Generating Any Code:**

1. ✅ Check existing patterns in the codebase first
2. ✅ Follow layered architecture (Core → Shared → Features)
3. ✅ Use atomic design for widgets (Atoms → Molecules → Organisms)
4. ✅ Follow BLoC state management with Freezed states
5. ✅ Use Injectable DI for all services and repositories
6. ✅ Include comprehensive error handling with Either types
7. ✅ Generate corresponding tests for all business logic
8. ✅ Follow very_good_analysis linting rules strictly
9. ✅ Use English only for all code and documentation
10. ✅ Include proper logging instead of print statements

**Code Quality Checklist for AI:**

- ✅ All public APIs documented
- ✅ Error handling implemented
- ✅ Tests generated for business logic
- ✅ Injectable annotations applied
- ✅ Proper import organization
- ✅ Line length under 80 characters
- ✅ No linting violations
- ✅ Semantic variable names

**Performance Considerations for AI:**

- ✅ Use const constructors when possible
- ✅ Implement lazy loading for heavy operations
- ✅ Optimize widget rebuilds with proper state management
- ✅ Use flutter_screenutil for responsive layouts
- ✅ Implement proper image caching and sizing

## Project Overview

**XP1** is a production-ready Flutter application built with Very Good CLI, following **layered architecture** with **Atomic Design principles**. This is a multi-platform app (iOS, Android, Web, Windows) with comprehensive state management, networking, testing infrastructure, and strict quality standards. **Code quality and maintainability are the highest priorities** - all code must pass very_good_analysis linting rules and maintain high test coverage to ensure production reliability.

## Architecture & Repository Overview

**Core Components:**

- **Layered Architecture**: Core → Shared → Features with clear separation of concerns
- **Atomic Design System**: Atoms → Molecules → Organisms for UI components
- **BLoC State Management**: Advanced state management with business logic separation
- **Dependency Injection**: Injectable/GetIt pattern for scalable architecture
- **Multi-Environment**: Development, staging, and production configurations
- **Asset Management**: Comprehensive image and SVG management with service contracts

**Repository Details:**

- **Size & Type:** Medium-scale Flutter project (~180 files) focused on mobile-first development with web and desktop support
- **Primary Language:** Dart 3.8+ with Flutter 3.24+ framework
- **Key Frameworks:** flutter_bloc, injectable/get_it, chopper, freezed, auto_route, slang
- **Code Generation:** Extensive use of build_runner for models, services, routing, and i18n
- **Testing Stack:** flutter_test, bloc_test, mocktail with very_good_cli coverage reporting
- **Quality Assurance:** very_good_analysis linting (130+ rules), license compliance, semantic commits

**Core Dependencies:**

- **State Management**: flutter_bloc ^9.1.1, hydrated_bloc ^10.1.1, replay_bloc ^0.3.0
- **Networking**: chopper ^8.0.3 with pretty_chopper_logger ^1.3.0
- **Code Generation**: freezed ^3.2.0, json_serializable ^6.7.1, injectable ^2.5.1
- **Navigation**: auto_route ^10.1.2 with auto_route_generator ^10.2.4
- **Internationalization**: slang ^4.8.1 with slang_flutter ^4.8.0
- **Security**: flutter_secure_storage ^9.2.2, envied ^1.2.0

## Key Development Workflows

### Project Structure & Architecture

**Critical Directory Layout:**

```
lib/
├── app/                               # Application entry point and bootstrap
├── bootstrap.dart                     # App initialization and configuration
├── main_development.dart              # Development flavor entry point
├── main_staging.dart                  # Staging flavor entry point
├── main_production.dart               # Production flavor entry point
├── core/                              # 🔧 INFRASTRUCTURE LAYER
│   ├── widgets/                       # Framework & app-wide utilities
│   │   ├── responsive_initializer.dart # Global responsive setup
│   │   ├── base_scaffold.dart         # Framework utilities
│   │   └── loading_overlay.dart       # App-wide utilities
│   ├── styles/                        # Design system (colors, typography)
│   ├── themes/                        # Theme configuration
│   ├── infrastructure/                # Cross-cutting concerns
│   │   ├── injection/                 # Dependency injection setup
│   │   ├── network/                   # HTTP client configuration
│   │   ├── storage/                   # Secure storage services
│   │   └── monitoring/                # Logging and analytics
│   ├── di/                           # Dependency injection modules
│   └── network/                      # Networking infrastructure
├── shared/                           # 🧱 BUSINESS LAYER
│   ├── widgets/                      # Reusable business components
│   │   ├── atoms/                    # Basic UI elements (buttons, inputs)
│   │   ├── molecules/                # Composite components (search bars)
│   │   └── organisms/                # Complex UI sections (nav drawers)
│   └── utilities/                    # Business utilities
├── features/                         # 📱 FEATURE LAYER
│   ├── splash/                       # 🚀 Splash screen feature
│   │   └── presentation/
│   │       ├── cubit/                # State management
│   │       ├── pages/                # SplashPage
│   │       └── widgets/              # Feature-specific widgets
│   ├── authentication/               # 🔐 Authentication feature
│   │   ├── data/                     # Data layer (repositories, models)
│   │   ├── domain/                   # Domain layer (entities, use cases)
│   │   ├── infrastructure/           # Infrastructure (API services)
│   │   └── presentation/             # Presentation layer (pages, cubits)
│   ├── home/                         # 🏠 Home feature
│   └── profile/                      # 👤 Profile feature
└── l10n/                            # 🌐 Internationalization
    ├── i18n/                        # Translation source files
    │   ├── en.i18n.json             # English translations (base)
    │   └── vi.i18n.json             # Vietnamese translations
    └── gen/                         # Generated slang code
        └── strings.g.dart           # Generated translation classes
```

**Critical Configuration Files:**

- **`analysis_options.yaml`** - Very Good Analysis linting with custom overrides
- **`Makefile`** - Primary build system, all development commands defined here
- **`pubspec.yaml`** - Dependencies organized by category with strict version management
- **`slang.yaml`** - Internationalization configuration for type-safe translations
- **`build.yaml`** - Build runner configuration for code generation

**Key Integration Points:**

- **Injectable DI:** `lib/core/infrastructure/injection/injection_container.dart` manages all dependencies
- **Chopper Networking:** `lib/core/network/api_client.dart` handles HTTP communication
- **BLoC State Management:** Feature-specific cubits with hydrated persistence
- **Asset Services:** `lib/shared/utilities/` contains image and SVG service contracts

**Testing Infrastructure:**

- **Unit Tests:** `*_test.dart` files use bloc_test and mocktail for comprehensive coverage
- **Widget Tests:** Feature-specific widget testing with comprehensive mocking
- **Integration Tests:** End-to-end testing scenarios for critical user flows
- **Generated File Exclusions:** All `*.g.dart`, `*.freezed.dart`, and `*.mocks.dart` files are excluded

### Build & Development Workflow

**Critical Prerequisites:**

- **Flutter SDK >=3.24.0** - verified compatible version with Dart >=3.8.0
- **Very Good CLI** - required for testing and package management
- **lcov** - required for HTML coverage reports (`brew install lcov` on macOS)
- **Node.js** - required for BATS testing framework and scripts

**Essential Build Commands:**

```bash
# Complete development workflow (primary development target)
make local-ci                 # ~5-8 minutes, full CI pipeline equivalent

# Quick development cycle
make check                    # Format + analyze (~30 seconds)
make check-strict            # Strict analysis with warnings (~45 seconds)
make check-all               # Complete checks with deps and licenses (~2 minutes)
make test                    # Run unit tests (~1-2 minutes)
make coverage                # Run tests with coverage + HTML report (~3-4 minutes)

# Code generation (run after model/service changes)
dart run build_runner build --delete-conflicting-outputs  # ~1-2 minutes

# Environment-specific builds
make run-dev                 # Development environment
make run-staging             # Staging environment
make run-prod                # Production environment

# Asset and i18n generation
make i18n-generate           # Generate type-safe translations
make i18n-watch              # Watch translation files for changes
```

**Critical Build Issues & Solutions:**

- **Code generation required** - run `dart run build_runner build --delete-conflicting-outputs` after model changes
- **Linting failures** - very_good_analysis is strict, all issues must be fixed
- **Missing lcov** - install with `brew install lcov` for coverage reports
- **Test exclusions** - generated files (_.g.dart, _.freezed.dart) are automatically excluded

**Development Environment Setup:**

1. Install Flutter 3.24+ and Dart 3.8+, Node.js for scripts
2. Install Very Good CLI: `dart pub global activate very_good_cli`
3. Install lcov: `brew install lcov` (macOS) or equivalent
4. **Always run `make setup-full` after fresh clone** - sets up all environments
5. **Always run `make check` before committing** - catches linting issues early
6. Use `make coverage` for comprehensive testing with visual reports

### Testing Strategy & Coverage

**Test Types & Commands:**

- **Unit Tests**: Comprehensive component testing with bloc_test and mocktail
  ```bash
  make test                    # Fast unit testing excluding generated files (~1-2 minutes)
  make coverage               # Full coverage with HTML report (~3-4 minutes)
  ```
- **Widget Tests**: Flutter widget testing with comprehensive UI validation
- **BLoC Tests**: State management testing with bloc_test framework
- **Integration Tests**: End-to-end scenarios for critical user workflows
- **Coverage Requirements**: Target 80%+ coverage, exclude all generated files

**Testing Best Practices:**

- **Always run `make test` before submitting changes** - fast feedback cycle
- **Run `make coverage` for feature changes** - ensures comprehensive testing
- **Use `make check` for quick validation** - format and analyze in 30 seconds
- **Generated files automatically excluded** - _.g.dart, _.freezed.dart, \*.mocks.dart

**Coverage Exclusions (Automatic):**

```yaml
# Automatically excluded from test coverage:
- "**/*.g.dart" # Generated code (build_runner)
- "**/*.freezed.dart" # Freezed generated models
- "**/*.mocks.dart" # Mock generated files
- "**/firebase_options.dart" # Firebase configuration
- "lib/l10n/gen/*" # Generated translations
```

### Development Guidelines & Patterns

**Always ensure proper line endings** - all files must end with a newline character for Git compatibility.

**BLoC State Management Pattern:**

```dart
// State with Freezed (required pattern)
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = FeatureInitial;
  const factory FeatureState.loading() = FeatureLoading;
  const factory FeatureState.loaded(List<Data> data) = FeatureLoaded;
  const factory FeatureState.error(String message) = FeatureError;
}

// Cubit with Injectable (required pattern)
@injectable
class FeatureCubit extends Cubit<FeatureState> {
  final FeatureRepository _repository;

  FeatureCubit(this._repository) : super(const FeatureState.initial());

  Future<void> loadData() async {
    emit(const FeatureState.loading());
    try {
      final data = await _repository.getData();
      emit(FeatureState.loaded(data));
    } catch (error) {
      emit(FeatureState.error(error.toString()));
    }
  }
}
```

**Dependency Injection Pattern:**

```dart
// Service registration (required pattern)
@module
abstract class ServiceModule {
  @lazySingleton
  ApiService apiService(Dio dio) => ApiService(dio);
}

// Usage in widgets (required pattern)
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => GetIt.instance<FeatureCubit>(),
    child: const FeatureView(),
  );
}
```

**Atomic Design Widget Organization:**

```dart
// Atoms: Basic UI building blocks
class CustomButton extends StatelessWidget {
  const CustomButton({required this.onPressed, required this.text, super.key});
  // Implementation...
}

// Molecules: Composite components
class SearchBar extends StatelessWidget {
  const SearchBar({required this.controller, super.key});
  // Combines atom (input) + atom (icon)
}

// Organisms: Complex UI sections
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});
  // Combines multiple molecules and atoms
}
```

**Code Standards (Strict Enforcement):**

- Follow very_good_analysis rules (130+ linting rules) - **zero tolerance for violations**
- Use English only for all code, comments, and documentation
- No `print()` statements - use `logger` package for proper logging
- Cascade operators (..) required for 2+ method calls on same object
- Public member API documentation required for all public members
- Line length limit: 80 characters - **strictly enforced**
- Alphabetical import sorting within categories

### API Integration & Networking

**Chopper Service Pattern (Required):**

```dart
@ChopperApi(baseUrl: '/api/v1')
abstract class UserApiService extends ChopperService {
  @Get(path: '/users/{id}')
  Future<Response<User>> getUser(@Path('id') String id);

  @Post(path: '/users')
  Future<Response<User>> createUser(@Body() CreateUserRequest request);

  static UserApiService create([ChopperClient? client]) =>
      _$UserApiService(client);
}
```

**Error Handling with fpdart (Required):**

```dart
Future<Either<Failure, Success>> performApiCall() async {
  try {
    final response = await _apiService.getData();
    return Right(Success(response.body));
  } on Exception catch (error) {
    logger.e('API call failed', error: error);
    return Left(Failure(error.toString()));
  }
}
```

**Network Configuration:**

- **Chopper HTTP Client**: Type-safe API client with code generation
- **Pretty Chopper Logger**: Development-only HTTP request/response logging
- **JWT Token Management**: Secure storage with flutter_secure_storage
- **Environment-specific URLs**: Different API endpoints per flavor

### Internationalization (i18n) System

**Slang Configuration (Type-Safe):**

```dart
// Usage pattern (required)
import 'package:xp1/l10n/gen/strings.g.dart';

// In widgets
Text(t.pages.home.title)              // Type-safe translation
Text(t.welcome(name: 'John'))         // Parameterized strings
Text(context.t.common.buttons.save)   // Context extension

// JSON structure (required)
{
  "pages": {
    "home": {
      "title": "Home",
      "subtitle": "Welcome to the home page"
    }
  },
  "common": {
    "buttons": {
      "save": "Save",
      "cancel": "Cancel"
    }
  }
}
```

**Translation Workflow:**

1. Edit JSON files in `lib/l10n/i18n/`
2. Run `make i18n-generate` to update Dart classes
3. Use type-safe translations in code
4. Use `make i18n-watch` for live development

### Asset Management Architecture

**Image Assets (Pure Flutter):**

```dart
// Service pattern (required)
final imageService = GetIt.instance<AssetImageService>();

Widget buildResponsiveImage() {
  return imageService.renderImage(
    assetPath: AppImages.welcomeImage,
    width: 300.w,                    // Responsive width with ScreenUtil
    height: 200.h,                   // Responsive height
    fit: BoxFit.contain,
    semanticLabel: 'Welcome image',  // Required for accessibility
    placeholder: const CircularProgressIndicator(),
  );
}
```

**SVG Icons (flutter_svg):**

```dart
// Service pattern (required)
final svgService = GetIt.instance<SvgIconService>();

Widget buildInteractiveIcon({required bool isSelected}) {
  return svgService.renderIcon(
    assetPath: AppIcons.homeIcon,
    size: AppIcons.medium,           // Predefined size constants
    color: isSelected ? Colors.blue : Colors.grey,
    onTap: () => handleNavigation(),
    semanticLabel: 'Home navigation', // Required for accessibility
  );
}
```

### Security Considerations

**Security is critical** - every component must follow security-first principles:

- **Critical**: Validate and sanitize all user inputs in forms and API calls
- **Mandatory**: Use flutter_secure_storage for JWT tokens and sensitive data
- **Essential**: Environment variables secured with envied package - never expose API keys
- **Required**: Input validation with formz for type-safe form handling
- **Must**: Proper error handling without exposing sensitive information
- **Always**: Log security events appropriately without logging sensitive data
- **Never**: Use plain SharedPreferences for sensitive data - always use secure storage

### Performance Guidelines

**Performance is essential** - smooth 60fps UI and fast app startup are priorities:

- **Critical**: Optimize image loading with proper caching and responsive sizing
- **Mandatory**: Use flutter_screenutil for responsive layouts across device sizes
- **Essential**: Implement proper state management to avoid unnecessary rebuilds
- **Required**: Lazy loading for heavy widgets and data lists
- **Must**: Monitor BLoC state complexity and optimize for performance
- **Always**: Profile widget rebuilds and optimize hot paths
- **Never**: Block UI thread with heavy computations - use isolates when needed

### Multi-Environment Configuration

**Environment Management (Required):**

```dart
// Environment-specific configuration
@EnviedField(varName: 'API_BASE_URL')
abstract class Env {
  static const String apiBaseUrl = _Env.apiBaseUrl;
}

// Usage in different flavors
// Development: lib/main_development.dart
// Staging: lib/main_staging.dart
// Production: lib/main_production.dart
```

**Environment Commands:**

```bash
# Environment setup (required after clone)
make install-dev             # Setup development environment
make install-staging         # Setup staging environment
make install-prod           # Setup production environment
make install-all            # Setup all environments

# Environment-specific runs
make run-dev                # Development with debug features
make run-staging            # Staging for QA testing
make run-prod              # Production configuration
```

### Quality Assurance & Compliance

**Linting Standards (Zero Tolerance):**

- **very_good_analysis**: 130+ strict rules - all violations must be fixed
- **Custom overrides**: Strategic overrides for project-specific needs
- **Line length**: 80 characters maximum - strictly enforced
- **Naming conventions**: camelCase variables, PascalCase classes, snake_case files
- **Import organization**: Dart → Flutter → packages → relative

**License Compliance (Business Critical):**

```bash
# License checking (required before adding dependencies)
make license-check           # Check business-safe licenses only
make license-report         # Generate detailed license report
make license-quick          # Quick development check

# Allowed licenses: MIT, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC, Unlicense
# Forbidden: GPL-2.0, GPL-3.0, LGPL-2.1, LGPL-3.0, AGPL-3.0, unknown, CC-BY-SA-4.0
```

**Dependency Management:**

- **Alphabetical sorting**: Dependencies sorted A-Z within logical categories
- **Version pinning**: Caret ranges for stable packages, exact versions for critical dependencies
- **Validation**: `dart run dependency_validator` to catch unused/missing dependencies
- **Updates**: Regular dependency updates with thorough testing

### Common Patterns & Conventions

**File Naming & Organization:**

- **snake_case** for all Dart files and directories
- **PascalCase** for classes and widgets
- **camelCase** for variables, functions, and methods
- **SCREAMING_SNAKE_CASE** for constants

**Import Organization (Required):**

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetical)
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// 4. Relative imports (local project)
import '../../../core/infrastructure/injection/injection_container.dart';
import '../../domain/entities/user.dart';
```

**Error Handling Patterns:**

```dart
// Repository pattern (required)
abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers();
}

// Implementation with proper error handling
@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final response = await _apiService.getUsers();
      return Right(response.body);
    } on Exception catch (error, stackTrace) {
      logger.e('Failed to get users', error: error, stackTrace: stackTrace);
      return Left(Failure('Failed to load users'));
    }
  }
}
```

**Widget Testing Patterns:**

```dart
// Widget test structure (required)
testWidgets('renders correctly with loading state', (tester) async {
  // Arrange
  when(() => mockCubit.state).thenReturn(const FeatureState.loading());

  // Act
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: mockCubit,
        child: const FeatureView(),
      ),
    ),
  );

  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Loading...'), findsOneWidget);
});
```

### CI/CD & Validation

**GitHub Actions Equivalent (Makefile):**

- **`make local-ci`** - Complete CI pipeline matching GitHub Actions
- **`make test-scripts`** - BATS testing for bash scripts
- **`make semantic-check`** - Semantic commit validation
- **`make flutter-ci`** - Flutter package and quality checks
- **All checks must pass** before merge approval

**Pre-commit Validation (Required):**

1. **Always run `make check`** - catches formatting and analysis issues
2. **Always run `make test`** - ensures all tests pass
3. **Run `make coverage` for feature changes** - validates test coverage
4. **Check `make license-check`** - ensures license compliance

**Performance Requirements:**

- **Unit tests must complete in <2 minutes** on standard hardware
- **Coverage generation must complete in <4 minutes** including HTML report
- **Code analysis must complete in <30 seconds** for quick feedback
- **Build generation must complete in <2 minutes** for iterative development

**Common Validation Failures & Solutions:**

- **Linting failures:** Run `make format` then `make analyze` to fix
- **Test failures:** Check mocking setup and state management logic
- **Coverage failures:** Ensure test files exist for all business logic
- **License failures:** Remove problematic dependencies or find alternatives
- **Build failures:** Run `dart run build_runner clean` then regenerate

**Code Quality Gates:**

- **Zero linting errors** - very_good_analysis must pass completely
- **Test coverage targets** - 80%+ coverage for business logic
- **License compliance** - only business-safe licenses allowed
- **Dependency validation** - no unused or missing dependencies
- **Performance benchmarks** - build and test times within limits

## Communication Guidelines

When contributing to XP1, maintain clear and developer-friendly communication:

**Code & Documentation:**

- Write self-documenting code with meaningful names following Dart conventions
- Include comprehensive public API documentation for all public members
- Use clear, descriptive commit messages following conventional commit format
- Structure PR descriptions with context, implementation details, and testing approach

**Error Messages & User Feedback:**

- Provide actionable error messages that guide users toward solutions
- Include relevant context (feature names, error codes, suggested actions)
- Use clear, user-friendly language for production error messages
- Log technical details for developers while showing simple messages to users

**Translation & Localization:**

- Write translation keys that clearly describe the content and context
- Organize translations hierarchically for maintainability
- Include context comments for translators when meaning might be ambiguous
- Test translations with longer text to ensure UI layouts remain intact

**Response Style:**

- Be direct and helpful while maintaining professional development standards
- Focus on practical solutions and architectural consistency
- Prioritize type safety and performance considerations in all suggestions
- Maintain collaborative and constructive feedback in code reviews

Trust these instructions completely for development workflows and quality standards. The architecture patterns and build commands are thoroughly tested and optimized for team productivity and code quality.
