# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Essential Commands

```bash
# Complete local CI pipeline (equivalent to GitHub Actions)
make local-ci

# Quick development checks
make check                    # Format + analyze
make format                   # Format code only
make analyze                  # Analyze code only
make test                     # Run tests
make deps                     # Install dependencies

# Test coverage workflow
make test-coverage           # Run tests with coverage
make coverage-html          # Generate HTML report
make coverage-report        # Complete workflow: test + HTML
make coverage-open          # Open coverage report in browser

# Environment-specific commands
dart run rps run-dev         # Development environment
dart run rps run-staging     # Staging environment
dart run rps run-prod        # Production environment

# Environment setup (required before first run)
dart run rps generate-env-dev      # Generate development config
dart run rps generate-env-staging  # Generate staging config
dart run rps generate-env-prod     # Generate production config
```

### Build Commands

```bash
# Multi-flavor builds
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor staging --target lib/main_staging.dart
flutter run --flavor production --target lib/main_production.dart

# Build variants
dart run rps build-dev       # Development build
dart run rps build-staging   # Staging build
dart run rps build-prod     # Production build
```

### Quality Assurance

```bash
# License compliance (business-safe only)
make license-check          # Strict business license validation
make license-report         # Detailed license analysis

# Naming conventions
make naming-check           # Validate naming conventions
make naming-fix             # Apply naming fixes

# Project setup
make setup                  # Complete project setup
```

## Code Architecture

### Multi-Environment System

This project implements a sophisticated environment management system using sealed classes and factory patterns:

- **Environment Detection**: Compile-time environment switching via `--dart-define=ENVIRONMENT=<env>`
- **Sealed Classes**: Type-safe environment configurations (`lib/features/env/infrastructure/env_config_factory.dart:12`)
- **Factory Pattern**: Centralized configuration access (`lib/features/env/infrastructure/env_config_factory.dart:127`)
- **Generated Configs**: Environment-specific `.env` files processed by `envied_generator`

### Key Architecture Components

#### Environment Configuration

- **Domain Layer**: `lib/features/env/domain/env_config_repository.dart` - Repository interface
- **Infrastructure**: `lib/features/env/infrastructure/env_config_factory.dart` - Factory implementation
- **Environments**: Separate files for dev/staging/production configurations
- **Bootstrap Integration**: Environment logging at app startup (`lib/bootstrap.dart:35-40`)

#### Application Structure

- **Bootstrap Pattern**: Centralized app initialization with error handling and BLoC observation (`lib/bootstrap.dart`)
- **Multi-Entry Points**: Separate main files for each environment (`lib/main_*.dart`)
- **Feature-Based Organization**: Code organized by feature domains under `lib/features/`

#### State Management

- **BLoC Pattern**: Using flutter_bloc for state management
- **Observer Pattern**: Global BLoC observation for debugging (`lib/bootstrap.dart:9-24`)

### Testing Strategy

- **Environment Testing**: Comprehensive tests for all three environments (`test/features/env/`)
- **Integration Tests**: Full environment workflow validation
- **Repository Pattern Testing**: Mock implementations for testability

## Code Standards & Quality

### Linting & Analysis

- **Very Good Analysis**: Strict 130+ lint rules enforced
- **Zero Tolerance**: No warnings or errors allowed in CI
- **Line Length**: 80 characters maximum (strictly enforced)
- **Documentation**: All public APIs must be documented (mandatory for CI)

### Critical Patterns

- **Const Constructors**: Required for performance (`prefer_const_constructors`)
- **Cascade Operators**: Mandatory for multiple method calls (`cascade_invocations`)
- **Sealed Classes**: Used for type-safe environment switching
- **Repository Pattern**: Clean architecture with domain/infrastructure separation

### Environment Usage Patterns

**Standard Access (90% of cases):**
```dart
final apiUrl = EnvConfigFactory.apiUrl;
final appName = EnvConfigFactory.appName;
final isDebug = EnvConfigFactory.isDebugMode;
```

**Environment-Specific Access:**
```dart
// For testing or cross-environment operations
final devConfig = const Development();
final stagingUrl = EnvConfigFactory.getApiUrlForEnvironment(const Staging());

// Bootstrap integration
void main() => bootstrap(() => App(environment: Environment.current));
```

## ⚡ Quick Command Reference

**Most Used Commands (Copy-Paste Ready):**

```bash
# Daily workflow
make check && make test                    # Start of session
dart run rps format && dart run rps analyze  # After each edit
dart run rps pre-commit                    # Before commit

# Environment switching
dart run rps generate-env-dev && dart run rps run-dev
dart run rps generate-env-staging && dart run rps run-staging
dart run rps generate-env-prod && dart run rps run-prod

# Emergency fixes
flutter clean && flutter pub get && dart run rps generate-env-dev
```

## Development Workflow

### Initial Setup

1. Run `make setup` for complete project initialization
2. Generate environment config: `dart run rps generate-env-dev`
3. Install dependencies: `make deps`
4. Verify setup: `make check`

### Environment Switching

Before running the app in a specific environment, generate the corresponding configuration:

```bash
# For development
dart run rps generate-env-dev && dart run rps run-dev

# For staging
dart run rps generate-env-staging && dart run rps run-staging

# For production
dart run rps generate-env-prod && dart run rps run-prod
```

### Pre-Commit Requirements

- **Format Check**: Code must be properly formatted
- **Analysis**: No warnings or errors from `dart analyze --fatal-infos`
- **License Validation**: Only business-safe licenses allowed (blocks GPL/copyleft)
- **Dependency Check**: No unused or missing dependencies

## Special Considerations

### License Compliance

This project enforces strict business-friendly license compliance:

- **Forbidden**: GPL, AGPL, LGPL, unknown licenses
- **Required**: MIT, BSD, Apache-2.0, ISC only
- **Validation**: Automatic blocking of problematic dependencies

### Build System

- **FVM**: Flutter version management (use `fvm` prefix for commands)
- **Very Good CLI**: Testing and coverage tooling
- **RPS Scripts**: Centralized script management via `rps.yaml`
- **Build Runner**: Code generation for environment configs

### Testing Requirements

- **Coverage**: Tests must maintain coverage standards
- **Environment Testing**: All environments must be tested
- **Integration Tests**: End-to-end environment workflow validation
- **Mock Testing**: Repository pattern enables comprehensive mocking

## 🚀 Mandatory Command Execution Protocol

**CRITICAL FOR CLAUDE CODE**: These commands MUST be executed during any coding session to prevent linting errors, warnings, and test failures. This is non-negotiable for code quality.

### 🎯 Before Making ANY Code Changes

**ALWAYS execute these commands first:**

```bash
# 1. Verify project health
make check                     # Format + analyze (2-3 seconds)
make test                      # Run all tests (10-15 seconds)

# Alternative using RPS
dart run rps check            # Format + analyze
dart run rps test             # Run tests
```

**Why**: Ensures you start with a clean baseline and don't introduce errors into already-broken code.

### 🔧 After Each Code Edit (MANDATORY)

**After EVERY code change, immediately run:**

```bash
# Quick validation loop (run after each file edit)
dart run rps format           # Auto-fix formatting (1-2 seconds)
dart run rps analyze          # Check for linting issues (2-3 seconds)

# If tests are affected, also run:
flutter test                  # Verify tests still pass (5-10 seconds)
```

**Integration with Code Changes:**

- Edit file → Save → Run `dart run rps format` → Run `dart run rps analyze`
- If tests affected → Run `flutter test`
- Fix any errors before continuing

### ✅ Before Final Response (NON-NEGOTIABLE)

**Before providing final code to user, MUST execute:**

```bash
# Complete validation pipeline
dart run rps pre-commit       # Format + analyze + test (full validation)

# Or step-by-step:
dart run rps format           # 1. Fix formatting
dart run rps analyze          # 2. Check linting
flutter test                  # 3. Verify tests pass
```

**If ANY command fails:**

- Fix the issues immediately
- Re-run the commands until all pass
- Only then provide the final response

### 🛡️ Error Prevention Strategy for Claude

#### **Level 1: Pre-Analysis Commands**

```bash
# Before analyzing user request
make check                    # Ensure current codebase is healthy
```

#### **Level 2: Continuous Validation**

```bash
# After each significant change
dart run rps format && dart run rps analyze
```

#### **Level 3: Final Validation**

```bash
# Before responding to user
dart run rps pre-commit       # Complete pipeline
```

### 🚨 Command Reference for Claude Code

| **When**            | **Commands**                                  | **Purpose**           | **Time** |
| ------------------- | --------------------------------------------- | --------------------- | -------- |
| **Start Session**   | `make check && make test`                     | Verify baseline       | 30s      |
| **After Each Edit** | `dart run rps format && dart run rps analyze` | Continuous validation | 5s       |
| **Before Response** | `dart run rps pre-commit`                     | Final validation      | 45s      |
| **Emergency**       | `dart run rps format` + `flutter test`        | Minimum viable        | 10s      |

### 🎨 Tool Usage Priority for Claude

#### **1. RPS Scripts (Primary - Use These)**

```bash
dart run rps format           # ⚡ Fastest formatting
dart run rps analyze          # ⚡ Quick analysis
dart run rps test             # ⚡ Test execution
dart run rps check            # ⚡ Format + analyze combo
dart run rps pre-commit       # 🏆 Complete validation
```

#### **2. Makefile (CI Equivalent)**

```bash
make check                    # Quick health check
make test                     # Test execution
make local-ci                 # Full CI pipeline (when needed)
make test-coverage           # Coverage analysis
```

#### **3. Direct Commands (When Tools Fail)**

```bash
dart format lib/ test/ --set-exit-if-changed
dart analyze --fatal-infos
flutter test
very_good test --coverage
```

### ⚡ Emergency Protocols

#### **When Linting Fails:**

```bash
1. dart run rps format          # Fix formatting first
2. dart analyze --fatal-infos   # See specific errors
3. Fix errors manually
4. dart run rps analyze         # Verify fixes
```

#### **When Tests Fail:**

```bash
1. flutter clean && flutter pub get    # Reset environment
2. dart run rps generate-env-dev       # Regenerate configs
3. flutter test --dart-define=ENVIRONMENT=development
4. Fix failing tests
5. flutter test                        # Verify all pass
```

#### **When Environment Issues:**

```bash
1. dart run rps generate-env-dev       # Regenerate development
2. flutter pub get                     # Refresh dependencies
3. make check                          # Verify health
4. make test                           # Verify tests
```

### 🎯 Claude Code Success Checklist

**Before providing ANY code response:**

- [ ] ✅ `dart run rps format` - No formatting issues
- [ ] ✅ `dart run rps analyze` - No linting errors/warnings
- [ ] ✅ `flutter test` - All tests pass
- [ ] ✅ Code follows project patterns
- [ ] ✅ Documentation is complete (if public APIs)
- [ ] ✅ Environment-specific testing done (if needed)

**Zero Tolerance Items:**

- ❌ No linting errors or warnings
- ❌ No test failures
- ❌ No formatting inconsistencies
- ❌ No missing documentation on public APIs
- ❌ No license compliance violations

### 📋 Claude Code Workflow Template

```bash
# 1. Start of coding session
make check && make test

# 2. For each code change iteration:
# Edit code → Save → Execute:
dart run rps format
dart run rps analyze
# Fix any issues → Repeat until clean

# 3. If tests affected:
flutter test
# Fix any failing tests

# 4. Before final response:
dart run rps pre-commit
# Must pass before providing code to user

# 5. For complex changes:
make test-coverage          # Verify coverage maintained
```

### 🔥 High-Speed Development Protocol

**For rapid iteration while maintaining quality:**

```bash
# Continuous validation loop (use during active coding)
dart run rps format && dart run rps analyze

# Parallel execution for speed
dart run rps format & dart run rps analyze & wait

# Quick test verification
flutter test --dart-define=ENVIRONMENT=development

# Final checkpoint
dart run rps pre-commit
```

### 🏆 Advanced Claude Workflows

#### **Multi-Environment Validation:**

```bash
# When environment changes are involved
dart run rps generate-env-dev && dart run rps test
dart run rps generate-env-staging && dart run rps test
dart run rps generate-env-prod && dart run rps test
```

#### **Coverage-Focused Development:**

```bash
# When adding new features
make test-coverage          # Generate coverage report
make coverage-open          # Review coverage gaps
# Add tests for uncovered code
make test-coverage          # Verify improved coverage
```

#### **Performance Validation:**

```bash
# For performance-critical changes
flutter test --coverage --dart-define=ENVIRONMENT=development
make test-coverage
# Review performance impact in coverage report
```

## 🎖️ Claude Code Quality Standards

### **Command Execution Discipline:**

- **NEVER** provide code without running validation commands
- **ALWAYS** fix linting errors before responding
- **IMMEDIATELY** run tests after changing test-related code
- **CONTINUOUSLY** format and analyze during development

### **Response Standards:**

- Every code response must be preceded by successful command execution
- Any failing commands must be addressed and resolved
- Coverage should be maintained or improved
- All environments must be considered for environment-related changes

**Remember**: These commands are your quality assurance system. They prevent 95% of common issues and ensure professional-grade code delivery. Make them automatic and non-negotiable!

## 🌐 Language Requirements - English Only Policy

### 📝 **MANDATORY: English Language for All Content**

**CRITICAL RULE**: All code, documentation, comments, and markdown files MUST be written in English only. This is non-negotiable for:

1. **Spell Check Compliance**: Prevents cspell errors in CI/CD
2. **International Collaboration**: Ensures global accessibility
3. **Professional Standards**: Maintains consistent codebase language
4. **Tool Compatibility**: Works with all development tools and IDEs

### 🚫 **What Must Be English**

#### **Code Content**
```dart
// ❌ WRONG: Vietnamese comments
/// Quản lý trạng thái counter với increment và decrement
class CounterCubit extends Cubit<int> {
  /// Tạo một CounterCubit với giá trị ban đầu là 0
  CounterCubit() : super(0);
  
  /// Tăng giá trị counter lên 1
  void increment() => emit(state + 1); // Tăng số lên
}

// ✅ CORRECT: English comments and documentation
/// Manages counter state with increment and decrement operations.
class CounterCubit extends Cubit<int> {
  /// Creates a CounterCubit with initial state of 0.
  CounterCubit() : super(0);
  
  /// Increments the counter value by 1.
  void increment() => emit(state + 1); // Increment the value
}
```

#### **Documentation Files**
```markdown
❌ WRONG: Vietnamese markdown content
# Cấu Hình Environment với Envied
## Tổng Quan
Hệ thống quản lý multiple environments...

✅ CORRECT: English markdown content
# Environment Configuration with Envied
## Overview
Multiple environment management system...
```

#### **Comments and Strings**
```dart
// ❌ WRONG: Vietnamese strings and comments
const appTitle = 'Ứng Dụng Đếm Số'; // Tiêu đề ứng dụng
// TODO: Thêm tính năng reset counter

// ✅ CORRECT: English strings and comments
const appTitle = 'Counter Application'; // Application title
// TODO: Add counter reset feature
```

### ✅ **English Language Checklist**

Before any commit, verify:

- [ ] **All documentation** (README, guides, etc.) is in English
- [ ] **All code comments** are in English
- [ ] **All string literals** for UI are either in English or use i18n keys
- [ ] **All commit messages** follow conventional commits in English
- [ ] **All variable/method names** use English terminology
- [ ] **All test descriptions** are in English

### 🛠️ **Spell Check Integration**

Our cspell configuration enforces English-only content:

```json
{
  "language": "en",
  "dictionaries": ["vgv_allowed", "vgv_forbidden"]
}
```

**When spell check fails:**
1. Convert non-English content to English
2. Add technical terms to `cspell.json` words array if needed
3. Never suppress spell check with ignore comments

### 🎯 **Vibe Coding English Protocol**

#### **During Active Coding:**

```bash
# After creating any markdown or documentation
npx cspell doc/**/*.md --no-progress    # Verify English content

# After adding comments or strings
dart run rps analyze                    # Check for linting issues
```

#### **Content Creation Guidelines:**

1. **Documentation Files**: Always write in clear, professional English
2. **Code Comments**: Use concise English explanations
3. **Variable Names**: Follow English naming conventions
4. **Error Messages**: Use English for user-facing messages
5. **Test Descriptions**: Write test cases in English

#### **Common Translation Patterns:**

| Vietnamese | English | Usage |
|------------|---------|--------|
| `Tổng quan` | `Overview` | Documentation sections |
| `Cấu hình` | `Configuration` | Settings and setup |
| `Kiến trúc` | `Architecture` | System design |
| `Sử dụng` | `Usage` | How-to guides |
| `Khắc phục sự cố` | `Troubleshooting` | Error resolution |

### 🚨 **Pre-Commit English Validation**

Add to your workflow:

```bash
# Validate English content before commit
npx cspell doc/**/*.md README.md --no-progress
dart run rps analyze  # Includes comment validation
dart run rps format   # Ensures consistent formatting

# Full validation
dart run rps pre-commit  # Must pass for English compliance
```

### 📚 **English Documentation Standards**

#### **Markdown Files:**
- Use clear, professional English
- Follow standard technical writing conventions
- Prefer active voice over passive voice
- Use consistent terminology throughout

#### **Code Documentation:**
- Use complete sentences for class/method documentation
- Follow Dart documentation standards with `///`
- Include parameter descriptions with `[paramName]` syntax
- Provide usage examples in English

#### **Error Messages:**
```dart
// ❌ WRONG: Mixed languages
throw Exception('Lỗi khi load config');

// ✅ CORRECT: English error messages
throw ConfigurationException('Failed to load configuration');
```

### 🔧 **Tools for English Compliance**

#### **Editor Integration:**
- VS Code: Install "Code Spell Checker" extension
- Set language to English in editor settings
- Enable real-time spell checking

#### **Git Hooks:**
- Pre-commit hooks run spell check automatically
- Blocks commits with non-English content
- Provides immediate feedback on language issues

#### **CI/CD Integration:**
- GitHub Actions runs spell check on all markdown files
- Fails build if non-English content is detected
- Generates reports of language compliance issues

### 💡 **Best Practices Summary**

1. **Always Default to English**: When in doubt, use English
2. **Consistent Terminology**: Use the same English terms throughout the project
3. **Professional Tone**: Write documentation as if for international users
4. **Tool Integration**: Leverage spell check and linting tools
5. **Review Process**: Check English compliance during code reviews

This English-only policy ensures our codebase remains accessible, professional, and compatible with all development tools and international collaboration standards.
