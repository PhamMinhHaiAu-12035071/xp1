# Development Guidelines

## 📋 Overview

This document outlines the development standards, best practices, and guidelines for contributing to the Xp1 Flutter project. Following these guidelines ensures code quality, maintainability, and consistency across the codebase.

## 🏗️ Architecture Guidelines

### BLoC Pattern Implementation

#### Cubit Structure

```dart
// ✅ Good: Clean cubit implementation
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// ❌ Avoid: Complex logic in cubit
class BadCubit extends Cubit<int> {
  BadCubit() : super(0);

  void increment() {
    // Complex business logic here
    final newValue = state + 1;
    if (newValue > 100) {
      // Handle edge case
    }
    emit(newValue);
  }
}
```

#### Widget Integration

```dart
// ✅ Good: Proper BLoC provider usage
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

// ✅ Good: Efficient state consumption
class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count');
  }
}
```

### Feature Organization

#### Directory Structure

```
feature_name/
├── cubit/
│   ├── feature_cubit.dart
│   └── feature_state.dart
├── view/
│   ├── feature_page.dart
│   └── widgets/
│       ├── feature_widget.dart
│       └── feature_card.dart
├── models/
│   └── feature_model.dart
└── feature.dart  # Barrel export
```

#### Barrel Exports

```dart
// ✅ Good: Clean barrel export
export 'cubit/counter_cubit.dart';
export 'view/counter_page.dart';
```

## 📝 Code Style Guidelines

### Naming Conventions

#### Classes and Files

```dart
// ✅ Good: PascalCase for classes
class CounterCubit extends Cubit<int> {}
class CounterPage extends StatelessWidget {}

// ✅ Good: snake_case for files
counter_cubit.dart
counter_page.dart
```

#### Variables and Methods

```dart
// ✅ Good: camelCase for variables and methods
final counterValue = 0;
void incrementCounter() {}

// ❌ Avoid: snake_case for variables
final counter_value = 0;
```

#### Constants

```dart
// ✅ Good: lowerCamelCase for constants (Very Good Analysis standard)
class AppConstants {
  static const String appName = 'Xp1';
  static const int maxCounterValue = 100;
  static const double defaultPadding = 16.0;
  static const Color primaryColor = Colors.blue;
}

// ❌ Avoid: SCREAMING_SNAKE_CASE (not recommended by Very Good Analysis)
static const String APP_NAME = 'Xp1';
static const int MAX_COUNTER_VALUE = 100;
```

### Code Formatting

#### Import Organization

```dart
// ✅ Good: Organized imports
import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:xp1/counter/counter.dart';
import 'package:xp1/l10n/l10n.dart';
```

#### Widget Structure

```dart
// ✅ Good: Clean widget structure
class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.counterAppBarTitle),
      ),
      body: const Center(
        child: CounterText(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

### Cascade Operators (`..`) - **MANDATORY USAGE**

**STOP creating unnecessary variables when you're going to call multiple methods on the same object.** Use cascade operators. This is not a suggestion - it's a requirement to avoid `cascade_invocations` linter errors.

#### **🔥 THE GOLDEN RULE: Multiple Method Calls = Cascade Operators**

```dart
// ❌ GARBAGE: Creating variables for multiple calls
final logger = Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
);
logger.e('Error message 1');
logger.e('Error message 2');
logger.e('Error message 3');

// ✅ CORRECT: Use cascade operators for multiple calls
Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
)
  ..e('Error message 1')
  ..e('Error message 2')
  ..e('Error message 3');

// ❌ GARBAGE: Multiple method calls on same reference
SomeClass someReference = SomeClass();
someReference.firstMethod();
someReference.secondMethod();
someReference.thirdMethod();

// ✅ CORRECT: Cascade consecutive method calls
SomeClass someReference = SomeClass()
  ..firstMethod()
  ..secondMethod()
  ..thirdMethod();

// ✅ ALSO CORRECT: Separate declaration with cascades
SomeClass someReference = SomeClass();
// ... other code in between ...
someReference
  ..firstMethod()
  ..secondMethod()
  ..thirdMethod();
```

#### **⚡ Single Method Call Rules**

```dart
// ✅ CORRECT: Single call, use dot notation
Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
).e('Single error message');

// ❌ WRONG: Don't use cascade for single calls (avoid_single_cascade_in_expression_statements)
Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
)..e('Single error message');
```

#### **🎯 Real-World CLI Tool Examples**

Based on our actual codebase fixes:

```dart
// ❌ BAD: What we had before (creates variables for no reason)
if (args.isEmpty) {
  final logger = Logger(
    printer: _SimplePrinter(),
    output: _CliLogOutput(),
  );
  logger.e('❌ Missing commit message');
  logger.e('💡 Usage: dart run tool/validate_commit.dart <message>');
  exit(1);
}

// ✅ GOOD: What we fixed it to (proper cascade usage)
if (args.isEmpty) {
  Logger(
    printer: _SimplePrinter(),
    output: _CliLogOutput(),
  )
    ..e('❌ Missing commit message')
    ..e('💡 Usage: dart run tool/validate_commit.dart <message>');
  exit(1);
}

// ✅ ALSO GOOD: Single call without cascade
if (commitMessage.isEmpty) {
  Logger(
    printer: _SimplePrinter(),
    output: _CliLogOutput(),
  ).e('❌ Empty commit message');
  exit(1);
}
```

#### **🛠️ Error Handling Patterns with Cascades**

```dart
// ✅ CORRECT: Error messages with context
static void _printTypeError(String type) {
  _logger
    ..e('❌ Invalid commit type: "$type"')
    ..e('')
    ..e('🔧 Available types: ${allowedTypes.join(', ')}');
  _printExamples();
}

// ✅ CORRECT: Complex error output
static void _printExamples() {
  _logger
    ..e('✅ Correct format: type(scope): description')
    ..e('')
    ..e('📝 Examples:')
    ..e('   feat(auth): add user registration')
    ..e('   fix(ui): resolve button alignment issue')
    ..e('   docs: update installation guide')
    ..e('   feat!: add breaking change')
    ..e('')
    ..e('📏 Rules:')
    ..e('   • 3-72 characters for description')
    ..e('   • Lowercase description')
    ..e('   • Optional scope in parentheses')
    ..e('   • Use ! for breaking changes');
}
```

#### **🎖️ WHY This Matters (Technical Debt Prevention)**

1. **Eliminates pointless variables** - No more `final logger = ...` when you'll only use it for method calls
2. **Reduces code noise** - Fewer lines, cleaner intent
3. **Prevents linter errors** - `cascade_invocations` rule compliance
4. **Better readability** - Clear chains of operations on the same object
5. **Follows Dart idioms** - This is how Dart code should be written

#### **🚨 Common Mistakes to Avoid**

```dart
// ❌ WRONG: Single cascade (triggers avoid_single_cascade_in_expression_statements)
object..method();

// ✅ RIGHT: Single call uses dot notation
object.method();

// ❌ WRONG: Mixed patterns in same codebase
final obj = Object();
obj.method1();  // Sometimes this...
obj..method2(); // Sometimes this... BE CONSISTENT!

// ✅ RIGHT: Consistent cascade usage
final obj = Object()
  ..method1()
  ..method2();
```

**BOTTOM LINE:** If you're calling 2+ methods on the same object reference, use cascades. If you're calling 1 method, use dot notation. **No exceptions. No excuses. No linter errors.**

## 🧪 Testing Guidelines

### Unit Testing (Very Good Analysis Standards)

#### Cubit Testing

```dart
// ✅ Good: Comprehensive cubit tests with proper structure
void main() {
  group('CounterCubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });

    test('initial state is 0', () {
      expect(counterCubit.state, equals(0));
    });

    blocTest<CounterCubit, int>(
      'emits [1] when increment is called',
      build: () => counterCubit,
      act: (cubit) => cubit.increment(),
      expect: () => [equals(1)],
    );

    blocTest<CounterCubit, int>(
      'emits [-1] when decrement is called',
      build: () => counterCubit,
      act: (cubit) => cubit.decrement(),
      expect: () => [equals(-1)],
    );

    blocTest<CounterCubit, int>(
      'emits [0, 1, 2] when increment is called multiple times',
      build: () => counterCubit,
      act: (cubit) => cubit
        ..increment()
        ..increment(),
      expect: () => [equals(1), equals(2)],
    );
  });
}
```

#### Repository Testing

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

#### Widget Testing

```dart
// ✅ Good: Widget test with proper setup
void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      await tester.pumpWidget(const App());

      expect(find.byType(CounterView), findsOneWidget);
    });

    testWidgets('increments counter when + button is pressed', (tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });
  });
}
```

### Test Organization

```
test/
├── feature_name/
│   ├── cubit/
│   │   └── feature_cubit_test.dart
│   └── view/
│       └── feature_page_test.dart
└── helpers/
    ├── helpers.dart
    └── pump_app.dart
```

## 🌐 Internationalization Guidelines

### Adding New Strings

#### ARB File Structure

```json
// ✅ Good: Proper ARB structure
{
  "@@locale": "en",
  "counterAppBarTitle": "Counter",
  "@counterAppBarTitle": {
    "description": "Text shown in the AppBar of the Counter Page"
  },
  "newFeatureTitle": "New Feature",
  "@newFeatureTitle": {
    "description": "Title for the new feature page"
  }
}
```

#### Usage in Code

```dart
// ✅ Good: Proper l10n usage
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.counterAppBarTitle),
      ),
      // ...
    );
  }
}
```

## 🔧 Development Workflow

### Git Workflow

#### Branch Naming

```bash
# ✅ Good: Descriptive branch names
feature/add-user-authentication
bugfix/fix-counter-increment
hotfix/critical-security-patch
```

#### Commit Messages

```bash
# ✅ Good: Conventional commit format
feat: add user authentication feature
fix: resolve counter increment bug
docs: update README with new features
test: add tests for counter cubit
refactor: improve widget structure
```

### Code Review Checklist (Very Good Analysis Standards)

#### Before Submitting PR

- [ ] Naming conventions followed (Very Good Analysis)
- [ ] Code properly formatted (dart format)
- [ ] No unused imports or variables
- [ ] Use const constructors when possible (required)
- [ ] Error handling implemented fully with specific exceptions
- [ ] Null safety handled properly
- [ ] Documentation complete for public APIs (required)
- [ ] Unit tests cover main use cases
- [ ] Performance considerations addressed
- [ ] UI responsive across different screen sizes
- [ ] Follow very_good_analysis rules (130+ rules)
- [ ] Internationalization strings added
- [ ] Security considerations addressed

#### Review Process

- [ ] Architecture alignment with BLoC pattern
- [ ] Code quality and readability following Very Good standards
- [ ] Test coverage adequacy with proper mocking
- [ ] Security considerations and input validation
- [ ] Performance impact assessment
- [ ] Documentation completeness and accuracy
- [ ] Error handling patterns consistency

## 🚀 Performance Guidelines

### Widget Optimization

#### Efficient Rebuilds

```dart
// ✅ Good: Selective rebuilds
class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count');
  }
}

// ❌ Avoid: Unnecessary rebuilds
class BadCounterText extends StatelessWidget {
  const BadCounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CounterCubit>();
    return Text('${cubit.state}');
  }
}
```

#### Memory Management

```dart
// ✅ Good: Proper disposal
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Timer logic
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
```

## 🔒 Security Guidelines

### Input Validation

```dart
// ✅ Good: Input validation
class UserInputValidator {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8;
  }
}
```

### Error Handling (Very Good Analysis Standards)

#### Specific Exception Classes

```dart
// ✅ Very Good pattern - specific exceptions
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

class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
```

#### Repository Error Handling

```dart
// ✅ Repository implementation with proper error handling
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

#### BLoC Error Handling

```dart
// ✅ BLoC with proper error handling
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<UserRequested>(_onUserRequested);
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
    } on UserNotFoundException {
      emit(const UserFailure('User not found'));
    } on NetworkException {
      emit(const UserFailure('Network error. Please check your connection.'));
    } on ApiException catch (e) {
      emit(UserFailure('API error: ${e.message}'));
    } catch (error) {
      emit(UserFailure('Unexpected error: $error'));
    }
  }
}
```

## 📚 Documentation Guidelines (Very Good Analysis Standards)

### Documentation Requirements (Required)

- **Use triple slash (`///`) for documentation comments** (required with very_good_analysis)
- **Document all public APIs** with detailed parameter descriptions (required)
- **Include usage examples** in documentation for complex widgets and methods
- **Comprehensive documentation** for all public APIs

### Class Documentation

````dart
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
  /// Get user by ID.
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
  /// * [UserNotFoundException] - When user does not exist
  /// * [ApiException] - When API call fails
  Future<User> getUser(String id);
}
````

### Method Documentation

````dart
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
````

### Widget Documentation

````dart
/// Widget displays user information with avatar and name.
///
/// This widget automatically loads avatar from URL and displays placeholder
/// if loading fails. Supports callback when user taps on it.
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
  /// Creates [UserInfoCard].
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

  /// Callback called when user taps on card.
  final VoidCallback? onTap;

  /// Whether to show avatar or not.
  final bool showAvatar;
}
````

### README Updates

- Update README when adding new features
- Include code examples for new functionality
- Update installation instructions if dependencies change
- Document breaking changes

## 🛠️ Tool Configuration

### Analysis Options (Very Good Analysis Configuration)

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

# Very Good Analysis already includes most best practices
# Only override when truly necessary
linter:
  rules:
    # Override rules if needed (not recommended)
    # lines_longer_than_80_chars: false  # If longer lines needed
```

### VS Code Settings for Very Good

```json
{
  "dart.lineLength": 80, // Very Good standard
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

### IDE Configuration

- Enable Dart analysis
- Configure auto-format on save
- Set up linting rules
- Configure test runner

## 🔄 Continuous Integration

### CI/CD Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: genhtml coverage/lcov.info -o coverage/
```

## 📈 Monitoring and Analytics

### Error Tracking

```dart
// ✅ Good: Error logging
class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    // Send to error tracking service
    super.onError(bloc, error, stackTrace);
  }
}
```

### Performance Monitoring

- Monitor widget rebuilds
- Track memory usage
- Monitor app startup time
- Track user interactions

---

_These guidelines ensure consistent, maintainable, and high-quality code across the Xp1 Flutter project._
