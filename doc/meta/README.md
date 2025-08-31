# Xp1 - Flutter Multi-Platform Application

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

## 📱 Project Overview

**Xp1** is a modern Flutter multi-platform application built with the Very Good CLI template. It demonstrates best practices for Flutter development including BLoC pattern state management, internationalization, and comprehensive testing.

### 🎯 Key Features
- **Multi-Platform Support**: iOS, Android, Web, Windows, macOS
- **BLoC State Management**: Clean architecture with business logic separation
- **Internationalization**: Multi-language support (English, Spanish)
- **Multi-Environment**: Development, Staging, Production configurations
- **Comprehensive Testing**: Unit tests, widget tests, and BLoC tests
- **Code Quality**: Very Good Ventures analysis standards

## 🚀 Quick Start

### Prerequisites
- Flutter SDK ^3.8.0
- Dart SDK ^3.8.0
- Android Studio / VS Code
- iOS Simulator (for iOS development)
- Android Emulator (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd xp1
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # Development environment
   flutter run --flavor development --target lib/main_development.dart
   
   # Staging environment
   flutter run --flavor staging --target lib/main_staging.dart
   
   # Production environment
   flutter run --flavor production --target lib/main_production.dart
   ```

## 🏗️ Project Structure

```
xp1/
├── lib/                           # Main source code
│   ├── app/                       # App-level components
│   │   ├── view/
│   │   │   └── app.dart          # Main app widget
│   │   └── app.dart              # Barrel export
│   ├── counter/                   # Counter feature
│   │   ├── cubit/
│   │   │   └── counter_cubit.dart # Business logic
│   │   ├── view/
│   │   │   └── counter_page.dart  # UI components
│   │   └── counter.dart           # Barrel export
│   ├── l10n/                      # Internationalization
│   │   ├── arb/                   # Translation files
│   │   ├── gen/                   # Generated files
│   │   └── l10n.dart              # Setup
│   ├── bootstrap.dart             # App initialization
│   └── main_*.dart                # Environment entry points
├── test/                          # Test files
├── docs/                          # Documentation
│   ├── README.md                  # This file
│   ├── tech-stack.md              # Technology stack
│   └── architecture.md            # Architecture documentation
└── pubspec.yaml                   # Dependencies
```

## 🧪 Testing

### Run All Tests
```bash
very_good test --coverage --test-randomize-ordering-seed random
```

### Generate Coverage Report
```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/

# Open coverage report
open coverage/index.html
```

### Test Structure
- **Unit Tests**: Business logic testing (`test/counter/cubit/`)
- **Widget Tests**: UI component testing (`test/counter/view/`)
- **Integration Tests**: End-to-end testing
- **BLoC Tests**: State management testing

## 🌐 Internationalization

### Adding New Strings

1. **Add to English ARB file** (`lib/l10n/arb/app_en.arb`):
   ```json
   {
     "@@locale": "en",
     "newString": "New String",
     "@newString": {
       "description": "Description of the new string"
     }
   }
   ```

2. **Add to Spanish ARB file** (`lib/l10n/arb/app_es.arb`):
   ```json
   {
     "@@locale": "es",
     "newString": "Nueva Cadena"
   }
   ```

3. **Use in code**:
   ```dart
   import 'package:xp1/l10n/l10n.dart';
   
   final l10n = context.l10n;
   Text(l10n.newString)
   ```

### Generate Localizations
```bash
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

## 🏛️ Architecture

### BLoC Pattern
The application uses the BLoC (Business Logic Component) pattern for state management:

```dart
// Business Logic
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// UI Integration
BlocProvider(
  create: (_) => CounterCubit(),
  child: const CounterView(),
)
```

### Feature-Based Organization
Each feature is organized in its own directory with:
- **cubit/**: Business logic and state management
- **view/**: UI components and widgets
- **models/**: Data models (when needed)

## 🔧 Development Workflow

### Code Quality
- **Static Analysis**: Very Good Ventures analysis rules (130+ strict rules)
- **Code Formatting**: Automatic formatting with `dart format` (80 character limit)
- **Linting**: Comprehensive linting rules with very_good_analysis
- **Documentation**: Mandatory documentation for all public APIs
- **Error Handling**: Specific exception handling patterns

### Git Workflow
1. Create feature branch
2. Implement changes
3. Write tests
4. Run tests and analysis
5. Create pull request
6. Code review
7. Merge to main

### Environment Configuration
- **Development**: Debug builds with development settings
- **Staging**: Release builds with staging configuration
- **Production**: Release builds with production settings

## 📱 Platform Support

### iOS
- **Minimum Version**: iOS 12.0+
- **Deployment**: App Store Connect
- **Simulator**: iOS Simulator support

### Android
- **Minimum Version**: API 21 (Android 5.0)
- **Deployment**: Google Play Console
- **Emulator**: Android Emulator support

### Web
- **Browser Support**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Deployment**: Web hosting platforms

### Desktop
- **Windows**: Windows 10+
- **macOS**: macOS 10.14+

## 🚀 Deployment

### Build Commands
```bash
# iOS
flutter build ios --flavor production

# Android
flutter build apk --flavor production
flutter build appbundle --flavor production

# Web
flutter build web --flavor production

# Windows
flutter build windows --flavor production

# macOS
flutter build macos --flavor production
```

### Release Process
1. Update version in `pubspec.yaml`
2. Run tests and analysis
3. Build for target platforms
4. Deploy to respective stores/platforms

## 📚 Documentation

### Available Documentation
- **[Tech Stack](../core/tech-stack.md)**: Detailed technology stack information
- **[Architecture](../core/architecture.md)**: Comprehensive architecture documentation
- **[API Documentation]**: Generated API documentation (if applicable)

### Contributing to Documentation
1. Update relevant markdown files in `docs/`
2. Keep documentation in sync with code changes
3. Follow markdown best practices
4. Include code examples where appropriate

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

### Code Standards
- Follow Very Good Ventures coding standards (130+ strict rules)
- Write comprehensive tests with proper mocking
- Use meaningful commit messages (conventional commits)
- Keep commits atomic and focused
- Mandatory documentation for all public APIs
- Specific exception handling patterns

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Getting Help
- **Documentation**: Check the `docs/` folder
- **Issues**: Create an issue on GitHub
- **Discussions**: Use GitHub Discussions for questions

### Common Issues
- **Build Issues**: Ensure Flutter SDK version matches requirements
- **Test Failures**: Run `flutter clean` and `flutter pub get`
- **Platform Issues**: Check platform-specific setup guides

## 🔄 Changelog

### Version 1.0.0+1
- Initial release
- BLoC pattern implementation
- Multi-platform support
- Internationalization
- Comprehensive testing

---

**Built with ❤️ using Flutter and Very Good CLI**

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
