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

### Widget Organization & Architecture

#### Widget Layer Strategy

This project follows a **3-layer widget architecture** combining **Clean Architecture** with **Atomic Design** principles:

```
lib/
├── core/widgets/                   # 🔧 INFRASTRUCTURE LAYER
├── shared/widgets/                 # 🧱 BUSINESS LAYER (Atomic Design)
└── features/*/widgets/             # 📱 FEATURE LAYER
```

#### 1. **Core Widgets Layer** (`lib/core/widgets/`)

**Purpose**: Framework utilities and infrastructure concerns

```dart
// ✅ Good: Core widget examples
core/widgets/
├── responsive_initializer.dart     # Global responsive setup
├── base_scaffold.dart              # Common scaffold structure
├── loading_overlay.dart            # App-wide loading states
├── error_boundary.dart             # Global error handling
└── navigation_wrapper.dart         # Navigation infrastructure

// ✅ Good: Core widget characteristics
class ResponsiveInitializer extends StatelessWidget {
  // ✅ No business logic
  // ✅ Framework-level utility
  // ✅ App-wide configuration
  // ✅ Technical infrastructure
}

// ❌ Avoid: Business logic in core widgets
class UserProfileCard extends StatelessWidget {
  // ❌ Business domain logic doesn't belong in core
}
```

#### 2. **Shared Widgets Layer** (`lib/shared/widgets/`)

**Purpose**: Reusable business components following Atomic Design

##### **Atoms** (`shared/widgets/atoms/`)

Basic UI building blocks - smallest components

```dart
// ✅ Good: Atomic components
atoms/
├── custom_button.dart              # Primary/secondary buttons
├── custom_input.dart               # Text input fields
├── custom_card.dart                # Container cards
├── avatar_image.dart               # User avatar display
├── status_badge.dart               # Status indicators
└── icon_button.dart                # Icon-based buttons

// ✅ Good: Atom implementation
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(type),
      child: Text(text),
    );
  }
}
```

##### **Molecules** (`shared/widgets/molecules/`)

Composite components combining atoms

```dart
// ✅ Good: Molecular components
molecules/
├── search_bar.dart                 # Search input + icon + action
├── user_avatar.dart                # Avatar + status + name
├── stats_card.dart                 # Card + icon + numbers + label
├── action_button.dart              # Button + icon + text
├── input_field.dart                # Label + input + validation
└── navigation_item.dart            # Icon + label + badge

// ✅ Good: Molecule implementation
class SearchBar extends StatelessWidget {
  const SearchBar({
    required this.onChanged,
    this.hint = 'Search...',
    this.onFilter,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final String hint;
  final VoidCallback? onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Uses atoms as building blocks
        Expanded(
          child: CustomInput(
            hint: hint,
            onChanged: onChanged,
            prefixIcon: Icons.search,
          ),
        ),
        if (onFilter != null)
          CustomIconButton(
            icon: Icons.filter_list,
            onPressed: onFilter,
          ),
      ],
    );
  }
}
```

##### **Organisms** (`shared/widgets/organisms/`)

Complex UI sections combining molecules and atoms

```dart
// ✅ Good: Organism components
organisms/
├── navigation_drawer.dart          # Complete navigation sidebar
├── header_section.dart             # App bar with actions and search
├── user_profile_section.dart       # Complete user profile display
├── stats_dashboard.dart            # Statistics overview section
├── action_bottom_sheet.dart        # Modal with multiple actions
└── data_table_section.dart         # Complete data table with controls

// ✅ Good: Organism implementation
class HeaderSection extends StatelessWidget {
  const HeaderSection({
    required this.title,
    this.subtitle,
    this.onSearch,
    this.actions = const [],
    super.key,
  });

  final String title;
  final String? subtitle;
  final ValueChanged<String>? onSearch;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Uses molecules and atoms
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headingLarge),
                    if (subtitle != null)
                      Text(subtitle!, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              ...actions,
            ],
          ),
          if (onSearch != null) ...[
            const SizedBox(height: 16),
            SearchBar(onChanged: onSearch!),
          ],
        ],
      ),
    );
  }
}
```

#### 3. **Feature Widgets Layer** (`lib/features/*/widgets/`)

**Purpose**: Feature-specific components

```dart
// ✅ Good: Feature-specific widgets
features/home/presentation/widgets/
├── home_carousel.dart              # Home-specific carousel
├── trending_section.dart           # Home trending content
├── quick_actions.dart              # Home quick action buttons
├── welcome_banner.dart             # Home welcome message
└── recent_activity.dart            # Home recent activity list

features/profile/presentation/widgets/
├── profile_form.dart               # Profile editing form
├── avatar_selector.dart            # Profile image selection
├── settings_panel.dart             # Profile settings panel
├── achievements_grid.dart          # Profile achievements display
└── activity_history.dart          # Profile activity timeline

// ✅ Good: Feature widget implementation
class HomeCarousel extends StatelessWidget {
  const HomeCarousel({
    required this.items,
    this.onItemTap,
    super.key,
  });

  final List<CarouselItem> items;
  final ValueChanged<CarouselItem>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Uses shared widgets as building blocks
          return CustomCard(
            onTap: () => onItemTap?.call(item),
            child: Column(
              children: [
                // Feature-specific layout using shared components
                Expanded(child: Image.network(item.imageUrl)),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.title, style: AppTextStyles.bodyLarge),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

#### Widget Decision Tree

Use this decision tree to determine widget placement:

```dart
// Decision process for widget placement
1. ❓ Is it framework/infrastructure related?
   ✅ YES → Place in `core/widgets/`

2. ❓ Is it reusable across multiple features?
   ✅ YES → Place in `shared/widgets/` (Atomic Design level)

3. ❓ Is it specific to one feature?
   ✅ YES → Place in `features/*/widgets/`

// Examples:
ResponsiveInitializer → core/widgets/ (framework setup)
CustomButton → shared/widgets/atoms/ (reusable across features)
HomeCarousel → features/home/widgets/ (specific to home feature)
```

### Feature Organization

#### Directory Structure (Updated with Widget Architecture)

```
feature_name/
├── presentation/
│   ├── pages/                      # Full-screen pages
│   │   └── feature_page.dart
│   └── widgets/                    # Feature-specific widgets
│       ├── feature_carousel.dart   # Feature-specific components
│       ├── feature_form.dart       # Feature business forms
│       └── feature_section.dart    # Feature content sections
├── cubit/                          # State management
│   ├── feature_cubit.dart
│   └── feature_state.dart
├── models/                         # Data models
│   ├── feature_model.dart          # Freezed models
│   ├── feature_model.freezed.dart  # Generated file
│   └── feature_model.g.dart        # Generated JSON
└── feature.dart                    # Barrel export (optional)
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
// ✅ Good: Using fpdart Either for error handling
import 'package:fpdart/fpdart.dart';

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
import 'package:fpdart/fpdart.dart';

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

## 🌐 Internationalization Guidelines with Slang

### Overview

This project uses [Slang](https://pub.dev/packages/slang) for type-safe internationalization. Slang provides compile-time translation safety, better IDE support, and more maintainable i18n code compared to traditional ARB-based approaches.

### Translation File Structure

#### JSON i18n Files

```json
// ✅ Good: Proper JSON structure for en.i18n.json
{
  "hello": "Hello",
  "welcome": "Welcome {name}",
  "counterAppBarTitle": "Counter",
  "items": {
    "one": "One item",
    "other": "{count} items"
  },
  "pages": {
    "home": {
      "title": "Home",
      "subtitle": "Welcome to the home page"
    },
    "profile": {
      "title": "Profile",
      "actions": {
        "edit": "Edit Profile",
        "save": "Save Changes"
      }
    }
  },
  "errors": {
    "network": "Network connection failed",
    "validation": {
      "required": "This field is required",
      "email": "Please enter a valid email"
    }
  }
}
```

```json
// ✅ Good: Corresponding vi.i18n.json
{
  "hello": "Xin chào",
  "welcome": "Chào mừng {name}",
  "counterAppBarTitle": "Bộ đếm",
  "items": {
    "other": "{count} mục"
  },
  "pages": {
    "home": {
      "title": "Trang chủ",
      "subtitle": "Chào mừng đến trang chủ"
    },
    "profile": {
      "title": "Hồ sơ",
      "actions": {
        "edit": "Chỉnh sửa hồ sơ",
        "save": "Lưu thay đổi"
      }
    }
  },
  "errors": {
    "network": "Kết nối mạng thất bại",
    "validation": {
      "required": "Trường này bắt buộc",
      "email": "Vui lòng nhập email hợp lệ"
    }
  }
}
```

### Usage in Code

#### Basic Translation Usage

```dart
// ✅ Good: Import generated translations
import 'package:xp1/l10n/gen/strings.g.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Type-safe translations with auto-complete
        title: Text(t.counterAppBarTitle),
      ),
      body: Column(
        children: [
          Text(t.hello),                      // Basic translation
          Text(t.welcome(name: 'John')),      // Parameterized translation
          Text(t.pages.home.title),           // Nested translation
          Text(t.items(count: 5)),           // Pluralization
        ],
      ),
    );
  }
}

// ❌ Avoid: Old ARB-based approach
class BadCounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;  // Old pattern
    return Text(l10n.counterAppBarTitle);  // No type safety
  }
}
```

#### Context Extension Usage

```dart
// ✅ Good: Using context extension (requires slang_flutter)
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.pages.profile.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text(context.t.pages.profile.actions.edit),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(context.t.pages.profile.actions.save),
          ),
        ],
      ),
    );
  }
}
```

### Advanced Translation Patterns

#### Error Handling with Translations

```dart
// ✅ Good: Type-safe error messages
class ApiService {
  Future<Either<String, User>> getUser(String id) async {
    try {
      final user = await _client.getUser(id);
      return Right(user);
    } on NetworkException {
      return Left(t.errors.network);
    } on ValidationException {
      return Left(t.errors.validation.required);
    }
  }
}

// ✅ Good: Error display in UI
class UserWidget extends StatelessWidget {
  final Either<String, User> userResult;

  @override
  Widget build(BuildContext context) {
    return userResult.fold(
      (error) => Text(
        error,  // Already translated error message
        style: TextStyle(color: Colors.red),
      ),
      (user) => UserCard(user: user),
    );
  }
}
```

#### Form Validation with Translations

```dart
// ✅ Good: Form validation with slang
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: t.pages.login.email,
              hintText: t.pages.login.emailHint,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return t.errors.validation.required;
              }
              if (!_isValidEmail(value!)) {
                return t.errors.validation.email;
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text(t.pages.login.actions.signIn),
          ),
        ],
      ),
    );
  }
}
```

#### Rich Text and Complex Formatting

```dart
// ✅ Good: Rich text with translations
class WelcomeText extends StatelessWidget {
  final String username;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: t.pages.welcome.richWelcome(
          username: username,
          linkToTerms: (text) => TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openTerms(),
          ),
        ),
      ),
    );
  }
}
```

### Locale Management Architecture

#### DDD-Based Locale Service

```dart
// ✅ Good: Domain service for locale management
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';

class LocaleService {
  final LocaleDomainService _domainService;

  LocaleService(this._domainService);

  /// Switch application locale with persistence
  Future<LocaleConfiguration> switchLocale(AppLocale locale) async {
    final config = LocaleConfiguration(
      languageCode: locale.languageCode,
      countryCode: locale.countryCode,
    );

    await _domainService.saveLocaleConfiguration(config);
    LocaleSettings.setLocale(locale);

    return config;
  }

  /// Get current locale configuration
  LocaleConfiguration getCurrentLocale() {
    return LocaleConfiguration(
      languageCode: LocaleSettings.currentLocale.languageCode,
      countryCode: LocaleSettings.currentLocale.countryCode,
    );
  }
}
```

#### BLoC Integration for Locale State

```dart
// ✅ Good: Locale cubit with persistence
class LocaleCubit extends HydratedCubit<LocaleState> {
  final LocaleService _localeService;

  LocaleCubit(this._localeService) : super(LocaleState.initial());

  Future<void> changeLocale(AppLocale locale) async {
    emit(LocaleState.changing());

    try {
      final config = await _localeService.switchLocale(locale);
      emit(LocaleState.changed(config));
    } catch (e) {
      emit(LocaleState.error(e.toString()));
    }
  }

  @override
  LocaleState? fromJson(Map<String, dynamic> json) {
    try {
      return LocaleState.fromJson(json);
    } catch (_) {
      return LocaleState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(LocaleState state) {
    return state.maybeWhen(
      changed: (config) => config.toJson(),
      orElse: () => null,
    );
  }
}
```

### Development Workflow

#### Adding New Translations

```bash
# 1. Edit JSON files in lib/l10n/i18n/
# Add new keys to both en.i18n.json and vi.i18n.json

# 2. Generate updated Dart classes
make i18n-generate

# 3. Use in code with full type safety and auto-complete
Text(t.newTranslationKey)
```

#### Live Development

```bash
# Recommended: Auto-generation during development
make i18n-watch

# Edit translation files → Code regenerates automatically
# IDE immediately shows new translations with auto-complete
```

#### Translation Validation

```bash
# Check for missing translations
make i18n-analyze

# Validate JSON files
make i18n-validate

# Clean and regenerate if needed
make i18n-clean && make i18n-generate
```

### Best Practices

#### Translation Organization

```dart
// ✅ Good: Hierarchical organization
{
  "pages": {
    "login": {
      "title": "Login",
      "fields": {
        "email": "Email",
        "password": "Password"
      },
      "actions": {
        "signIn": "Sign In",
        "forgotPassword": "Forgot Password?"
      }
    }
  },
  "common": {
    "actions": {
      "save": "Save",
      "cancel": "Cancel",
      "delete": "Delete"
    },
    "status": {
      "loading": "Loading...",
      "error": "An error occurred",
      "success": "Success!"
    }
  }
}

// ❌ Avoid: Flat structure
{
  "loginTitle": "Login",
  "loginEmail": "Email",
  "loginPassword": "Password",
  "loginSignIn": "Sign In",
  "commonSave": "Save",
  "commonCancel": "Cancel"
}
```

#### Consistent Naming Conventions

```dart
// ✅ Good: Consistent naming patterns
t.pages.home.title              // Page titles
t.pages.home.actions.edit       // Page actions
t.common.actions.save           // Common actions
t.errors.validation.required    // Error messages
t.status.loading                // Status messages

// ❌ Avoid: Inconsistent naming
t.homePageTitle
t.editAction
t.saveBtn
t.reqError
```

#### Parameterization

```dart
// ✅ Good: Proper parameterization
{
  "greeting": "Hello {name}!",
  "itemCount": "You have {count} items",
  "lastSeen": "Last seen {time} ago"
}

// Usage
Text(t.greeting(name: user.name))
Text(t.itemCount(count: items.length))
Text(t.lastSeen(time: formatTime(user.lastSeen)))

// ❌ Avoid: String concatenation
Text('Hello ${user.name}!')  // Not translatable
```

### Testing Internationalization

#### Translation Coverage Testing

```dart
// ✅ Good: Test translation coverage
void main() {
  group('Translation Coverage', () {
    test('should have Vietnamese translations for all English keys', () {
      final enKeys = _extractKeys(enTranslations);
      final viKeys = _extractKeys(viTranslations);

      final missingKeys = enKeys.where((key) => !viKeys.contains(key));

      expect(
        missingKeys,
        isEmpty,
        reason: 'Missing Vietnamese translations: ${missingKeys.join(', ')}',
      );
    });
  });
}
```

#### Widget Testing with Translations

```dart
// ✅ Good: Test widgets with different locales
void main() {
  group('LoginPage', () {
    testWidgets('should display Vietnamese text when locale is vi', (tester) async {
      LocaleSettings.setLocale(AppLocale.vi);

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
          locale: AppLocale.vi.flutterLocale,
        ),
      );

      expect(find.text('Đăng nhập'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });
  });
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

## 🎨 Asset Management Guidelines

### Image Asset Management

This project uses a **Pure Flutter Approach** for image asset management, leveraging existing Flutter capabilities with responsive design patterns.

#### Architecture Overview

```dart
// ✅ Contract-based design pattern
lib/
├── core/
│   ├── assets/
│   │   ├── images/
│   │   │   ├── app_images.dart          # Contract interface
│   │   │   └── app_images_impl.dart     # Implementation
│   │   └── services/
│   │       ├── asset_image_service.dart      # Service interface
│   │       └── asset_image_service_impl.dart # Service implementation
└── features/
    └── splash/
        └── presentation/
            └── widgets/
                └── splash_image.dart    # Usage example
```

#### AppImages Contract Pattern

```dart
// ✅ Good: Type-safe asset path management
abstract class AppImages {
  // Splash Screen Assets
  static const String logoImage = 'assets/images/common/logo.png';

  // Employee Assets
  static const String employeePlaceholder = 'assets/images/employee/placeholder.png';
  static const String employeeAvatar = 'assets/images/employee/avatar.png';

  // Common Assets
  static const String defaultPlaceholder = 'assets/images/placeholders/default.png';
  static const String errorPlaceholder = 'assets/images/placeholders/error.png';
}

// ✅ Good: Implementation with validation
class AppImagesImpl implements AppImages {
  static const AppImagesImpl _instance = AppImagesImpl._internal();
  factory AppImagesImpl() => _instance;
  const AppImagesImpl._internal();

  /// Validates that asset exists in pubspec.yaml
  bool validateAssetPath(String assetPath) {
    // Implementation for development-time validation
    return true;
  }
}
```

#### AssetImageService Pattern

```dart
// ✅ Good: Service layer for responsive image rendering
abstract class AssetImageService {
  /// Render image with responsive sizing and error handling
  Widget renderImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? semanticLabel,
    Widget? errorWidget,
    Widget? placeholder,
  });

  /// Pre-cache image for performance
  Future<void> precacheImage(String assetPath, BuildContext context);
}

// ✅ Good: Implementation with flutter_screenutil integration
class AssetImageServiceImpl implements AssetImageService {
  @override
  Widget renderImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? semanticLabel,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    return Image.asset(
      assetPath,
      width: width?.w,  // Responsive width
      height: height?.h, // Responsive height
      fit: fit,
      semanticLabel: semanticLabel,
      frameBuilder: placeholder != null
          ? (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return frame == null ? placeholder! : child;
            }
          : null,
      errorBuilder: errorWidget != null
          ? (context, error, stackTrace) => errorWidget!
          : (context, error, stackTrace) => Container(
              width: width?.w,
              height: height?.h,
              color: Colors.grey.shade300,
              child: Icon(Icons.error, color: Colors.grey.shade600),
            ),
    );
  }

  @override
  Future<void> precacheImage(String assetPath, BuildContext context) {
    return precacheImage(AssetImage(assetPath), context);
  }
}
```

#### Usage in Widgets

```dart
// ✅ Good: Using asset service in widgets
class SplashImage extends StatelessWidget {
  const SplashImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetIt.instance<AssetImageService>().renderImage(
      assetPath: AppImages.welcomeImage,
      width: 300,
      height: 200,
      fit: BoxFit.cover,
      semanticLabel: 'Welcome splash image',
      placeholder: Container(
        width: 300.w,
        height: 200.h,
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// ❌ Avoid: Direct asset usage without service layer
class BadSplashImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/splash/logo.png'); // No error handling
  }
}
```

### SVG Asset Management

SVG assets require the `flutter_svg` package and follow similar contract-service patterns.

#### AppIcons Contract Pattern

```dart
// ✅ Good: SVG icon path management
abstract class AppIcons {
  // Navigation Icons
  static const String homeIcon = 'assets/icons/navigation/home.svg';
  static const String profileIcon = 'assets/icons/navigation/profile.svg';
  static const String settingsIcon = 'assets/icons/navigation/settings.svg';

  // Action Icons
  static const String editIcon = 'assets/icons/action/edit.svg';
  static const String deleteIcon = 'assets/icons/action/delete.svg';
  static const String saveIcon = 'assets/icons/action/save.svg';
  static const String cancelIcon = 'assets/icons/action/cancel.svg';

  // Status Icons
  static const String successIcon = 'assets/icons/status/success.svg';
  static const String errorIcon = 'assets/icons/status/error.svg';
  static const String warningIcon = 'assets/icons/status/warning.svg';
  static const String infoIcon = 'assets/icons/status/info.svg';

  // UI Icons
  static const String searchIcon = 'assets/icons/ui/search.svg';
  static const String filterIcon = 'assets/icons/ui/filter.svg';
  static const String menuIcon = 'assets/icons/ui/menu.svg';
  static const String closeIcon = 'assets/icons/ui/close.svg';
  static const String arrowBackIcon = 'assets/icons/ui/arrow_back.svg';

  // Size Constants
  static const double small = 16.0;
  static const double medium = 24.0;
  static const double large = 32.0;
  static const double extraLarge = 48.0;
}
```

#### SvgIconService Pattern

```dart
// ✅ Good: SVG service with comprehensive features
abstract class SvgIconService {
  /// Render SVG icon with responsive sizing and styling
  Widget renderIcon({
    required String assetPath,
    double? size,
    Color? color,
    String? semanticLabel,
    VoidCallback? onTap,
    Widget? errorWidget,
  });

  /// Pre-cache SVG for performance
  Future<void> precacheSvg(String assetPath);
}

class SvgIconServiceImpl implements SvgIconService {
  @override
  Widget renderIcon({
    required String assetPath,
    double? size,
    Color? color,
    String? semanticLabel,
    VoidCallback? onTap,
    Widget? errorWidget,
  }) {
    final svgWidget = SvgPicture.asset(
      assetPath,
      width: size?.w,
      height: size?.h,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticLabel,
      placeholderBuilder: (context) => Container(
        width: size?.w,
        height: size?.h,
        color: Colors.grey.shade300,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: svgWidget,
        ),
      );
    }

    return svgWidget;
  }

  @override
  Future<void> precacheSvg(String assetPath) async {
    final loader = SvgAssetLoader(assetPath);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}
```

#### Usage Examples

```dart
// ✅ Good: SVG icon usage with service
class NavigationIcon extends StatelessWidget {
  const NavigationIcon({
    required this.iconPath,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final String iconPath;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GetIt.instance<SvgIconService>().renderIcon(
      assetPath: iconPath,
      size: AppIcons.medium,
      color: isSelected ? Colors.blue : Colors.grey,
      onTap: onTap,
      semanticLabel: 'Navigation icon',
    );
  }
}

// ✅ Good: Complex SVG usage
class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.iconPath,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    super.key,
  });

  final String iconPath;
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: GetIt.instance<SvgIconService>().renderIcon(
        assetPath: iconPath,
        size: AppIcons.small,
        color: isEnabled ? Colors.white : Colors.grey,
      ),
      label: Text(label),
    );
  }
}
```

### Asset Testing Patterns

#### Image Asset Service Testing

```dart
// ✅ Good: Comprehensive asset service testing
void main() {
  group('AssetImageService', () {
    late AssetImageService assetImageService;
    late MockBuildContext mockContext;

    setUp(() {
      assetImageService = AssetImageServiceImpl();
      mockContext = MockBuildContext();
    });

    group('renderImage', () {
      testWidgets('should render image with correct properties', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: assetImageService.renderImage(
                assetPath: AppImages.welcomeImage,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

        expect(find.byType(Image), findsOneWidget);

        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.width, equals(200.w));
        expect(imageWidget.height, equals(150.h));
        expect(imageWidget.fit, equals(BoxFit.cover));
      });

      testWidgets('should show error widget on asset load failure', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: assetImageService.renderImage(
                assetPath: 'invalid/path.png',
                errorWidget: const Icon(Icons.error, key: Key('error_widget')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byKey(const Key('error_widget')), findsOneWidget);
      });
    });

    group('precacheImage', () {
      testWidgets('should precache image successfully', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: SizedBox()));

        expect(
          () => assetImageService.precacheImage(
            AppImages.welcomeImage,
            tester.element(find.byType(SizedBox)),
          ),
          returnsNormally,
        );
      });
    });
  });
}
```

#### SVG Icon Service Testing

```dart
// ✅ Good: SVG service testing
void main() {
  group('SvgIconService', () {
    late SvgIconService svgIconService;

    setUp(() {
      svgIconService = SvgIconServiceImpl();
    });

    group('renderIcon', () {
      testWidgets('should render SVG with correct properties', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: svgIconService.renderIcon(
                assetPath: AppIcons.homeIcon,
                size: AppIcons.large,
                color: Colors.blue,
              ),
            ),
          ),
        );

        expect(find.byType(SvgPicture), findsOneWidget);

        final svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(svgWidget.width, equals(AppIcons.large.w));
        expect(svgWidget.height, equals(AppIcons.large.h));
      });

      testWidgets('should make icon tappable when onTap provided', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: svgIconService.renderIcon(
                assetPath: AppIcons.editIcon,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(InkWell));
        expect(tapped, isTrue);
      });
    });
  });
}
```

## 🚀 Splash Screen Development Guidelines

### Simplified Splash Architecture

The splash screen follows a simplified architecture optimized for performance and maintainability.

#### Architecture Overview

```dart
// ✅ Simplified splash feature structure
features/splash/
├── presentation/
│   ├── cubit/
│   │   ├── splash_cubit.dart         # State management
│   │   └── splash_state.dart         # Freezed states
│   ├── pages/
│   │   └── splash_page.dart          # Full-screen page
│   └── widgets/
│       ├── atomic/
│       │   ├── atoms/
│       │   │   └── splash_logo.dart      # Logo atom
│       │   ├── molecules/
│       │   │   └── splash_content.dart   # Content molecule
│       │   └── organisms/
│       │       └── splash_layout.dart    # Layout organism
│       └── splash_content.dart       # Main content widget
└── splash.dart                       # Barrel export
```

#### SplashCubit Implementation

```dart
// ✅ Good: Simplified splash cubit
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  /// Initialize splash screen and navigate after delay
  Future<void> initialize() async {
    emit(const SplashState.loading());

    try {
      // Simple 2-second delay
      await Future.delayed(const Duration(seconds: 2));
      emit(const SplashState.completed());
    } catch (error) {
      emit(SplashState.error(error.toString()));
    }
  }
}

// ✅ Good: Freezed states for splash
@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = SplashInitial;
  const factory SplashState.loading() = SplashLoading;
  const factory SplashState.completed() = SplashCompleted;
  const factory SplashState.error(String message) = SplashError;
}
```

#### Atomic Design Implementation

```dart
// ✅ Good: Splash logo atom
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetIt.instance<AssetImageService>().renderImage(
      assetPath: AppImages.welcomeImage,
      width: 300,
      height: 200,
      fit: BoxFit.contain,
      semanticLabel: 'App welcome logo',
    );
  }
}

// ✅ Good: Splash content molecule
class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SplashLogo(),
        SizedBox(height: 24.h),
        const CircularProgressIndicator(),
      ],
    );
  }
}

// ✅ Good: Splash layout organism
class SplashLayout extends StatelessWidget {
  const SplashLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.orange, // Native splash background color
      ),
      child: const SafeArea(
        child: Center(
          child: SplashContent(),
        ),
      ),
    );
  }
}
```

#### SplashPage Implementation

```dart
// ✅ Good: Complete splash page with BLoC integration
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SplashCubit>()..initialize(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        state.maybeWhen(
          completed: () => context.router.pushAndClearStack(
            const MainWrapperRoute(),
          ),
          error: (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          ),
          orElse: () {},
        );
      },
      child: const Scaffold(
        body: SplashLayout(),
      ),
    );
  }
}
```

### Native Splash Integration

#### Configuration

```yaml
# ✅ Good: flutter_native_splash.yaml configuration
flutter_native_splash:
  color: "#FF9800" # Orange background
  color_dark: "#FF9800"

  android_12:
    color: "#FF9800"
    color_dark: "#FF9800"

  web: true
  android: true
  ios: true

  remove_after_delay: true
```

#### Platform-Specific Assets

```bash
# ✅ Generated native splash assets structure
android/app/src/main/res/
├── drawable/background.png
├── drawable-hdpi/background.png
├── drawable-mdpi/background.png
├── drawable-xhdpi/background.png
├── drawable-xxhdpi/background.png
└── drawable-xxxhdpi/background.png

ios/Runner/Assets.xcassets/LaunchBackground.imageset/
├── background.png
├── background@2x.png
├── background@3x.png
└── Contents.json
```

### Splash Testing Patterns

#### Unit Testing

```dart
// ✅ Good: Splash cubit testing
void main() {
  group('SplashCubit', () {
    late SplashCubit splashCubit;

    setUp(() {
      splashCubit = SplashCubit();
    });

    tearDown(() {
      splashCubit.close();
    });

    test('initial state should be SplashInitial', () {
      expect(splashCubit.state, equals(const SplashState.initial()));
    });

    blocTest<SplashCubit, SplashState>(
      'should emit [loading, completed] when initialize succeeds',
      build: () => splashCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const SplashState.loading(),
        const SplashState.completed(),
      ],
      wait: const Duration(seconds: 3), // Account for 2-second delay
    );

    blocTest<SplashCubit, SplashState>(
      'should complete after exactly 2 seconds',
      build: () => splashCubit,
      act: (cubit) => cubit.initialize(),
      verify: (cubit) {
        expect(cubit.state, equals(const SplashState.completed()));
      },
      wait: const Duration(seconds: 3),
    );
  });
}
```

#### Widget Testing

```dart
// ✅ Good: Splash page widget testing
void main() {
  group('SplashPage', () {
    testWidgets('should display splash content', (tester) async {
      await tester.pumpApp(const SplashPage());

      expect(find.byType(SplashLayout), findsOneWidget);
      expect(find.byType(SplashContent), findsOneWidget);
      expect(find.byType(SplashLogo), findsOneWidget);
    });

    testWidgets('should navigate after splash completion', (tester) async {
      await tester.pumpApp(const SplashPage());

      // Wait for splash to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should have navigated away from splash
      expect(find.byType(SplashPage), findsNothing);
    });

    testWidgets('should show error message on failure', (tester) async {
      // Mock error scenario
      when(() => mockSplashCubit.initialize())
          .thenThrow(Exception('Test error'));

      await tester.pumpApp(const SplashPage());
      await tester.pumpAndSettle();

      expect(find.text('Test error'), findsOneWidget);
    });
  });
}
```

#### Integration Testing

```dart
// ✅ Good: Splash flow integration testing
void main() {
  group('Splash Flow Integration', () {
    testWidgets('complete splash to main navigation flow', (tester) async {
      await tester.pumpWidget(const App());

      // Should start on splash page
      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(SplashLogo), findsOneWidget);

      // Wait for splash to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to main wrapper
      expect(find.byType(MainWrapperPage), findsOneWidget);
      expect(find.byType(SplashPage), findsNothing);
    });
  });
}
```

### Performance Guidelines

#### Image Loading Optimization

```dart
// ✅ Good: Image precaching for performance
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Precache splash image for instant loading
    GetIt.instance<AssetImageService>().precacheImage(
      AppImages.welcomeImage,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SplashCubit>()..initialize(),
      child: const SplashView(),
    );
  }
}
```

#### Memory Management

```dart
// ✅ Good: Memory-efficient splash implementation
class SplashCubit extends Cubit<SplashState> {
  Timer? _timer;

  SplashCubit() : super(const SplashState.initial());

  Future<void> initialize() async {
    emit(const SplashState.loading());

    // Use timer instead of Future.delayed for better control
    _timer = Timer(const Duration(seconds: 2), () {
      if (!isClosed) {
        emit(const SplashState.completed());
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
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
