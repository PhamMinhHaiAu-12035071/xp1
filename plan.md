# Phân tích Requirements: Dependency Management

Dựa trên nội dung bạn cung cấp, đây là một **task về quản lý dependencies hiệu quả** cho Flutter/Dart project. Dưới đây là phân tích chi tiết:

## **📋 Hiểu Requirements**

### **1. Dependency Practices**

- **Review and minimize dependencies**: Audit và loại bỏ dependencies không cần thiết
- **Use pubspec.yaml effectively**: Tối ưu cấu trúc và cách organize dependencies
- **Setup dependency overrides**: Xử lý conflicts và version constraints

### **2. Maintenance**

- **Create script for dependency updates**: Automation cho việc update dependencies
- **Check for vulnerabilities**: Security scanning cho dependencies
- **Document dependency purposes**: Ghi chú mục đích của từng dependency

## **🎯 Implementation Strategy**

### **Phase 1: Dependency Audit & Cleanup**

#### Script để review dependencies

```bash
# scripts/deps-audit.sh
#!/bin/bash
echo "📦 Dependency Audit Report"
echo "=========================="

# 1. List all dependencies with versions
echo "🔍 Current Dependencies:"
dart pub deps --style=tree

# 2. Find unused dependencies
echo -e "\n🚮 Checking for unused dependencies..."
dart pub deps --style=list | grep -E "^[a-z]" > deps.txt
find lib/ test/ -name "*.dart" -exec grep -l "import 'package:" {} \; | \
  xargs grep -h "import 'package:" | \
  sed "s/import 'package:\([^/]*\).*/\1/" | \
  sort -u > used_deps.txt

echo "Potentially unused:"
comm -23 <(sort deps.txt) <(sort used_deps.txt)

# 3. Check for outdated packages
echo -e "\n📈 Outdated packages:"
dart pub outdated --mode=outdated

# 4. License summary
echo -e "\n📜 License Summary:"
very_good packages check licenses || true

rm -f deps.txt used_deps.txt
```

### **Phase 2: Pubspec.yaml Optimization**

#### Template pubspec.yaml structure

```yaml
name: your_project
description: A well-documented Flutter project
version: 1.0.0+1
publish_to: "none"

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter

  # UI & Navigation - Core app functionality
  cupertino_icons: ^1.0.6 # iOS-style icons

  # State Management - App state handling
  # bloc: ^8.1.0  # Business Logic Component pattern

  # Networking - API communication
  # dio: ^5.3.0  # HTTP client with interceptors

  # Local Storage - Data persistence
  # shared_preferences: ^2.2.0  # Simple key-value storage

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

  # Testing - Quality assurance
  mocktail: ^1.0.0 # Mocking framework

  # Code Generation - Development productivity
  # build_runner: ^2.4.0    # Code generation runner

  # Development Tools - Workflow enhancement
  very_good_cli: ^0.26.0 # Project templates & utilities

# Dependency overrides for conflict resolution
dependency_overrides:
  # Example: Force specific version to resolve conflicts
  # meta: 1.9.1

flutter:
  uses-material-design: true

  # Assets organization
  assets:
    - assets/images/
    - assets/icons/

  # Font management
  # fonts:
  #   - family: CustomFont
  #     fonts:
  #       - asset: assets/fonts/CustomFont-Regular.ttf
```

### **Phase 3: Automated Update Scripts**

#### Makefile for dependency management

```makefile
# Makefile - Dependency Management
.PHONY: deps-audit deps-update deps-check deps-clean deps-security

# Comprehensive dependency audit
deps-audit:
	@echo "📦 Running comprehensive dependency audit..."
	@./scripts/deps-audit.sh

# Safe dependency updates
deps-update:
	@echo "🔄 Updating dependencies safely..."
	@echo "1️⃣ Checking current state..."
	@dart pub deps --style=compact
	@echo -e "\n2️⃣ Getting latest compatible versions..."
	@dart pub get
	@echo -e "\n3️⃣ Checking for major updates..."
	@dart pub outdated
	@echo -e "\n4️⃣ Running tests after update..."
	@make test
	@echo -e "\n✅ Dependencies updated successfully!"

# Check for security vulnerabilities
deps-security:
	@echo "🔒 Checking for security vulnerabilities..."
	@dart pub audit || echo "⚠️  Consider updating vulnerable packages"

# Clean and reinstall dependencies
deps-clean:
	@echo "🧹 Cleaning dependency cache..."
	@flutter clean
	@rm -rf .dart_tool/
	@flutter pub get
	@echo "✅ Dependencies reinstalled"

# Check dependency health
deps-check:
	@echo "🏥 Dependency health check..."
	@dart pub publish --dry-run
	@make license-check
	@make deps-security

# Add new dependency with documentation
deps-add:
	@echo "📋 Adding new dependency..."
	@read -p "Package name: " pkg; \
	read -p "Purpose/description: " desc; \
	echo "# $$desc" >> .dependency-notes.md; \
	echo "$$pkg: latest version for $$desc" >> .dependency-notes.md; \
	dart pub add $$pkg; \
	make deps-check

# Remove dependency
deps-remove:
	@echo "🗑️  Removing dependency..."
	@read -p "Package name to remove: " pkg; \
	dart pub remove $$pkg; \
	make deps-check

# Generate dependency documentation
deps-docs:
	@echo "📚 Generating dependency documentation..."
	@./scripts/generate-deps-docs.sh
```

### **Phase 4: Dependency Documentation**

#### Auto-generate dependency docs

```bash
# scripts/generate-deps-docs.sh
#!/bin/bash

echo "# Dependency Documentation" > DEPENDENCIES.md
echo "Generated on: $(date)" >> DEPENDENCIES.md
echo "" >> DEPENDENCIES.md

echo "## Production Dependencies" >> DEPENDENCIES.md
echo "" >> DEPENDENCIES.md

# Parse pubspec.yaml dependencies section
sed -n '/^dependencies:/,/^dev_dependencies:/p' pubspec.yaml | \
  grep -E "^\s+[a-z]" | \
  while read line; do
    pkg=$(echo $line | cut -d: -f1 | xargs)
    version=$(echo $line | cut -d: -f2- | xargs)

    # Get package description from pub.dev
    desc=$(curl -s "https://pub.dev/api/packages/$pkg" | \
           jq -r '.latest.description // "No description available"' 2>/dev/null || \
           echo "No description available")

    echo "### $pkg" >> DEPENDENCIES.md
    echo "- **Version**: $version" >> DEPENDENCIES.md
    echo "- **Purpose**: $desc" >> DEPENDENCIES.md
    echo "" >> DEPENDENCIES.md
  done

echo "## Development Dependencies" >> DEPENDENCIES.md
echo "" >> DEPENDENCIES.md

# Parse dev_dependencies section
sed -n '/^dev_dependencies:/,/^flutter:/p' pubspec.yaml | \
  grep -E "^\s+[a-z]" | \
  while read line; do
    pkg=$(echo $line | cut -d: -f1 | xargs)
    version=$(echo $line | cut -d: -f2- | xargs)

    echo "### $pkg" >> DEPENDENCIES.md
    echo "- **Version**: $version" >> DEPENDENCIES.md
    echo "- **Type**: Development/Testing" >> DEPENDENCIES.md
    echo "" >> DEPENDENCIES.md
  done

echo "📚 Dependency documentation generated: DEPENDENCIES.md"
```

### **Phase 5: Integration với Lefthook**

```yaml
# lefthook.yml - Updated with dependency management
pre-commit:
  commands:
    deps-audit-on-pubspec-change:
      glob: "pubspec.yaml"
      run: |
        echo "📦 pubspec.yaml changed, running dependency audit..."
        make deps-check
        git add DEPENDENCIES.md

pre-push:
  commands:
    deps-security-check:
      run: make deps-security

    license-compliance:
      run: make license-check

# Custom dependency management hooks
deps-update:
  commands:
    safe-update:
      run: make deps-update

deps-audit:
  commands:
    full-audit:
      run: make deps-audit
```

### **Phase 6: Automated Monitoring**

#### GitHub Actions for dependency monitoring

```yaml
# .github/workflows/dependency-monitoring.yml
name: Dependency Monitoring

on:
  schedule:
    - cron: "0 9 * * MON" # Weekly Monday check
  pull_request:
    paths: ["pubspec.yaml"]

jobs:
  dependency-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
      - name: Install dependencies
        run: dart pub get
      - name: Security audit
        run: dart pub audit
      - name: License check
        run: |
          dart pub global activate very_good_cli
          very_good packages check licenses --allowed="MIT,BSD-3-Clause,Apache-2.0"
      - name: Check for outdated packages
        run: dart pub outdated --mode=outdated
```

## **📊 Deliverables Summary**

| Component             | Purpose                      | Files                           |
| --------------------- | ---------------------------- | ------------------------------- |
| **Audit Scripts**     | Review & minimize deps       | `scripts/deps-audit.sh`         |
| **Update Automation** | Safe dependency updates      | `Makefile` targets              |
| **Security Checking** | Vulnerability scanning       | `dart pub audit` integration    |
| **Documentation**     | Auto-generate docs           | `scripts/generate-deps-docs.sh` |
| **Git Hooks**         | Enforce dependency policies  | `lefthook.yml` updates          |
| **CI Monitoring**     | Continuous dependency health | GitHub Actions                  |

## **🎯 Expected Outcomes**

1. **Clean Dependencies**: Minimal, well-documented dependencies
2. **Automated Updates**: Safe, tested dependency updates
3. **Security Awareness**: Early vulnerability detection
4. **Team Documentation**: Clear dependency purposes
5. **Conflict Resolution**: Effective override strategies
6. **Compliance**: License and security compliance

**Workflow**: Audit → Minimize → Document → Automate → Monitor → Maintain

Tổng thể, đây là một comprehensive dependency management strategy để keep project clean, secure, và maintainable.
