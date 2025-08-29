#!/bin/bash
set -e

echo "📝 Running spell check..."

echo "  📦 Installing cspell if needed..."
npm list cspell || npm install cspell

echo "  📚 Checking markdown files..."
npx cspell "**/*.md" --no-progress --config cspell.json

echo "  📝 Checking Dart code documentation..."
npx cspell "lib/**/*.dart" "test/**/*.dart" --no-progress --config cspell.json

echo "✅ Spell check passed"
