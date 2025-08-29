# Makefile for xp1 Flutter project
# Provides easy commands for local CI equivalent to GitHub Actions

.PHONY: semantic-check flutter-ci spell-check test-scripts local-ci check format analyze test help license-check license-audit license-report license-validate-main license-validate-dev license-ci license-quick license-override license-clean-check license-help check-very-good-cli

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

local-ci: test-scripts semantic-check flutter-ci spell-check
	@echo ""
	@echo "🎉 Complete local CI pipeline finished!"
	@echo "✅ All checks equivalent to GitHub Actions passed!"

# Quick development commands
check: flutter-ci
	@echo "✅ Quick development check completed"

format:
	@echo "🎨 Formatting code..."
	@fvm dart format lib/ test/ --set-exit-if-changed

analyze:
	@echo "🔍 Analyzing code..."
	@fvm flutter analyze --fatal-infos

test:
	@echo "🧪 Running tests..."
	@fvm flutter test

deps:
	@echo "📦 Installing dependencies..."
	@fvm flutter pub get

clean:
	@echo "🧹 Cleaning build files..."
	@fvm flutter clean

# Setup commands
setup:
	@echo "⚙️ Setting up project..."
	@npm install
	@fvm flutter pub get
	@chmod +x scripts/*.sh
	@echo "✅ Project setup completed"

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
		--jobs=4 \
		--cache-dir=/tmp/license-cache \
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
	@fvm flutter clean
	@fvm flutter pub get
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
	@echo "  make check         - Quick Flutter checks only"
	@echo "  make format        - Format code"
	@echo "  make analyze       - Analyze code"
	@echo "  make test          - Run tests"
	@echo "  make deps          - Install dependencies"
	@echo ""
	@echo "⚙️ Setup:"
	@echo "  make setup         - Initial project setup"
	@echo "  make clean         - Clean build files"
	@echo ""
	@echo "🔐 License Compliance:"
	@echo "  make license-check - Check business-safe licenses only"
	@echo "  make license-help  - Show all license commands"
	@echo ""
	@echo "❓ Help:"
	@echo "  make help          - Show this help"
