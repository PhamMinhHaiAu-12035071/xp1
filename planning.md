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

**Required dependencies**:

```yaml
dependencies:
  # HTTP CLIENT
  chopper: <latest_version>

  # ERROR HANDLING
  fpdart: <latest_version>

  # DEPENDENCY INJECTION
  get_it: <latest_version>
  injectable: <latest_version>

  # JSON SERIALIZATION
  json_annotation: <latest_version>

  # LOGGING
  logger: <latest_version>

  # NETWORKING
  pretty_chopper_logger: <latest_version>
  equatable: <latest_version>

  # ANNOTATIONS
  freezed_annotation: <latest_version>
  json_annotation: <latest_version>

  # SECURITY
  flutter_secure_storage: <latest_version>

dev_dependencies:
  # CODE GENERATION
  chopper_generator: <latest_version>
  injectable_generator: <latest_version>
  json_serializable: <latest_version>
  build_runner: <latest_version>

  # 🧪 TESTING INFRASTRUCTURE
  mocktail: <latest_version> # Behavior testing
  bloc_test: <latest_version> # BLoC testing utilities
```

**Core principles**: Chopper for API, Either for errors, Injectable for DI, FlutterSecureStorage for JWT tokens.

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
│   ├── models/                 # JSON <-> API mapping
│   │   ├── login_request.dart
│   │   ├── login_response.dart
│   │   └── token_model.dart
│   ├── mappers/                # Model <-> Entity conversion
│   │   ├── auth_mapper.dart
│   │   ├── user_mapper.dart
│   │   └── token_mapper.dart
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
│   ├── auth_interceptor.dart  # JWT token injection
│   ├── logging_interceptor.dart
│   └── error_handler.dart
├── security/                  # 🔐 SECURITY LAYER (NEW)
│   ├── secure_storage_service.dart   # Encrypted JWT token storage
│   ├── token_manager.dart            # JWT management & refresh
│   ├── jwt_service.dart              # JWT encoding/decoding/validation
│   └── security_keys.dart            # Security constants
├── mappers/                   # 🔄 BASE MAPPER ABSTRACTIONS (NEW)
│   └── base_mapper.dart              # Abstract mapper contract
├── storage/                   # Local persistence
│   └── secure_storage_service.dart # JWT token storage
├── di/                        # Dependency injection
│   ├── network_module.dart    # HTTP clients
│   ├── auth_module.dart       # Auth services
│   └── security_module.dart   # Security services
└── errors/
    ├── api_error.dart         # Network errors
    ├── storage_error.dart     # Storage errors
    └── security_error.dart    # Security/auth errors
```

---

## 🔐 SECURITY ARCHITECTURE

### JWT-First Security Approach

**🚨 CRITICAL**: JWT security is not an afterthought. Build proper token handling from day 1.

#### JWT Token Management Strategy

```dart
// Secure JWT token storage with encryption
@LazySingleton()
class TokenManager {
  final SecureStorageService _secureStorage;
  final JwtService _jwtService;

  // Never store JWT tokens in plain text
  Future<void> storeTokens(TokenEntity tokens) async {
    await _secureStorage.store(
      SecurityKeys.accessToken,
      tokens.accessToken,
    );
    await _secureStorage.store(
      SecurityKeys.refreshToken,
      tokens.refreshToken,
    );
  }

  // Automatic JWT token refresh before expiry
  Future<Either<SecurityFailure, TokenEntity>> getValidToken() async {
    final token = await getStoredToken();

    // Check JWT expiration
    if (_jwtService.isTokenExpired(token.accessToken)) {
      return await refreshToken();
    }

    return Right(token);
  }

  // Validate JWT token structure and signature
  bool isTokenValid(String token) {
    return _jwtService.validateToken(token);
  }
}
```

#### JWT Service Implementation

```dart
@LazySingleton()
class JwtService {
  // Decode JWT payload (dart:convert only)
  Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Check if JWT token is expired
  bool isTokenExpired(String token) {
    final decoded = decodeToken(token);
    if (decoded == null) return true;

    final exp = decoded['exp'] as int?;
    if (exp == null) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  }

  // Extract user info from JWT
  Map<String, dynamic>? getUserInfo(String token) {
    return decodeToken(token);
  }
}
```

#### API Security Interceptors

```dart
@Injectable()
class SecurityInterceptor implements Interceptor {
  final TokenManager _tokenManager;

  @override
  Future<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request;

    // Add security headers
    final secureRequest = request.copyWith(
      headers: {
        ...request.headers,
        'X-API-Version': '1.0',
        'X-Client-Platform': Platform.operatingSystem,
        'Content-Type': 'application/json',
      },
    );

    // Add JWT token if available
    final tokenResult = await _tokenManager.getValidToken();
    return tokenResult.fold(
      (failure) => chain.proceed(secureRequest),
      (token) => chain.proceed(
        secureRequest.copyWith(
          headers: {
            ...secureRequest.headers,
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      ),
    );
  }
}
```

#### JWT Security Best Practices

**🔒 JWT Security Checklist**:

- [ ] **Secure storage** - JWT tokens in FlutterSecureStorage only
- [ ] **Token validation** - Check JWT structure and expiry
- [ ] **Automatic refresh** - Refresh tokens before expiry
- [ ] **HTTPS only** - Never send JWT over HTTP
- [ ] **Token cleanup** - Clear tokens on logout
- [ ] **No logging** - Never log JWT tokens (even in debug)

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

3. **`lib/core/storage/secure_storage_service.dart`** (JWT token management)

```dart
@LazySingleton()
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Store JWT tokens
  Future<void> storeAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  // Retrieve tokens
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // Clear tokens (logout)
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
```

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

5. **`lib/core/di/auth_module.dart`** (Register mappers)

```dart
@module
abstract class AuthModule {
  // Mappers are automatically registered with @injectable
  // No manual registration needed for TokenMapper, UserMapper

  @injectable
  AuthRepository provideAuthRepository(
    AuthApiService apiService,
    TokenStorageService tokenStorage,
    TokenMapper tokenMapper,     // 🔥 Auto-injected
    UserMapper userMapper,       // 🔥 Auto-injected
  ) {
    return AuthRepositoryImpl(
      apiService,
      tokenStorage,
      tokenMapper,
      userMapper,
    );
  }
}
```

### Step 2: Domain Layer - The Truth

**Priority**: CRITICAL  
**Time**: 0.5 days

**Create business logic first**.

**Files to create**:

1. **`lib/features/authentication/domain/entities/user_entity.dart`**

```dart
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String username,
    required String email,
  }) = _UserEntity;
}
```

2. **`lib/features/authentication/domain/entities/token_entity.dart`**

```dart
@freezed
class TokenEntity with _$TokenEntity {
  const factory TokenEntity({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    required DateTime issuedAt,
  }) = _TokenEntity;

  const TokenEntity._();

  bool get isExpired {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expiryTime);
  }

  bool get willExpireSoon {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    final timeUntilExpiry = expiryTime.difference(DateTime.now());
    return timeUntilExpiry.inMinutes < 5; // Refresh if < 5 minutes left
  }
}
```

3. **`lib/features/authentication/domain/failures/auth_failure.dart`**

```dart
@freezed
sealed class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidCredentials() = InvalidCredentialsFailure;
  const factory AuthFailure.networkError(String message) = NetworkFailure;
  const factory AuthFailure.serverError(int statusCode) = ServerFailure;
  const factory AuthFailure.tokenExpired() = TokenExpiredFailure;
  const factory AuthFailure.unauthorized() = UnauthorizedFailure;
  const factory AuthFailure.unknown(String message) = UnknownFailure;
}
```

4. **`lib/features/authentication/domain/usecases/login_usecase.dart`**

```dart
@freezed
class LoginInput with _$LoginInput {
  const factory LoginInput({
    required String username,
    required String password,
    @Default(false) bool rememberMe,
    String? deviceId,
  }) = _LoginInput;
}

@freezed
class LoginResult with _$LoginResult {
  const factory LoginResult({
    required TokenEntity token,
    required UserEntity user,
    @Default(false) bool isFirstLogin,
  }) = _LoginResult;
}

@injectable
class LoginUseCase {
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<AuthFailure, LoginResult>> call(LoginInput input) async {
    return await _authRepository.login(input);
  }
}
```

5. **`lib/features/authentication/domain/repositories/auth_repository.dart`**

```dart
abstract class AuthRepository {
  Future<Either<AuthFailure, LoginResult>> login(LoginInput input);
  Future<Either<AuthFailure, TokenEntity>> refreshToken();
  Future<Either<AuthFailure, void>> logout();
}
```

### Step 3: Infrastructure Layer - The Real Work

**Priority**: CRITICAL  
**Time**: 2.5 days

**🔥 CRITICAL**: Create mappers FIRST - they're required for repository implementation.

**Files to create**:

1. **`lib/core/mappers/base_mapper.dart` (CREATE FIRST - Foundation)**

```dart
/// Abstract base class for all mappers
///
/// Provides type-safe conversion contract between Models and Entities
/// Enforces consistency across all feature mappers
abstract class BaseMapper<TModel, TEntity> {
  /// Converts a model from infrastructure layer to domain entity
  ///
  /// This is the core method that every mapper MUST implement
  /// [model] - The infrastructure model (API response, DB model, etc.)
  /// Returns domain entity for use in business logic
  TEntity fromModelToEntity(TModel model);

  /// Converts a domain entity back to infrastructure model
  ///
  /// Optional method - override only if reverse conversion is needed
  /// [entity] - The domain entity
  /// Returns model for storage/API calls
  TModel fromEntityToModel(TEntity entity) {
    throw UnimplementedError(
      'Override fromEntityToModel() if reverse conversion is needed'
    );
  }

  /// Converts a list of models to entities
  ///
  /// Default implementation using fromModelToEntity()
  /// Override for custom list handling if needed
  List<TEntity> fromModelListToEntityList(List<TModel> models) {
    return models.map(fromModelToEntity).toList();
  }

  /// Converts a list of entities to models
  ///
  /// Default implementation using fromEntityToModel()
  /// Override for custom list handling if needed
  List<TModel> fromEntityListToModelList(List<TEntity> entities) {
    return entities.map(fromEntityToModel).toList();
  }
}
```

2. **`lib/features/authentication/infrastructure/mappers/` (CREATE SECOND)**

```bash
mkdir -p lib/features/authentication/infrastructure/mappers
```

3. **`lib/features/authentication/infrastructure/services/auth_api_service.dart`**

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
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String username,
    required String password,
    String? deviceId,
    @Default(false) bool rememberMe,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
```

3. **`lib/features/authentication/infrastructure/models/login_response.dart`**

```dart
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    required UserModel user,
    @Default(false) bool isFirstLogin,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
```

4. **`lib/features/authentication/infrastructure/models/user_model.dart`**

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String email,
    String? fullName,
    String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

5. **`lib/features/authentication/infrastructure/mappers/auth_mapper.dart`**

```dart
@injectable
class AuthMapper extends BaseMapper<LoginResponse, LoginResult> {
  const AuthMapper(this._userMapper);

  final UserMapper _userMapper;

  @override
  LoginResult fromModelToEntity(LoginResponse model) {
    return LoginResult(
      token: TokenEntity(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
        expiresIn: model.expiresIn,
        issuedAt: DateTime.now(),
      ),
      user: _userMapper.fromModelToEntity(model.user),
      isFirstLogin: model.isFirstLogin,
    );
  }

  LoginRequest fromInputToModel(LoginInput input) {
    return LoginRequest(
      username: input.username,
      password: input.password,
      deviceId: input.deviceId,
      rememberMe: input.rememberMe,
    );
  }
}
```

6. **`lib/features/authentication/infrastructure/mappers/user_mapper.dart`**

```dart
@injectable
class UserMapper extends BaseMapper<UserModel, UserEntity> {
  @override
  UserEntity fromModelToEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      email: model.email,
    );
  }

  @override
  UserModel fromEntityToModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
    );
  }
}
```

7. **`lib/features/authentication/infrastructure/repositories/auth_repository_impl.dart`**

```dart
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._authApiService,
    this._secureStorage,
    this._authMapper,
  );

  final AuthApiService _authApiService;
  final SecureStorageService _secureStorage;
  final AuthMapper _authMapper;

  @override
  Future<Either<AuthFailure, LoginResult>> login(LoginInput input) async {
    try {
      final loginRequest = _authMapper.fromInputToModel(input);
      final response = await _authApiService.login(loginRequest.toJson());

      // Handle HTTP status codes
      if (response.statusCode == 401) {
        return const Left(AuthFailure.invalidCredentials());
      }

      if (response.statusCode == 422) {
        return const Left(AuthFailure.invalidCredentials());
      }

      if (response.statusCode >= 500) {
        return Left(AuthFailure.serverError(response.statusCode ?? 500));
      }

      if (response.statusCode != 200 || response.body == null) {
        return Left(AuthFailure.unknown('Unexpected response: ${response.statusCode}'));
      }

      // Parse and convert response
      final loginResponse = LoginResponse.fromJson(response.body!);
      final result = _authMapper.fromModelToEntity(loginResponse);

      // Store tokens if remember me is enabled
      if (input.rememberMe) {
        await _secureStorage.storeAccessToken(result.token.accessToken);
        await _secureStorage.storeRefreshToken(result.token.refreshToken);
      }

      return Right(result);
    } on SocketException {
      return const Left(AuthFailure.networkError('No internet connection'));
    } on FormatException catch (e) {
      return Left(AuthFailure.unknown('Invalid response format: ${e.message}'));
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, TokenEntity>> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthFailure.tokenExpired());
      }

      final response = await _authApiService.refreshToken({
        'refresh_token': refreshToken,
      });

      if (response.statusCode == 401) {
        await _secureStorage.clearTokens();
        return const Left(AuthFailure.tokenExpired());
      }

      if (response.statusCode != 200 || response.body == null) {
        return Left(AuthFailure.serverError(response.statusCode ?? 500));
      }

      final tokenResponse = LoginResponse.fromJson(response.body!);
      final tokenEntity = TokenEntity(
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        expiresIn: tokenResponse.expiresIn,
        issuedAt: DateTime.now(),
      );

      await _secureStorage.storeAccessToken(tokenEntity.accessToken);
      await _secureStorage.storeRefreshToken(tokenEntity.refreshToken);

      return Right(tokenEntity);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _secureStorage.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }
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

### Step 5: JWT Security Implementation - Lock It Down

**Priority**: CRITICAL  
**Time**: 1 day

```bash
# 5.1 Create security infrastructure
mkdir -p lib/core/security

# 5.2 Implement JWT secure storage
# 5.3 Create JWT token management system
# 5.4 Add JWT validation service
# 5.5 Add security interceptors
```

### Step 6: Comprehensive Testing - Prove It Works

**Priority**: CRITICAL  
**Time**: 2 days

```bash
# Unit tests for each layer
mkdir -p test/features/authentication/{domain,infrastructure,application,security}
mkdir -p test/features/authentication/infrastructure/mappers  # 🔥 Mapper tests

# Integration tests
mkdir -p test/integration/{authentication,security,network}

# E2E tests
mkdir -p test/e2e/authentication_flows
```

**🧪 Testing Strategy**:

- **Unit Tests**: 95%+ coverage for business logic
  - **Mapper Tests**: Model ↔ Entity conversion accuracy
  - **Use Case Tests**: Domain logic validation
  - **Repository Tests**: Data flow and error handling
- **Integration Tests**: API contracts, JWT security flows
- **Widget Tests**: Authentication UI components
- **E2E Tests**: Complete authentication journeys
- **Security Tests**: JWT token management and validation
- **Performance Tests**: Login response times, memory usage

---

## 🔄 MAPPER PATTERN - DATA CONVERSION LAYER

### **🔥 LINUS JUDGMENT: ESSENTIAL ARCHITECTURE LAYER**

**MISSING**: Mapper layer required for Clean Architecture.

#### **Implementation**

```dart
// Repository with mapper injection
class AuthRepositoryImpl {
  AuthRepositoryImpl(this._api, this._tokenMapper);

  final TokenMapper _tokenMapper;

  Future<Either<AuthFailure, TokenEntity>> login() async {
    final response = await _api.login();
    final loginResponse = LoginResponse.fromJson(response.data);
    final tokenEntity = _tokenMapper.fromLoginResponseToEntity(loginResponse);
    return Right(tokenEntity);
  }
}
```

#### **Requirements**

Mappers handle Model ↔ Entity conversion only.

#### **Standard Pattern**

```dart
@injectable
class TokenMapper {
  // API Response → Domain Entity
  TokenEntity fromLoginResponseToEntity(LoginResponse response);

  // Storage Model → Domain Entity
  TokenEntity fromModelToEntity(TokenModel model);

  // Domain Entity → Storage Model
  TokenModel fromEntityToModel(TokenEntity entity);
}
```

#### **Data Flow Architecture**

```
API JSON → Model (fromJson) → Mapper → Entity → Use Case
Entity → Mapper → Model (toJson) → API JSON
```

#### **BaseMapper Benefits**

Type safety, consistent API, compile-time checks.

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
# 🎯 STEP 1: Core dependencies (using existing packages when possible)
flutter pub add chopper
flutter pub add fpdart
flutter pub add get_it
flutter pub add injectable
flutter pub add json_annotation
flutter pub add freezed_annotation
flutter pub add logger
flutter pub add pretty_chopper_logger
flutter pub add equatable

# 🔐 STEP 2: JWT Security layer (CRITICAL)
flutter pub add flutter_secure_storage

# 🧪 STEP 3: Dev dependencies
flutter pub add -d chopper_generator
flutter pub add -d injectable_generator
flutter pub add -d json_serializable
flutter pub add -d freezed
flutter pub add -d build_runner

# Testing infrastructure
flutter pub add -d mocktail
flutter pub add -d bloc_test

# 🚀 STEP 4: Generate code & setup
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 🛡️ Platform-Specific Setup

**No additional platform setup required** - JWT authentication and secure storage work out of the box on all platforms.

---

## 🎯 SUCCESS CRITERIA

### **Security**

- JWT tokens in FlutterSecureStorage only
- Token validation and auto-refresh
- HTTPS only, no sensitive data in logs

### **Testing**

- 95%+ test coverage (unit, integration, widget, E2E)
- All API endpoints and security flows covered

### **Performance**

- Login < 2 seconds, token refresh < 500ms
- JWT validation < 50ms, immediate error feedback

### **UX**

- Auto-login, loading states, error messages
- Accessibility and form validation

### **Code Quality**

- Clean Architecture compliance
- Zero linter errors, 100% API documentation

---

---

## 🔥 IMPLEMENTATION SUMMARY

**Stack**: Chopper + Either + Injectable + FlutterSecureStorage + Freezed

**Architecture**: Domain → Use Cases → Infrastructure → Presentation

**Code Generation**: Freezed for immutable classes, json_serializable for API models

**Error Handling**: Sealed classes with specific failure types

**Security**: JWT tokens in FlutterSecureStorage only (no crypto needed)

**Testing**: 95%+ coverage required

---

## 📚 REFERENCES

- **Clean Architecture**: Domain → Use Cases → Infrastructure → Presentation
- **Chopper**: HTTP client with code generation
- **fpdart**: Either monad for error handling
- **Freezed**: Immutable classes and sealed unions for Dart
- **json_serializable**: JSON serialization code generation
- **Flutter Secure Storage**: Encrypted JWT token storage
- **JWT**: Token decoding with dart:convert

---

_"Good programmers worry about data structures and their relationships. Everything else is implementation detail." - Linus Torvalds_
