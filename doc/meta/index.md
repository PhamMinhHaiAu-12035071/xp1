# Xp1 Project Documentation

## 📚 Documentation Overview

Welcome to the Xp1 Flutter project documentation. This index provides quick access to all project documentation and guides.

## 🗂️ Documentation Structure

### Core Documentation
- **[README](README.md)** - Project overview, setup, and quick start guide
- **[Tech Stack](../core/tech-stack.md)** - Comprehensive technology stack information
- **[Architecture](../core/architecture.md)** - System architecture and design patterns
- **[Development Guidelines](../core/development-guidelines.md)** - Coding standards and best practices

### Quick Reference
- **[Project Structure](#project-structure)** - File and folder organization
- **[Getting Started](#getting-started)** - Setup and installation
- **[Development Workflow](#development-workflow)** - Development process
- **[Testing](#testing)** - Testing strategies and guidelines

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
│   ├── index.md                   # This file
│   ├── README.md                  # Enhanced README
│   ├── tech-stack.md              # Technology stack
│   ├── architecture.md            # Architecture documentation
│   └── development-guidelines.md  # Development guidelines
└── pubspec.yaml                   # Dependencies
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.8.0
- Dart SDK ^3.8.0
- Android Studio / VS Code
- iOS Simulator (for iOS development)
- Android Emulator (for Android development)

### Quick Setup
```bash
# Clone and setup
git clone <repository-url>
cd xp1
flutter pub get

# Run the application
flutter run --flavor development --target lib/main_development.dart
```

### Environment Configuration
- **Development**: `flutter run --flavor development --target lib/main_development.dart`
- **Staging**: `flutter run --flavor staging --target lib/main_staging.dart`
- **Production**: `flutter run --flavor production --target lib/main_production.dart`

## 🔧 Development Workflow

### Code Quality
- **Static Analysis**: Very Good Ventures analysis rules (130+ strict rules)
- **Code Formatting**: Automatic formatting with `dart format` (80 character limit)
- **Linting**: Comprehensive linting rules với very_good_analysis
- **Documentation**: Mandatory documentation cho tất cả public APIs
- **Error Handling**: Specific exception handling patterns

### Git Workflow
1. Create feature branch
2. Implement changes
3. Write tests
4. Run tests and analysis
5. Create pull request
6. Code review
7. Merge to main

### Testing
```bash
# Run all tests
very_good test --coverage --test-randomize-ordering-seed random

# Generate coverage report
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

## 🏛️ Architecture Overview

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

### Feature Organization
Each feature is organized in its own directory with:
- **cubit/**: Business logic and state management
- **view/**: UI components and widgets
- **models/**: Data models (when needed)

## 🌐 Internationalization

### Adding New Strings
1. Add to English ARB file (`lib/l10n/arb/app_en.arb`)
2. Add to Spanish ARB file (`lib/l10n/arb/app_es.arb`)
3. Use in code with `context.l10n.stringName`

### Generate Localizations
```bash
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

## 📱 Platform Support

### Supported Platforms
- ✅ iOS (iOS 12.0+)
- ✅ Android (API 21+)
- ✅ Web (Modern browsers)
- ✅ Windows (Windows 10+)
- ✅ macOS (macOS 10.14+)

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

## 🧪 Testing

### Test Structure
- **Unit Tests**: Business logic testing (`test/counter/cubit/`)
- **Widget Tests**: UI component testing (`test/counter/view/`)
- **Integration Tests**: End-to-end testing
- **BLoC Tests**: State management testing

### Testing Patterns
```dart
// Cubit Testing
blocTest<CounterCubit, int>(
  'emits [1] when increment is called',
  build: CounterCubit.new,
  act: (cubit) => cubit.increment(),
  expect: () => [equals(1)],
);

// Widget Testing
testWidgets('counter increments when + button is pressed', (tester) async {
  await tester.pumpWidget(const App());
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});
```

## 🔒 Security & Performance

### Security Considerations
- Static analysis with Very Good Ventures rules
- Dependency vulnerability scanning
- Platform-specific security configurations
- Input validation and error handling

### Performance Optimization
- Efficient BLoC state management
- Minimal widget rebuilds
- Proper memory management
- Asset optimization

## 📈 Monitoring & Analytics

### Error Tracking
- Global error handling in `bootstrap.dart`
- BLoC error logging with `AppBlocObserver`
- Platform-specific error reporting

### Performance Monitoring
- Widget rebuild monitoring
- Memory usage tracking
- App startup time measurement
- User interaction analytics

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
- Write comprehensive tests với proper mocking
- Use meaningful commit messages (conventional commits)
- Keep commits atomic and focused
- Mandatory documentation cho public APIs
- Specific exception handling patterns

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

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

**Documentation Navigation**

| Document | Purpose | Audience |
|----------|---------|----------|
| [README](README.md) | Project overview and quick start | All users |
| [Tech Stack](../core/tech-stack.md) | Technology details | Developers |
| [Architecture](../core/architecture.md) | System design | Architects, Developers |
| [Development Guidelines](../core/development-guidelines.md) | Coding standards | Developers |

---

*This documentation index serves as the central hub for all Xp1 Flutter project documentation.*
