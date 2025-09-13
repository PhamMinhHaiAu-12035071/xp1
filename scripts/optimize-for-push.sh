#!/bin/bash
set -e

echo "🧹 Optimizing project for push..."

# Clean build artifacts to reduce package size
echo "  🗑️  Cleaning build artifacts..."
flutter clean > /dev/null 2>&1 || true

# Clean coverage reports (keep only latest)
echo "  📊 Cleaning old coverage reports..."
find coverage/ -name "*.html" -not -path "coverage/html/*" -delete 2>/dev/null || true
find coverage/ -name "*.lcov" -not -name "lcov.info" -delete 2>/dev/null || true

# Clean node_modules if it's too large
if [ -d "node_modules" ]; then
  NODE_SIZE=$(du -sm node_modules/ | cut -f1)
  if [ "$NODE_SIZE" -gt 50 ]; then
    echo "  📦 Node modules size: ${NODE_SIZE}MB - cleaning..."
    rm -rf node_modules/
    npm install --silent
  fi
fi

# Clean any temporary files
echo "  🧽 Cleaning temporary files..."
find . -name "*.tmp" -delete 2>/dev/null || true
find . -name "*.log" -not -path "./coverage/*" -delete 2>/dev/null || true

echo "✅ Project optimized for push"
