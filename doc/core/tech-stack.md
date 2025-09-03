# Tech Stack Documentation

## Project Overview

**Project Name**: Xp1  
**Description**: A Very Good Project with Auto Route Navigation  
**Version**: 1.0.0+1  
**Type**: Flutter Multi-Platform Application with Type-Safe Navigation

## Core Technologies

### Frontend Framework

- **Flutter**: ^3.8.0 (SDK)
  - Cross-platform UI framework
  - Material Design 3 support
  - Hot reload development

### Navigation System

- **auto_route**: ^10.1.2
  - Type-safe route generation
  - Route guards and protection
  - Nested navigation support
  - Testing-friendly router
- **auto_route_generator**: ^10.2.4 (dev)
  - Code generation for routes
  - Build runner integration

### State Management

- **BLoC Pattern**: ^9.0.0
  - Business Logic Component architecture
  - Reactive state management
  - Separation of concerns
- **flutter_bloc**: ^9.1.1
  - Flutter-specific BLoC implementation
  - Widget integration helpers
- **hydrated_bloc**: ^10.1.1
  - Persistent BLoC state management
  - Automatic state restoration
  - Local storage integration
- **replay_bloc**: ^0.3.0
  - Undo/Redo functionality for BLoC
  - State history management
  - Time-travel debugging support

### Code Generation & Serialization

- **freezed**: ^3.2.0 (dev)
  - Immutable data classes generation
  - Union types and sealed classes
  - Deep equality and copy functionality
- **freezed_annotation**: ^3.1.0
  - Annotations for Freezed code generation
  - Type-safe immutable models
- **json_annotation**: ^4.8.1
  - JSON serialization annotations
  - Type-safe JSON handling
- **json_serializable**: ^6.7.1 (dev)
  - JSON serialization code generation
  - Automatic fromJson/toJson methods

### Functional Programming

- **dartz**: ^0.10.1
  - Functional programming utilities
  - Either types for error handling
  - Option types for null safety
- **fpdart**: ^1.1.0
  - Pure functional programming for Dart
  - Monads and functional composition
  - Advanced functional utilities
- **equatable**: ^2.0.5
  - Value equality for immutable objects
  - Simplified equality comparisons
  - Hash code generation

### Internationalization

- **flutter_localizations**: SDK
  - Built-in Flutter localization support
- **intl**: ^0.20.2
  - Internationalization and localization formatting

### Development Tools

- **very_good_analysis**: ^9.0.0
  - Code analysis and linting rules
  - Very Good Ventures coding standards
- **build_runner**: ^2.7.0
  - Code generation for auto_route
  - Build system automation

### Testing Framework

- **flutter_test**: SDK
  - Flutter widget and unit testing
- **bloc_test**: ^10.0.0
  - BLoC-specific testing utilities
- **mocktail**: ^1.0.4
  - Mocking framework for testing

## Project Structure

### Multi-Environment Support

- **Development**: `lib/main_development.dart`
- **Staging**: `lib/main_staging.dart`
- **Production**: `lib/main_production.dart`

### Platform Support

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ Windows
- ✅ macOS

## Architecture Patterns

### Navigation Architecture Implementation

```
lib/
├── core/
│   ├── routing/
│   │   ├── app_router.dart       # Router configuration
│   │   └── app_router.gr.dart    # Generated routes
│   ├── guards/
│   │   └── auth_guard.dart       # Route protection
│   └── constants/
│       └── route_constants.dart  # Route paths
├── features/
│   ├── authentication/
│   │   └── presentation/
│   │       └── pages/
│   │           └── login_page.dart
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page.dart
│   └── main_navigation/
│       └── presentation/
│           └── pages/
│               └── main_wrapper_page.dart
```

### App Structure

```
lib/
├── app/
│   ├── view/
│   │   └── app.dart              # Main app widget
│   └── app.dart                  # Barrel export
├── l10n/                         # Internationalization
├── bootstrap.dart                # App initialization
└── main_*.dart                   # Environment entry points
```

## Development Workflow

### Running the Application

```bash
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

### Navigation Code Generation

```bash
# Generate route files after route changes
dart run build_runner build --delete-conflicting-outputs

# Watch for changes during development
dart run build_runner watch

# Clean generated files if conflicts occur
dart run build_runner clean
```

### Testing

```bash
# Run all tests with coverage
very_good test --coverage --test-randomize-ordering-seed random

# Generate coverage report
genhtml coverage/lcov.info -o coverage/
open coverage/index.html

# Test navigation flows
flutter test test/features/*/presentation/pages/
flutter test test/helpers/
```

### Code Generation

```bash
# Generate localizations
flutter gen-l10n --arb-dir="lib/l10n/arb"

# Generate routes and data classes
dart run build_runner build --delete-conflicting-outputs

# Watch for changes during development
dart run build_runner watch

# Clean generated files
dart run build_runner clean

# Generate specific files (Freezed + JSON)
dart run build_runner build --delete-conflicting-outputs
```

## Dependencies Management

### Production Dependencies

- `auto_route`: Type-safe navigation system
- `bloc`: State management core
- `flutter_bloc`: Flutter BLoC integration
- `hydrated_bloc`: Persistent BLoC state management
- `replay_bloc`: Undo/Redo functionality for BLoC
- `freezed_annotation`: Annotations for immutable data classes
- `json_annotation`: JSON serialization annotations
- `dartz`: Functional programming utilities
- `fpdart`: Pure functional programming for Dart
- `equatable`: Value equality for immutable objects
- `flutter_localizations`: Localization support
- `intl`: Internationalization utilities
- `meta`: Metadata annotations for Dart

### Development Dependencies

- `auto_route_generator`: Route code generation
- `freezed`: Immutable data classes generation
- `json_serializable`: JSON serialization code generation
- `bloc_test`: BLoC testing utilities
- `build_runner`: Code generation system
- `flutter_test`: Flutter testing framework
- `mocktail`: Mocking framework
- `very_good_analysis`: Code analysis

## Configuration Files

### Analysis Options

- `analysis_options.yaml`: Dart analysis configuration
- `very_good_analysis`: Very Good Ventures coding standards

### Localization

- `l10n.yaml`: Localization configuration
- `lib/l10n/arb/`: ARB files for translations

### Build Configuration

- `pubspec.yaml`: Project dependencies and configuration
- `pubspec.lock`: Locked dependency versions

## Best Practices

### Code Organization

- Feature-based folder structure
- Separation of business logic (cubit) and UI (view)
- Barrel exports for clean imports

### State Management

- Use BLoC pattern for complex state
- Keep cubits focused and single-purpose
- Proper error handling in state management

### Testing

- Unit tests for business logic
- Widget tests for UI components
- BLoC tests for state management
- Coverage reporting enabled

### Internationalization

- All user-facing strings in ARB files
- Proper locale support configuration
- Generated localization classes

## Performance Considerations

### Build Optimization

- Multi-environment builds for different deployment targets
- Proper asset management
- Code splitting where applicable

### Runtime Performance

- Efficient BLoC state management
- Proper widget rebuild optimization
- Memory management best practices

## Security Considerations

### Code Analysis

- Very Good Ventures analysis rules
- Static analysis for security issues
- Dependency vulnerability scanning

### Platform Security

- Platform-specific security configurations
- Proper permission handling
- Secure storage practices

## Deployment

### Build Flavors

- Development: Debug builds with development configuration
- Staging: Release builds with staging configuration
- Production: Release builds with production configuration

### Platform Deployment

- iOS: App Store deployment
- Android: Google Play Store deployment
- Web: Web hosting deployment
- Desktop: Platform-specific packaging

## Maintenance

### Dependency Updates

- Regular dependency updates
- Security patch management
- Breaking change assessment

### Code Quality

- Automated testing in CI/CD
- Code coverage monitoring
- Static analysis integration

---

_Last Updated: $(date)_
_Document Version: 1.0_
