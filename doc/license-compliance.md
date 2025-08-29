# License Compliance Guide

Hướng dẫn sử dụng hệ thống kiểm tra license để đảm bảo chỉ sử dụng các
license an toàn về mặt pháp lý trong dự án Flutter.

## 🎯 Mục tiêu

- **Chỉ sử dụng permissive licenses** (MIT, BSD, Apache)
- **Tránh copyleft licenses** (GPL, LGPL, AGPL)
- **Phát hiện unknown/problematic licenses**
- **Tự động enforcement** qua git hooks
- **Business-safe compliance** cho commercial use

## 🔐 License Categories

### ✅ Business-Safe Licenses (Allowed)

```
MIT, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC, Unlicense
```

### ❌ Problematic Licenses (Forbidden)

```
GPL-2.0, GPL-3.0, LGPL-2.1, LGPL-3.0, AGPL-3.0
unknown, CC-BY-SA-4.0, SSPL-1.0
```

## 🚀 Quick Start

### 1. Setup Very Good CLI

```bash
dart pub global activate very_good_cli
```

### 2. Check Current Project

```bash
make license-check
```

### 3. Generate Report

```bash
make license-report
```

## 📋 Available Commands

### Main Commands

```bash
make license-check         # Main compliance check (strict)
make license-report        # Generate detailed report
make license-help          # Show all license commands
```

### Development Commands

```bash
make license-validate-main # Check main dependencies only
make license-validate-dev  # Check dev dependencies only
make license-quick         # Quick check for development
```

### Emergency Commands

```bash
make license-override      # Emergency override (use with caution)
make license-clean-check   # Clean and recheck
make license-ci            # CI/CD friendly check
```

## 🔧 Git Hook Integration

### Pre-Commit Hook

- **Trigger**: Khi `pubspec.yaml` thay đổi
- **Action**: Quick license check cho main dependencies
- **Command**: `make license-validate-main`

### Pre-Push Hook

- **Trigger**: Trước mỗi lần push
- **Action**: Full license compliance check
- **Command**: `make license-check`
- **Behavior**: Block push nếu có license issues

### Manual License Management

```bash
# Direct Makefile commands (no custom hooks needed)
make license-check          # Full compliance check
make license-report         # Generate detailed report
make license-help           # Show all available commands
```

## 📊 Usage Workflow

### Daily Development

```bash
# Adding new package
echo "new_package: ^1.0.0" >> pubspec.yaml
flutter pub get
make license-check          # Verify new package is safe

# Quick check during development
make license-validate-main  # Check main deps only
```

### Before Committing

```bash
git add pubspec.yaml
git commit -m "feat(deps): add new dependency"
# Auto-runs license check if pubspec.yaml changed
```

### Before Pushing

```bash
git push origin feature-branch
# Auto-runs full compliance check
# Will block if any forbidden licenses found
```

### Periodic Audit

```bash
make license-report         # Generate detailed report
cat license-report.txt      # Review license usage
```

## 🚨 Troubleshooting

### License Check Failed

```bash
# 1. See detailed report
make license-report
grep -i "GPL\|unknown" license-report.txt

# 2. View dependency tree
dart pub deps

# 3. Find alternatives
# Remove problematic packages
# Search for MIT/BSD/Apache alternatives on pub.dev
```

### Emergency Situations

```bash
# If urgent fix needed (use sparingly)
make license-override
```

### Clean Installation

```bash
# If license state is corrupted
make license-clean-check
```

## 🧪 Testing

### Test License Integration

```bash
./scripts/test-license-integration.sh
```

### Test Individual Commands

```bash
npm test -- test/license-check.bats
npm test -- test/license-integration.bats
```

## 📈 Monitoring & Reports

### Report Files

- `license-report.txt` - Detailed license analysis (git-ignored)

### Report Contents

- License counts by type
- Package-to-license mapping
- Compliance status
- Action recommendations

## 🔍 Example Output

### Successful Check

```
🔐 Business License Compliance Check
✅ Allowed: MIT,BSD-2-Clause,BSD-3-Clause,Apache-2.0,ISC,Unlicense
❌ Forbidden: GPL-2.0,GPL-3.0,LGPL-2.1,LGPL-3.0,AGPL-3.0,unknown

🎉 All packages use business-safe licenses!
💼 Safe for commercial use without legal concerns
```

### Failed Check

```
🚨 LICENSE COMPLIANCE FAILURE

📋 Action items:
  1. Remove packages with forbidden licenses
  2. Find alternatives with MIT/BSD/Apache licenses
  3. Contact package authors for license clarification

🔍 Run 'make license-report' for detailed analysis
```

## 🎯 Benefits

| Benefit                   | Description                                           |
| ------------------------- | ----------------------------------------------------- |
| **Legal Safety**          | Chỉ sử dụng permissive licenses, tránh rủi ro pháp lý |
| **Automated Enforcement** | Tự động block commits/pushes vi phạm policy           |
| **Early Detection**       | Phát hiện license issues ngay khi add dependencies    |
| **Documentation**         | License report tracking theo thời gian                |
| **Team Compliance**       | Toàn team follow cùng license policy                  |

## 📚 Resources

- [Very Good CLI Documentation](https://pub.dev/packages/very_good_cli)
- [MIT License](https://choosealicense.com/licenses/mit/)
- [Apache 2.0 License](https://choosealicense.com/licenses/apache-2.0/)
- [BSD Licenses](https://choosealicense.com/licenses/bsd-3-clause/)

---

**⚠️ Important**: Luôn tham khảo ý kiến legal team cho business-critical
decisions về licensing, đặc biệt khi có doubts về specific licenses.
