# Architecture Documentation

## Project Overview

**Project Name**: Xp1  
**Architecture Type**: Flutter Multi-Platform with BLoC Pattern & Auto Route Navigation  
**Document Version**: 2.0  
**Last Updated**: $(date)

## Architecture Principles

### Core Design Principles

1. **Separation of Concerns**: Business logic separated from UI
2. **Reactive Programming**: State-driven UI updates
3. **Testability**: All components easily testable
4. **Scalability**: Feature-based modular structure
5. **Maintainability**: Clear code organization and patterns

### Architectural Patterns

#### Auto Route Navigation Pattern

- **Purpose**: Type-safe navigation with route guards and nested routes
- **Implementation**: Using `auto_route` package with code generation
- **Benefits**:
  - Compile-time route safety
  - Centralized route configuration
  - Built-in route guards
  - Nested navigation support
  - Testing-friendly router

#### BLoC (Business Logic Component) Pattern

- **Purpose**: State management and business logic separation
- **Implementation**: Using `bloc` and `flutter_bloc` packages
- **Benefits**:
  - Predictable state changes
  - Easy testing
  - Reusable business logic
  - Clear data flow

#### Feature-Based Organization

- **Structure**: Each feature in its own directory with presentation layers
- **Components**: presentation/pages (UI), cubit (business logic), models (data)
- **Benefits**: Modularity, maintainability, team collaboration, clear separation

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │    Home     │  │ Attendance  │  │   Profile   │          │
│  │   Feature   │  │   Feature   │  │   Feature   │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │    Auth     │  │ Statistics  │  │  Features   │          │
│  │   Feature   │  │   Feature   │  │   Feature   │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
│  ┌─────────────────────────────────────────────────────────┐│
│  │          Locale Management (DDD) + Slang i18n           ││
│  │  Domain | Application | Infrastructure | Generated      ││
│  └─────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│              Auto Route Navigation Layer                    │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐│
│  │   App Router    │ │   Route Guards  │ │ Navigation      ││
│  │  Configuration  │ │ (Auth, etc.)    │ │ Testing         ││
│  └─────────────────┘ └─────────────────┘ └─────────────────┘│
├─────────────────────────────────────────────────────────────┤
│                    Bootstrap Layer                          │
├─────────────────────────────────────────────────────────────┤
│                    Flutter Framework                        │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │     iOS     │  │   Android   │  │     Web     │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

### Component Architecture

#### Navigation Architecture

```
core/
├── routing/
│   ├── app_router.dart             # Main router configuration
│   └── app_router.gr.dart          # Generated route definitions
├── guards/
│   └── auth_guard.dart             # Route protection
└── constants/
    └── route_constants.dart        # Route path constants
```

#### Feature Architecture (Example: Home Feature)

```
features/home/
├── presentation/
│   └── pages/
│       └── home_page.dart          # UI Components
└── home.dart                       # Barrel Export (if needed)
```

#### Main Navigation Architecture

```
features/main_navigation/
├── presentation/
│   └── pages/
│       └── main_wrapper_page.dart  # Bottom navigation wrapper
└── main_navigation.dart            # Barrel Export
```

#### App Feature Architecture

```
app/
├── view/
│   └── app.dart                    # Main App Widget with Router
└── app.dart                        # Barrel Export
```

## Data Flow Architecture

### Navigation Flow

```
User Tap → Route Request → Route Guard → Page Resolution → Widget Display
    ↑                                                           ↓
    └───────────── Navigation Complete ←────────────────────────┘
```

### State Management Flow

```
User Action → Widget → Cubit → State Change → Widget Rebuild
     ↑                                                    ↓
     └─────────────── UI Update ←────────────────────────┘
```

### Authentication Flow with Navigation

```
Login Request → AuthGuard → Protected Route → Main Navigation
      ↑              ↓               ↓              ↓
Login Page ← Redirect ← Unauthorized ← Route Access
```

### BLoC Observer Pattern

```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    // Log state changes
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // Handle errors
  }
}
```

## File Structure

### Root Directory Structure

```
xp1/
├── lib/                           # Main source code
│   ├── app/                       # App-level components
│   ├── counter/                   # Counter feature
│   ├── l10n/                      # Internationalization
│   ├── bootstrap.dart             # App initialization
│   └── main_*.dart                # Environment entry points
├── test/                          # Test files
├── android/                       # Android-specific code
├── ios/                          # iOS-specific code
├── web/                          # Web-specific code
├── windows/                      # Windows-specific code
├── macos/                        # macOS-specific code
├── pubspec.yaml                  # Dependencies
└── analysis_options.yaml         # Code analysis rules
```

### Source Code Structure

```
lib/
├── app/
│   ├── view/
│   │   └── app.dart              # Main app widget with router
│   └── app.dart                  # Barrel export
├── core/
│   ├── routing/
│   │   ├── app_router.dart       # Auto route configuration
│   │   └── app_router.gr.dart    # Generated routes
│   ├── guards/
│   │   └── auth_guard.dart       # Authentication guard
│   └── constants/
│       └── route_constants.dart  # Route path constants
├── features/
│   ├── authentication/
│   │   └── presentation/
│   │       └── pages/
│   │           └── login_page.dart      # Login UI
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page.dart       # Home UI
│   ├── attendance/
│   │   └── presentation/
│   │       └── pages/
│   │           └── attendance_page.dart # Attendance UI
│   ├── profile/
│   │   └── presentation/
│   │       └── pages/
│   │           └── profile_page.dart    # Profile UI
│   ├── statistics/
│   │   └── presentation/
│   │       └── pages/
│   │           └── statistics_page.dart # Statistics UI
│   ├── features/
│   │   └── presentation/
│   │       └── pages/
│   │           └── features_page.dart   # Features UI
│   ├── locale/                          # Locale management feature (DDD)
│   │   ├── application/
│   │   │   └── locale_application_service.dart # Application service
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── locale_configuration.dart   # Domain entity
│   │   │   ├── services/
│   │   │   │   └── locale_domain_service.dart  # Domain service
│   │   │   └── exceptions/
│   │   │       └── locale_exceptions.dart      # Domain exceptions
│   │   ├── infrastructure/
│   │   │   └── locale_repository_impl.dart     # Infrastructure layer
│   │   └── locale.dart                         # Barrel export
│   └── main_navigation/
│       └── presentation/
│           └── pages/
│               └── main_wrapper_page.dart # Bottom navigation
├── l10n/
│   ├── i18n/                     # Translation source files
│   │   ├── en.i18n.json          # English translations (base locale)
│   │   └── vi.i18n.json          # Vietnamese translations
│   └── gen/                      # Generated slang code
│       └── strings.g.dart        # Generated translation classes
├── bootstrap.dart                # App initialization
├── main_development.dart         # Development entry point
├── main_staging.dart             # Staging entry point
└── main_production.dart          # Production entry point
```

## Environment Configuration

### Multi-Environment Architecture

- **Development**: Debug builds with development configuration
- **Staging**: Release builds with staging configuration
- **Production**: Release builds with production configuration

### Environment Entry Points

```dart
// main_development.dart
import 'package:xp1/app/app.dart';
import 'package:xp1/bootstrap.dart';

Future<void> main() async => bootstrap(() => const App());

// main_staging.dart
import 'package:xp1/app/app.dart';
import 'package:xp1/bootstrap.dart';

Future<void> main() async => bootstrap(() => const App());

// main_production.dart
import 'package:xp1/app/app.dart';
import 'package:xp1/bootstrap.dart';

Future<void> main() async => bootstrap(() => const App());
```

## Navigation Architecture

### Auto Route Configuration

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRouteGuard> get guards => [AuthGuard()];

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
      initial: true,
    ),
    AutoRoute(
      page: MainWrapperRoute.page,
      path: '/main',
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
  ];
}
```

### Route Guards Implementation

```dart
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

### Navigation Integration

```dart
// Type-safe navigation
context.router.push(const HomeRoute());
context.router.pushAndClearStack(const LoginRoute());

// Bottom navigation with auto route
AutoTabsScaffold(
  routes: const [
    HomeRoute(),
    StatisticsRoute(),
    AttendanceRoute(),
    FeaturesRoute(),
    ProfileRoute(),
  ],
)
```

## Internationalization Architecture with Slang

### Type-Safe Translation System

This project uses [Slang](https://pub.dev/packages/slang) for type-safe internationalization with compile-time translation safety, better IDE support, and more maintainable i18n code.

### Translation File Structure

```
l10n/
├── i18n/                         # Translation source files
│   ├── en.i18n.json              # English translations (base locale)
│   └── vi.i18n.json              # Vietnamese translations
└── gen/                          # Generated slang code
    └── strings.g.dart            # Generated translation classes
```

### Configuration Architecture

#### Slang Configuration (slang.yaml)

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

### Generated Code Architecture

```dart
// Auto-generated by Slang
enum AppLocale {
  en(languageCode: 'en'),
  vi(languageCode: 'vi', countryCode: 'VN');
}

class Translations {
  static AppLocale _current = AppLocale.en;

  // Type-safe translation accessors
  String get hello => _current == AppLocale.en ? 'Hello' : 'Xin chào';
  String welcome(String name) => _current == AppLocale.en
    ? 'Welcome $name'
    : 'Chào mừng $name';
}

// Global translation instance
Translations get t => Translations.instance;
```

### Integration with Flutter App

```dart
MaterialApp(
  locale: LocaleSettings.currentLocale.flutterLocale,
  supportedLocales: AppLocaleUtils.supportedLocales,
  localizationsDelegates: GlobalMaterialLocalizations.delegate,
  // ...
)
```

## Locale Management Architecture (DDD)

### Domain-Driven Design for Locale Management

The project implements a complete DDD-based locale management system with clear separation of concerns across domain, application, and infrastructure layers.

### Architectural Layers

#### Domain Layer

**Entities:**

```dart
// lib/features/locale/domain/entities/locale_configuration.dart
@freezed
class LocaleConfiguration with _$LocaleConfiguration {
  const factory LocaleConfiguration({
    required String languageCode,
    String? countryCode,
    String? scriptCode,
  }) = _LocaleConfiguration;

  factory LocaleConfiguration.fromJson(Map<String, Object?> json) =>
      _$LocaleConfigurationFromJson(json);
}
```

**Domain Services:**

```dart
// lib/features/locale/domain/services/locale_domain_service.dart
abstract class LocaleDomainService {
  Future<LocaleConfiguration> saveLocaleConfiguration(LocaleConfiguration config);
  Future<LocaleConfiguration?> getLocaleConfiguration();
  Future<void> clearLocaleConfiguration();

  LocaleConfiguration getSystemLocale();
  List<LocaleConfiguration> getSupportedLocales();
  bool isLocaleSupported(LocaleConfiguration config);
}
```

**Exceptions:**

```dart
// lib/features/locale/domain/exceptions/locale_exceptions.dart
abstract class LocaleException implements Exception {
  const LocaleException(this.message);
  final String message;
}

class UnsupportedLocaleException extends LocaleException {
  const UnsupportedLocaleException(String locale)
    : super('Unsupported locale: $locale');
}

class LocaleApplicationException extends LocaleException {
  const LocaleApplicationException(String message)
    : super('Locale application error: $message');
}
```

#### Application Layer

**Application Services:**

```dart
// lib/features/locale/application/locale_application_service.dart
class LocaleApplicationService {
  final LocaleDomainService _domainService;

  LocaleApplicationService({required LocaleDomainService domainService})
      : _domainService = domainService;

  Future<LocaleConfiguration> switchLocale(AppLocale locale) async {
    final config = LocaleConfiguration(
      languageCode: locale.languageCode,
      countryCode: locale.countryCode,
    );

    if (!_domainService.isLocaleSupported(config)) {
      throw UnsupportedLocaleException(locale.languageCode);
    }

    await _domainService.saveLocaleConfiguration(config);
    LocaleSettings.setLocale(locale);

    return config;
  }

  Future<LocaleConfiguration> getCurrentLocale() async {
    final saved = await _domainService.getLocaleConfiguration();
    return saved ?? _domainService.getSystemLocale();
  }
}
```

#### Infrastructure Layer

**Repository Implementation:**

```dart
// lib/features/locale/infrastructure/locale_repository_impl.dart
class LocaleRepositoryImpl implements LocaleDomainService {
  final SharedPreferences _prefs;
  final String _localeKey = 'selected_locale';

  @override
  Future<LocaleConfiguration> saveLocaleConfiguration(
    LocaleConfiguration config,
  ) async {
    final json = config.toJson();
    await _prefs.setString(_localeKey, jsonEncode(json));
    return config;
  }

  @override
  Future<LocaleConfiguration?> getLocaleConfiguration() async {
    final jsonString = _prefs.getString(_localeKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return LocaleConfiguration.fromJson(json);
    } catch (e) {
      await clearLocaleConfiguration();
      return null;
    }
  }

  @override
  LocaleConfiguration getSystemLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    return LocaleConfiguration(
      languageCode: systemLocale.languageCode,
      countryCode: systemLocale.countryCode,
    );
  }
}
```

### Feature Structure

```
features/locale/
├── application/
│   └── locale_application_service.dart    # Application service layer
├── domain/
│   ├── entities/
│   │   └── locale_configuration.dart      # Domain entity
│   ├── services/
│   │   └── locale_domain_service.dart     # Domain service interface
│   └── exceptions/
│       └── locale_exceptions.dart         # Domain exceptions
├── infrastructure/
│   └── locale_repository_impl.dart        # Infrastructure implementation
└── locale.dart                            # Barrel export
```

### State Management Integration

#### Locale BLoC/Cubit

```dart
// State representation
@freezed
class LocaleState with _$LocaleState {
  const factory LocaleState.initial() = LocaleInitial;
  const factory LocaleState.loading() = LocaleLoading;
  const factory LocaleState.loaded(LocaleConfiguration config) = LocaleLoaded;
  const factory LocaleState.error(String message) = LocaleError;
}

// Cubit implementation
class LocaleCubit extends HydratedCubit<LocaleState> {
  final LocaleApplicationService _applicationService;

  LocaleCubit(this._applicationService) : super(const LocaleState.initial());

  Future<void> switchLocale(AppLocale locale) async {
    emit(const LocaleState.loading());

    try {
      final config = await _applicationService.switchLocale(locale);
      emit(LocaleState.loaded(config));
    } on UnsupportedLocaleException catch (e) {
      emit(LocaleState.error(e.message));
    } on LocaleApplicationException catch (e) {
      emit(LocaleState.error(e.message));
    } catch (e) {
      emit(LocaleState.error('Unexpected error: $e'));
    }
  }

  @override
  LocaleState? fromJson(Map<String, dynamic> json) {
    try {
      return LocaleState.fromJson(json);
    } catch (_) {
      return const LocaleState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(LocaleState state) {
    return state.maybeWhen(
      loaded: (config) => config.toJson(),
      orElse: () => null,
    );
  }
}
```

### Bootstrap Integration

The locale system is integrated into the application bootstrap process:

```dart
// lib/bootstrap.dart
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // ... other bootstrap code ...

  // Initialize locale system
  await _initializeLocaleSystem();

  // ... rest of bootstrap ...
}

Future<void> _initializeLocaleSystem() async {
  final prefs = await SharedPreferences.getInstance();
  final localeService = LocaleRepositoryImpl(prefs);
  final applicationService = LocaleApplicationService(
    domainService: localeService,
  );

  // Register for dependency injection
  getIt.registerSingleton<LocaleDomainService>(localeService);
  getIt.registerSingleton<LocaleApplicationService>(applicationService);

  // Load saved locale
  final savedLocale = await applicationService.getCurrentLocale();
  final appLocale = AppLocale.values.firstWhere(
    (locale) => locale.languageCode == savedLocale.languageCode,
    orElse: () => AppLocale.en,
  );

  LocaleSettings.setLocale(appLocale);
}
```

### Utility Functions

```dart
// lib/core/utils/locale_utils.dart
/// Utility function for manual locale switching with improved DDD compliance.
Future<LocaleConfiguration> switchLocale(AppLocale locale) async {
  final applicationService = LocaleApplicationService(
    domainService: getIt<LocaleDomainService>(),
  );

  return await applicationService.switchLocale(locale);
}

/// Get current locale configuration
LocaleConfiguration getCurrentLocaleConfig() {
  return LocaleConfiguration(
    languageCode: LocaleSettings.currentLocale.languageCode,
    countryCode: LocaleSettings.currentLocale.countryCode,
  );
}
```

### Testing Architecture

#### Unit Tests for Domain Logic

```dart
// test/features/locale/domain/services/locale_domain_service_test.dart
void main() {
  group('LocaleDomainService', () {
    late LocaleDomainService service;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      service = LocaleRepositoryImpl(mockPrefs);
    });

    test('should save locale configuration', () async {
      // Arrange
      const config = LocaleConfiguration(languageCode: 'vi', countryCode: 'VN');

      // Act
      await service.saveLocaleConfiguration(config);

      // Assert
      verify(() => mockPrefs.setString(any(), any())).called(1);
    });
  });
}
```

#### Integration Tests for Application Layer

```dart
// test/features/locale/application/locale_application_service_test.dart
void main() {
  group('LocaleApplicationService', () {
    test('should switch locale and apply to slang', () async {
      // Arrange
      final service = LocaleApplicationService(
        domainService: MockLocaleDomainService(),
      );

      // Act
      await service.switchLocale(AppLocale.vi);

      // Assert
      expect(LocaleSettings.currentLocale, AppLocale.vi);
    });
  });
}
```

## Testing Architecture

### Test Structure

```
test/
├── app/
│   └── view/
│       └── app_test.dart                    # App widget tests
├── features/
│   ├── authentication/
│   │   └── presentation/
│   │       └── pages/
│   │           └── login_page_test.dart     # Login page tests
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page_test.dart      # Home page tests
│   ├── attendance/
│   │   └── presentation/
│   │       └── pages/
│   │           └── attendance_page_test.dart # Attendance tests
│   ├── profile/
│   │   └── presentation/
│   │       └── pages/
│   │           └── profile_page_test.dart   # Profile tests
│   ├── statistics/
│   │   └── presentation/
│   │       └── pages/
│   │           └── statistics_page_test.dart # Statistics tests
│   ├── features/
│   │   └── presentation/
│   │       └── pages/
│   │           └── features_page_test.dart  # Features tests
│   └── main_navigation/
│       └── presentation/
│           └── pages/
│               └── main_wrapper_page_test.dart # Navigation tests
└── helpers/
    ├── helpers.dart                         # Test utilities
    ├── pump_app.dart                        # App test wrapper
    └── page_test_helpers.dart               # Page testing helpers
```

### Testing Patterns

#### Navigation Testing

```dart
testWidgets('should navigate to main when login succeeds', (tester) async {
  await tester.pumpAppWithRouter(const SizedBox());
  await tester.pumpAndSettle();

  final loginButton = find.byType(ElevatedButton);
  await tester.tap(loginButton);
  await tester.pumpAndSettle();

  expect(find.byType(LoginPage), findsNothing);
});
```

#### Page Testing with Helpers (DRY Compliance)

```dart
void main() {
  group('HomePage', () {
    PageTestHelpers.testStandardPage<HomePage>(
      const HomePage(),
      'Hello World - Home',
      () => const HomePage(),
      (key) => HomePage(key: key),
    );
  });
}
```

#### Widget Testing

```dart
testWidgets('should display app bar with login title', (tester) async {
  await tester.pumpApp(const LoginPage());
  expect(find.byType(AppBar), findsOneWidget);
  expect(find.text('Login'), findsNWidgets(2));
});
```

## Error Handling Architecture

### Global Error Handling

```dart
FlutterError.onError = (details) {
  log(details.exceptionAsString(), stackTrace: details.stack);
};
```

### BLoC Error Handling

```dart
@override
void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
  log('onError(${bloc.runtimeType}, $error, $stackTrace)');
  super.onError(bloc, error, stackTrace);
}
```

## Performance Architecture

### Build Optimization

- **Multi-environment builds**: Separate configurations for different environments
- **Asset optimization**: Efficient asset management
- **Code splitting**: Platform-specific code separation

### Runtime Optimization

- **Efficient state management**: Minimal widget rebuilds
- **Memory management**: Proper disposal of resources
- **Lazy loading**: Load resources when needed

## Security Architecture

### Code Analysis

- **Static analysis**: `very_good_analysis` rules
- **Security scanning**: Dependency vulnerability checks
- **Code quality**: Automated quality gates

### Platform Security

- **iOS**: App Store security guidelines
- **Android**: Google Play security requirements
- **Web**: Web security best practices

## Deployment Architecture

### Build Pipeline

```
Source Code → Analysis → Testing → Build → Deploy
     ↑           ↓         ↓       ↓       ↓
   Version    Quality   Coverage  Flavor  Platform
```

### Platform Deployment

- **iOS**: App Store Connect deployment
- **Android**: Google Play Console deployment
- **Web**: Web hosting platform deployment
- **Desktop**: Platform-specific packaging

## Scalability Considerations

### Horizontal Scaling

- **Feature modules**: Independent feature development
- **Team collaboration**: Parallel development capabilities
- **Code reuse**: Shared components and utilities

### Vertical Scaling

- **Performance optimization**: Efficient algorithms and data structures
- **Memory management**: Proper resource utilization
- **State optimization**: Minimal state updates

## Maintenance Architecture

### Code Quality

- **Automated testing**: CI/CD integration
- **Code coverage**: Coverage reporting and monitoring
- **Static analysis**: Automated code quality checks

### Documentation

- **Code documentation**: Inline code comments
- **Architecture documentation**: System design documentation
- **API documentation**: Interface documentation

### Monitoring

- **Error tracking**: Global error handling and logging
- **Performance monitoring**: Runtime performance tracking
- **Usage analytics**: User behavior tracking

## Future Considerations

### Potential Enhancements

- **State persistence**: Local storage integration
- **Network layer**: API integration architecture
- **Authentication**: User authentication system
- **Push notifications**: Notification system
- **Analytics**: User analytics integration

### Migration Paths

- **State management**: Potential migration to other state management solutions
- **Platform support**: Additional platform support
- **Architecture evolution**: Pattern improvements and optimizations

---

_This architecture document serves as a comprehensive guide for understanding and maintaining the Xp1 Flutter application architecture._
