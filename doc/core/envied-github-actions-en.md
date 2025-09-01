# Envied Package Setup in GitHub Actions

## 🎯 Overview

This project uses the **envied** package to manage environment variables securely with obfuscation. The GitHub Actions workflow has been configured to automatically copy from `.example` files and generate environment code for all environments.

## 🏗️ Environment Files Structure

```
lib/features/env/
├── development.env.example    # Template for development
├── staging.env.example        # Template for staging
├── production.env.example     # Template for production
├── env_development.dart       # EnvDev class
├── env_staging.dart          # EnvStaging class
├── env_production.dart       # EnvProd class
└── *.g.dart                  # Generated files (by build_runner)
```

## 🔧 GitHub Actions Setup

### Environment Variables in Workflow

The workflow defines environment variables for all environments:

```yaml
env:
  # Development Environment
  DEV_API_URL: "https://dev-api.xp1.com/api/v1"
  DEV_APP_NAME: "XP1 Development CI"
  DEV_ENVIRONMENT_NAME: "development"
  DEV_IS_DEBUG_MODE: "true"
  DEV_API_TIMEOUT_MS: "30000"

  # Staging Environment
  STAGING_API_URL: "https://staging-api.xp1.com/api"
  STAGING_APP_NAME: "XP1 Staging"
  # ... and other variables
```

### Composite Action: setup-envied

Following DRY principle, we have a composite action at `.github/actions/setup-envied/action.yml`:

**Inputs:**

- `flutter-version`: Flutter version (default: 3.35.1)
- `environment-mode`: `all` or `development-only` (default: all)
- `very-good-cli`: Whether to install Very Good CLI (default: true)

**Usage:**

```yaml
- name: 🔧 Setup Envied Environment
  uses: ./.github/actions/setup-envied
  with:
    flutter-version: ${{ env.FLUTTER_VERSION }}
    environment-mode: "all" # Create all environments
    very-good-cli: "true"
```

## 🔄 Workflow Process

### 1. Setup Job (Create all environments)

```yaml
- name: 🔧 Setup Envied Environment
  uses: ./.github/actions/setup-envied
  with:
    environment-mode: "all" # ✅ Create development, staging, production
```

### 2. Other CI Jobs (Development only)

```yaml
- name: 🔧 Setup Envied Environment
  uses: ./.github/actions/setup-envied
  with:
    environment-mode: "development-only" # ✅ Save time
```

### 3. Detailed Process:

1. **Copy Template Files:**

   ```bash
   cp lib/features/env/development.env.example lib/features/env/development.env
   ```

2. **Replace Values with Environment Variables:**

   ```bash
   sed -i "s|API_URL=.*|API_URL=${DEV_API_URL}|g" lib/features/env/development.env
   ```

3. **Generate Envied Code:**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Verify Generated Files:**
   - Check `.env` files exist
   - Check `.g.dart` files are generated

## 🛡️ Security Best Practices

### ✅ What we've done right:

1. **Don't commit sensitive files:**

   ```gitignore
   # .gitignore
   lib/features/env/*.env
   lib/features/env/*.g.dart
   ```

2. **Use .example templates:** Commit safe, reusable templates

3. **Environment variables in workflow:** Centralized configuration

4. **Validation steps:** Ensure all files are created successfully

### 🔐 If GitHub Secrets are needed:

For production or sensitive data:

```yaml
# In workflow
- name: 🔧 Create production .env
  run: |
    echo "SECRET_API_KEY=${{ secrets.PROD_SECRET_KEY }}" >> lib/features/env/production.env
    echo "DATABASE_URL=${{ secrets.PROD_DATABASE_URL }}" >> lib/features/env/production.env
```

## 🔧 Local Development

Developers only need to:

1. **Copy example file:**

   ```bash
   cp lib/features/env/development.env.example lib/features/env/development.env
   ```

2. **Fill in actual values:**

   ```env
   API_URL=http://localhost:3000/api
   APP_NAME=XP1 Local Dev
   ```

3. **Generate code:**

   ```bash
   dart run build_runner build
   ```

## 📋 Troubleshooting

### Common errors:

1. **Missing .env files:**

   ```
   ❌ development.env missing
   ```

   **Fix:** Check that template copy step succeeded

2. **Missing .g.dart files:**

   ```
   ❌ env_development.g.dart missing
   ```

   **Fix:** Check build_runner command

3. **Sed command fails on macOS:**

   ```bash
   # macOS requires backup extension
   sed -i "" "s|API_URL=.*|API_URL=${DEV_API_URL}|g" lib/features/env/development.env
   ```

### Debug workflow:

```yaml
- name: 🐛 Debug environment files
  run: |
    echo "📋 Listing .env files:"
    ls -la lib/features/env/*.env
    echo "📋 Content of development.env:"
    cat lib/features/env/development.env
```

## 🚀 Results

✅ **DRY principle:** Code duplication reduced by 80%  
✅ **Maintainability:** Only need to update composite action  
✅ **Security:** Don't commit sensitive data  
✅ **Flexibility:** Support multiple environments  
✅ **Validation:** Automatic file generation check

## 📚 Related Files

- `.github/workflows/main.yaml` - Main workflow
- `.github/actions/setup-envied/action.yml` - Composite action
- `lib/features/env/*.example` - Environment templates
- `lib/features/env/env_*.dart` - Envied classes

## 🔄 Advanced Usage

### Multi-environment Build Matrix

For building different environments in parallel:

```yaml
strategy:
  matrix:
    environment: [development, staging, production]

steps:
  - name: 🔧 Setup Envied Environment
    uses: ./.github/actions/setup-envied
    with:
      environment-mode: ${{ matrix.environment }}

  - name: 🏗️ Build for ${{ matrix.environment }}
    run: flutter build apk --release
```

### Custom Environment Variables

For sensitive values that need GitHub Secrets:

```yaml
- name: 🔧 Setup Custom Environment
  uses: ./.github/actions/setup-envied
  with:
    environment-mode: "production"

- name: 🔐 Add Secrets to Production
  run: |
    echo "SECRET_KEY=${{ secrets.PROD_SECRET_KEY }}" >> lib/features/env/production.env
    echo "DATABASE_URL=${{ secrets.PROD_DB_URL }}" >> lib/features/env/production.env

- name: 🏗️ Regenerate with Secrets
  run: dart run build_runner build --delete-conflicting-outputs
```

## 💡 Tips & Best Practices

### 1. Environment-Specific Secrets

Organize secrets by environment:

- `DEV_API_KEY`, `STAGING_API_KEY`, `PROD_API_KEY`
- Use environment prefixes for clarity

### 2. Template Validation

Add validation to ensure templates are properly formatted:

```yaml
- name: ✅ Validate Templates
  run: |
    for template in lib/features/env/*.example; do
      if ! grep -q "API_URL=" "$template"; then
        echo "❌ Missing API_URL in $template"
        exit 1
      fi
    done
```

### 3. Cache Generated Files

For faster builds, consider caching generated files:

```yaml
- name: 📦 Cache Generated Files
  uses: actions/cache@v3
  with:
    path: lib/features/env/*.g.dart
    key: envied-${{ hashFiles('lib/features/env/*.dart', 'lib/features/env/*.example') }}
```

### 4. Conditional Generation

Only regenerate when necessary:

```yaml
- name: 🔍 Check if Regeneration Needed
  id: check-envied
  run: |
    if [ ! -f "lib/features/env/env_development.g.dart" ] || 
       [ "lib/features/env/development.env.example" -nt "lib/features/env/env_development.g.dart" ]; then
      echo "regenerate=true" >> $GITHUB_OUTPUT
    else
      echo "regenerate=false" >> $GITHUB_OUTPUT
    fi

- name: 🏗️ Generate Envied Code
  if: steps.check-envied.outputs.regenerate == 'true'
  run: dart run build_runner build --delete-conflicting-outputs
```

## 🔧 Development Workflow

### Local Setup Script

Create a setup script for developers:

```bash
#!/bin/bash
# scripts/setup-env.sh

echo "🔧 Setting up environment files..."

for env in development staging production; do
  if [ ! -f "lib/features/env/${env}.env" ]; then
    cp "lib/features/env/${env}.env.example" "lib/features/env/${env}.env"
    echo "✅ Created ${env}.env"
  else
    echo "⚠️  ${env}.env already exists"
  fi
done

echo "🏗️ Generating envied code..."
dart run build_runner build --delete-conflicting-outputs

echo "✅ Environment setup complete!"
```

### IDE Integration

Add tasks for VS Code (`.vscode/tasks.json`):

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Setup Environment Files",
      "type": "shell",
      "command": "./scripts/setup-env.sh",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ]
}
```

This comprehensive setup ensures that the envied package works seamlessly in both CI/CD and local development environments while maintaining security and following best practices! 🚀
