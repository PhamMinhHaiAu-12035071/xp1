#!/bin/bash
set -e

echo "🔥 Running complete local CI pipeline..."
echo "=================================================="

echo ""
echo "Step 1/3: Semantic checks"
echo "------------------------"
./scripts/semantic-check.sh

echo ""
echo "Step 2/3: Flutter CI"
echo "-------------------"
./scripts/flutter-ci.sh

echo ""
echo "Step 3/3: Spell check"
echo "--------------------"
./scripts/spell-check.sh

echo ""
echo "=================================================="
echo "🎉 All CI checks passed! Ready for GitHub Actions!"
echo "=================================================="
