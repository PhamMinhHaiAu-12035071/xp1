# Local CI Setup with Lefthook

This document guides you how to run GitHub Actions equivalent jobs locally
through lefthook using **identical configuration** as CI.

## 🎯 Unified Configuration

Both local and GitHub Actions use the **same `cspell.json`** with:

- ✅ **VGV Dictionaries** (Very Good practices)
- ✅ **Technical terms** (pubspec, lefthook, etc.)
- ✅ **Internationalization words** (Spanish l10n)
- ✅ **Same ignore paths and overrides**

## Jobs Overview

### 1. semantic-check (Job 1: semantic-pull-request equivalent)

- **validate-commit**: Validates latest commit message according to
  Conventional Commits
- **validate-pr-title**: Validates PR title following semantic conventions

### 2. flutter-ci (Job 2: build equivalent)

- **dependencies**: Install Flutter dependencies
- **analyze**: Analyze code with fatal-infos
- **format-check**: Check code formatting
- **test**: Run unit tests
- **publish-check**: Check package publishability

### 3. spell-check (Job 3: spell-check equivalent)

- **install-cspell**: Install cspell if not available
- **check-markdown**: Check spelling in markdown files
- **check-docs**: Check spelling in Dart code

## Usage

### Install dependencies

```bash
# Install npm dependencies (lefthook + cspell)
npm install

# Install lefthook hooks
npm run prepare
# or
lefthook install
```

### Run individual jobs

```bash
# Job 1: Semantic PR check
lefthook run semantic-check

# Job 2: Flutter package build
lefthook run flutter-ci

# Job 3: Spell check
lefthook run spell-check
```

### Run all jobs

```bash
# Run all 3 jobs in sequence (equivalent to full GitHub Actions)
lefthook run local-ci

# Run all jobs in parallel (faster)
lefthook run semantic-check & \
lefthook run flutter-ci & \
lefthook run spell-check & \
wait
```

### Automatic git hooks

- **pre-commit**: Automatically format code with RPS
- **pre-push**: Run quick flutter-ci check
- **commit-msg**: Validate conventional commit format

## 🔄 Configuration Sync

### Unified cspell Configuration

```bash
# Both files are identical:
cspell.json              # Used by local lefthook
.github/cspell.json      # Used by GitHub Actions

# To sync after changes:
cp .github/cspell.json cspell.json
```

### VGV Dictionaries Included

- **vgv_allowed**: Allowed Very Good spellings
- **vgv_forbidden**: Forbidden Very Good spellings
- **Technical terms**: pubspec, mocktail, lefthook, etc.
- **L10n words**: Spanish translation terms

## Troubleshooting

### cspell not found error

```bash
# Install globally
npm install -g cspell

# Or install locally only
npm install cspell
```

### FVM not found error

```bash
# If not using FVM, you can modify commands in lefthook.yml:
# Replace "fvm flutter" with "flutter"
# Replace "fvm dart" with "dart"
```

### Debug validation tools

```bash
# Test validate_commit directly
dart run tools/validate_commit.dart "feat: add new feature"

# Test validate_pr_title
dart run tools/validate_pr_title.dart "feat(auth): add user login"
```

### Test spell check with specific config

```bash
# Test with explicit config (same as GitHub Actions)
npx cspell "**/*.md" --config cspell.json
npx cspell "lib/**/*.dart" --config cspell.json
```

## VS Code Integration

Add to `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Local CI - Full",
      "type": "shell",
      "command": "lefthook run local-ci",
      "group": "test",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Local CI - Flutter Only",
      "type": "shell",
      "command": "lefthook run flutter-ci",
      "group": "test"
    }
  ]
}
```

## 🏆 Expected Results

When properly configured, you should see:

```bash
✔️ check-docs: 0 issues found in 15 files
✔️ check-markdown: 0 issues found in 8 files
✔️ format-check: No formatting changes needed
✔️ analyze: No issues found
✔️ test: All tests passed
```

## Best Practices

1. **Before creating PR**: Run `lefthook run local-ci`
2. **During development**: Only run `lefthook run flutter-ci` to save time
3. **Commit validation**: Lefthook automatically validates via commit-msg hook
4. **Code formatting**: Pre-commit hook automatically formats code
5. **Configuration sync**: Keep both cspell files identical

## 🎯 Benefits

- ✅ **100% CI Consistency**: Local tests exactly match GitHub Actions
- ✅ **VGV Best Practices**: Uses Very Good dictionaries
- ✅ **Early Feedback**: Catch issues before pushing
- ✅ **Faster Development**: No waiting for CI to find basic issues
