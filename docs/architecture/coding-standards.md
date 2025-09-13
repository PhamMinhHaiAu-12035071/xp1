# XP1 Coding Standards

This document defines **MANDATORY** coding standards for the XP1 Flutter Authentication project. These standards directly control AI agent behavior and ensure consistent, high-quality code across the entire project.

**Target Audience:** AI development agents, human developers, code reviewers  
**Enforcement:** Automated through linting, manual through code review  
**Compliance Level:** 100% - Zero tolerance for violations

## Core Standards

### Languages & Runtimes

- **Dart:** >=3.8.0 (null safety enabled, strict mode)
- **Flutter:** >=3.24.0 (latest stable channel)
- **Minimum Target Platforms:**
  - iOS: 12.0+
  - Android: API level 21+ (Android 5.0)
  - Web: Modern browsers only

### Style & Linting

- **Linting Package:** Very Good Analysis 9.0.0
- **Configuration File:** `analysis_options.yaml` (project root)
- **Enforcement Level:** **ZERO TOLERANCE** - All linter errors must be resolved
- **Line Length:** Maximum 80 characters
- **Import Organization:** Automatic via `dart format`

**Required Linting Rules:**

```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  errors:
    # Treat warnings as errors
    avoid_print: error
    prefer_const_constructors: error
    sort_pub_dependencies: error
```

### Test Organization

- **Test Structure:** Mirror `lib/` directory structure in `test/`
- **File Convention:** `*_test.dart` for all test files
- **Coverage Requirement:** 100% line coverage, 95% branch coverage
- **Test Framework:** Flutter Test + BLoC Test
- **Location:** All tests in `test/` directory

## Naming Conventions

| Element             | Convention           | Example                    | Notes                            |
| ------------------- | -------------------- | -------------------------- | -------------------------------- |
| **Classes**         | PascalCase           | `AuthenticationBloc`       | Include descriptive suffixes     |
| **Methods**         | camelCase            | `authenticateUser()`       | Use verbs for actions            |
| **Variables**       | camelCase            | `accessToken`              | Descriptive, avoid abbreviations |
| **Constants**       | SCREAMING_SNAKE_CASE | `API_BASE_URL`             | All caps with underscores        |
| **Files**           | snake_case           | `auth_repository.dart`     | Match class name pattern         |
| **Directories**     | snake_case           | `auth/data/repositories/`  | Logical grouping                 |
| **Enums**           | PascalCase           | `AuthenticationStatus`     | Singular form                    |
| **Enum Values**     | camelCase            | `loading`, `authenticated` | Descriptive states               |
| **Private Members** | \_camelCase          | `_handleLoginEvent`        | Leading underscore               |

### File Naming Patterns

```
Feature Structure:
- auth_bloc.dart (contains AuthBloc)
- auth_event.dart (contains AuthEvent)
- auth_state.dart (contains AuthState)
- auth_repository.dart (contains AuthRepository)

Test Structure:
- auth_bloc_test.dart
- auth_repository_test.dart
```

## Critical Rules

**⚠️ These rules are MANDATORY for AI agents and will cause build/review failures if violated:**

### Logging and Debugging

- **NO print() statements:** Use `Logger` instance instead

  ```dart
  // ❌ WRONG
  print('User logged in');

  // ✅ CORRECT
  logger.info('User logged in successfully');
  ```

### State Management

- **BLoC Pattern Only:** All state changes must use BLoC pattern

  ```dart
  // ❌ WRONG - Direct widget state
  setState(() { isLoading = true; });

  // ✅ CORRECT - BLoC event
  context.read<AuthBloc>().add(AuthEvent.loginRequested());
  ```

### API Integration

- **Chopper Generated Clients Only:** No manual HTTP calls

  ```dart
  // ❌ WRONG - Manual HTTP
  final response = await http.post(url);

  // ✅ CORRECT - Generated client
  final response = await authApiService.login(request);
  ```

### Security

- **Secure Storage Only:** Never use SharedPreferences for sensitive data

  ```dart
  // ❌ WRONG - Insecure storage
  await SharedPreferences.getInstance().setString('token', token);

  // ✅ CORRECT - Secure storage
  await secureStorageService.storeAccessToken(token);
  ```

### Error Handling

- **Either Types Required:** All async operations must use functional error handling

  ```dart
  // ❌ WRONG - Exception throwing
  Future<User> getUser() async {
    throw Exception('User not found');
  }

  // ✅ CORRECT - Either type
  Future<Either<AuthFailure, User>> getUser() async {
    return left(AuthFailure.userNotFound());
  }
  ```

### Testing

- **100% Coverage Required:** All public methods must have tests
  ```dart
  // ✅ REQUIRED - Test for every public method
  group('AuthRepository', () {
    test('should return user when login succeeds', () {
      // Arrange, Act, Assert
    });

    test('should return failure when login fails', () {
      // Arrange, Act, Assert
    });
  });
  ```

### Code Generation

- **Run build_runner after changes:** Always run before committing
  ```bash
  # REQUIRED after model/API changes
  dart run build_runner build --delete-conflicting-outputs
  ```

### Validation

- **Formz Only:** All user inputs must use Formz validation

  ```dart
  // ❌ WRONG - Manual validation
  if (email.isEmpty || !email.contains('@')) {
    return 'Invalid email';
  }

  // ✅ CORRECT - Formz validation
  class Email extends FormzInput<String, EmailValidationError> {
    @override
    EmailValidationError? validator(String value) {
      return EmailValidator.validate(value);
    }
  }
  ```

## Language-Specific Guidelines

### Dart Specifics

#### Null Safety

- **Enable strict null safety:** All code must be null-safe
- **Avoid dynamic types:** Use specific types or generics
- **Use late keyword carefully:** Only when initialization is guaranteed

```dart
// ✅ CORRECT - Null safety patterns
String? nullableValue;
late final String lateValue; // Only if guaranteed initialization
final String definiteValue = 'value';
```

#### Immutability

- **Prefer immutable classes:** Use `@immutable` annotation
- **Use Freezed for data classes:** Code generation for immutable models
- **Final fields preferred:** Use `final` for all possible fields

```dart
// ✅ CORRECT - Immutable class
@immutable
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    String? email,
  }) = _User;
}
```

#### Async Programming

- **Prefer async/await:** Over raw Futures and callbacks
- **Handle errors properly:** Use Either types or proper try-catch
- **Use FutureBuilder/StreamBuilder:** For UI async operations

```dart
// ✅ CORRECT - Async pattern
Future<Either<AuthFailure, User>> authenticateUser(
  String username,
  String password,
) async {
  try {
    final response = await authApiService.login(
      LoginRequest(username: username, password: password),
    );
    return right(response.data.toUser());
  } catch (e) {
    return left(AuthFailure.networkError());
  }
}
```

### Flutter Specifics

#### Widget Construction

- **Prefer const constructors:** Use `const` for static widgets
- **Extract complex widgets:** Create separate widget classes
- **Use key parameter:** For stateful widgets in lists

```dart
// ✅ CORRECT - Widget patterns
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        UsernameField(),
        PasswordField(),
        LoginButton(),
      ],
    );
  }
}
```

#### State Management Integration

- **BlocProvider positioning:** Place at appropriate widget tree level
- **BlocBuilder usage:** Use for UI state changes
- **BlocListener usage:** Use for side effects (navigation, snackbars)

```dart
// ✅ CORRECT - BLoC integration
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    state.mapOrNull(
      authenticated: (_) => context.router.pushAndClearStack('/home'),
      error: (errorState) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorState.message))),
    );
  },
  builder: (context, state) {
    return state.maybeMap(
      loading: (_) => const CircularProgressIndicator(),
      orElse: () => const LoginForm(),
    );
  },
)
```

## Security Guidelines

### Data Protection

- **No hardcoded secrets:** All secrets via environment configuration
- **Sensitive data encryption:** Use FlutterSecureStorage for tokens
- **No PII in logs:** Never log personally identifiable information

```dart
// ✅ CORRECT - Secure patterns
class SecureStorageService {
  static const _accessTokenKey = 'access_token';

  Future<void> storeAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    // ❌ NEVER log the actual token
    logger.info('Access token stored successfully');
  }
}
```

### Input Validation

- **Validate all inputs:** Server and client-side validation
- **Sanitize data:** Clean user inputs before processing
- **Use whitelist approach:** Define allowed inputs rather than blocked

```dart
// ✅ CORRECT - Input validation
class UsernameValidator {
  static const _allowedPattern = r'^[a-zA-Z0-9_]{3,20}$';

  static bool isValid(String username) {
    return RegExp(_allowedPattern).hasMatch(username);
  }
}
```

## Testing Standards

### Test Structure

**Follow AAA Pattern:** Arrange, Act, Assert

```dart
// ✅ CORRECT - AAA pattern
test('should emit authenticated state when login succeeds', () {
  // Arrange
  when(() => mockAuthRepository.login(any(), any()))
      .thenAnswer((_) async => right(mockUser));

  // Act
  bloc.add(AuthEvent.loginRequested(
    username: 'test@example.com',
    password: 'password123',
  ));

  // Assert
  expectLater(
    bloc.stream,
    emitsInOrder([
      AuthState.loading(),
      AuthState.authenticated(user: mockUser),
    ]),
  );
});
```

### Test Coverage Requirements

- **Unit Tests:** 100% line coverage for business logic
- **Widget Tests:** All custom widgets must have tests
- **Integration Tests:** Critical user flows must be tested

```dart
// ✅ REQUIRED - Comprehensive test coverage
group('AuthBloc', () {
  late AuthBloc bloc;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    bloc = AuthBloc(authRepository: mockRepository);
  });

  group('loginRequested', () {
    test('should emit loading then authenticated on success', () {
      // Test implementation
    });

    test('should emit loading then error on failure', () {
      // Test implementation
    });

    test('should handle network errors gracefully', () {
      // Test implementation
    });
  });
});
```

### Mock Usage

- **Mock all external dependencies:** Use Mocktail for mocking
- **Verify interactions:** Check that methods are called correctly
- **Test edge cases:** Cover error scenarios and edge cases

```dart
// ✅ CORRECT - Mocking patterns
class MockAuthRepository extends Mock implements AuthRepository {}

test('should call repository with correct parameters', () {
  // Arrange
  const username = 'test@example.com';
  const password = 'password123';

  // Act
  bloc.add(AuthEvent.loginRequested(
    username: username,
    password: password,
  ));

  // Assert
  verify(() => mockRepository.login(username, password)).called(1);
});
```

## Code Quality Enforcement

### Pre-commit Hooks

**Required checks before commit:**

```bash
# Formatting
dart format .

# Analysis
dart analyze

# Tests
flutter test

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Dependencies
dart run dependency_validator
```

### CI/CD Integration

**Automated quality gates:**

```yaml
# .github/workflows/quality.yml
- name: Check formatting
  run: dart format --set-exit-if-changed .

- name: Analyze code
  run: dart analyze --fatal-infos

- name: Run tests
  run: flutter test --coverage

- name: Check coverage
  run: |
    lcov --summary coverage/lcov.info
    # Fail if coverage < 95%
```

### Code Review Checklist

**Mandatory review items:**

- [ ] All linter errors resolved
- [ ] Tests added for new functionality
- [ ] No hardcoded values or secrets
- [ ] Proper error handling implemented
- [ ] Documentation updated if needed
- [ ] Performance implications considered
- [ ] Security implications reviewed
- [ ] Accessibility requirements met

## Documentation Requirements

### Code Documentation

- **Public APIs:** All public methods must have dartdoc comments
- **Complex logic:** Add inline comments for complex algorithms
- **TODO comments:** Include ticket references for future work

````dart
/// Authenticates a user with the provided credentials.
///
/// Returns [Either] with [AuthFailure] on error or [User] on success.
/// Throws [NetworkException] if network is unavailable.
///
/// Example:
/// ```dart
/// final result = await authRepository.login('user@example.com', 'password');
/// result.fold(
///   (failure) => handleError(failure),
///   (user) => navigateToHome(user),
/// );
/// ```
Future<Either<AuthFailure, User>> login(
  String username,
  String password,
) async {
  // Implementation
}
````

### Architecture Documentation

- **Update tech stack:** When adding new dependencies
- **Document patterns:** When introducing new architectural patterns
- **Keep README current:** Update setup and usage instructions

## Performance Guidelines

### Flutter Performance

- **Avoid rebuilds:** Use `const` constructors when possible
- **Optimize widget tree:** Extract widgets to reduce rebuild scope
- **Use keys appropriately:** For list items and stateful widgets

```dart
// ✅ CORRECT - Performance optimized
class UserList extends StatelessWidget {
  const UserList({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserListItem(
          key: ValueKey(user.id), // Stable key for performance
          user: user,
        );
      },
    );
  }
}
```

### Memory Management

- **Dispose resources:** Always dispose streams, controllers, and listeners
- **Avoid memory leaks:** Cancel subscriptions in dispose methods
- **Use weak references:** When appropriate for caching

```dart
// ✅ CORRECT - Resource management
class AuthController extends ChangeNotifier {
  StreamSubscription<AuthState>? _authSubscription;

  void initialize() {
    _authSubscription = authBloc.stream.listen(_handleAuthState);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
```

## Accessibility Standards

### Flutter Accessibility

- **Semantic labels:** Add semantics to all interactive elements
- **Screen reader support:** Test with TalkBack/VoiceOver
- **Contrast ratios:** Ensure WCAG 2.1 AA compliance

```dart
// ✅ CORRECT - Accessibility support
Semantics(
  label: 'Login button',
  hint: 'Double tap to log in with your credentials',
  child: ElevatedButton(
    onPressed: _handleLogin,
    child: const Text('Login'),
  ),
)
```

### Keyboard Navigation

- **Focus management:** Proper tab order for form fields
- **Keyboard shortcuts:** Support common keyboard interactions
- **Focus indicators:** Clear visual focus indicators

## Maintenance Guidelines

### Dependency Management

- **Regular updates:** Monthly dependency updates
- **Security patches:** Immediate security update policy
- **Breaking changes:** Careful evaluation of breaking changes

### Code Cleanup

- **Remove dead code:** Regular cleanup of unused code
- **Refactor duplicates:** Extract common functionality
- **Update documentation:** Keep documentation in sync with code

---

**Document Control**

- Created: January 2025
- Last Modified: January 2025
- Next Review: February 2025
- Owner: Development Team
- Version: 1.0
- Compliance Level: Mandatory for all code contributions
