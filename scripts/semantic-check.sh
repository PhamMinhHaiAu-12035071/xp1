#!/bin/bash
set -e

echo "🔍 Running semantic checks..."

echo "  📝 Validating commit message..."
fvm dart run tool/validate_commit.dart "$(git log -1 --pretty=%B)"

echo "  🏷️  Validating PR title..."
fvm dart run tool/validate_pr_title.dart

echo "✅ Semantic checks passed"
