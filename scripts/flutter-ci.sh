#!/bin/bash
set -e

echo "🚀 Running Flutter CI..."

echo "  📦 Installing dependencies..."
fvm flutter pub get

echo "  🔍 Analyzing code..."
fvm flutter analyze --fatal-infos

echo "  🎨 Checking code format..."
# Format all lib directories except generated files
find lib -name "*.dart" -not -path "lib/l10n/gen/*" -not -name "*.g.dart" -not -name "*.freezed.dart" | xargs fvm dart format --set-exit-if-changed --output=none
# Format test directory
fvm dart format test/ --set-exit-if-changed --output=none

echo "  🧪 Running tests..."
make test

echo "  📋 Checking publish readiness..."
fvm flutter pub publish --dry-run

echo "✅ Flutter CI passed"
