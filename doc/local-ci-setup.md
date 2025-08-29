# Local CI Setup with Lefthook

This document guides you how to run GitHub Actions equivalent jobs locally
through lefthook using **identical configuration** as CI, now with **comprehensive git hooks integration**.

## 🎯 Unified Configuration

Both local and GitHub Actions use the **same `cspell.json`** with:

- ✅ **VGV Dictionaries** (Very Good practices)
- ✅ **Technical terms** (pubspec, lefthook, etc.)
- ✅ **Internationalization words** (Spanish l10n)
- ✅ **Same ignore paths and overrides**

## 🔄 Comprehensive Git Hooks

### 🚀 Pre-commit Hook (Quick Checks)

Runs **fast, staged-file-focused** checks on every commit:

- ✅ **RPS Pre-commit** - Format and fix Dart files
- ✅ **Format Check** - Ensure code formatting
- ✅ **Quick Analysis** - Analyze staged Dart files
- ✅ **Spell Check Quick** - Check spelling on staged markdown

### 🛡️ Pre-push Hook (Full CI Pipeline)

Runs **complete GitHub Actions equivalent** before every push:

- ✅ **1-semantic-full** - Complete semantic validation
- ✅ **2-flutter-ci-full** - Full Flutter CI (deps, analyze, test, publish-check)
- ✅ **3-spell-check-full** - Complete spell check (docs + markdown)

### 📝 Commit-msg Hook

- ✅ **Conventional Commit Validation** - Enforce semantic commit format

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

# Install lefthook hooks (automatic via npm prepare script)
npm run prepare
# or manually
npx lefthook install
```

### Manual job execution

```bash
# Job 1: Semantic PR check
npx lefthook run semantic-check

# Job 2: Flutter package build
npx lefthook run flutter-ci

# Job 3: Spell check
npx lefthook run spell-check

# All jobs combined
npx lefthook run local-ci
```

### Git workflow (Automatic)

```bash
# 1. Commit triggers pre-commit (quick checks) + commit-msg validation
git add .
git commit -m "feat: add new feature"
# ✅ Runs: format, quick-analysis, spell-check-quick, commit validation

# 2. Push triggers pre-push (full CI pipeline)
git push
# ✅ Runs: semantic-check + flutter-ci + spell-check (complete)
```

## 🏗️ Hook Architecture

```
Developer Workflow                    Automated Checks
┌─────────────────┐                  ┌─────────────────┐
│ git add .       │                  │                 │
│ git commit      │ ────────────────▶│ pre-commit      │
│                 │                  │ (quick checks)  │
└─────────────────┘                  └─────────────────┘
         │                                    │
         ▼                                    ▼
┌─────────────────┐                  ┌─────────────────┐
│ git push        │ ────────────────▶│ pre-push        │
│                 │                  │ (full CI)       │
└─────────────────┘                  └─────────────────┘
```

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

## 🎯 Expected Hook Results

### Pre-commit (Fast) ⚡

```bash
✔️ format-check: No formatting changes needed
✔️ spell-check-quick: 0 issues in staged files
✔️ analyze-quick: No issues in staged files
✔️ rps-pre-commit: All checks passed
```

### Pre-push (Comprehensive) 🛡️

```bash
✔️ 1-semantic-full: Commit validation passed
✔️ 2-flutter-ci-full: All Flutter checks passed
✔️ 3-spell-check-full: 0 issues found
```

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

### Skip hooks temporarily

```bash
# Skip pre-commit hook
git commit --no-verify -m "emergency fix"

# Skip pre-push hook
git push --no-verify
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
      "command": "npx lefthook run local-ci",
      "group": "test",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Pre-push Check",
      "type": "shell",
      "command": "npx lefthook run semantic-check && npx lefthook run flutter-ci && npx lefthook run spell-check",
      "group": "test"
    }
  ]
}
```

## 🏆 Developer Experience

### Before Commit ⚡

- **Fast feedback** on staged changes only
- **Auto-fix** formatting issues
- **Quick validation** of commit message

### Before Push 🛡️

- **Complete CI pipeline** runs locally
- **Catch all issues** before remote CI
- **100% confidence** in code quality

### Zero Surprises 🎯

- **Identical checks** as GitHub Actions
- **Same dictionaries** and configurations
- **Predictable results** every time

## Best Practices

1. **Trust the hooks**: Let them catch issues automatically
2. **Quick commits**: Pre-commit is fast, commit frequently
3. **Comprehensive pushes**: Pre-push ensures CI will pass
4. **Emergency bypass**: Use `--no-verify` sparingly for urgent fixes
5. **Keep config synced**: Update both cspell files together

## 🎯 Benefits

- ✅ **100% CI Consistency**: Local tests exactly match GitHub Actions
- ✅ **VGV Best Practices**: Uses Very Good dictionaries automatically
- ✅ **Automatic Quality Gate**: No bad code reaches remote
- ✅ **Fast Feedback Loop**: Issues caught at commit/push time
- ✅ **Zero Maintenance**: Configurations stay synchronized
