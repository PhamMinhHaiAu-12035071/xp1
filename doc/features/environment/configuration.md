# Environment Configuration với Envied

## 📋 Tổng Quan

Hệ thống quản lý multiple environments sử dụng [envied package](https://pub.dev/packages/envied) cho việc bảo mật và quản lý environment variables.

## 🏗️ Kiến Trúc

### Clean Architecture Pattern

```
lib/features/env/
├── domain/
│   └── env_config_repository.dart      # Interface
├── infrastructure/
│   ├── env_config_factory.dart         # Factory pattern
│   └── env_config_repository_impl.dart # Implementation
├── env_development.dart                # Development env class
├── env_staging.dart                    # Staging env class
├── env_production.dart                 # Production env class
├── development.env                     # Dev config (gitignored)
├── staging.env                         # Staging config (gitignored)
└── production.env                      # Prod config (gitignored)
```

## 🚀 Usage

### 1. Code Generation

Trước khi chạy app, cần generate environment code:

```bash
# Development environment
dart run rps generate-env-dev

# Staging environment
dart run rps generate-env-staging

# Production environment
dart run rps generate-env-prod
```

### 2. Running App với Environment

```bash
# Development
dart run rps run-dev

# Staging
dart run rps run-staging

# Production
dart run rps run-prod
```

### 3. Building với Environment

```bash
# Development build
dart run rps build-dev

# Staging build
dart run rps build-staging

# Production build
dart run rps build-prod
```

## ⚙️ Environment Variables

Mỗi environment file chứa:

```env
API_URL=https://api-url.com/api/v1
APP_NAME=App Name
ENVIRONMENT_NAME=environment
IS_DEBUG_MODE=true/false
API_TIMEOUT_MS=30000
```

## 🔧 Development Workflow

### 1. Thêm Environment Variable Mới

1. **Cập nhật Repository Interface:**

```dart
// lib/features/env/domain/env_config_repository.dart
abstract class EnvConfigRepository {
  String get newVariable;
}
```

2. **Cập nhật Environment Files:**

```env
# development.env, staging.env, production.env
NEW_VARIABLE=value
```

3. **Cập nhật Environment Classes:**

```dart
// env_development.dart, env_staging.dart, env_production.dart
@EnviedField(varName: 'NEW_VARIABLE')
static String newVariable = _EnvDev.newVariable;
```

4. **Cập nhật Factory:**

```dart
// env_config_factory.dart
static String get newVariable => getNewVariableForEnvironment(_currentEnvironment);

static String getNewVariableForEnvironment(EnvironmentType environment) {
  switch (environment) {
    case EnvironmentType.production:
      return EnvProd.newVariable;
    case EnvironmentType.staging:
      return EnvStaging.newVariable;
    case EnvironmentType.development:
      return EnvDev.newVariable;
  }
}
```

5. **Cập nhật Repository Implementation:**

```dart
// env_config_repository_impl.dart
@override
String get newVariable => EnvConfigFactory.newVariable;
```

6. **Generate lại code:**

```bash
dart run rps generate-env-dev
```

### 2. Testing Environment Configuration

```bash
# Run tests
flutter test test/features/env/

# Run specific test
flutter test test/features/env/infrastructure/env_config_factory_test.dart
```

## 🔒 Security Best Practices

### ✅ Đã Implement:

- **.env files đã được gitignore** để tránh expose secrets
- **Generated files (.g.dart) đã được gitignore**
- **Clean Architecture** tách biệt domain logic và infrastructure
- **Factory pattern** cho runtime environment selection
- **Type-safe access** thông qua repository interface

### ⚠️ Lưu Ý Quan Trọng:

1. **KHÔNG BAO GIỜ** commit file `.env` vào Git
2. **KHÔNG BAO GIỜ** commit file `.g.dart` vào Git
3. **LUÔN LUÔN** sử dụng repository interface, không truy cập trực tiếp env classes
4. Trong production, xem xét sử dụng `obfuscate: true` cho sensitive data

## 🛠️ CLI Commands Reference

### Environment Generation:

```bash
dart run rps generate-env-dev      # Generate development env
dart run rps generate-env-staging  # Generate staging env
dart run rps generate-env-prod     # Generate production env
```

### Running:

```bash
dart run rps run-dev      # Run development
dart run rps run-staging  # Run staging
dart run rps run-prod     # Run production
```

### Building:

```bash
dart run rps build-dev      # Build development
dart run rps build-staging  # Build staging
dart run rps build-prod     # Build production
```

### Manual Commands (nếu cần):

```bash
# Generate với specific env file
dart run build_runner build --define=envied_generator:envied=path=lib/features/env/development.env --delete-conflicting-outputs

# Run với environment flag
flutter run --dart-define=ENVIRONMENT=development --target=lib/main_development.dart
```

## 🧪 Testing

Environment configuration được test comprehensive:

- **Unit tests** cho factory pattern
- **Integration tests** cho repository implementation
- **Environment-specific** behavior testing

```bash
# Run tất cả environment tests
flutter test test/features/env/

# Test coverage
flutter test --coverage test/features/env/
```

## 📈 Monitoring & Debugging

Bootstrap code sẽ log environment info khi start:

```
🚀 Starting app with environment: development
📍 API URL: https://dev-api.xp1.com/api/v1
🔧 Debug mode: true
```

## 🔄 CI/CD Integration

Trong CI/CD pipeline, sử dụng:

```yaml
# GitHub Actions example
- name: Build Development
  run: |
    dart run rps generate-env-dev
    dart run rps build-dev

- name: Build Production
  run: |
    dart run rps generate-env-prod
    dart run rps build-prod
```

## 🆘 Troubleshooting

### Issue: Build Runner Conflicts

```bash
dart run build_runner clean
dart run rps generate-env-dev
```

### Issue: Environment Not Switching

1. Kiểm tra `--dart-define=ENVIRONMENT=xxx` flag
2. Verify environment factory logic
3. Check bootstrap logs cho environment info

### Issue: Missing Environment Variables

1. Verify file `.env` tồn tại
2. Check file path trong `@Envied(path: '...')` annotation
3. Run code generation lại
