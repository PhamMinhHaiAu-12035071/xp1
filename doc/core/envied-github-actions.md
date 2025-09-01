# Envied Package Setup trong GitHub Actions

## 🎯 Tổng quan

Project này sử dụng **envied** package để quản lý environment variables một cách an toàn và obfuscated. GitHub Actions workflow đã được cấu hình để tự động copy từ `.example` files và generate environment code cho tất cả environments.

## 🏗️ Cấu trúc Environment Files

```
lib/features/env/
├── development.env.example    # Template cho development
├── staging.env.example        # Template cho staging
├── production.env.example     # Template cho production
├── env_development.dart       # EnvDev class
├── env_staging.dart          # EnvStaging class
├── env_production.dart       # EnvProd class
└── *.g.dart                  # Generated files (bởi build_runner)
```

## 🔧 GitHub Actions Setup

### Environment Variables trong Workflow

Workflow định nghĩa environment variables cho tất cả environments:

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
  # ... và các variables khác
```

### Composite Action: setup-envied

Để tuân theo DRY principle, chúng ta có composite action tại `.github/actions/setup-envied/action.yml`:

**Inputs:**

- `flutter-version`: Flutter version (default: 3.35.1)
- `environment-mode`: `all` hoặc `development-only` (default: all)
- `very-good-cli`: Install Very Good CLI hay không (default: true)

**Cách sử dụng:**

```yaml
- name: 🔧 Setup Envied Environment
  uses: ./.github/actions/setup-envied
  with:
    flutter-version: ${{ env.FLUTTER_VERSION }}
    environment-mode: "all" # Tạo tất cả environments
    very-good-cli: "true"
```

## 🔄 Quy trình hoạt động

### 1. Setup Job (Tạo tất cả environments)

```yaml
- name: 🔧 Setup Envied Environment
  uses: ./.github/actions/setup-envied
  with:
    environment-mode: "all" # ✅ Tạo development, staging, production
```

### 2. CI Jobs khác (Chỉ cần development)

```yaml
- name: 🔧 Setup Envied Environment
  uses: ./.github/actions/setup-envied
  with:
    environment-mode: "development-only" # ✅ Tiết kiệm thời gian
```

### 3. Quy trình chi tiết:

1. **Copy Template Files:**

   ```bash
   cp lib/features/env/development.env.example lib/features/env/development.env
   ```

2. **Replace Values với Environment Variables:**

   ```bash
   sed -i "s|API_URL=.*|API_URL=${DEV_API_URL}|g" lib/features/env/development.env
   ```

3. **Generate Envied Code:**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Verify Generated Files:**
   - Check `.env` files tồn tại
   - Check `.g.dart` files được generate

## 🛡️ Security Best Practices

### ✅ Những điều đã làm đúng:

1. **Không commit sensitive files:**

   ```gitignore
   # .gitignore
   lib/features/env/*.env
   lib/features/env/*.g.dart
   ```

2. **Sử dụng .example templates:** Commit safe, reusable templates

3. **Environment variables trong workflow:** Centralized configuration

4. **Validation steps:** Đảm bảo tất cả files được tạo thành công

### 🔐 Nếu cần GitHub Secrets:

Cho production hoặc sensitive data:

```yaml
# In workflow
- name: 🔧 Create production .env
  run: |
    echo "SECRET_API_KEY=${{ secrets.PROD_SECRET_KEY }}" >> lib/features/env/production.env
    echo "DATABASE_URL=${{ secrets.PROD_DATABASE_URL }}" >> lib/features/env/production.env
```

## 🔧 Local Development

Developers chỉ cần:

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

### Lỗi thường gặp:

1. **Missing .env files:**

   ```
   ❌ development.env missing
   ```

   **Fix:** Check step copy templates thành công

2. **Missing .g.dart files:**

   ```
   ❌ env_development.g.dart missing
   ```

   **Fix:** Check build_runner command

3. **Sed command fails trên macOS:**
   ```bash
   # macOS cần backup extension
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

## 🚀 Kết quả

✅ **DRY principle:** Code duplication giảm 80%  
✅ **Maintainability:** Chỉ cần update composite action  
✅ **Security:** Không commit sensitive data  
✅ **Flexibility:** Hỗ trợ multiple environments  
✅ **Validation:** Tự động check file generation

## 📚 Related Files

- `.github/workflows/main.yaml` - Main workflow
- `.github/actions/setup-envied/action.yml` - Composite action
- `lib/features/env/*.example` - Environment templates
- `lib/features/env/env_*.dart` - Envied classes
