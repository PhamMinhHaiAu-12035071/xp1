# 🚀 API Integration, Models, Repository & Infrastructure Layer Planning

**Author**: Linus Torvalds Engineering Approach  
**Target Feature**: Authentication System (`@authentication/`)  
**Architecture**: Clean Code (Uncle Bob) + Pragmatic Engineering (Linus Style)

---

## 🎯 CORE JUDGMENT

**✅ Worth doing**: This is fundamental infrastructure. Without proper API integration, your authentication is garbage.

**🔥 Key Insights**:

- **Data structure**: Authentication flows are simple - you need tokens, you store them, you refresh them. Don't overcomplicate.
- **Complexity to eliminate**: Current login form exists but has no backend integration. That's not authentication, it's UI theater.
- **Risk points**: Network failures, token expiry, storage corruption. Handle these or users will hate your app.
- **Good catch**: You spotted the hardcoded URL garbage immediately. That's **good taste**.

---

## 📋 LINUS-STYLE SOLUTION

### Phase 1: Stop the Madness - Remove Bad Code

```bash
# First, understand what garbage we're dealing with
find lib/features/authentication -name "*.dart" -exec wc -l {} +
```

**Current State Analysis**:

- ✅ **Good**: Login UI exists with proper validation
- ❌ **Bad**: No API integration whatsoever
- ❌ **Terrible**: Login button does fake delay with `Future.delayed(2 seconds)` - this is theater, not software

**Action**:

1. Keep the UI components (they're decent)
2. Rip out the fake authentication logic
3. Build real infrastructure

---

## 🏗️ INFRASTRUCTURE REQUIREMENTS

### Package Dependencies Analysis

Based on KSK reference project analysis:

```yaml
dependencies:
  # HTTP CLIENT - Use Chopper (it's what KSK uses, it works)
  chopper: ^8.1.0

  # EITHER MONAD - Don't reinvent error handling
  fpdart: ^1.1.1

  # DEPENDENCY INJECTION - Get_it + Injectable pattern
  get_it: ^8.0.3
  injectable: ^2.5.0

  # JSON SERIALIZATION - Build system integration
  json_annotation: ^4.9.0

  # LOGGING - Use logger, not print statements
  logger: ^2.5.0

  # NETWORKING INTERCEPTORS - For auth and logging
  pretty_chopper_logger: ^1.2.2

dev_dependencies:
  # CODE GENERATION
  chopper_generator: ^8.1.0
  injectable_generator: ^2.7.0
  json_serializable: ^6.7.0
  build_runner: ^2.5.4
```

**Why these choices?**

- **Chopper**: Reference project uses it. It works. It generates clean service code.
- **Not Dio**: We could use Dio, but Chopper has cleaner code generation. Less boilerplate = less bugs.
- **fpdart**: Either monad for error handling. Stop using exceptions for control flow.
- **Environment System**: You already have a **perfect** env config system. Use it, don't ignore it.

---

## 🎨 PROJECT STRUCTURE

### Directory Architecture

```
lib/features/authentication/
├── domain/                     # Business rules (zero dependencies)
│   ├── entities/
│   │   ├── user_entity.dart
│   │   └── token_entity.dart
│   ├── failures/
│   │   └── auth_failure.dart
│   ├── repositories/           # Abstract contracts
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       └── refresh_token_usecase.dart
├── infrastructure/             # External world adapters
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   ├── models/                 # JSON <-> Entity mapping
│   │   ├── login_request.dart
│   │   ├── login_response.dart
│   │   └── token_model.dart
│   ├── repositories/
│   │   └── auth_repository_impl.dart
│   └── services/
│       ├── auth_api_service.dart
│       └── token_storage_service.dart
├── application/                # State management
│   └── blocs/
│       └── auth_bloc.dart
└── presentation/               # UI (already exists, mostly good)
    ├── pages/
    │   └── login_page.dart     # ✅ Keep this
    └── widgets/
        ├── login_form.dart     # ✅ Keep this
        └── login_carousel.dart # ✅ Keep this
```

### Core Infrastructure Extensions

```
lib/core/
├── network/                    # Networking foundation
│   ├── api_client.dart        # Chopper client + env integration
│   ├── auth_interceptor.dart  # Token injection
│   ├── logging_interceptor.dart
│   └── error_handler.dart
├── storage/                   # Local persistence
│   ├── secure_storage.dart    # Token storage
│   └── storage_keys.dart
├── di/                        # Dependency injection
│   ├── network_module.dart    # HTTP clients
│   └── auth_module.dart       # Auth services
└── errors/
    ├── api_error.dart         # Network errors
    └── storage_error.dart     # Storage errors
```

---

## 🔧 IMPLEMENTATION PLAN

### Step 1: Foundation - Core Infrastructure

**Priority**: CRITICAL  
**Time**: 1 day

```bash
# 1.1 Add dependencies
flutter pub add chopper fpdart get_it injectable json_annotation logger
flutter pub add -d chopper_generator injectable_generator json_serializable build_runner

# 1.2 Create core network infrastructure
mkdir -p lib/core/{network,storage,di,errors}
```

**Files to create**:

1. **`lib/core/network/api_client.dart`**

```dart
@injectable
class ApiClient {
  const ApiClient(this._envConfig);

  final EnvConfigRepository _envConfig;

  @lazySingleton
  ChopperClient create() {
    return ChopperClient(
      baseUrl: Uri.parse(_envConfig.apiUrl), // 🔥 Use existing env system
      services: [
        AuthApiService.create(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        AuthInterceptor(),
        LoggingInterceptor(),
      ],
    );
  }
}
```

2. **`lib/core/errors/api_error.dart`** (Copy from KSK reference)

3. **`lib/core/storage/secure_storage.dart`** (Token management)

4. **`lib/core/di/network_module.dart`** (Proper DI setup)

```dart
@module
abstract class NetworkModule {
  @injectable
  ChopperClient provideChopperClient(
    EnvConfigRepository envConfig,
    AuthInterceptor authInterceptor,
  ) {
    return ChopperClient(
      baseUrl: Uri.parse(envConfig.apiUrl),
      services: [
        AuthApiService.create(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        authInterceptor,
        if (envConfig.isDebugMode) LoggingInterceptor(),
      ],
    );
  }
}
```

### Step 2: Domain Layer - The Truth

**Priority**: CRITICAL  
**Time**: 0.5 days

**Why domain first?** Because domain defines what your app actually does. Everything else is just implementation details.

**Files to create**:

1. **`lib/features/authentication/domain/entities/user_entity.dart`**

```dart
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
  });

  final String id;
  final String username;
  final String email;

  @override
  List<Object> get props => [id, username, email];
}
```

2. **`lib/features/authentication/domain/entities/token_entity.dart`**

```dart
class TokenEntity extends Equatable {
  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  @override
  List<Object> get props => [accessToken, refreshToken, expiresIn];
}
```

3. **`lib/features/authentication/domain/repositories/auth_repository.dart`**

```dart
abstract class AuthRepository {
  Future<Either<AuthFailure, TokenEntity>> login({
    required String username,
    required String password,
  });

  Future<Either<AuthFailure, TokenEntity>> refreshToken();

  Future<Either<AuthFailure, void>> logout();
}
```

### Step 3: Infrastructure Layer - The Real Work

**Priority**: CRITICAL  
**Time**: 2 days

**Files to create**:

1. **`lib/features/authentication/infrastructure/services/auth_api_service.dart`**

```dart
@ChopperApi(baseUrl: '/auth')
abstract class AuthApiService extends ChopperService {
  static AuthApiService create([ChopperClient? client]) =>
      _$AuthApiService(client);

  @POST(path: '/login')
  Future<Response<Map<String, dynamic>>> login(
    @Body() Map<String, dynamic> loginRequest,
  );

  @POST(path: '/refresh')
  Future<Response<Map<String, dynamic>>> refreshToken(
    @Body() Map<String, dynamic> refreshRequest,
  );
}
```

2. **`lib/features/authentication/infrastructure/models/login_request.dart`**

```dart
@JsonSerializable()
class LoginRequest {
  const LoginRequest({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

3. **`lib/features/authentication/infrastructure/repositories/auth_repository_impl.dart`**

```dart
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  // Implementation following KSK pattern exactly
}
```

### Step 4: Integration - Connect the Dots

**Priority**: HIGH  
**Time**: 1 day

1. **Update `lib/features/authentication/presentation/widgets/login_form.dart`**

   - Remove fake delay: `await Future<void>.delayed(const Duration(seconds: 2));`
   - Inject AuthBloc and call real login
   - Handle loading states properly

2. **Create BLoC integration**
3. **Add proper error handling**

### Step 5: Testing - Prove It Works

**Priority**: HIGH  
**Time**: 1 day

```bash
# Unit tests for each layer
mkdir -p test/features/authentication/{domain,infrastructure,application}

# Integration tests for API
mkdir -p test/integration/authentication
```

---

## 🚨 CRITICAL RULES

### The "Never Break Userspace" Rules

1. **Backward Compatibility**: Login UI must continue working during migration
2. **Graceful Degradation**: Handle network failures gracefully
3. **No Data Loss**: User credentials should never be lost due to storage issues

### The "Good Taste" Rules

1. **Single Responsibility**: Each class does ONE thing well
2. **No God Classes**: If your repository has more than 10 methods, split it
3. **Error Handling**: Use Either<Failure, Success> pattern. No exceptions for business logic.

### The "Pragmatic" Rules

1. **Copy from KSK**: They already solved this. Don't reinvent the wheel.
2. **Test the Happy Path First**: Get login working before handling edge cases
3. **Measure Performance**: Add logging interceptors to track API response times

---

## 📦 PACKAGE INSTALLATION COMMANDS

```bash
# Core dependencies (skip envied - you already have it ✅)
flutter pub add chopper:^8.1.0
flutter pub add fpdart:^1.1.1
flutter pub add get_it:^8.0.3
flutter pub add injectable:^2.5.0
flutter pub add json_annotation:^4.9.0
flutter pub add logger:^2.5.0
flutter pub add pretty_chopper_logger:^1.2.2
flutter pub add equatable:^2.0.7

# Dev dependencies
flutter pub add -d chopper_generator:^8.1.0
flutter pub add -d injectable_generator:^2.7.0
flutter pub add -d json_serializable:^6.7.0
flutter pub add -d build_runner:^2.5.4

# Generate code
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

## 🎯 SUCCESS CRITERIA

### Definition of Done

1. **User can login with real credentials** ✅
2. **Token refresh happens automatically** ✅
3. **Network errors are handled gracefully** ✅
4. **All tests pass** ✅
5. **Code follows KSK reference patterns** ✅
6. **Zero linter errors** ✅

### Performance Targets

- **Login response**: < 3 seconds on 3G
- **Token refresh**: < 1 second
- **Error feedback**: Immediate UI feedback

---

## 🔥 LINUS FINAL WORDS

**"This isn't rocket science. It's authentication. Every app needs it. Stop overthinking and start implementing."**

The KSK reference project shows you exactly how to structure this. Follow their patterns:

- Use Chopper for API services
- Use Either for error handling
- Use Injectable for dependency injection
- Use the exact same folder structure
- **Use your existing environment system** - it's already perfect, don't hardcode URLs

**Don't try to be clever. Be correct. Be fast. Ship it.**

---

## 📚 REFERENCE MATERIALS

- **KSK Project Structure**: `/Users/phamau/Desktop/projects/ksk/ksk_app/lib/features/auth/`
- **Clean Architecture**: Uncle Bob's patterns (entities → use cases → interfaces → frameworks)
- **Chopper Documentation**: Type-safe HTTP client code generation
- **fpdart Documentation**: Functional programming patterns for Dart

**Next Steps**: Start with Step 1 (Foundation). Don't skip steps. Each phase builds on the previous one.

---

_"Good programmers worry about data structures and their relationships. Everything else is implementation detail." - Linus Torvalds_
