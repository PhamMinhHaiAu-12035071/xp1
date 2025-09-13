#!/bin/bash

# Quick analyze script for pre-push hook
# This script runs dart analyze with minimal flags to avoid the 18k+ warnings issue

echo "⚡ Running quick analyze (errors only)..."

# Run flutter analyze with --no-fatal-warnings to ignore warnings and infos
fvm flutter analyze --no-fatal-warnings

# Check exit code
if [ $? -eq 0 ]; then
    echo "✅ Quick analyze passed!"
    exit 0
else
    echo "❌ Quick analyze failed!"
    exit 1
fi
