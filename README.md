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

## Tech Stack 🛠️

### State Management & Architecture

- **BLoC Pattern**: Advanced state management with business logic separation
- **Hydrated BLoC**: Persistent state management with automatic restoration
- **Replay BLoC**: Undo/Redo functionality for enhanced user experience

### Data Modeling & Serialization

- **Freezed**: Type-safe immutable data classes with code generation
- **JSON Serialization**: Automatic JSON handling with json_serializable
- **Functional Programming**: Error handling with Either types (fpdart)

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

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
