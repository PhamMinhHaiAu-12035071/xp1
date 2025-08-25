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
- [ ] Internationalization strings added
- [ ] Security considerations addressed

#### Review Process
- [ ] Architecture alignment với BLoC pattern
- [ ] Code quality và readability theo Very Good standards
- [ ] Test coverage adequacy với proper mocking
- [ ] Security considerations và input validation
- [ ] Performance impact assessment
- [ ] Documentation completeness và accuracy
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

### Documentation Requirements (Bắt buộc)
- **Use triple slash (`///`) for documentation comments** (bắt buộc với very_good_analysis)
- **Document all public APIs** with detailed parameter descriptions (bắt buộc)
- **Include usage examples** in documentation for complex widgets and methods
- **Comprehensive documentation** cho tất cả public APIs

### Class Documentation
```dart
/// Repository để quản lý user data.
/// 
/// Cung cấp methods để CRUD operations với user entities
/// thông qua local database và remote API.
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
/// * [User], model class cho user data
/// * [UserBloc], BLoC để quản lý user state
abstract class UserRepository {
  /// Lấy user by ID.
  /// 
  /// Throws [UserNotFoundException] nếu không tìm thấy.
  /// 
  /// ## Parameters
  /// 
  /// * [id] - User ID cần lấy
  /// 
  /// ## Returns
  /// 
  /// Future<User> - User data
  /// 
  /// ## Throws
  /// 
  /// * [UserNotFoundException] - Khi user không tồn tại
  /// * [ApiException] - Khi API call thất bại
  Future<User> getUser(String id);
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

### Widget Documentation
```dart
/// Widget hiển thị thông tin người dùng với avatar và tên.
/// 
/// Widget này tự động load avatar từ URL và hiển thị placeholder
/// nếu load thất bại. Hỗ trợ callback khi user tap vào.
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
  /// Tạo [UserInfoCard].
  /// 
  /// [user] là required và không được null.
  /// [onTap] là optional callback khi user tap.
  /// [showAvatar] mặc định là true.
  const UserInfoCard({
    required this.user,
    this.onTap,
    this.showAvatar = true,
    super.key,
  });

  /// User data để hiển thị.
  final User user;
  
  /// Callback được gọi khi user tap vào card.
  final VoidCallback? onTap;
  
  /// Có hiển thị avatar hay không.
  final bool showAvatar;
}
```

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

# Very Good Analysis đã include hầu hết rules tốt nhất
# Chỉ override khi thực sự cần thiết
linter:
  rules:
    # Override rules nếu cần (không khuyến khích)
    # lines_longer_than_80_chars: false  # Nếu cần dòng dài hơn
```

### VS Code Settings cho Very Good
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

*These guidelines ensure consistent, maintainable, and high-quality code across the Xp1 Flutter project.*
