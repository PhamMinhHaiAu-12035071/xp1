# Environment Configuration with Envied

## 📋 Overview

Multiple environments management system using [envied package](https://pub.dev/packages/envied) for secure management of environment variables.

## 🏗️ Architecture

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

Before running the app, you need to generate environment code:

```bash
# Development environment
dart run rps generate-env-dev

# Staging environment
dart run rps generate-env-staging

# Production environment
dart run rps generate-env-prod
```

### 2. Running App with Environment

```bash
# Development
dart run rps run-dev

# Staging
dart run rps run-staging

# Production
dart run rps run-prod
```

### 3. Building with Environment

```bash
# Development build
dart run rps build-dev

# Staging build
dart run rps build-staging

# Production build
dart run rps build-prod
```

## ⚙️ Environment Variables

Each environment file contains:

```env
API_URL=https://api-url.com/api/v1
APP_NAME=App Name
ENVIRONMENT_NAME=environment
IS_DEBUG_MODE=true/false
API_TIMEOUT_MS=30000
```

## 🔧 Development Workflow

### 1. Adding New Environment Variables

1. **Update Repository Interface:**

```dart
// lib/features/env/domain/env_config_repository.dart
abstract class EnvConfigRepository {
  String get newVariable;
}
```

2. **Update Environment Files:**

```env
# development.env, staging.env, production.env
NEW_VARIABLE=value
```

3. **Update Environment Classes:**

```dart
// env_development.dart, env_staging.dart, env_production.dart
@EnviedField(varName: 'NEW_VARIABLE')
static String newVariable = _EnvDev.newVariable;
```

4. **Update Factory:**

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

5. **Update Repository Implementation:**

```dart
// env_config_repository_impl.dart
@override
String get newVariable => EnvConfigFactory.newVariable;
```

6. **Regenerate code:**

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

### ✅ Already Implemented:

- **.env files are gitignored** to avoid exposing secrets
- **Generated files (.g.dart) are gitignored**
- **Clean Architecture** separates domain logic and infrastructure
- **Factory pattern** for runtime environment selection
- **Type-safe access** through repository interface

### ⚠️ Important Notes:

1. **NEVER** commit `.env` files to Git
2. **NEVER** commit `.g.dart` files to Git
3. **ALWAYS** use repository interface, do not access env classes directly
4. In production, consider using `obfuscate: true` for sensitive data

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

### Manual Commands (if needed):

```bash
# Generate with specific env file
dart run build_runner build --define=envied_generator:envied=path=lib/features/env/development.env --delete-conflicting-outputs

# Run with environment flag
flutter run --dart-define=ENVIRONMENT=development --target=lib/main_development.dart
```

## 🧪 Testing

Environment configuration is comprehensively tested:

- **Unit tests** for factory pattern
- **Integration tests** for repository implementation
- **Environment-specific** behavior testing

```bash
# Run all environment tests
flutter test test/features/env/

# Test coverage
flutter test --coverage test/features/env/
```

## 📈 Monitoring & Debugging

Bootstrap code will log environment info at startup:

```
🚀 Starting app with environment: development
📍 API URL: https://dev-api.xp1.com/api/v1
🔧 Debug mode: true
```

## 🔄 CI/CD Integration

In CI/CD pipeline, use:

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

1. Check `--dart-define=ENVIRONMENT=xxx` flag
2. Verify environment factory logic
3. Check bootstrap logs for environment info

### Issue: Missing Environment Variables

1. Verify that `.env` file exists
2. Check file path in `@Envied(path: '...')` annotation
3. Run code generation again
