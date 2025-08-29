#!/bin/bash
set -e

echo "🚀 Running Flutter CI..."

echo "  📦 Installing dependencies..."
fvm flutter pub get

echo "  🔍 Analyzing code..."
fvm flutter analyze --fatal-infos

echo "  🎨 Checking code format..."
fvm dart format lib/ test/ --set-exit-if-changed --output=none

echo "  🧪 Running tests..."
fvm flutter test

echo "  📋 Checking publish readiness..."
fvm flutter pub publish --dry-run

echo "✅ Flutter CI passed"
