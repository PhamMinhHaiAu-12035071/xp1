#!/bin/bash

# setup-env.sh - Script to setup environment files for development
# This script copies .env.example files to .env files if they don't exist

set -e

# Use ENV_DIR from environment variable for testing, fallback to default
ENV_DIR="${ENV_DIR:-lib/features/env}"
ENVIRONMENTS=("development" "staging" "production")

echo "🔧 Setting up environment files..."

# Create env directory if it doesn't exist
mkdir -p "$ENV_DIR"

# Function to setup env file for specific environment
setup_env_file() {
    local env="$1"
    local example_file="$ENV_DIR/${env}.env.example"
    local env_file="$ENV_DIR/${env}.env"
    
    if [ -f "$example_file" ]; then
        if [ ! -f "$env_file" ]; then
            echo "📋 Creating $env_file from $example_file"
            cp "$example_file" "$env_file"
            echo "✅ Created: $env_file"
        else
            echo "ℹ️  $env_file already exists, skipping..."
        fi
    else
        echo "⚠️  Warning: $example_file not found"
    fi
}

# Setup environment files for all environments
for env in "${ENVIRONMENTS[@]}"; do
    setup_env_file "$env"
done

echo ""
echo "🎉 Environment setup completed!"
echo ""
echo "📝 Next steps:"
echo "  1. Edit the .env files with your actual values"
echo "  2. Run 'make install-dev' or 'dart run rps install-dev' to complete setup"
echo ""
echo "🔒 Security note: .env files are git-ignored for security"
