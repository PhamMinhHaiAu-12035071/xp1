# Makefile for xp1 Flutter project
# Provides easy commands for local CI equivalent to GitHub Actions

.PHONY: semantic-check flutter-ci spell-check local-ci check format analyze test help

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

local-ci: semantic-check flutter-ci spell-check
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

# Help command
help:
	@echo "Available commands:"
	@echo ""
	@echo "🎯 GitHub Actions Equivalent:"
	@echo "  make local-ci       - Run complete CI pipeline (all 3 jobs)"
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
	@echo "  make help          - Show this help"
