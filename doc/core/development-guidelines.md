# Development Guidelines

## 📋 Overview

This document outlines the development standards, best practices, and guidelines for contributing to the Xp1 Flutter project. Following these guidelines ensures code quality, maintainability, and consistency across the codebase.

## 🏗️ Architecture Guidelines

### Navigation System Implementation

#### Auto Route Configuration

```dart
// ✅ Good: Type-safe route configuration
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

// ❌ Avoid: String-based navigation
Navigator.pushNamed(context, '/profile');
Navigator.pushReplacementNamed(context, '/home');
```

#### Route Guards Implementation

```dart
// ✅ Good: Clean guard implementation
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

// ❌ Avoid: Heavy operations in guards
class BadAuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // ❌ Don't make API calls in guards
    final isAuth = await authApi.checkToken();
    // This blocks navigation
  }
}
```

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

#### Directory Structure (Updated for Navigation)

```
feature_name/
├── presentation/
│   └── pages/
│       ├── feature_page.dart
│       └── widgets/
│           ├── feature_widget.dart
│           └── feature_card.dart
├── cubit/
│   ├── feature_cubit.dart
│   └── feature_state.dart
├── models/
│   ├── feature_model.dart          # Freezed models
│   ├── feature_model.freezed.dart  # Generated file
│   └── feature_model.g.dart        # Generated JSON
└── feature.dart  # Barrel export (optional)
```

#### Navigation Data Structures (Linus Principle)

```dart
// ✅ Good: Eliminate special cases with data structures
class NavTabConfig {
  const NavTabConfig({
    required this.route,
    required this.icon,
    required this.label,
  });

  final PageRouteInfo route;
  final IconData icon;
  final String label;
}

// Single source of truth for navigation tabs
static const List<NavTabConfig> _navTabs = [
  NavTabConfig(route: HomeRoute(), icon: Icons.home, label: 'Home'),
  NavTabConfig(route: ProfileRoute(), icon: Icons.person, label: 'Profile'),
];

// Generate both routes and navigation items from same data
AutoTabsScaffold(
  routes: _navTabs.map((tab) => tab.route).toList(),
  bottomNavigationBuilder: (_, tabsRouter) {
    return BottomNavigationBar(
      items: _navTabs.map((tab) => BottomNavigationBarItem(
        icon: Icon(tab.icon),
        label: tab.label,
      )).toList(),
    );
  },
)
```

#### Barrel Exports

```dart
// ✅ Good: Clean barrel export
export 'presentation/pages/counter_page.dart';
export 'cubit/counter_cubit.dart';
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

## 🏗️ Data Modeling with Freezed

### Freezed Implementation Patterns

#### Basic Data Models

```dart
// ✅ Good: Freezed data model with JSON support
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    @Default(false) bool isActive,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
```

#### Union Types for State Management

```dart
// ✅ Good: Freezed unions for BLoC states
@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserInitial;
  const factory UserState.loading() = UserLoading;
  const factory UserState.success(UserModel user) = UserSuccess;
  const factory UserState.failure(String message) = UserFailure;
}

// Usage in BLoC
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState.initial());

  Future<void> fetchUser(String id) async {
    emit(const UserState.loading());
    try {
      final user = await userRepository.getUser(id);
      emit(UserState.success(user));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }
}
```

#### Advanced Freezed Patterns

```dart
// ✅ Good: Custom methods and getters
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String firstName,
    required String lastName,
    String? email,
  }) = _UserModel;

  // Custom getters
  const UserModel._();

  String get fullName => '$firstName $lastName';
  bool get hasEmail => email != null && email!.isNotEmpty;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
```

## 🔄 Functional Programming Patterns

### Either Types for Error Handling

```dart
// ✅ Good: Using dartz Either for error handling
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<UserFailure, UserModel>> getUser(String id);
  Future<Either<UserFailure, List<UserModel>>> getUsers();
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<UserFailure, UserModel>> getUser(String id) async {
    try {
      final response = await apiClient.getUser(id);
      final user = UserModel.fromJson(response.data);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(UserFailure.network(e.message));
    } on ApiException catch (e) {
      return Left(UserFailure.api(e.message, e.statusCode));
    } catch (e) {
      return Left(UserFailure.unknown(e.toString()));
    }
  }
}
```

#### BLoC Integration with Either

```dart
// ✅ Good: BLoC with Either types
class UserCubit extends Cubit<UserState> {
  UserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserState.initial());

  final UserRepository _userRepository;

  Future<void> fetchUser(String id) async {
    emit(const UserState.loading());

    final result = await _userRepository.getUser(id);

    result.fold(
      (failure) => emit(UserState.failure(failure.message)),
      (user) => emit(UserState.success(user)),
    );
  }
}
```

### Option Types for Null Safety

```dart
// ✅ Good: Using Option for better null handling
import 'package:dartz/dartz.dart';

class UserService {
  Option<UserModel> findUserByEmail(String email) {
    final user = users.firstWhereOrNull((user) => user.email == email);
    return optionOf(user);
  }

  String getUserDisplayName(String email) {
    return findUserByEmail(email).fold(
      () => 'Unknown User',
      (user) => user.fullName,
    );
  }
}
```

## 🏪 Advanced State Management

### Hydrated BLoC Implementation

```dart
// ✅ Good: Hydrated BLoC for persistent state
class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState.initial());

  void updateTheme(ThemeMode theme) {
    state.maybeWhen(
      loaded: (settings) => emit(
        SettingsState.loaded(settings.copyWith(themeMode: theme)),
      ),
      orElse: () {},
    );
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      return SettingsState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.maybeWhen(
      loaded: (settings) => settings.toJson(),
      orElse: () => null,
    );
  }
}
```

### Replay BLoC for Undo/Redo

```dart
// ✅ Good: Replay BLoC implementation
class CounterCubit extends ReplayCubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// Usage with undo/redo
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: context.read<CounterCubit>().canUndo
                ? () => context.read<CounterCubit>().undo()
                : null,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: context.read<CounterCubit>().canRedo
                ? () => context.read<CounterCubit>().redo()
                : null,
            icon: const Icon(Icons.redo),
          ),
        ],
      ),
      // ... rest of the widget
    );
  }
}
```

### Cascade Operators (`..`) - **RECOMMENDED USAGE**

**Prefer using cascade operators when calling multiple methods on the same object.** This helps avoid creating unnecessary variables and follows Dart best practices to prevent `cascade_invocations` linter errors.

#### **🔥 THE GOLDEN RULE: Multiple Method Calls = Cascade Operators**

```dart
// ❌ Avoid: Creating variables for multiple calls
final logger = Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
);
logger.e('Error message 1');
logger.e('Error message 2');
logger.e('Error message 3');

// ✅ Preferred: Use cascade operators for multiple calls
Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
)
  ..e('Error message 1')
  ..e('Error message 2')
  ..e('Error message 3');

// ❌ Avoid: Multiple method calls on same reference
SomeClass someReference = SomeClass();
someReference.firstMethod();
someReference.secondMethod();
someReference.thirdMethod();

// ✅ Preferred: Cascade consecutive method calls
SomeClass someReference = SomeClass()
  ..firstMethod()
  ..secondMethod()
  ..thirdMethod();

// ✅ Also good: Separate declaration with cascades
SomeClass someReference = SomeClass();
// ... other code in between ...
someReference
  ..firstMethod()
  ..secondMethod()
  ..thirdMethod();
```

#### **⚡ Single Method Call Rules**

```dart
// ✅ Preferred: Single call, use dot notation
Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
).e('Single error message');

// ❌ Avoid: Don't use cascade for single calls (avoid_single_cascade_in_expression_statements)
Logger(
  printer: SimplePrinter(),
  output: CliLogOutput(),
)..e('Single error message');
```

#### **🎯 Real-World CLI Tool Examples**

Based on our actual codebase fixes:

```dart
// ❌ Before: Creates variables unnecessarily
if (args.isEmpty) {
  final logger = Logger(
    printer: _SimplePrinter(),
    output: _CliLogOutput(),
  );
  logger.e('❌ Missing commit message');
  logger.e('💡 Usage: dart run tool/validate_commit.dart <message>');
  exit(1);
}

// ✅ Improved: Using cascade operators
if (args.isEmpty) {
  Logger(
    printer: _SimplePrinter(),
    output: _CliLogOutput(),
  )
    ..e('❌ Missing commit message')
    ..e('💡 Usage: dart run tool/validate_commit.dart <message>');
  exit(1);
}

// ✅ Also good: Single call without cascade
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

#### **🎖️ Why This Matters (Benefits)**

1. **Eliminates unnecessary variables** - No need for `final logger = ...` when you'll only use it for method calls
2. **Reduces code noise** - Fewer lines, cleaner intent
3. **Prevents linter errors** - `cascade_invocations` rule compliance
4. **Better readability** - Clear chains of operations on the same object
5. **Follows Dart idioms** - This is how Dart code should be written

#### **🚨 Common Patterns to Avoid**

```dart
// ❌ Avoid: Single cascade (triggers avoid_single_cascade_in_expression_statements)
object..method();

// ✅ Preferred: Single call uses dot notation
object.method();

// ❌ Avoid: Mixed patterns in same codebase
final obj = Object();
obj.method1();  // Sometimes this...
obj..method2(); // Sometimes this... BE CONSISTENT!

// ✅ Preferred: Consistent cascade usage
final obj = Object()
  ..method1()
  ..method2();
```

#### **⚠️ Special Cases: Static Methods & Alternative Approaches**

**Note:** Cascade operators only work with instances, not static methods on classes.

```dart
// ❌ Doesn't work: Cascade with static methods
EnvConfigFactory
  ..apiUrl
  ..appName;  // Error: Type 'Type' has no getter 'apiUrl'

// ✅ Solution 1: Use records for grouping (Dart 3+)
final _ = (
  EnvConfigFactory.apiUrl,
  EnvConfigFactory.appName,
  EnvConfigFactory.environmentName,
  EnvConfigFactory.isDebugMode,
);

// ✅ Solution 2: Extract to separate statements when meaningful
final apiUrl = EnvConfigFactory.apiUrl;
final appName = EnvConfigFactory.appName;
final envName = EnvConfigFactory.environmentName;
// Use variables as needed...

// ✅ Solution 3: Create instance if possible
final config = EnvConfigFactory.currentEnvironment
  ..validateConfiguration()
  ..logConfiguration();
```

#### **🎯 Updated Golden Rule**

1. **Instance methods (2+ calls)** → Use cascade operators (`..`)
2. **Instance methods (1 call)** → Use dot notation (`.`)
3. **Static methods (multiple calls)** → Use records `()` or meaningful variables
4. **Static methods (single call)** → Direct access

**Summary:** For 2+ methods on the same object reference, use cascades. For single method calls, use dot notation. For static methods, use records or meaningful variables. This approach ensures clean, consistent code that follows Dart best practices.

## 🧪 Testing Guidelines

### Navigation Testing (Auto Route)

#### Route Testing

```dart
// ✅ Good: Navigation flow testing
testWidgets('should navigate to main when login succeeds', (tester) async {
  await tester.pumpAppWithRouter(const SizedBox());
  await tester.pumpAndSettle();

  final loginButton = find.byType(ElevatedButton);
  await tester.tap(loginButton);
  await tester.pumpAndSettle();

  expect(find.byType(LoginPage), findsNothing);
});

// ✅ Good: Route guard testing
testWidgets('should redirect to login when not authenticated', (tester) async {
  // Set up unauthenticated state
  await tester.pumpAppWithRouter(const SizedBox());

  // Try to access protected route
  context.router.push(const ProfileRoute());
  await tester.pumpAndSettle();

  // Should be redirected to login
  expect(find.byType(LoginPage), findsOneWidget);
});
```

#### Page Testing with Helpers (DRY Compliance)

```dart
// ✅ Good: Use PageTestHelpers to eliminate duplication
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

// ✅ Good: Comprehensive testing with navigation
void main() {
  group('AttendancePage', () {
    PageTestHelpers.testComprehensivePage<AttendancePage>(
      const AttendancePage(),
      'Hello World - Attendance',
      () => const AttendancePage(),
      (key) => AttendancePage(key: key),
      pageRoute: '/main/attendance',
    );
  });
}

// ❌ Avoid: Code duplication (violates DRY principle)
group('ProfilePage', () {
  testWidgets('should render ProfilePage widget', (tester) async {
    await tester.pumpApp(const ProfilePage());
    expect(find.byType(ProfilePage), findsOneWidget);
  });

  testWidgets('should render Scaffold', (tester) async {
    await tester.pumpApp(const ProfilePage());
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('should display hello world text', (tester) async {
    await tester.pumpApp(const ProfilePage());
    expect(find.text('Hello World - Profile'), findsOneWidget);
  });
  // ... 20+ more duplicate tests (BAD!)
});
```

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
├── features/
│   ├── authentication/
│   │   └── presentation/
│   │       └── pages/
│   │           └── login_page_test.dart
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page_test.dart
│   ├── attendance/
│   │   └── presentation/
│   │       └── pages/
│   │           └── attendance_page_test.dart
│   ├── profile/
│   │   └── presentation/
│   │       └── pages/
│   │           └── profile_page_test.dart
│   ├── statistics/
│   │   └── presentation/
│   │       └── pages/
│   │           └── statistics_page_test.dart
│   ├── features/
│   │   └── presentation/
│   │       └── pages/
│   │           └── features_page_test.dart
│   └── main_navigation/
│       └── presentation/
│           └── pages/
│               └── main_wrapper_page_test.dart
└── helpers/
    ├── helpers.dart
    ├── pump_app.dart
    └── page_test_helpers.dart     # DRY testing utilities
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
