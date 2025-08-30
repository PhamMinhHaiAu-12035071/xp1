# Dart/Flutter Naming Conventions

## Quick Reference

| Type                | Convention     | Example                    |
| ------------------- | -------------- | -------------------------- |
| Variables/Functions | camelCase      | `userName`, `fetchData()`  |
| Classes/Widgets     | PascalCase     | `UserModel`, `LoginScreen` |
| Constants           | lowerCamelCase | `appName`, `maxRetries`    |
| Files/Directories   | snake_case     | `user_model.dart`, `auth/` |

## Core Rules

### Variables & Functions (camelCase)

```dart
// ✅ CORRECT
String userName = 'john';
void calculateTotal() {}
Future<User> fetchUserData() async {}

// ❌ INCORRECT
String user_name = 'john';     // snake_case
String UserName = 'john';      // PascalCase
```

### Classes & Widgets (PascalCase)

```dart
// ✅ CORRECT
class UserRepository {}
class LoginScreen extends StatelessWidget {}
enum UserRole { admin, user, guest }

// ❌ INCORRECT
class userRepository {}        // camelCase
class login_screen {}          // snake_case
```

### Constants (lowerCamelCase - Very Good Analysis Standard)

```dart
// ✅ CORRECT
class AppConstants {
  static const String appName = 'MyApp';
  static const int maxRetries = 3;
  static const Duration timeout = Duration(seconds: 30);
}

// ❌ INCORRECT - Not recommended by Very Good Analysis
const String API_BASE_URL = 'https://api.example.com';
const int MAX_RETRIES = 3;
```

### Files & Directories (snake_case)

```dart
// ✅ CORRECT
user_repository.dart
login_screen.dart
api_service.dart

// Directory structure
lib/
├── features/
│   ├── user_profile/
│   └── authentication/
└── shared/
    └── widgets/

// ❌ INCORRECT
UserRepository.dart           // PascalCase
loginScreen.dart             // camelCase
```

## Enforcement

### Automatic Validation

```bash
# Check naming conventions
make naming-check

# Apply automatic fixes
make naming-fix
```

### Linter Configuration

The project uses `analysis_options.yaml` with strict naming rules:

- `camel_case_types`: Classes, enums → PascalCase
- `non_constant_identifier_names`: Variables, functions → camelCase
- `constant_identifier_names`: Constants → lowerCamelCase
- `file_names`: Files → snake_case

All naming violations are treated as **errors**, not warnings.

### Git Hooks

Pre-commit hooks automatically run `dart analyze` to catch naming violations before they're committed.

## Summary

1. **Variables/Functions**: camelCase (`userName`, `fetchData()`)
2. **Classes/Widgets**: PascalCase (`UserModel`, `LoginScreen`)
3. **Constants**: lowerCamelCase (`appName`, `maxRetries`)
4. **Files/Directories**: snake_case (`user_model.dart`, `auth/`)

These conventions ensure consistent, readable code that follows Dart/Flutter best practices and Very Good Analysis standards.
