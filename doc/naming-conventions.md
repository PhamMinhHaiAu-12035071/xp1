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
String user_name = 'john';
String UserName = 'john';
```

### Classes & Widgets (PascalCase)

```dart
// ✅ CORRECT
class UserRepository {}
class LoginScreen extends StatelessWidget {}
enum UserRole { admin, user, guest }

// ❌ INCORRECT
class userRepository {}
class login_screen {}
```

### Constants (lowerCamelCase - Very Good Analysis Standard)

```dart
// ✅ CORRECT
static const String appName = 'MyApp';
static const int maxRetries = 3;

// ❌ INCORRECT
const String API_BASE_URL = 'https://api.example.com';
```

### Files & Directories (snake_case)

```dart
// ✅ CORRECT
user_repository.dart
login_screen.dart
api_service.dart

// Directory structure
lib/features/user_profile/
lib/features/authentication/
lib/shared/widgets/

// ❌ INCORRECT
UserRepository.dart
loginScreen.dart
```

## Enforcement

```bash
# Check naming conventions
make naming-check

# Apply automatic fixes
make naming-fix
```

### Linter Rules

The project enforces naming through `analysis_options.yaml`:

- `camel_case_types`: Classes, enums → PascalCase
- `non_constant_identifier_names`: Variables, functions → camelCase
- `constant_identifier_names`: Constants → lowerCamelCase
- `file_names`: Files → snake_case

All violations are **errors**. Pre-commit hooks run `dart analyze` automatically.

## Summary

1. **Variables/Functions**: camelCase (`userName`, `fetchData()`)
2. **Classes/Widgets**: PascalCase (`UserModel`, `LoginScreen`)
3. **Constants**: lowerCamelCase (`appName`, `maxRetries`)
4. **Files/Directories**: snake_case (`user_model.dart`, `auth/`)

These conventions follow Dart/Flutter best practices and Very Good Analysis standards.
