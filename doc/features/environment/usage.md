# Environment Configuration Usage Guide

## Quick Start

### Daily Development Workflow

```bash
# Setup development environment (one-time)
dart run rps generate-env-dev

# Run development app
dart run rps run-dev
```

### Testing Different Environments

```bash
# Setup and test staging
dart run rps generate-env-staging
dart run rps run-staging

# Setup and test production
dart run rps generate-env-prod
dart run rps run-prod
```

## Available Commands

| Command                             | Purpose                       | When to Use                             |
| ----------------------------------- | ----------------------------- | --------------------------------------- |
| `dart run rps generate-env-dev`     | Setup development environment | Daily development, testing dev features |
| `dart run rps generate-env-staging` | Setup staging environment     | Testing staging configs, QA             |
| `dart run rps generate-env-prod`    | Setup production environment  | Release preparation, prod testing       |

## How It Works

Each command:

1. **Cleans build cache** - Prevents corruption issues
2. **Generates environment files** - From specific `.env` file
3. **Ready to run** - Use corresponding `run-*` command

## Environment Files

- `lib/features/env/development.env` - Development configuration
- `lib/features/env/staging.env` - Staging configuration
- `lib/features/env/production.env` - Production configuration

## CI/CD Integration

```yaml
# GitHub Actions example
- name: Setup Development Environment
  run: dart run rps generate-env-dev

- name: Run Development Tests
  run: flutter test

- name: Setup Production Environment
  run: dart run rps generate-env-prod

- name: Build Production Release
  run: dart run rps build-prod
```

## Why This Approach?

✅ **Simple & Reliable** - Clean cache + generate approach  
✅ **No Complex Scripts** - Straightforward commands  
✅ **Perfect for Development** - Switch environments as needed  
✅ **CI/CD Ready** - Explicit environment control  
✅ **Easy to Debug** - Clear error messages
