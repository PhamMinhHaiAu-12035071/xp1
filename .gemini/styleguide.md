# Flutter Coding Standards - Very Good Analysis

## Introduction

This style guide outlines the coding conventions for Flutter applications developed in our organization.
It's based on **very_good_analysis** - a comprehensive linting package designed by Very Good Ventures with 130+ strict lint rules.
This guide ensures consistency, maintainability, and high-quality code across all Flutter projects while following industry best practices.

## Key Principles

* **Very Good Ventures Standards**: Strict adherence to `very_good_analysis` rules
* **Optimized for Readability**: Code must be readable and understandable for first-time readers
* **Comprehensive Documentation**: Write detailed documentation for all public APIs (required by very_good_analysis)
* **Maintainability**: Code that is easy to maintain, extend, and debug
* **Performance First**: Optimize performance from design phase with mandatory const usage
* **Consistency**: Consistent adherence throughout the entire codebase
* **Modern Dart 3+ Syntax**: Use latest language features for type safety and expressiveness
* **Flutter 3.27+ Compatibility**: Follow latest framework updates and deprecation guidelines

## Very Good Analysis Configuration

### Analysis Options (analysis_options.yaml)
```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "**/firebase_options.dart"
    - "build/**"
    - "coverage/**"
  
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

# Very Good Analysis includes most best-practice rules
# Only override when absolutely necessary
linter:
  rules:
    # Override rules if needed (not recommended)
    # lines_longer_than_80_chars: false  # If longer lines needed
```

## Deviations from Official Flutter/Dart Standards

### Line Length
* **Maximum line length:** 80 characters (Very Good standard).
    * Enforces consistent code formatting across the team.
    * Improves code readability and maintainability.

### Import Organization
* **Group imports in this order:**
    * Dart core libraries (`dart:` imports)
    * Flutter framework imports (`package:flutter/`)
    * Third-party packages (alphabetical order)
    * Internal packages (relative imports for files within lib/)
* **Use relative imports** for files within the same package for better maintainability.

### Documentation Style
* **Use triple slash (`///`) for documentation comments** (required by very_good_analysis).
* **Include usage examples** in documentation for complex widgets and methods.
* **Document all public APIs** with detailed parameter descriptions (mandatory).
* **English only**: All documentation must be written in English for international collaboration.

## 🚨 CRITICAL: Flutter 3.27+ Color Deprecation Guidelines

**IMPORTANT**: Flutter 3.27.0+ introduced breaking changes for Color API to support wide-gamut color spaces.

### ✅ CORRECT: Use withValues() (Flutter 3.27+)

```dart
// ✅ CORRECT: New withValues() method (prevents precision loss)
BoxShadow(
  color: Colors.black.withValues(alpha: 0.04),
  blurRadius: 8,
)

// ✅ CORRECT: Access alpha component
final alphaValue = color.a; // Direct floating-point access

// ✅ CORRECT: Convert to ARGB for integer operations
final colorValue = color.toARGB32();
expect(color.toARGB32(), equals(0xFF2196F3));
```

### ❌ DEPRECATED: Avoid these methods (Flutter 3.27+)

```dart
// ❌ DEPRECATED: withOpacity() causes precision loss
BoxShadow(
  color: Colors.black.withOpacity(0.04), // DEPRECATED
  blurRadius: 8,
)

// ❌ DEPRECATED: Old component accessors
final alphaValue = color.alpha;  // DEPRECATED
final colorValue = color.value;  // DEPRECATED
final opacity = color.opacity;   // DEPRECATED
```

### Migration Guide

| **Deprecated (Old)**          | **Recommended (New)**                    | **Reason**                  |
|-------------------------------|------------------------------------------|-----------------------------|
| `color.withOpacity(0.5)`     | `color.withValues(alpha: 0.5)`          | Prevents precision loss     |
| `color.opacity`               | `color.a`                                | Direct floating-point value |
| `color.alpha`                 | `(color.a * 255.0).round() & 0xff`      | Explicit integer conversion |
| `color.value`                 | `color.toARGB32()`                       | Explicit ARGB conversion    |

**Why this change?**
Flutter now supports wide-gamut color spaces (Display P3) beyond sRGB. The new methods provide better precision and avoid data loss when working with modern color spaces.

## 🚀 DART 3+ MODERN SYNTAX - HIGHEST PRIORITY

> **MANDATORY**: Always prioritize Dart 3+ features and syntax over legacy patterns. Use the latest language constructs for better type safety, expressiveness, and performance.

### Pattern Matching & Switch Expressions (Dart 3.0+)

```dart
// ❌ OLD: Switch statement with manual handling
String getStatusMessage(ApiState state) {
  switch (state.runtimeType) {
    case LoadingState:
      return 'Loading...';
    case SuccessState:
      final successState = state as SuccessState;
      return 'Success: ${successState.data}';
    case ErrorState:
      final errorState = state as ErrorState;
      return 'Error: ${errorState.message}';
    default:
      return 'Unknown state';
  }
}

// ✅ DART 3+: Switch expression with pattern matching
String getStatusMessage(ApiState state) => switch (state) {
  LoadingState() => 'Loading...',
  SuccessState(:final data) => 'Success: $data',
  ErrorState(:final message) => 'Error: $message',
};
```

### Sealed Classes for Type Safety (Dart 3.0+)

```dart
// ✅ CORRECT: Sealed class for exhaustive pattern matching
sealed class ApiState {}

final class LoadingState extends ApiState {}

final class SuccessState extends ApiState {
  const SuccessState(this.data);
  final String data;
}

final class ErrorState extends ApiState {
  const ErrorState(this.message);
  final String message;
}

// ✅ USAGE: Compiler ensures exhaustive handling
Widget buildStateWidget(ApiState state) => switch (state) {
  LoadingState() => const CircularProgressIndicator(),
  SuccessState(:final data) => Text(data),
  ErrorState(:final message) => ErrorWidget(message),
  // No default needed - compiler enforces completeness!
};
```

### Records for Multiple Return Values (Dart 3.0+)

```dart
// ❌ OLD: Creating classes for simple data
class ValidationResult {
  const ValidationResult(this.isValid, this.error);
  final bool isValid;
  final String? error;
}

ValidationResult validateEmail(String email) {
  if (email.isEmpty) return ValidationResult(false, 'Email required');
  if (!email.contains('@')) return ValidationResult(false, 'Invalid format');
  return ValidationResult(true, null);
}

// ✅ DART 3+: Records for lightweight data
(bool isValid, String? error) validateEmail(String email) {
  if (email.isEmpty) return (false, 'Email required');
  if (!email.contains('@')) return (false, 'Invalid format');
  return (true, null);
}

// ✅ USAGE: Destructuring assignment
final (isValid, error) = validateEmail(userEmail);
if (!isValid) {
  showError(error!);
}
```

### Extension Types for Zero-Cost Wrappers (Dart 3.3+)

```dart
// ❌ OLD: Runtime overhead with wrapper classes
class UserId {
  const UserId(this.value);
  final String value;
  
  bool get isValid => value.isNotEmpty && value.length > 3;
}

// ✅ DART 3.3+: Zero-cost extension type
extension type UserId(String value) {
  UserId.fromString(String str) : value = str;
  
  bool get isValid => value.isNotEmpty && value.length > 3;
  String get displayName => 'User($value)';
}

// Usage: No runtime cost, full type safety
void processUser(UserId id) {
  if (id.isValid) {
    print(id.displayName);
  }
}
```

#### Documentation Templates for Common Patterns

**Sealed Class Documentation:**
```dart
/// Sealed class representing different application environments.
/// 
/// This class provides a factory pattern for environment-specific 
/// configurations and ensures type safety when switching between 
/// development, staging, and production.
sealed class Environment {
  /// Creates an instance of Environment.
  const Environment();
  
  /// Gets the current environment instance based on compile-time 
  /// configuration.
  static Environment get current => _getCurrentEnvironment();
  
  /// The API base URL for this environment.
  String get apiUrl;
  
  /// The application name for this environment.
  String get appName;
}
```

**Factory Class Documentation:**
```dart
/// Factory class for accessing environment configuration.
/// 
/// Provides static methods to access current environment settings
/// and utilities for environment-specific operations.
class EnvConfigFactory {
  /// Gets the current environment instance.
  static Environment get currentEnvironment => Environment.current;
  
  /// Gets the API URL from the current environment.
  static String get apiUrl => currentEnvironment.apiUrl;
  
  /// Gets the API URL for a specific environment.
  /// 
  /// [environment] The environment to get the API URL from.
  static String getApiUrlForEnvironment(Environment environment) =>
      environment.apiUrl;
}
```

**Implementation Class Documentation:**
```dart
/// Development environment configuration.
/// 
/// Provides configuration values specific to development environment.
final class Development extends Environment {
  /// Creates a development environment instance.
  const Development();
  
  @override
  String get apiUrl => EnvDev.apiUrl;
}
```

**Auto-Documentation Rules:**
- **Classes/Interfaces**: What they represent and their primary purpose
- **Methods**: What they do and their parameters (use `[paramName]` syntax)
- **Properties**: What they represent or contain
- **Constructors**: What they create and initial state
- **Factory methods**: What they return and when to use them
- **Static methods**: Their purpose and when to call them

## Naming Conventions (Very Good Analysis Standards)

### Classes, Enums, Typedefs, Extensions
```dart
// ✅ CORRECT - UpperCamelCase
class UserRepository extends Repository<User> {}
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {}
enum ConnectionState { connected, disconnected }
typedef UserCallback = void Function(User user);
extension StringExtensions on String {}

// ❌ AVOID
class userProfileScreen {} // lowercase
class User_Profile_Screen {} // snake_case
```

### Variables, Methods, Parameters
```dart
// ✅ CORRECT - lowerCamelCase
final String userName = 'john_doe';
int itemCount = 0;
void fetchUserData() {}
void calculateTotalAmount({required double basePrice}) {}

// ❌ AVOID
final String user_name = 'john_doe'; // snake_case
final String UserName = 'john_doe'; // UpperCamelCase
```

### Files and Directories
```dart
// ✅ CORRECT - snake_case
user_repository.dart
payment_bloc.dart
home_page.dart
lib/features/authentication/

// ❌ AVOID
UserRepository.dart // UpperCamelCase
user-repository.dart // kebab-case
```

### Constants (Very Good Analysis Update)
```dart
// ✅ CORRECT - lowerCamelCase for const (not SCREAMING_SNAKE_CASE)
const double defaultPadding = 16.0;
const Color primaryColor = Colors.blue;

// ✅ CORRECT - lowerCamelCase for static const
static const String apiBaseUrl = 'https://api.example.com';
static const int maxRetryCount = 3;

// ❌ AVOID - SCREAMING_SNAKE_CASE is not recommended
static const String API_BASE_URL = 'https://api.example.com';
static const int MAX_RETRY_COUNT = 3;
```

### Private Members
```dart
// ✅ CORRECT - underscore prefix for private members
class _HomePageState extends State<HomePage> {}
final String _privateField = 'private';
void _privateMethod() {}
```

## Code Formatting & Structure

### Indentation and Line Length
```dart
// ✅ CORRECT - Use 2 spaces for indentation (Very Good standard)
class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Example'),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
```

### Trailing Commas
```dart
// ✅ CORRECT - Use trailing comma for better formatting
Widget build(BuildContext context) {
  return Column(
    children: [
      const Text('First item'),
      const Text('Second item'), // trailing comma
    ], // trailing comma
  );
}

// ✅ CORRECT - No trailing comma needed with single parameter
const Text('Simple text')
```

### Import Organization
```dart
// ✅ CORRECT - Group imports by category
// 1. Dart core libraries
import 'dart:async';
import 'dart:convert';

// 2. Flutter framework  
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages (alphabetical order)
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// 4. Internal packages (relative imports for files in lib/)
import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'widgets/user_card.dart';
```

## Widget Best Practices (Very Good Analysis)

### StatelessWidget Template
```dart
/// Widget displaying user information with avatar and name.
/// 
/// This widget automatically loads avatar from URL and displays placeholder
/// if loading fails. Supports callback when user taps.
/// 
/// ## Usage
/// 
/// ```dart
/// UserInfoCard(
///   user: User(
///     name: 'John Doe',
///     email: 'john@example.com',
///     avatarUrl: 'https://example.com/avatar.jpg',
///   ),
///   onTap: () => Navigator.push(context, UserDetailScreen.route()),
///   showAvatar: true,
/// )
/// ```
class UserInfoCard extends StatelessWidget {
  /// Creates a [UserInfoCard].
  /// 
  /// [user] is required and cannot be null.
  /// [onTap] is optional callback when user taps.
  /// [showAvatar] defaults to true.
  const UserInfoCard({
    required this.user,
    this.onTap,
    this.showAvatar = true,
    super.key,
  });

  /// User data to display.
  final User user;
  
  /// Callback called when user taps the card.
  final VoidCallback? onTap;
  
  /// Whether to show avatar or not.
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showAvatar) ...[
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                user.name,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### StatefulWidget Template
```dart
/// Counter widget with state management.
/// 
/// Supports initial value and callback when value changes.
class CounterWidget extends StatefulWidget {
  /// Creates a [CounterWidget].
  /// 
  /// [initialValue] defaults to 0.
  /// [onChanged] is optional callback when value changes.
  const CounterWidget({
    this.initialValue = 0,
    this.onChanged,
    super.key,
  });

  /// Initial value of the counter.
  final int initialValue;
  
  /// Callback called when value changes.
  final ValueChanged<int>? onChanged;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  void _increment() {
    setState(() {
      _count++;
    });
    widget.onChanged?.call(_count);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Count: $_count'),
        IconButton(
          onPressed: _increment,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
```

## Performance Optimization (Very Good Analysis Requirements)

### Const Usage (Mandatory)
```dart
// ✅ MANDATORY - const constructors
const Text('Static text')
const SizedBox(height: 16.0)
const Icon(Icons.home)

// ✅ CORRECT - Const collections
const <String>['item1', 'item2']
const {
  'key1': 'value1',
  'key2': 'value2',
}

// ✅ CORRECT - Const constructor
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
}
```

### Widget Extraction
```dart
// ✅ CORRECT - Extract widgets to avoid unnecessary rebuilds
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Column(
        children: [
          _Header(), // Extract as separate widget
          Expanded(child: _Content()),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.blue,
      child: const Center(
        child: Text('Header'),
      ),
    );
  }
}
```

### ListView Optimization
```dart
// ✅ CORRECT - Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ListTile(
      key: ValueKey(item.id), // Key for dynamic content
      title: Text(item.title),
      subtitle: Text(item.description),
    );
  },
)

// ✅ CORRECT - Use ListView.separated for dividers
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
  separatorBuilder: (context, index) => const Divider(),
)
```

## Error Handling & Null Safety (Very Good Analysis)

### Safe Navigation
```dart
// ✅ CORRECT - Null-aware operators
final userName = user?.name ?? 'Unknown';
final userEmail = user?.profile?.email;
final itemCount = items?.length ?? 0;

// ✅ CORRECT - Safe method calls
user?.updateProfile();
items?.forEach((item) => print(item));

// ❌ AVOID - Unsafe casting
final user = data as User; // May throw exception
// Instead use:
final user = data is User ? data : null;
```

### Exception Handling (Very Good Pattern)
```dart
// ✅ VERY GOOD PATTERN - specific exceptions
class UserNotFoundException implements Exception {
  const UserNotFoundException(this.userId);
  final String userId;
  
  @override
  String toString() => 'UserNotFoundException: User with ID $userId not found';
}

class ApiException implements Exception {
  const ApiException(this.message, this.statusCode);
  final String message;
  final int statusCode;
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

// ✅ REPOSITORY IMPLEMENTATION
class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUser(String id) async {
    try {
      final response = await http.get(Uri.parse('/api/users/$id'));
      
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw UserNotFoundException(id);
      } else {
        throw ApiException('Failed to fetch user', response.statusCode);
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on FormatException {
      throw DataParsingException('Invalid response format');
    } on UserNotFoundException {
      rethrow;
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }
}
```

## State Management Patterns (Very Good Analysis)

### BLoC Pattern (Very Good Style)
```dart
// Event
sealed class UserEvent extends Equatable {
  const UserEvent();
}

final class UserRequested extends UserEvent {
  const UserRequested(this.userId);
  final String userId;
  
  @override
  List<Object> get props => [userId];
}

final class UserUpdated extends UserEvent {
  const UserUpdated(this.user);
  final User user;
  
  @override
  List<Object> get props => [user];
}

// State
sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

final class UserSuccess extends UserState {
  const UserSuccess(this.user);
  final User user;
  
  @override
  List<Object> get props => [user];
}

final class UserFailure extends UserState {
  const UserFailure(this.error);
  final String error;
  
  @override
  List<Object> get props => [error];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<UserRequested>(_onUserRequested);
    on<UserUpdated>(_onUserUpdated);
  }

  final UserRepository _userRepository;

  Future<void> _onUserRequested(
    UserRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    
    try {
      final user = await _userRepository.getUser(event.userId);
      emit(UserSuccess(user));
    } catch (error) {
      emit(UserFailure(error.toString()));
    }
  }

  Future<void> _onUserUpdated(
    UserUpdated event,
    Emitter<UserState> emit,
  ) async {
    try {
      await _userRepository.saveUser(event.user);
      emit(UserSuccess(event.user));
    } catch (error) {
      emit(UserFailure(error.toString()));
    }
  }
}
```

## Documentation Standards (Very Good Analysis Requirements)

### Class Documentation
```dart
/// Repository for managing user data.
/// 
/// Provides methods for CRUD operations with user entities
/// through local database and remote API.
/// 
/// ## Usage
/// 
/// ```dart
/// final repository = UserRepository();
/// final user = await repository.getUser('user123');
/// ```
/// 
/// ## See also
/// 
/// * [User], model class for user data
/// * [UserBloc], BLoC for managing user state
abstract class UserRepository {
  /// Gets user by ID.
  /// 
  /// Throws [UserNotFoundException] if not found.
  /// 
  /// ## Parameters
  /// 
  /// * [id] - User ID to retrieve
  /// 
  /// ## Returns
  /// 
  /// Future<User> - User data
  /// 
  /// ## Throws
  /// 
  /// * [UserNotFoundException] - When user doesn't exist
  /// * [ApiException] - When API call fails
  Future<User> getUser(String id);
  
  /// Saves or updates user.
  /// 
  /// ## Parameters
  /// 
  /// * [user] - User data to save
  /// 
  /// ## Returns
  /// 
  /// Future<void> - Completes when save succeeds
  /// 
  /// ## Throws
  /// 
  /// * [ApiException] - When API call fails
  Future<void> saveUser(User user);
}
```

### Method Documentation
```dart
/// Validates email address format.
/// 
/// Returns `true` if [email] has valid format, `false` otherwise.
/// 
/// ## Parameters
/// 
/// * [email] - Email address to validate
/// 
/// ## Returns
/// 
/// bool - True if email is valid, false otherwise
/// 
/// ## Examples
/// 
/// ```dart
/// print(isValidEmail('user@example.com')); // true
/// print(isValidEmail('invalid-email'));    // false
/// ```
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}
```

## Testing Standards (Very Good Analysis)

### Unit Test Structure
```dart
void main() {
  group('UserRepository', () {
    late UserRepository userRepository;
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
      userRepository = UserRepositoryImpl(apiClient: mockApiClient);
    });

    group('getUser', () {
      test('should return user when API call succeeds', () async {
        // Arrange
        const userId = 'user123';
        const expectedUser = User(
          id: userId,
          name: 'John Doe',
          email: 'john@example.com',
        );
        
        when(() => mockApiClient.getUser(userId))
            .thenAnswer((_) async => expectedUser);

        // Act
        final result = await userRepository.getUser(userId);

        // Assert
        expect(result, equals(expectedUser));
        verify(() => mockApiClient.getUser(userId)).called(1);
      });

      test('should throw UserNotFoundException when user not found', () async {
        // Arrange
        const userId = 'user123';
        when(() => mockApiClient.getUser(userId))
            .thenThrow(const UserNotFoundException(userId));

        // Act & Assert
        expect(
          () => userRepository.getUser(userId),
          throwsA(isA<UserNotFoundException>()),
        );
      });
    });
  });
}
```

### Widget Test Structure
```dart
void main() {
  group('UserInfoCard', () {
    late User testUser;

    setUp(() {
      testUser = const User(
        id: '1',
        name: 'John Doe', 
        email: 'john@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
      );
    });

    testWidgets('should display user name and email', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserInfoCard(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      var tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserInfoCard(
              user: testUser,
              onTap: () => tapCount++,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(UserInfoCard));
      await tester.pump();

      // Assert
      expect(tapCount, equals(1));
    });
  });
}
```

## Project Structure (Very Good CLI Default)

```
lib/
├── app/                     # App-level configuration
│   ├── app.dart
│   └── view/
│       └── app.dart
├── counter/                 # Feature modules
│   ├── counter.dart
│   ├── cubit/
│   └── view/
├── l10n/                    # Localization
│   └── arb/
└── main.dart
```

## Development Workflow

### 1. Pre-commit setup với very_good_cli
```bash
# Cài lefthook (đã include trong very_good_cli)
very_good packages get

# lefthook.yml sẽ tự động được tạo với:
```

```yaml
# lefthook.yml (auto-generated)
pre-commit:
  commands:
    analyze:
      glob: "*.dart"
      run: flutter analyze --fatal-infos
    format:
      glob: "*.dart"  
      run: dart format --set-exit-if-changed {staged_files}
    test:
      glob: "*.dart"
      run: flutter test --optimization --coverage --test-randomize-ordering-seed random
```

### 2. Scripts commands
```bash
# Format code
dart format .

# Analyze with very_good_analysis
flutter analyze --fatal-infos

# Run tests với coverage
flutter test --coverage --test-randomize-ordering-seed random

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### 3. VS Code settings cho Very Good
```json
{
  "dart.lineLength": 80,  // Very Good standard
  "dart.enableSdkFormatter": true,
  "editor.formatOnSave": true,
  "editor.rulers": [80],
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.selectionHighlight": false
  }
}
```

## Code Review Checklist

- [ ] Naming conventions được tuân thủ (Very Good Analysis)
- [ ] Code được format đúng (dart format)
- [ ] Không có unused imports hoặc variables
- [ ] Sử dụng const constructors khi có thể (bắt buộc)
- [ ] Error handling được implement đầy đủ với specific exceptions
- [ ] Null safety được xử lý đúng cách
- [ ] Documentation đầy đủ cho public APIs (bắt buộc)
- [ ] Unit tests cover các use cases chính
- [ ] Performance considerations được xem xét
- [ ] UI responsive trên các screen sizes khác nhau
- [ ] Tuân thủ very_good_analysis rules (130+ rules)

## Tooling

### Recommended packages
```yaml
dev_dependencies:
  very_good_analysis: ^9.0.0  # Stricter linting rules
  mocktail: ^1.0.3            # Mocking for tests
  test: ^1.25.2               # Testing framework
```

### Analysis options
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "**/firebase_options.dart"
    - "build/**"
    - "coverage/**"
  
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

# Very Good Analysis đã include hầu hết rules tốt nhất
# Chỉ override khi thực sự cần thiết
linter:
  rules:
    # Override rules nếu cần (không khuyến khích)
    # lines_longer_than_80_chars: false  # Nếu cần dòng dài hơn
```

## Integration với Gemini Code Assist

### Updated config.yaml
```yaml
have_fun: false
code_review:
  disable: false
  comment_severity_threshold: HIGH  # Stricter vì đã có very_good_analysis
  max_review_comments: 10
pull_request_opened:
  help: false
  summary: true
  code_review: true

ignore_patterns:
  - "**/*.g.dart"
  - "**/*.freezed.dart"
  - "**/*.mocks.dart"
  - "build/**"
  - "coverage/**"
  - "test/.test_coverage.dart"
```

## Flutter-Specific Best Practices

### Navigation
```dart
// ✅ CORRECT - Use named routes
Navigator.pushNamed(context, '/user-detail', arguments: userId);

// ✅ CORRECT - Use GoRouter for complex navigation
GoRouter.of(context).push('/user/$userId');
```

### Localization
```dart
// ✅ CORRECT - Use AppLocalizations
Text(AppLocalizations.of(context)!.welcomeMessage)

// ✅ CORRECT - Use context extension
Text(context.l10n.welcomeMessage)
```

### Theme Usage
```dart
// ✅ CORRECT - Use Theme.of(context)
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
)
```

### Responsive Design
```dart
// ✅ CORRECT - Use MediaQuery and LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return const DesktopLayout();
    } else {
      return const MobileLayout();
    }
  },
)
```

## Security Guidelines

### Input Validation
```dart
// ✅ CORRECT - Validate user input
class UserInputValidator {
  /// Validates email address format.
  /// 
  /// Returns `true` if [email] has valid format, `false` otherwise.
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }
}
```

### Secure Storage
```dart
// ✅ CORRECT - Use flutter_secure_storage for sensitive data
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

## Accessibility

### Semantic Labels
```dart
// ✅ CORRECT - Add semantic labels for accessibility
IconButton(
  onPressed: () {},
  icon: const Icon(Icons.close),
  tooltip: 'Close dialog',
  semanticsLabel: 'Close dialog button',
)
```

### Color Contrast
```dart
// ✅ CORRECT - Ensure sufficient contrast ratio
Text(
  'Important text',
  style: TextStyle(
    color: Colors.white,
    backgroundColor: Colors.black87, // High contrast
  ),
)
```

## Code Review Focus Areas

Gemini Code Assist sẽ tự động review code theo 5 categories chính:

1. **Correctness** - Đảm bảo code hoạt động đúng, xử lý edge cases, kiểm tra logic errors
2. **Efficiency** - Tối ưu performance, tránh memory leaks, cấu trúc dữ liệu hiệu quả
3. **Maintainability** - Code dễ đọc, module hoá tốt, đặt tên rõ ràng
4. **Security** - Bảo mật data handling, input validation, tránh vulnerabilities
5. **Miscellaneous** - Testing, scalability, error handling và monitoring

## Complete Example

The following example demonstrates a complete Flutter application that follows all the Very Good Analysis principles outlined in this style guide:

```dart
/// Main application entry point.
/// 
/// This app demonstrates a simple user management system with proper
/// state management, error handling, and testing practices.
void main() {
  runApp(const UserManagementApp());
}

/// Main application widget that sets up the app structure.
/// 
/// Uses Material Design 3 and implements proper theming and localization.
class UserManagementApp extends StatelessWidget {
  const UserManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UserListScreen(),
    );
  }
}

/// Screen that displays a list of users with proper state management.
/// 
/// Demonstrates BLoC pattern, error handling, and responsive design.
class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        userRepository: UserRepositoryImpl(
          apiClient: ApiClient(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const _UserListBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddUserDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddUserDialog(),
    );
  }
}

/// Body widget that handles the user list display logic.
/// 
/// Extracted as a separate widget to improve maintainability and testing.
class _UserListBody extends StatelessWidget {
  const _UserListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return switch (state) {
          UserInitial() => const _LoadingWidget(),
          UserLoading() => const _LoadingWidget(),
          UserSuccess() => _UserListView(users: state.users),
          UserFailure() => _ErrorWidget(message: state.error),
        };
      },
    );
  }
}

/// Widget that displays a loading indicator.
/// 
/// Uses const constructor for better performance.
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Widget that displays an error message with retry functionality.
/// 
/// Demonstrates proper error handling and user feedback.
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<UserBloc>().add(const LoadUsers()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Widget that displays the list of users.
/// 
/// Uses ListView.builder for optimal performance with large lists.
class _UserListView extends StatelessWidget {
  const _UserListView({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserInfoCard(
          key: ValueKey(user.id),
          user: user,
          onTap: () => _navigateToUserDetail(context, user),
        );
      },
    );
  }

  void _navigateToUserDetail(BuildContext context, User user) {
    Navigator.pushNamed(
      context,
      '/user-detail',
      arguments: user,
    );
  }
}

/// Dialog for adding new users with proper form validation.
/// 
/// Demonstrates form handling, validation, and state management.
class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!UserInputValidator.isValidEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        avatarUrl: 'https://via.placeholder.com/150',
      );
      
      context.read<UserBloc>().add(UserUpdated(user));
      Navigator.of(context).pop();
    }
  }
}

/// Utility class for input validation.
/// 
/// Contains static methods for validating user input.
class UserInputValidator {
  /// Validates email address format.
  /// 
  /// Returns `true` if [email] has valid format, `false` otherwise.
  /// 
  /// ## Examples
  /// 
  /// ```dart
  /// print(UserInputValidator.isValidEmail('user@example.com')); // true
  /// print(UserInputValidator.isValidEmail('invalid-email'));    // false
  /// ```
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```