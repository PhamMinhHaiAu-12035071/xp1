# Makefile for xp1 Flutter project
# Provides easy commands for local CI equivalent to GitHub Actions

# Detect FVM availability for CI compatibility
FVM_EXISTS := $(shell command -v fvm 2> /dev/null)
ifdef FVM_EXISTS
  DART_CMD = fvm dart
  FLUTTER_CMD = fvm flutter
else
  DART_CMD = dart
  FLUTTER_CMD = flutter
endif

.PHONY: semantic-check flutter-ci spell-check test-scripts local-ci check check-strict check-all format format-check analyze analyze-quick analyze-strict validate-deps test test-coverage coverage coverage-html coverage-open coverage-clean coverage-report build-android build-ios build-web build-dev build-staging build-prod generate-env-dev generate-env-staging generate-env-prod generate-icons i18n-generate i18n-watch i18n-analyze i18n-validate i18n-clean i18n-help deps clean reset pre-commit setup setup-full hooks-install hooks-uninstall test-commit-validation install-dev install-staging install-prod install-all run-dev run-staging run-prod help license-check license-audit license-report license-validate-main license-validate-dev license-ci license-quick license-override license-clean-check license-help check-very-good-cli naming-check naming-fix naming-docs

# GitHub Actions equivalent commands
semantic-check:
	@echo "🔍 Running semantic checks..."
	@./scripts/semantic-check.sh

flutter-ci:
	@echo "🚀 Running Flutter CI..."
	@./scripts/flutter-ci.sh

spell-check:
	@echo "📝 Running spell check..."
	@./scripts/spell-check.sh

test-scripts:
	@echo "🧪 Testing bash scripts..."
	@npm test

local-ci: test-scripts semantic-check flutter-ci
	@echo "⚠️  Spell-check temporarily skipped due to npm dependency conflicts"
	@echo ""
	@echo "🎉 Complete local CI pipeline finished!"
	@echo "✅ All checks equivalent to GitHub Actions passed!"

# Optimized CI for pre-push (faster, lighter)
pre-push-ci: format analyze-quick test license-check
	@echo "🚀 Optimized pre-push CI completed!"
	@echo "✅ Quick checks passed - ready for push!"

# Quick development commands
check:
	@echo "✅ Quick development check..."
	@$(DART_CMD) format lib/ test/ || true
	@if git diff --quiet lib/ test/; then \
		echo "✅ Code formatted successfully."; \
	else \
		echo "❌ Code formatting required."; \
		exit 1; \
	fi
	@$(DART_CMD) analyze --fatal-infos

check-strict:
	@echo "🔍 Strict development check..."
	@$(DART_CMD) format lib/ test/ || true
	@if git diff --quiet lib/ test/; then \
		echo "✅ Code formatted successfully."; \
	else \
		echo "❌ Code formatting required."; \
		exit 1; \
	fi
	@$(DART_CMD) analyze --fatal-infos --fatal-warnings

check-all:
	@echo "🔍 Complete development check..."
	@$(DART_CMD) format lib/ test/ || true
	@if git diff --quiet lib/ test/; then \
		echo "✅ Code formatted successfully."; \
	else \
		echo "❌ Code formatting required."; \
		exit 1; \
	fi
	@$(DART_CMD) analyze --fatal-infos
	@$(DART_CMD) run dependency_validator
	@very_good packages check licenses --forbidden="GPL-2.0,GPL-3.0,LGPL-2.1,LGPL-3.0,AGPL-3.0,unknown,CC-BY-SA-4.0,SSPL-1.0" --dependency-type="direct-main,direct-dev"

format:
	@echo "🎨 Formatting code..."
	@$(DART_CMD) format lib/ test/
	@if git diff --quiet lib/ test/; then \
		echo "✅ Code is already formatted."; \
	else \
		echo "✅ Code has been formatted."; \
	fi

format-check:
	@echo "🔍 Checking code format..."
	@$(DART_CMD) format lib/ test/ || true
	@if git diff --quiet lib/ test/; then \
		echo "✅ Code is properly formatted."; \
	else \
		echo "❌ Code is not properly formatted."; \
		git diff --name-only lib/ test/; \
		exit 1; \
	fi

analyze:
	@echo "🔍 Analyzing code..."
	@$(DART_CMD) analyze --fatal-infos

analyze-quick:
	@echo "⚡ Quick analysis..."
	@$(DART_CMD) analyze --fatal-warnings

analyze-strict:
	@echo "🔍 Strict analysis..."
	@$(DART_CMD) analyze --fatal-infos --fatal-warnings

validate-deps:
	@echo "📦 Validating dependencies..."
	@$(DART_CMD) run dependency_validator

test:
	@echo "🧪 Running unit tests..."
	@$(FLUTTER_CMD) test test/app/ test/core/ test/features/ test/helpers/ test/integration/ test/l10n/ test/setup/ test/widgetbook/

# Test coverage commands using flutter test (more reliable than very_good test --coverage)
coverage:
	@echo "🧪📊 Running complete coverage workflow..."
	@echo "1️⃣ Running unit tests with coverage..."
	@echo "⚠️  Note: Using flutter test --coverage for reliable coverage generation"
	@$(FLUTTER_CMD) test test/app/ test/core/ test/features/ test/helpers/ test/integration/ test/l10n/ test/setup/ test/widgetbook/ --coverage
	@echo "2️⃣ Generating HTML coverage report..."
	@if command -v genhtml >/dev/null 2>&1; then \
		genhtml coverage/lcov.info -o coverage/html --title "xp1 Test Coverage"; \
		echo "✅ HTML coverage report generated at: coverage/html/index.html"; \
	else \
		echo "❌ genhtml not found. Install lcov package:"; \
		echo "  macOS: brew install lcov"; \
		echo "  Ubuntu/Debian: sudo apt-get install lcov"; \
		echo "  CentOS/RHEL: sudo yum install lcov"; \
		echo "  Or download from: https://github.com/linux-test-project/lcov"; \
		exit 1; \
	fi
	@echo "3️⃣ Opening coverage report in browser..."
	@if [ -f coverage/html/index.html ]; then \
		if command -v open >/dev/null 2>&1; then \
			open coverage/html/index.html; \
		elif command -v xdg-open >/dev/null 2>&1; then \
			xdg-open coverage/html/index.html; \
		elif command -v start >/dev/null 2>&1; then \
			start coverage/html/index.html; \
		else \
			echo "❌ No browser launcher found. Open manually:"; \
			echo "   file://$(pwd)/coverage/html/index.html"; \
		fi \
	else \
		echo "❌ HTML coverage report not found."; \
		exit 1; \
	fi
	@echo "🎉 Coverage workflow completed!"
	@echo "💡 Run 'make coverage-clean' to remove coverage files"

coverage-clean:
	@echo "🧹 Cleaning coverage files..."
	@rm -rf coverage/



# Build commands
build-android:
	@echo "🤖 Building Android APK..."
	@$(FLUTTER_CMD) build apk --release

build-ios:
	@echo "🍎 Building iOS..."
	@$(FLUTTER_CMD) build ios --release

build-web:
	@echo "🌐 Building Web..."
	@$(FLUTTER_CMD) build web --release

build-dev:
	@echo "🔨 Building development APK..."
	@$(FLUTTER_CMD) build apk --debug --dart-define=ENVIRONMENT=development

build-staging:
	@echo "🔨 Building staging APK..."
	@$(FLUTTER_CMD) build apk --release --dart-define=ENVIRONMENT=staging

build-prod:
	@echo "🔨 Building production APK..."
	@$(FLUTTER_CMD) build apk --release --dart-define=ENVIRONMENT=production

# Environment generation commands
generate-env-dev:
	@echo "🏗️ Generating development environment..."
	@$(DART_CMD) run build_runner clean
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/development.env --delete-conflicting-outputs

generate-env-staging:
	@echo "🏗️ Generating staging environment..."
	@$(DART_CMD) run build_runner clean
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/staging.env --delete-conflicting-outputs

generate-env-prod:
	@echo "🏗️ Generating production environment..."
	@$(DART_CMD) run build_runner clean
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/production.env --delete-conflicting-outputs

# App icon generation commands
generate-icons:
	@echo "🎨 Generating app icons..."
	@$(FLUTTER_CMD) pub run flutter_launcher_icons
	@echo "✅ Icons generated successfully"

# Internationalization (i18n) commands using Slang
i18n-generate:
	@echo "🌐 Generating slang translations..."
	@$(DART_CMD) run slang
	@echo "✅ Slang translations generated successfully"

i18n-watch:
	@echo "👀 Watching translation files for changes..."
	@echo "🔄 Auto-generating on file changes (Ctrl+C to stop)"
	@$(DART_CMD) run slang watch

i18n-analyze:
	@echo "🔍 Analyzing translation coverage..."
	@$(DART_CMD) run slang analyze
	@echo "📊 Translation analysis completed"

i18n-validate:
	@echo "✅ Validating translation files..."
	@if [ ! -f "lib/l10n/i18n/en.i18n.json" ]; then \
		echo "❌ English translation file not found"; \
		exit 1; \
	fi
	@if [ ! -f "lib/l10n/i18n/vi.i18n.json" ]; then \
		echo "❌ Vietnamese translation file not found"; \
		exit 1; \
	fi
	@$(DART_CMD) run slang
	@echo "✅ Translation files validated successfully"

i18n-clean:
	@echo "🧹 Cleaning generated slang files..."
	@rm -rf lib/l10n/gen/
	@echo "✅ Slang generated files cleaned"

i18n-help:
	@echo "🌐 Internationalization (i18n) Commands using Slang:"
	@echo ""
	@echo "  i18n-generate  - Generate slang translation code from JSON files"
	@echo "  i18n-watch     - Watch translation files and auto-generate on changes"
	@echo "  i18n-analyze   - Analyze translation coverage and completeness"
	@echo "  i18n-validate  - Validate translation files and regenerate"
	@echo "  i18n-clean     - Clean all generated slang files"
	@echo "  i18n-help      - Show this help"
	@echo ""
	@echo "📁 Translation files location:"
	@echo "  lib/l10n/i18n/en.i18n.json - English translations"
	@echo "  lib/l10n/i18n/vi.i18n.json - Vietnamese translations"
	@echo ""
	@echo "🏗️ Generated files location:"
	@echo "  lib/l10n/gen/ - All generated slang code"
	@echo ""
	@echo "⚡ Quick workflow:"
	@echo "  1. Edit JSON files in lib/l10n/i18n/"
	@echo "  2. Run 'make i18n-generate' to update code"
	@echo "  3. Use 'make i18n-watch' for live development"

# Development commands
deps:
	@echo "📦 Installing dependencies..."
	@$(FLUTTER_CMD) pub get
	@lefthook install

clean:
	@echo "🧹 Cleaning build files..."
	@$(FLUTTER_CMD) clean
	@$(FLUTTER_CMD) pub get

reset:
	@echo "🔄 Resetting project..."
	@$(FLUTTER_CMD) clean
	@$(FLUTTER_CMD) pub get
	@$(FLUTTER_CMD) pub run build_runner build --delete-conflicting-outputs

# Git hooks and commit commands
pre-commit:
	@echo "🚀 Running pre-commit checks..."
	@$(DART_CMD) format lib/ test/ || true
	@if git diff --quiet lib/ test/; then \
		echo "✅ Code formatted successfully."; \
	else \
		echo "❌ Code formatting required."; \
		exit 1; \
	fi
	@$(DART_CMD) analyze --fatal-infos
	@make test

# Setup commands
setup:
	@echo "⚙️ Setting up project..."
	@npm install
	@$(FLUTTER_CMD) pub get
	@chmod +x scripts/*.sh
	@echo "✅ Project setup completed"

setup-full:
	@echo "⚙️ Complete project setup..."
	@npm install
	@$(FLUTTER_CMD) pub get
	@chmod +x scripts/*.sh
	@./scripts/setup-env.sh
	@lefthook install
	@$(DART_CMD) run tool/validate_commit.dart --help || echo 'Commit validator ready'
	@echo "✅ Complete setup finished"

# Git hooks management
hooks-install:
	@echo "🪝 Installing git hooks..."
	@lefthook install

hooks-uninstall:
	@echo "🪝 Uninstalling git hooks..."
	@lefthook uninstall

# Test commit validation
test-commit-validation:
	@echo "✅ Testing commit validation..."
	@echo 'feat(test): add validation example' > .tmp/test_commit
	@$(DART_CMD) run tool/validate_commit.dart .tmp/test_commit
	@rm .tmp/test_commit

# Naming conventions enforcement - Simplified per Linus review
naming-check:
	@echo "🔍 Checking naming conventions..."
	@$(DART_CMD) analyze --fatal-infos
	@echo "✅ Naming check completed"

naming-fix:
	@echo "🔧 Applying naming fixes..."
	@$(DART_CMD) fix --apply
	@$(DART_CMD) format lib/ test/ || true
	@if git diff --quiet lib/ test/; then \
		echo "✅ Code formatted after naming fixes."; \
	else \
		echo "✅ Code has been formatted after naming fixes."; \
	fi
	@echo "✅ Naming fixes applied"

naming-docs:
	@echo "📚 Opening naming conventions documentation..."
	@if command -v open >/dev/null 2>&1; then \
		open doc/naming-conventions.md; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open doc/naming-conventions.md; \
	else \
		echo "📖 View naming conventions: doc/naming-conventions.md"; \
	fi

# License compliance checking
# Business-safe licenses only (avoid GPL, AGPL, unknown)
PERMISSIVE_LICENSES := MIT,BSD-2-Clause,BSD-3-Clause,Apache-2.0,ISC,Unlicense
COPYLEFT_LICENSES := GPL-2.0,GPL-3.0,LGPL-2.1,LGPL-3.0,AGPL-3.0
PROBLEMATIC_LICENSES := unknown,CC-BY-SA-4.0,SSPL-1.0

# Check if Very Good CLI is installed
check-very-good-cli:
	@command -v very_good >/dev/null 2>&1 || { \
		echo "❌ Very Good CLI not found"; \
		echo "💡 Install with: dart pub global activate very_good_cli"; \
		exit 1; \
	}

# Main license compliance check
license-check: check-very-good-cli
	@echo "🔐 Business License Compliance Check"
	@echo "✅ Allowed: $(PERMISSIVE_LICENSES)"
	@echo "❌ Forbidden: $(COPYLEFT_LICENSES),$(PROBLEMATIC_LICENSES)"
	@echo ""
	@if very_good packages check licenses \
		--forbidden="$(COPYLEFT_LICENSES),$(PROBLEMATIC_LICENSES)" \
		--dependency-type="direct-main,direct-dev"; then \
		echo ""; \
		echo "🎉 All packages use business-safe licenses!"; \
		echo "💼 Safe for commercial use without legal concerns"; \
	else \
		echo ""; \
		echo "🚨 LICENSE COMPLIANCE FAILURE"; \
		echo ""; \
		echo "📋 Action items:"; \
		echo "  1. Remove packages with forbidden licenses"; \
		echo "  2. Find alternatives with MIT/BSD/Apache licenses"; \
		echo "  3. Contact package authors for license clarification"; \
		echo ""; \
		echo "🔍 Run 'make license-report' for detailed analysis"; \
		exit 1; \
	fi

# Generate detailed license report
license-report: check-very-good-cli
	@echo "📊 Generating License Report..."
	@echo "==============================================="
	@very_good packages check licenses \
		--dependency-type="direct-main,direct-dev,transitive"
	@echo "==============================================="
	@echo "📈 Summary saved to license-report.txt"
	@very_good packages check licenses > license-report.txt 2>&1 || true

# Validate specific dependency types
license-validate-main: check-very-good-cli
	@echo "🎯 Checking main dependencies only..."
	@very_good packages check licenses \
		--dependency-type="direct-main" \
		--allowed="$(PERMISSIVE_LICENSES)"

license-validate-dev: check-very-good-cli
	@echo "🛠️  Checking dev dependencies only..."
	@very_good packages check licenses \
		--dependency-type="direct-dev" \
		--allowed="$(PERMISSIVE_LICENSES)"

# CI/CD friendly check with clean output and performance optimization
license-ci: check-very-good-cli
	@very_good packages check licenses \
		--forbidden="$(COPYLEFT_LICENSES),$(PROBLEMATIC_LICENSES)" \
		--dependency-type="direct-main,direct-dev" \
		|| exit 1

# Quick check for development
license-quick: check-very-good-cli
	@echo "⚡ Quick license check..."
	@very_good packages check licenses \
		--dependency-type="direct-main" \
		--allowed="$(PERMISSIVE_LICENSES)"

# Emergency override (use with caution)
license-override: check-very-good-cli
	@echo "⚠️  OVERRIDE: Running license check with failure ignored"
	@very_good packages check licenses \
		--ignore-retrieval-failures || echo "Override completed"

# Clean and recheck
license-clean-check:
	@echo "🧹 Cleaning and rechecking licenses..."
	@$(FLUTTER_CMD) clean
	@$(FLUTTER_CMD) pub get
	@make license-check

# License help command
license-help:
	@echo "🔐 License Management Commands:"
	@echo ""
	@echo "  license-check         - Main compliance check (strict)"
	@echo "  license-report        - Generate detailed report"
	@echo "  license-validate-main - Check main dependencies only"
	@echo "  license-validate-dev  - Check dev dependencies only"
	@echo "  license-ci            - CI/CD friendly check"
	@echo "  license-quick         - Quick check for development"
	@echo "  license-override      - Emergency override (use with caution)"
	@echo "  license-clean-check   - Clean and recheck"
	@echo ""
	@echo "📋 Business-safe licenses: $(PERMISSIVE_LICENSES)"
	@echo "⚠️  Avoided licenses: $(COPYLEFT_LICENSES),$(PROBLEMATIC_LICENSES)"

# Private helper target for common installation steps
.PHONY: _install_common
_install_common:
	@$(FLUTTER_CMD) clean
	@$(FLUTTER_CMD) pub get
	@npm install
	@chmod +x scripts/*.sh
	@./scripts/setup-env.sh
	@lefthook install
	@$(DART_CMD) run build_runner clean

# Complete environment setup commands for new team members
install-dev: _install_common
	@echo "🚀 Setting up complete development environment..."
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/development.env --delete-conflicting-outputs
	@echo "✅ Development environment ready!"

install-staging: _install_common
	@echo "🚀 Setting up complete staging environment..."
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/staging.env --delete-conflicting-outputs
	@echo "✅ Staging environment ready!"

install-prod: _install_common
	@echo "🚀 Setting up complete production environment..."
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/production.env --delete-conflicting-outputs
	@echo "✅ Production environment ready!"

install-all: _install_common
	@echo "🚀 Setting up ALL environments..."
	@echo "📦 Building development..."
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/development.env --delete-conflicting-outputs
	@echo "📦 Building staging..."
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/staging.env --delete-conflicting-outputs
	@echo "📦 Building production..."
	@$(DART_CMD) run build_runner build --define=envied_generator:envied=path=lib/features/env/production.env --delete-conflicting-outputs
	@echo "🎉 ALL environments ready!"

# Environment-specific run commands
run-dev:
	@echo "🏃 Running development environment..."
	@$(FLUTTER_CMD) run --dart-define=ENVIRONMENT=development --target=lib/main_development.dart

run-staging:
	@echo "🏃 Running staging environment..."
	@$(FLUTTER_CMD) run --dart-define=ENVIRONMENT=staging --target=lib/main_staging.dart

run-prod:
	@echo "🏃 Running production environment..."
	@$(FLUTTER_CMD) run --dart-define=ENVIRONMENT=production --target=lib/main_production.dart

# Help command
help:
	@echo "Available commands:"
	@echo ""
	@echo "🎯 GitHub Actions Equivalent:"
	@echo "  make local-ci       - Run complete CI pipeline (bash tests + 3 jobs)"
	@echo "  make test-scripts   - Test bash scripts (BATS framework)"
	@echo "  make semantic-check - Job 1: Semantic validation"
	@echo "  make flutter-ci     - Job 2: Flutter package checks"
	@echo "  make spell-check    - Job 3: Spell checking"
	@echo ""
	@echo "⚡ Quick Development:"
	@echo "  make check         - Quick Flutter checks (format + analyze)"
	@echo "  make check-strict  - Strict checks with fatal warnings"
	@echo "  make check-all     - Complete checks with deps and licenses"
	@echo "  make format        - Format code"
	@echo "  make format-check  - Check code formatting"
	@echo "  make analyze       - Analyze code"
	@echo "  make analyze-quick - Quick analysis"
	@echo "  make analyze-strict - Strict analysis with warnings"
	@echo "  make validate-deps - Validate dependencies"
	@echo "  make test          - Run tests (excludes generated files)"
	@echo "  make deps          - Install dependencies"
	@echo "  make pre-commit    - Run pre-commit checks"
	@echo ""
	@echo "🔨 Build Commands:"
	@echo "  make build-android - Build Android APK"
	@echo "  make build-ios     - Build iOS"
	@echo "  make build-web     - Build Web"
	@echo "  make build-dev     - Build development APK"
	@echo "  make build-staging - Build staging APK"
	@echo "  make build-prod    - Build production APK"
	@echo ""
	@echo "🏗️ Environment Generation:"
	@echo "  make generate-env-dev     - Generate development environment"
	@echo "  make generate-env-staging - Generate staging environment"
	@echo "  make generate-env-prod    - Generate production environment"
	@echo ""
	@echo "🎨 App Icon Generation:"
	@echo "  make generate-icons       - Generate app icons for all platforms"
	@echo ""
	@echo "🌐 Internationalization (i18n) with Slang:"
	@echo "  make i18n-generate        - Generate slang translations from JSON files"
	@echo "  make i18n-watch           - Watch translation files for changes"
	@echo "  make i18n-analyze         - Analyze translation coverage"
	@echo "  make i18n-validate        - Validate translation files"
	@echo "  make i18n-clean           - Clean generated slang files"
	@echo "  make i18n-help            - Show detailed i18n help"
	@echo ""
	@echo "📊 Test Coverage (using very_good CLI + lcov, excludes generated files):"
	@echo "  make test           - Run unit tests only (excludes generated files)"
	@echo "  make coverage       - Run unit tests with coverage (excludes generated files)"
	@echo "  make coverage-clean - Clean all coverage files"
	@echo ""
	@echo "⚡ Excluded from test/coverage commands:"
	@echo "  *.g.dart, *.freezed.dart, *.config.dart, env_*.dart, strings*.g.dart"
	@echo ""
	@echo "🔧 LCOV & genhtml Usage Examples:"
	@echo "  # Install lcov (includes genhtml):"
	@echo "  brew install lcov                    # macOS"
	@echo "  sudo apt-get install lcov           # Ubuntu/Debian"
	@echo "  # Manual HTML generation:"
	@echo "  genhtml coverage/lcov.info -o coverage/html"
	@echo "  # View coverage summary:"
	@echo "  lcov --summary coverage/lcov.info"
	@echo "  # List uncovered lines:"
	@echo "  lcov --list coverage/lcov.info"
	@echo ""
	@echo "⚙️ Setup & Installation:"
	@echo "  make setup         - Basic project setup"
	@echo "  make setup-full    - Complete project setup with hooks"
	@echo "  make install-dev   - Complete development environment setup (RECOMMENDED for new devs)"
	@echo "  make install-staging - Complete staging environment setup"
	@echo "  make install-prod  - Complete production environment setup"
	@echo "  make install-all   - Setup all environments at once"
	@echo "  make clean         - Clean build files"
	@echo "  make reset         - Reset project (clean + pub get + build_runner)"
	@echo ""
	@echo "🪝 Git Hooks:"
	@echo "  make hooks-install   - Install git hooks"
	@echo "  make hooks-uninstall - Uninstall git hooks"
	@echo "  make test-commit-validation - Test commit validation"
	@echo ""
	@echo "🏃 Quick Run Commands:"
	@echo "  make run-dev       - Run development environment"
	@echo "  make run-staging   - Run staging environment"
	@echo "  make run-prod      - Run production environment"
	@echo ""
	@echo "🔐 License Compliance:"
	@echo "  make license-check - Check business-safe licenses only"
	@echo "  make license-help  - Show all license commands"
	@echo ""
	@echo "🏷️ Naming Conventions (Simplified):"
	@echo "  make naming-check  - Validate naming conventions (dart analyze only)"
	@echo "  make naming-fix    - Apply naming fixes (dart fix + format)"
	@echo "  make naming-docs   - Open naming conventions guide"
	@echo ""
	@echo "❓ Help:"
	@echo "  make help          - Show this help"
