# Flutter Coding Standards & Best Practices Guide

## Introduction

This style guide outlines the coding conventions for Flutter applications developed in our organization.
It's based on the official Flutter and Dart style guides, but with some modifications to address specific needs and
preferences within our development team. This guide ensures consistency, maintainability, and high-quality code
across all Flutter projects.

## Key Principles

* **Optimized for Readability**: Code phải dễ đọc và hiểu ngay cả với người lần đầu đọc
* **Detailed Documentation**: Viết documentation chi tiết cho tất cả public APIs
* **Maintainability**: Code dễ bảo trì, mở rộng và debug
* **Performance First**: Tối ưu hiệu suất từ khi thiết kế
* **Consistency**: Tuân thủ nhất quán trong toàn bộ codebase

## Deviations from Official Flutter/Dart Standards

### Line Length
* **Maximum line length:** 100 characters (instead of Dart's default 80).
    * Modern screens allow for wider lines, improving code readability in many cases.
    * Flutter widgets often have long parameter lists that benefit from wider lines.

### Import Organization
* **Group imports in this order:**
    * Dart core libraries (`dart:` imports)
    * Flutter framework imports (`package:flutter/`)
    * Third-party packages (alphabetical order)
    * Internal packages (relative imports for files within lib/)
* **Use relative imports** for files within the same package for better maintainability.

### Documentation Style
* **Use triple slash (`///`) for documentation comments** instead of triple quotes.
* **Include usage examples** in documentation for complex widgets and methods.
* **Document all public APIs** with detailed parameter descriptions.

## Naming Conventions

### Classes, Enums, Typedefs, Extensions
```dart
// ✅ Tốt - UpperCamelCase
class UserProfileScreen extends StatelessWidget {}
class PaymentRepository {}
enum ConnectionState { connected, disconnected }
typedef UserCallback = void Function(User user);
extension StringExtensions on String {}

// ❌ Tránh
class userProfileScreen {} // lowercase
class User_Profile_Screen {} // snake_case
```

### Variables, Methods, Parameters
```dart
// ✅ Tốt - lowerCamelCase
final String userName = 'john_doe';
int itemCount = 0;
void fetchUserData() {}
void calculateTotalAmount({required double basePrice}) {}

// ❌ Tránh  
final String user_name = 'john_doe'; // snake_case
final String UserName = 'john_doe'; // UpperCamelCase
```

### Files và Directories
```dart
// ✅ Tốt - snake_case
user_profile_screen.dart
payment_repository.dart
lib/features/authentication/

// ❌ Tránh
UserProfileScreen.dart // UpperCamelCase
user-profile-screen.dart // kebab-case
```

### Constants
```dart
// ✅ Tốt - lowerCamelCase cho const
const double defaultPadding = 16.0;
const Color primaryColor = Colors.blue;

// ✅ Tốt - SCREAMING_SNAKE_CASE cho static const
static const String API_BASE_URL = 'https://api.example.com';
static const int MAX_RETRY_COUNT = 3;
```

## Code Formatting & Structure

### Indentation và Line Length
```dart
// ✅ Sử dụng 2 spaces cho indentation
class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Example'),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
```

### Trailing Commas
```dart
// ✅ Tốt - Sử dụng trailing comma để format tốt hơn
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('First item'),
      Text('Second item'), // trailing comma
    ], // trailing comma
  );
}

// ✅ Tốt - Không cần trailing comma với single parameter
Text('Simple text')
```

### Import Organization
```dart
// ✅ Tốt - Nhóm imports theo thứ tự
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

// 4. Internal packages (relative imports cho files trong lib/)
import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'widgets/user_card.dart';
```

## Widget Best Practices

### StatelessWidget Template
```dart
class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.user,
    this.onTap,
    this.showAvatar = true,
  });

  final User user;
  final VoidCallback? onTap;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: showAvatar ? CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl),
        ) : null,
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}
```

### StatefulWidget Template
```dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({
    super.key,
    this.initialValue = 0,
    this.onChanged,
  });

  final int initialValue;
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
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
```

## Performance Optimization

### Const Constructors
```dart
// ✅ Tốt - Sử dụng const khi có thể
const Text('Static text')
const SizedBox(height: 16.0)
const Icon(Icons.home)

// ✅ Tốt - Const constructor
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
}
```

### Widget Extraction
```dart
// ✅ Tốt - Extract widgets để tránh rebuilds không cần thiết
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          _buildHeader(), // Extract thành method riêng
          _ProfileInfoSection(), // Extract thành widget riêng
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      color: Colors.blue,
      child: Center(child: Text('Header')),
    );
  }
}

class _ProfileInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('User Information'),
            // More widgets...
          ],
        ),
      ),
    );
  }
}
```

### ListView Optimization
```dart
// ✅ Tốt - Sử dụng ListView.builder cho long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ListTile(
      key: ValueKey(item.id), // Key cho dynamic content
      title: Text(item.title),
      subtitle: Text(item.description),
    );
  },
)

// ✅ Tốt - Sử dụng ListView.separated cho dividers
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
  separatorBuilder: (context, index) => Divider(),
)
```

## Error Handling & Null Safety

### Safe Navigation
```dart
// ✅ Tốt - Null-aware operators
final userName = user?.name ?? 'Unknown';
final userEmail = user?.profile?.email;
final itemCount = items?.length ?? 0;

// ✅ Tốt - Safe method calls
user?.updateProfile();
items?.forEach((item) => print(item));

// ❌ Tránh - Unsafe casting
final user = data as User; // Có thể throw exception
// Thay vào đó:
final user = data is User ? data : null;
```

### Exception Handling
```dart
// ✅ Tốt - Specific exception handling
Future<User> fetchUser(String userId) async {
  try {
    final response = await http.get(Uri.parse('/api/users/$userId'));
    
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('Failed to fetch user: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('No internet connection');
  } on FormatException {
    throw DataParsingException('Invalid response format');
  } on ApiException {
    rethrow;
  } catch (e) {
    throw UnknownException('Unexpected error: $e');
  }
}
```

## State Management Patterns

### Provider Pattern
```dart
class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUser(String userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _user = await userRepository.getUser(userId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
```

### BLoC Pattern
```dart
// Event
abstract class UserEvent extends Equatable {
  const UserEvent();
  
  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser(this.userId);
  
  final String userId;
  
  @override
  List<Object> get props => [userId];
}

// State
abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  const UserLoaded(this.user);
  
  final User user;
  
  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  const UserError(this.message);
  
  final String message;
  
  @override
  List<Object> get props => [message];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  final UserRepository userRepository;

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    
    try {
      final user = await userRepository.getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

## Documentation Standards

### Class Documentation
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
/// 
/// ## See also
/// 
/// * [User], model class cho user data
/// * [UserDetailScreen], màn hình chi tiết user
class UserInfoCard extends StatelessWidget {
  /// Tạo [UserInfoCard].
  /// 
  /// [user] là required và không được null.
  /// [onTap] là optional callback khi user tap.
  /// [showAvatar] mặc định là true.
  const UserInfoCard({
    super.key,
    required this.user,
    this.onTap,
    this.showAvatar = true,
  });

  /// User data để hiển thị.
  final User user;
  
  /// Callback được gọi khi user tap vào card.
  final VoidCallback? onTap;
  
  /// Có hiển thị avatar hay không.
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    // Implementation...
  }
}
```

### Method Documentation
```dart
/// Validates email address format.
/// 
/// Returns `true` if [email] has valid format, `false` otherwise.
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

## Testing Standards

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
        final expectedUser = User(
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

      test('should throw ApiException when API call fails', () async {
        // Arrange
        const userId = 'user123';
        when(() => mockApiClient.getUser(userId))
            .thenThrow(ApiException('User not found'));

        // Act & Assert
        expect(
          () => userRepository.getUser(userId),
          throwsA(isA<ApiException>()),
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
      testUser = User(
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

## Project Structure

```
lib/
├── core/                    # Core utilities, constants, themes
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── extensions/
├── data/                    # Data layer
│   ├── models/
│   ├── repositories/
│   ├── datasources/
│   └── services/
├── domain/                  # Business logic
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/            # UI layer
│   ├── pages/
│   ├── widgets/
│   ├── providers/ (hoặc bloc/)
│   └── routes/
├── shared/                  # Shared utilities
│   ├── widgets/
│   └── utils/
└── main.dart
```

## Code Review Checklist

- [ ] Naming conventions được tuân thủ
- [ ] Code được format đúng (dart format)
- [ ] Không có unused imports hoặc variables
- [ ] Sử dụng const constructors khi có thể
- [ ] Error handling được implement đầy đủ
- [ ] Null safety được xử lý đúng cách
- [ ] Documentation đầy đủ cho public APIs
- [ ] Unit tests cover các use cases chính
- [ ] Performance considerations được xem xét
- [ ] UI responsive trên các screen sizes khác nhau

## Tooling

### Recommended packages
```yaml
dev_dependencies:
  flutter_lints: ^4.0.0      # Official linting rules
  very_good_analysis: ^9.0.0 # Stricter linting rules
```

### Analysis options
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  
linter:
  rules:
    # Additional custom rules
    avoid_print: true
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    sort_constructors_first: true
    sort_unnamed_constructors_first: true
```

## Flutter-Specific Best Practices

### Navigation
```dart
// ✅ Tốt - Sử dụng named routes
Navigator.pushNamed(context, '/user-detail', arguments: userId);

// ✅ Tốt - Sử dụng GoRouter cho complex navigation
GoRouter.of(context).push('/user/$userId');
```

### Localization
```dart
// ✅ Tốt - Sử dụng AppLocalizations
Text(AppLocalizations.of(context)!.welcomeMessage)

// ✅ Tốt - Sử dụng context extension
Text(context.l10n.welcomeMessage)
```

### Theme Usage
```dart
// ✅ Tốt - Sử dụng Theme.of(context)
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
// ✅ Tốt - Sử dụng MediaQuery và LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return DesktopLayout();
    } else {
      return MobileLayout();
    }
  },
)
```

## Security Guidelines

### Input Validation
```dart
// ✅ Tốt - Validate user input
class UserInputValidator {
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
// ✅ Tốt - Sử dụng flutter_secure_storage cho sensitive data
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

## Accessibility

### Semantic Labels
```dart
// ✅ Tốt - Thêm semantic labels cho accessibility
IconButton(
  onPressed: () {},
  icon: Icon(Icons.close),
  tooltip: 'Close dialog',
  semanticsLabel: 'Close dialog button',
)
```

### Color Contrast
```dart
// ✅ Tốt - Đảm bảo contrast ratio đủ cao
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

The following example demonstrates a complete Flutter application that follows all the principles outlined in this style guide:

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
          UserLoaded() => _UserListView(users: state.users),
          UserError() => _ErrorWidget(message: state.message),
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
      
      context.read<UserBloc>().add(AddUser(user));
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