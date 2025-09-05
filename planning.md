## Bước 1: Cài đặt Dependencies

Cập nhật `pubspec.yaml` với slang packages (giữ nguyên categories hiện có):

```yaml
dependencies:
  # === CORE FRAMEWORK ===
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # === INTERNATIONALIZATION ===
  slang: <latest_version> # Type-safe i18n solution
  slang_flutter: <latest_version> # Flutter integration for slang

  # === PERSISTENCE ===
  shared_preferences: <latest_version> # For locale persistence

  # ... các dependencies khác giữ nguyên

dev_dependencies:
  # === CODE GENERATION ===
  # NOTE: Remove build_runner if using slang CLI as primary generator
  # Only keep if needed for other code generation
  slang_build_runner: <latest_version> # Generator for slang (if using build_runner)


  # ... các dev_dependencies khác giữ nguyên
```

**Auto-upgrade và conflict checking:**

```bash
# 1. Upgrade to latest compatible versions
dart pub upgrade --major-versions

# 2. Check for dependency conflicts
dart pub deps --style=tree

# 3. Verify no conflicts exist
make deps-check  # Will be added to Makefile

# 4. Test with upgraded dependencies
make test
```

## Bước 2: Cấu trúc Thư mục và Cleanup

Cập nhật cấu trúc `lib/l10n/` hiện có:

```
lib/l10n/
├── i18n/                    # Mới - thay thế arb/
│   ├── en.i18n.json        # Base locale (English)
│   └── vi.i18n.json        # Vietnamese locale
├── gen/                     # Đã có - sẽ update với slang output
│   └── strings.g.dart      # Generated bởi slang (thay thế app_localizations.dart)
└── l10n.dart               # Đã có - sẽ update export slang
```

**Cleanup Tasks:**

- Remove `lib/l10n/arb/` directory và files
- Remove `l10n.yaml` configuration file
- Remove generated files cũ trong `lib/l10n/gen/`
- **Remove old ARB l10n tests**: `test/l10n/` nếu có tests cho app_localizations cũ
- Update test imports và references từ app_localizations sang slang

**Automated Cleanup Script:**

Tạo file `scripts/cleanup_l10n.sh`:

```bash
#!/bin/bash
set -e

echo "🧹 Cleaning up old l10n implementation..."

# 1. Remove ARB files with git tracking
git rm -rf lib/l10n/arb/ 2>/dev/null || rm -rf lib/l10n/arb/

# 2. Remove old configuration
git rm l10n.yaml 2>/dev/null || rm -f l10n.yaml

# 3. Remove old generated files
rm -f lib/l10n/gen/app_localizations*.dart

# 4. Find and display AppLocalizations references
echo "📋 Found AppLocalizations references in tests:"
grep -r "AppLocalizations" test/ || echo "No references found"

# 5. Clean build artifacts
flutter clean

echo "✅ Cleanup completed. Review the grep output above and manually update test files."
```

**Test Migration Guide:**

1. **Find all references:**

```bash
# Search for AppLocalizations usage
grep -r "AppLocalizations" test/
grep -r "app_localizations" test/
```

2. **Update import statements:**

```dart
// ❌ Old imports
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ✅ New imports
import 'package:xp1/l10n/gen/strings.g.dart';
```

3. **Update test setup:**

```dart
// ❌ Old test setup
await tester.pumpWidget(MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
));

// ✅ New test setup
await tester.pumpWidget(TranslationProvider(
  child: MaterialApp(
    locale: TranslationProvider.of(context).flutterLocale,
    supportedLocales: AppLocaleUtils.supportedLocales,
    // ...
  ),
));
```

4. **Update text references:**

```dart
// ❌ Old usage
AppLocalizations.of(context)!.helloWorld

// ✅ New usage
t.pages.home.helloWorld
```

**Test Cleanup (TDD Approach):**

- Remove tests references đến `AppLocalizations` cũ
- Remove test helpers cho arb localization
- Chuẩn bị test structure mới cho slang với 100% coverage target

## Bước 3: Tạo File Cấu hình

Tạo file `slang.yaml` ở root project (thay thế `l10n.yaml`):

```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: lib/l10n/i18n
input_file_pattern: .i18n.json
output_directory: lib/l10n/gen
output_file_name: strings.g.dart
lazy: true
locale_handling: true
flutter_integration: true
translate_var: t
enum_name: AppLocale
class_name: Translations
translation_class_visibility: private
string_interpolation: dart
flat_map: true
timestamp: true
statistics: true
```

## Bước 4: Tạo Translation Files

**lib/l10n/i18n/en.i18n.json** (Base locale):

```json
{
  "app": {
    "title": "XP1"
  },
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "confirm": "Confirm",
    "loading": "Loading...",
    "error": "Something went wrong",
    "success": "Operation completed successfully",
    "apple(count)": "{count, plural, =0{no apples} =1{1 apple} other{{count} apples}}"
  },
  "auth": {
    "login": "Login",
    "loginButton": "Login",
    "logout": "Logout",
    "welcome": "Welcome to XP1",
    "welcomeUser(rich)": "Welcome <b>{name}</b>! Please ${clickHere(click here)} to continue."
  },
  "navigation": {
    "home": "Home",
    "statistics": "Statistics",
    "attendance": "Attendance",
    "features": "Features",
    "profile": "Profile"
  },
  "pages": {
    "login": {
      "title": "Login",
      "welcomeMessage": "Welcome to {pageName}",
      "instruction": "Please enter your credentials to access the application",
      "forgotPassword": "Forgot your password?"
    },
    "home": {
      "title": "Home",
      "welcomeMessage": "Welcome to {pageName}",
      "todayStats": "Today's Overview",
      "quickActions": "Quick Actions"
    },
    "statistics": {
      "title": "Statistics",
      "welcomeMessage": "Welcome to {pageName}",
      "viewReport": "View detailed report",
      "exportData": "Export data"
    },
    "attendance": {
      "title": "Attendance",
      "welcomeMessage": "Welcome to {pageName}",
      "checkIn": "Check In",
      "checkOut": "Check Out",
      "currentStatus": "Current Status: {status}"
    },
    "features": {
      "title": "Features",
      "welcomeMessage": "Welcome to {pageName}",
      "availableFeatures": "Available Features",
      "comingSoon": "Coming Soon"
    },
    "profile": {
      "title": "Profile",
      "welcomeMessage": "Welcome to {pageName}",
      "editProfile": "Edit Profile",
      "settings": "Settings",
      "preferences": "Preferences"
    }
  },
  "settings": {
    "language": "Language",
    "chooseLanguage": "Choose your preferred language",
    "systemDefault": "System Default"
  }
}
```

**lib/l10n/i18n/vi.i18n.json** (Vietnamese):

```json
{
  "app": {
    "title": "XP1"
  },
  "common": {
    "save": "Lưu",
    "cancel": "Hủy",
    "confirm": "Xác nhận",
    "loading": "Đang tải...",
    "error": "Có lỗi xảy ra",
    "success": "Thao tác thành công",
    "apple(count)": "{count, plural, =0{không có táo} =1{1 quả táo} other{{count} quả táo}}"
  },
  "auth": {
    "login": "Đăng nhập",
    "loginButton": "Đăng nhập",
    "logout": "Đăng xuất",
    "welcome": "Chào mừng đến với XP1",
    "welcomeUser(rich)": "Chào mừng <b>{name}</b>! Vui lòng ${clickHere(nhấn vào đây)} để tiếp tục."
  },
  "navigation": {
    "home": "Trang chủ",
    "statistics": "Thống kê",
    "attendance": "Chấm công",
    "features": "Tính năng",
    "profile": "Hồ sơ"
  },
  "pages": {
    "login": {
      "title": "Đăng nhập",
      "welcomeMessage": "Chào mừng đến với {pageName}",
      "instruction": "Vui lòng nhập thông tin đăng nhập để truy cập ứng dụng",
      "forgotPassword": "Quên mật khẩu?"
    },
    "home": {
      "title": "Trang chủ",
      "welcomeMessage": "Chào mừng đến với {pageName}",
      "todayStats": "Tổng quan hôm nay",
      "quickActions": "Thao tác nhanh"
    },
    "statistics": {
      "title": "Thống kê",
      "welcomeMessage": "Chào mừng đến với {pageName}",
      "viewReport": "Xem báo cáo chi tiết",
      "exportData": "Xuất dữ liệu"
    },
    "attendance": {
      "title": "Chấm công",
      "welcomeMessage": "Chào mừng đến với {pageName}",
      "checkIn": "Check In",
      "checkOut": "Check Out",
      "currentStatus": "Trạng thái hiện tại: {status}"
    },
    "features": {
      "title": "Tính năng",
      "welcomeMessage": "Chào mừng đến với {pageName}",
      "availableFeatures": "Tính năng có sẵn",
      "comingSoon": "Sắp ra mắt"
    },
    "profile": {
      "title": "Hồ sơ",
      "welcomeMessage": "Chào mừng đến với {pageName}",
      "editProfile": "Chỉnh sửa hồ sơ",
      "settings": "Cài đặt",
      "preferences": "Tùy chọn"
    }
  },
  "settings": {
    "language": "Ngôn ngữ",
    "chooseLanguage": "Chọn ngôn ngữ ưa thích",
    "systemDefault": "Mặc định hệ thống"
  }
}
```

## Bước 5: Generate Code

Chạy lệnh để generate code (theo Makefile hiện có):

```bash
# Sử dụng slang CLI (recommended)
fvm dart run slang

# Hoặc sử dụng build_runner như project hiện tại
fvm dart run build_runner build --delete-conflicting-outputs

# Sau khi generate, format và analyze
make format
make analyze

# Check dependencies conflict
fvm dart pub deps --style=tree
```

## Bước 6: Setup trong Main App

**Cập nhật lib/app/view/app.dart** (giữ nguyên cấu trúc hiện có):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/l10n.dart'; // Sẽ export slang
import 'package:xp1/l10n/gen/strings.g.dart'; // Slang generated
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// Main application widget with Material theme and localization setup.
class App extends StatelessWidget {
  /// Creates app widget.
  const App({super.key});

  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          final locale = TranslationProvider.of(context).flutterLocale;
          Logger.log('Locale changed to ${locale.languageCode}');
          return MaterialApp.router(
            title: t.app.title, // Sử dụng slang translation
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            locale: locale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _appRouter.config(),
          );
        },
      ),
    );
  }
}
```

**Cập nhật bootstrap với Locale Persistence:**

```dart
// Trong lib/bootstrap.dart
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

void setupBootstrap() async {
  // Initialize locale with persistence
  await _initializeLocale();

  // ... existing setup code
}

Future<void> _initializeLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale');

  AppLocale targetLocale;

  if (savedLocale != null) {
    // Use saved preference
    targetLocale = AppLocale.values.firstWhere(
      (locale) => locale.languageCode == savedLocale,
      orElse: () => _getSystemLocale(),
    );
  } else {
    // First run: use system locale with fallback
    targetLocale = _getSystemLocale();
    await prefs.setString('app_locale', targetLocale.languageCode);
  }

  LocaleSettings.setLocale(targetLocale);
}

AppLocale _getSystemLocale() {
  final systemLocale = Platform.localeName.split('_').first;

  // Check if system locale is supported
  for (final locale in AppLocale.values) {
    if (locale.languageCode == systemLocale) {
      return locale;
    }
  }

  // Fallback to English if system locale not supported
  return AppLocale.en;
}

// Utility function for manual locale switching
Future<void> switchLocale(AppLocale locale) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('app_locale', locale.languageCode);
  LocaleSettings.setLocale(locale);
}
```

**State Management Integration (if using Riverpod/Bloc):**

```dart
// lib/core/providers/locale_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

class LocaleNotifier extends StateNotifier<AppLocale> {
  LocaleNotifier() : super(AppLocale.en) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('app_locale');

    if (savedLocale != null) {
      final locale = AppLocale.values.firstWhere(
        (l) => l.languageCode == savedLocale,
        orElse: () => AppLocale.en,
      );
      state = locale;
      LocaleSettings.setLocale(locale);
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.languageCode);
    state = locale;
    LocaleSettings.setLocale(locale);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLocale>(
  (ref) => LocaleNotifier(),
);
```

**Lợi ích của Persistent Locale Management:**

- ✅ User preference persistence across app restarts
- ✅ System locale fallback for better UX
- ✅ State management integration for reactive UI
- ✅ Manual control for testing (via switchLocale function)
- ✅ Consistent behavior across devices

## Bước 7: Cập nhật Pages với Slang

**lib/features/authentication/presentation/pages/login_page.dart**:

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Login page for user authentication.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a login page.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.login.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.pages.login.welcomeMessage(pageName: t.pages.login.title),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              t.pages.login.instruction,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.router.replaceAll([
                  const MainWrapperRoute(),
                ]);
              },
              child: Text(t.auth.loginButton),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Handle forgot password
              },
              child: Text(t.pages.login.forgotPassword),
            ),
          ],
        ),
      ),
    );
  }
}
```

**lib/features/main_navigation/presentation/pages/main_wrapper_page.dart**:

```dart
// Cập nhật NavTabConfig để sử dụng translations
static List<NavTabConfig> get _navTabs => [
  NavTabConfig(
    route: const HomeRoute(),
    icon: Icons.home,
    label: t.navigation.home,
  ),
  NavTabConfig(
    route: const StatisticsRoute(),
    icon: Icons.analytics,
    label: t.navigation.statistics,
  ),
  NavTabConfig(
    route: const AttendanceRoute(),
    icon: Icons.access_time,
    label: t.navigation.attendance,
  ),
  NavTabConfig(
    route: const FeaturesRoute(),
    icon: Icons.apps,
    label: t.navigation.features,
  ),
  NavTabConfig(
    route: const ProfileRoute(),
    icon: Icons.person,
    label: t.navigation.profile,
  ),
];
```

**lib/features/home/presentation/pages/home_page.dart** (cleaned up):

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Home page showing main dashboard content.
@RoutePage()
class HomePage extends StatelessWidget {
  /// Creates a home page.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.home.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.pages.home.welcomeMessage(pageName: t.pages.home.title),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      t.pages.home.todayStats,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.pages.home.quickActions,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**lib/features/settings/presentation/pages/settings_page.dart** (new file for locale switching):

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp1/core/providers/locale_provider.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Settings page with language selection.
@RoutePage()
class SettingsPage extends ConsumerWidget {
  /// Creates a settings page.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.profile.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t.settings.language),
            subtitle: Text(t.settings.chooseLanguage),
            trailing: DropdownButton<AppLocale>(
              value: currentLocale,
              onChanged: (locale) {
                if (locale != null) {
                  ref.read(localeProvider.notifier).setLocale(locale);
                }
              },
              items: [
                for (final locale in AppLocale.values)
                  DropdownMenuItem(
                    value: locale,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_getLocaleFlag(locale)),
                        const SizedBox(width: 8),
                        Text(_getLocaleName(locale)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLocaleFlag(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        return '🇺🇸';
      case AppLocale.vi:
        return '🇻🇳';
    }
  }

  String _getLocaleName(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        return 'English';
      case AppLocale.vi:
        return 'Tiếng Việt';
    }
  }
}
```

**Testing Approach cho Manual Locale:**

```dart
// 1. Test English (trong bootstrap.dart)
LocaleSettings.setLocale(AppLocale.en);
// Expected: UI shows "Hello World - Home", "English" navigation

// 2. Test Vietnamese (trong bootstrap.dart)
LocaleSettings.setLocale(AppLocale.vi);
// Expected: UI shows "Xin chào - Trang chủ", "Tiếng Việt" navigation

// 3. Runtime switching (trong HomePage widget)
setState(() {
  LocaleSettings.setLocale(AppLocale.vi);
});
// Expected: UI updates immediately to Vietnamese
```

## Bước 8: Update lib/l10n/l10n.dart Export

Cập nhật file export để sử dụng slang:

```dart
// lib/l10n/l10n.dart
export 'package:xp1/l10n/gen/strings.g.dart';
```

## Bước 9: Cleanup ARB Files và Configuration

**Xóa các file cũ (theo Makefile workflow):**

```bash
# 1. Clean build files first
make clean

# 2. Remove arb files
rm -rf lib/l10n/arb/

# 3. Remove generated files cũ
rm lib/l10n/gen/app_localizations*.dart

# 4. Remove l10n.yaml configuration
rm l10n.yaml

# 5. Install dependencies và setup lại
make deps

# 6. Generate slang files
make i18n-generate

# 7. Verify everything works
make check-all
```

**Automated cleanup (recommended):**

```bash
# 1. Make cleanup script executable
chmod +x scripts/cleanup_l10n.sh

# 2. Run automated cleanup
make cleanup-l10n  # Will be added to Makefile

# 3. Review and manually update remaining test references
# Script will show you what needs manual updates
```

**Manual cleanup (fallback):**

- Delete `lib/l10n/arb/` folder
- Delete `lib/l10n/gen/app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_es.dart` (nếu có)
- Delete `l10n.yaml` file
- Remove any existing test files cho ARB localization
- Clean up imports trong test files reference đến old AppLocalizations

## Bước 10: Setup iOS Configuration

Cập nhật supported locales trong **ios/Runner/Info.plist**:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>vi</string>
</array>
```

## Bước 11: Update Build Scripts

**Cập nhật Makefile để support slang (add to existing Makefile):**

```makefile
# ... existing targets

.PHONY: i18n-generate
i18n-generate: ## Generate translations using slang
	@echo "🌐 Generating translations..."
	@fvm dart run slang
	@make format

.PHONY: i18n-watch
i18n-watch: ## Watch translation files for changes
	@echo "👀 Watching translation files..."
	@fvm dart run slang watch

.PHONY: i18n-build
i18n-build: ## Generate translations with build_runner
	@echo "🏗️ Building translations with build_runner..."
	@fvm dart run build_runner build --delete-conflicting-outputs
	@make format

.PHONY: i18n-analyze
i18n-analyze: ## Analyze translations using slang
	@echo "🔍 Analyzing translations..."
	@fvm dart run slang analyze

.PHONY: i18n-clean
i18n-clean: ## Clean unused translation keys
	@echo "🧹 Cleaning unused translation keys..."
	@fvm dart run slang clean

.PHONY: i18n-normalize
i18n-normalize: ## Normalize translation file ordering
	@echo "📝 Normalizing translation files..."
	@fvm dart run slang normalize

.PHONY: i18n-stats
i18n-stats: ## Show translation statistics
	@echo "📊 Translation statistics..."
	@fvm dart run slang stats

.PHONY: cleanup-l10n
cleanup-l10n: ## Clean up old l10n implementation
	@echo "🧹 Running automated l10n cleanup..."
	@chmod +x scripts/cleanup_l10n.sh
	@./scripts/cleanup_l10n.sh

.PHONY: deps-check
deps-check: ## Check for dependency conflicts
	@echo "🔍 Checking dependencies..."
	@fvm dart pub deps --style=tree

.PHONY: i18n-check
i18n-check: ## Complete i18n validation (analyze + clean + stats)
	@echo "✅ Running complete i18n validation..."
	@make i18n-analyze
	@make i18n-clean
	@make i18n-stats
```

**Pre-commit Hook Integration:**

Update `lefthook.yml` to include i18n validation:

```yaml
# Add to existing lefthook.yml
pre-commit:
  parallel: true
  commands:
    # ... existing commands
    i18n-check:
      glob: "lib/l10n/i18n/*.json"
      run: make i18n-analyze && make i18n-clean
      stage_fixed: true
```

**Manual Testing Commands:**

```bash
# Generate translations
make i18n-generate

# Watch for changes (development)
make i18n-watch

# Build with code generation
make i18n-build

# Clean unused keys
make i18n-clean

# Normalize file ordering
make i18n-normalize

# View statistics
make i18n-stats

# Complete validation
make i18n-check

# Check dependencies
make deps-check
```

## Bước 12: Các Lệnh CLI Hữu ích (theo Makefile)

```bash
# === SLANG COMMANDS ===
# Generate translations (with formatting)
make i18n-generate

# Watch for changes (development mode)
make i18n-watch

# Build with full code generation
make i18n-build

# Analyze translations
make i18n-analyze

# Clean unused keys
make i18n-clean

# Normalize file ordering
make i18n-normalize

# View statistics
make i18n-stats

# Complete validation (analyze + clean + stats)
make i18n-check

# Cleanup old l10n implementation
make cleanup-l10n

# Check dependencies
make deps-check

# Direct slang commands
fvm dart run slang                    # Generate
fvm dart run slang watch             # Watch mode
fvm dart run slang analyze           # Analyze missing/unused
fvm dart run slang clean             # Clean unused
fvm dart run slang normalize         # Normalize order
fvm dart run slang stats             # Statistics

# === DEVELOPMENT WORKFLOW ===
# Quick check (format + analyze)
make check

# Complete check (format + analyze + deps + licenses)
make check-all

# Format code
make format

# Analyze code
make analyze

# Install dependencies
make deps

# === TESTING COMMANDS ===
# Run all tests with 100% coverage requirement
make test

# Run tests with coverage report
make coverage

# BDD tests only (reliable for large test suites)
make bdd-coverage

# Clean coverage files
make coverage-clean
```

**Manual Locale Testing Workflow:**

```bash
# 1. Generate translations
make i18n-generate

# 2. Test English (default)
# In bootstrap.dart: LocaleSettings.setLocale(AppLocale.en);
make run-dev

# 3. Test Vietnamese
# In bootstrap.dart: LocaleSettings.setLocale(AppLocale.vi);
make run-dev

# 4. Run tests để verify
make test
```

## Bước 13: Testing Slang Implementation (TDD Approach - 100% Coverage)

**TDD Red-Green-Refactor Pattern:**

1. **Red**: Write failing tests first
2. **Green**: Implement minimum code to pass
3. **Refactor**: Improve code while keeping tests green

**test/l10n/slang_test.dart** (Complete coverage for localization):

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

void main() {
  group('Slang Localization - TDD Coverage', () {
    late Translations enTranslations;
    late Translations viTranslations;

    setUpAll(() {
      // Initialize translations for all tests
      enTranslations = AppLocale.en.build();
      viTranslations = AppLocale.vi.build();
    });

    group('App Titles', () {
      test('should have correct app title for all locales', () {
        expect(enTranslations.app.title, 'XP1');
        expect(viTranslations.app.title, 'XP1');
      });
    });

    group('Common Translations', () {
      test('should have all common action translations', () {
        // English
        expect(enTranslations.common.save, 'Save');
        expect(enTranslations.common.cancel, 'Cancel');
        expect(enTranslations.common.confirm, 'Confirm');
        expect(enTranslations.common.loading, 'Loading...');
        expect(enTranslations.common.error, 'Something went wrong');
        expect(enTranslations.common.success, 'Operation completed successfully');

        // Vietnamese
        expect(viTranslations.common.save, 'Lưu');
        expect(viTranslations.common.cancel, 'Hủy');
        expect(viTranslations.common.confirm, 'Xác nhận');
        expect(viTranslations.common.loading, 'Đang tải...');
        expect(viTranslations.common.error, 'Có lỗi xảy ra');
        expect(viTranslations.common.success, 'Thao tác thành công');
      });

      test('should handle pluralization correctly for all edge cases', () {
        // English pluralization edge cases
        expect(enTranslations.common.apple(0), 'no apples');
        expect(enTranslations.common.apple(1), '1 apple');
        expect(enTranslations.common.apple(2), '2 apples');
        expect(enTranslations.common.apple(10), '10 apples');
        expect(enTranslations.common.apple(100), '100 apples');
        expect(enTranslations.common.apple(1001), '1001 apples');

        // Vietnamese pluralization (no plural forms)
        expect(viTranslations.common.apple(0), 'không có táo');
        expect(viTranslations.common.apple(1), '1 quả táo');
        expect(viTranslations.common.apple(2), '2 quả táo');
        expect(viTranslations.common.apple(10), '10 quả táo');
        expect(viTranslations.common.apple(100), '100 quả táo');
        expect(viTranslations.common.apple(1001), '1001 quả táo');
      });
    });

    group('Navigation Labels', () {
      test('should have correct navigation labels - English', () {
        expect(enTranslations.navigation.home, 'Home');
        expect(enTranslations.navigation.statistics, 'Statistics');
        expect(enTranslations.navigation.attendance, 'Attendance');
        expect(enTranslations.navigation.features, 'Features');
        expect(enTranslations.navigation.profile, 'Profile');
      });

      test('should have correct navigation labels - Vietnamese', () {
        expect(viTranslations.navigation.home, 'Trang chủ');
        expect(viTranslations.navigation.statistics, 'Thống kê');
        expect(viTranslations.navigation.attendance, 'Chấm công');
        expect(viTranslations.navigation.features, 'Tính năng');
        expect(viTranslations.navigation.profile, 'Hồ sơ');
      });
    });

    group('Authentication Translations', () {
      test('should have auth translations for all locales', () {
        // English
        expect(enTranslations.auth.login, 'Login');
        expect(enTranslations.auth.loginButton, 'Login');
        expect(enTranslations.auth.logout, 'Logout');
        expect(enTranslations.auth.welcome, 'Welcome to XP1');

        // Vietnamese
        expect(viTranslations.auth.login, 'Đăng nhập');
        expect(viTranslations.auth.loginButton, 'Đăng nhập');
        expect(viTranslations.auth.logout, 'Đăng xuất');
        expect(viTranslations.auth.welcome, 'Chào mừng đến với XP1');
      });
    });

    group('Page Titles and Content', () {
      test('should have all page titles - English', () {
        expect(enTranslations.pages.login.title, 'Login');
        expect(enTranslations.pages.home.title, 'Home');
        expect(enTranslations.pages.statistics.title, 'Statistics');
        expect(enTranslations.pages.attendance.title, 'Attendance');
        expect(enTranslations.pages.features.title, 'Features');
        expect(enTranslations.pages.profile.title, 'Profile');
      });

      test('should have all page titles - Vietnamese', () {
        expect(viTranslations.pages.login.title, 'Đăng nhập');
        expect(viTranslations.pages.home.title, 'Trang chủ');
        expect(viTranslations.pages.statistics.title, 'Thống kê');
        expect(viTranslations.pages.attendance.title, 'Chấm công');
        expect(viTranslations.pages.features.title, 'Tính năng');
        expect(viTranslations.pages.profile.title, 'Hồ sơ');
      });

      test('should have parameterized welcome messages for all pages', () {
        // English
        expect(
          enTranslations.pages.login.welcomeMessage(pageName: 'Test Page'),
          'Welcome to Test Page',
        );
        expect(
          enTranslations.pages.home.welcomeMessage(pageName: 'Home'),
          'Welcome to Home',
        );

        // Vietnamese
        expect(
          viTranslations.pages.login.welcomeMessage(pageName: 'Trang Test'),
          'Chào mừng đến với Trang Test',
        );
        expect(
          viTranslations.pages.home.welcomeMessage(pageName: 'Trang chủ'),
          'Chào mừng đến với Trang chủ',
        );
      });

      test('should have page-specific content - English', () {
        expect(enTranslations.pages.login.instruction,
               'Please enter your credentials to access the application');
        expect(enTranslations.pages.login.forgotPassword, 'Forgot your password?');
        expect(enTranslations.pages.home.todayStats, "Today's Overview");
        expect(enTranslations.pages.home.quickActions, 'Quick Actions');
        expect(enTranslations.pages.attendance.checkIn, 'Check In');
        expect(enTranslations.pages.attendance.checkOut, 'Check Out');
      });

      test('should have page-specific content - Vietnamese', () {
        expect(viTranslations.pages.login.instruction,
               'Vui lòng nhập thông tin đăng nhập để truy cập ứng dụng');
        expect(viTranslations.pages.login.forgotPassword, 'Quên mật khẩu?');
        expect(viTranslations.pages.home.todayStats, 'Tổng quan hôm nay');
        expect(viTranslations.pages.home.quickActions, 'Thao tác nhanh');
        expect(viTranslations.pages.attendance.checkIn, 'Check In');
        expect(viTranslations.pages.attendance.checkOut, 'Check Out');
      });
    });

    group('Rich Text Support', () {
      test('should handle rich text with parameters', () {
        // Note: Actual rich text rendering would need to be tested in widget tests
        // Here we test that the function exists and returns expected content
        final englishRichText = enTranslations.auth.welcomeUser(
          name: 'John',
          clickHere: (text) => '[$text]', // Mock link function
        );
        expect(englishRichText, contains('Welcome'));
        expect(englishRichText, contains('John'));
        expect(englishRichText, contains('[click here]'));

        final vietnameseRichText = viTranslations.auth.welcomeUser(
          name: 'Anh',
          clickHere: (text) => '[$text]', // Mock link function
        );
        expect(vietnameseRichText, contains('Chào mừng'));
        expect(vietnameseRichText, contains('Anh'));
        expect(vietnameseRichText, contains('[nhấn vào đây]'));
      });
    });

    group('Settings Translations', () {
      test('should have settings translations for all locales', () {
        // English
        expect(enTranslations.settings.language, 'Language');
        expect(enTranslations.settings.chooseLanguage, 'Choose your preferred language');
        expect(enTranslations.settings.systemDefault, 'System Default');

        // Vietnamese
        expect(viTranslations.settings.language, 'Ngôn ngữ');
        expect(viTranslations.settings.chooseLanguage, 'Chọn ngôn ngữ ưa thích');
        expect(viTranslations.settings.systemDefault, 'Mặc định hệ thống');
      });
    });

    group('Locale Support', () {
    test('all locales should be supported by Flutter', () {
      for (final locale in AppLocale.values) {
        expect(
          kMaterialSupportedLanguages,
          contains(locale.languageCode),
            reason: 'Locale ${locale.languageCode} should be supported by Flutter',
        );
      }
    });

      test('should have exactly 2 supported locales', () {
        expect(AppLocale.values.length, 2);
        expect(AppLocale.values, contains(AppLocale.en));
        expect(AppLocale.values, contains(AppLocale.vi));
      });
    });

    group('LocaleSettings', () {
      test('should initialize with correct default locale', () {
        LocaleSettings.setLocale(AppLocale.en);
        expect(LocaleSettings.currentLocale, AppLocale.en);

        LocaleSettings.setLocale(AppLocale.vi);
        expect(LocaleSettings.currentLocale, AppLocale.vi);
      });
    });

    group('Error Cases', () {
      test('should throw on missing key', () {
        expect(
          () => enTranslations.missingKey,
          throwsA(isA<MissingTranslationException>()),
        );
      });

      test('should handle edge cases gracefully', () {
        // Test with null parameters (if applicable)
        expect(
          () => enTranslations.pages.attendance.currentStatus(status: ''),
          returnsNormally,
        );

        // Test with very long parameters
        final longStatus = 'A' * 1000;
        expect(
          () => enTranslations.pages.attendance.currentStatus(status: longStatus),
          returnsNormally,
        );
      });
    });
  });
}
```

**BDD Feature Examples:**

Create `test/bdd/locale_switching.feature`:

```gherkin
Feature: Locale Switching
  As a user
  I want to switch between languages
  So that I can use the app in my preferred language

  Background:
    Given the app is launched

  Scenario: Switch to Vietnamese
    Given I am on the home page
    And the interface is in English
    When I navigate to settings
    And I select Vietnamese language
    Then the interface should change to Vietnamese
    And the navigation should show "Trang chủ" instead of "Home"

  Scenario: Switch to English
    Given I am on the home page
    And the interface is in Vietnamese
    When I navigate to settings
    And I select English language
    Then the interface should change to English
    And the navigation should show "Home" instead of "Trang chủ"

  Scenario: Language persistence
    Given I have set the language to Vietnamese
    When I restart the app
    Then the interface should still be in Vietnamese

  Scenario: System locale fallback
    Given I am using the app for the first time
    And my system locale is Vietnamese
    When the app launches
    Then the interface should default to Vietnamese

  Scenario: Unsupported locale fallback
    Given I am using the app for the first time
    And my system locale is French
    When the app launches
    Then the interface should default to English

  Scenario: Pluralization edge cases
    Given I am on a page with item counts
    When I have 0 items
    Then it should display "no items" in English
    And "không có mục" in Vietnamese
    When I have 1 item
    Then it should display "1 item" in English
    And "1 mục" in Vietnamese
    When I have multiple items
    Then it should display "X items" in English
    And "X mục" in Vietnamese
```

**test/l10n/locale_switching_test.dart** (Widget test for locale switching):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

void main() {
  group('Locale Switching Tests', () {
    testWidgets('should update UI when locale changes', (tester) async {
      // Set initial locale
      LocaleSettings.setLocale(AppLocale.en);

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            locale: TranslationProvider.of(tester.element(find.byType(TranslationProvider))).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Text(t.navigation.home),
              ),
            ),
          ),
        ),
      );

      // Should show English text
      expect(find.text('Home'), findsOneWidget);

      // Change to Vietnamese
      LocaleSettings.setLocale(AppLocale.vi);
      await tester.pump();

      // Should show Vietnamese text
      expect(find.text('Trang chủ'), findsOneWidget);
    });
  });
}
```

## Bước 14: Test Coverage Validation

**Chạy test coverage để đảm bảo 100% (sử dụng existing Makefile):**

```bash
# === TDD WORKFLOW ===
# 1. RED: Write failing tests first
make test  # Should fail initially

# 2. GREEN: Generate slang và implement
make i18n-generate
make test  # Should pass

# 3. REFACTOR: Improve code
make format
make analyze
make test  # Should still pass

# === COVERAGE COMMANDS ===
# Run tests with 100% coverage requirement (as per Makefile)
make test

# Complete coverage workflow (tests + HTML report + auto-open)
make coverage

# BDD tests only (reliable for locale switching tests)
make bdd-coverage

# Clean coverage files
make coverage-clean

# Quick development check
make check

# Complete development check
make check-all
```

**Manual Locale Testing Steps:**

```bash
# 1. Test English locale
# Edit lib/bootstrap.dart: LocaleSettings.setLocale(AppLocale.en);
make run-dev
# Verify UI shows English text

# 2. Test Vietnamese locale
# Edit lib/bootstrap.dart: LocaleSettings.setLocale(AppLocale.vi);
make run-dev
# Verify UI shows Vietnamese text

# 3. Run automated tests
make test
# Should pass 100% coverage requirement
```

**Coverage Requirements (100% Target):**

- ✅ All translation keys tested (EN/VI)
- ✅ Manual locale switching tested
- ✅ All navigation labels tested
- ✅ All page content tested
- ✅ Error cases tested
- ✅ Widget integration tested

## Bước 15: Documentation Updates

Sau khi hoàn thành slang integration, cập nhật documentation:

### **CLAUDE.md** Updates:

````markdown
# Translation Commands

## Slang I18n Commands

### Daily Development

```bash
# Generate translations (recommended)
make i18n-generate

# Watch for changes during development
make i18n-watch

# Complete validation before commit
make i18n-check
```
````

### Quality Assurance

```bash
# Analyze missing/unused keys
make i18n-analyze

# Clean unused keys
make i18n-clean

# Normalize file ordering
make i18n-normalize

# View translation statistics
make i18n-stats
```

### Migration & Cleanup

```bash
# Clean up old l10n implementation
make cleanup-l10n

# Check dependency conflicts
make deps-check
```

## Locale Testing

### Manual Testing

```bash
# Test English (edit bootstrap.dart)
LocaleSettings.setLocale(AppLocale.en);
make run-dev

# Test Vietnamese
LocaleSettings.setLocale(AppLocale.vi);
make run-dev
```

### State Management Testing

```bash
# Test with Riverpod provider
ref.read(localeProvider.notifier).setLocale(AppLocale.vi);
```

````

### **doc/core/tech-stack.md** Updates:

Add to Internationalization section:

```markdown
## Internationalization

- **Framework**: Slang v3.1.0+ (Type-safe i18n)
- **Supported Locales**: English (en), Vietnamese (vi)
- **State Management**: Riverpod LocaleNotifier with SharedPreferences persistence
- **Features**:
  - Pluralization support
  - Rich text with parameters
  - System locale fallback
  - Hot-reload friendly development
- **Build Integration**: Makefile targets + lefthook pre-commit validation
````

### **doc/core/development-guidelines.md** Updates:

Add Translation Patterns section:

````markdown
## Translation Patterns

### Basic Usage

```dart
// Simple text
Text(t.common.save)

// Parameterized text
Text(t.pages.home.welcomeMessage(pageName: 'Dashboard'))

// Pluralization
Text(t.common.apple(count))
```
````

### Rich Text (Advanced)

```dart
// Rich text with inline elements
RichText(
  text: TextSpan(
    children: t.auth.welcomeUser(
      name: userName,
      clickHere: (text) => TextSpan(
        text: text,
        style: TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () => handleLink(),
      ),
    ),
  ),
)
```

### Locale Management

```dart
// Get current locale
final currentLocale = LocaleSettings.currentLocale;

// Change locale with persistence
await ref.read(localeProvider.notifier).setLocale(AppLocale.vi);

// Manual locale switching (testing)
await switchLocale(AppLocale.en);
```

### Translation File Structure

```json
{
  "pages": {
    "featureName": {
      "title": "Page Title",
      "welcomeMessage": "Welcome to {pageName}",
      "action": "Action Button"
    }
  }
}
```

````

### **README.md** Updates:

Update supported languages section:

```markdown
## 🌐 Internationalization

This application supports multiple languages:

- 🇺🇸 **English** (Default)
- 🇻🇳 **Vietnamese** (Tiếng Việt)

### Features
- Type-safe translations with Slang
- Automatic pluralization
- Rich text support with parameters
- Persistent language preferences
- System locale fallback

### For Developers
```bash
# Generate translations
make i18n-generate

# Watch for changes
make i18n-watch

# Validate translations
make i18n-check
````

````

### **Version Update Procedures:**

**When upgrading Slang version:**

1. **Update Dependencies:**
```bash
# Update pubspec.yaml
slang: ^X.Y.Z
slang_flutter: ^X.Y.Z
slang_build_runner: ^X.Y.Z  # if using

# Upgrade and check conflicts
dart pub upgrade --major-versions
make deps-check
````

2. **Update Documentation:**

```bash
# Update version references in tech-stack.md
sed -i 's/v[0-9]\+\.[0-9]\+\.[0-9]\+/vX.Y.Z/g' doc/core/tech-stack.md

# Update CLAUDE.md if commands changed
# Check slang changelog for breaking changes
```

3. **Regenerate and Test:**

```bash
# Clean and regenerate
make i18n-clean
make i18n-generate

# Run full test suite
make test

# Test locale switching manually
make run-dev
```

4. **Validate and Commit:**

```bash
# Complete validation
make i18n-check
make check-all

# Update changelog
echo "- Updated Slang to vX.Y.Z" >> CHANGELOG.md

# Commit with conventional format
git add .
git commit -m "feat(i18n): upgrade slang to vX.Y.Z"
```

**Documentation Maintenance Schedule:**

- **After every slang upgrade**: Update version numbers in tech-stack.md
- **After adding new features**: Update development-guidelines.md patterns
- **After changing commands**: Update CLAUDE.md workflow
- **Before major releases**: Review and update README.md examples

## Summary - Migration Checklist

### ✅ Dependencies & Configuration

- [ ] Add slang packages to pubspec.yaml with version pinning
- [ ] Create slang.yaml configuration without unnecessary imports
- [ ] Remove l10n.yaml

### ✅ File Structure

- [ ] Create lib/l10n/i18n/ directory
- [ ] Create en.i18n.json and vi.i18n.json (English và Vietnamese) with plural examples
- [ ] Remove lib/l10n/arb/ directory using git rm
- [ ] Clean generated files in lib/l10n/gen/
- [ ] Remove old ARB l10n tests
- [ ] Migrate tests by replacing AppLocalizations with Translations

### ✅ Code Updates

- [ ] Update lib/l10n/l10n.dart exports
- [ ] Update lib/app/view/app.dart with slang and builder for locale logging
- [ ] Update lib/bootstrap.dart with LocaleSettings
- [ ] Update all pages to use slang translations
- [ ] Update MainWrapperPage navigation labels
- [ ] Move locale switcher to settings page with shared_preferences persistence

### ✅ Testing & Validation (TDD - 100% Coverage với Makefile)

- [ ] **Red Phase**: Write failing tests first (slang_test.dart, locale_switching_test.dart) including negative tests
- [ ] **Green Phase**: Run `make i18n-generate` và implement code với `make test`
- [ ] **Refactor Phase**: Use `make format` and `make analyze` while maintaining test coverage
- [ ] **Manual Testing**: Test English và Vietnamese với bootstrap locale switching
- [ ] **Automated Testing**: Test language switching scenarios với widget tests and BDD features
- [ ] **Coverage Validation**: Run `make coverage` để validate 100% coverage requirement
- [ ] **Quality Checks**: Run `make check-all` để ensure no linting issues
- [ ] **Documentation**: Update documentation per checklist

### ✅ Advanced Features (Optional)

**Rich Text Support:**

```json
{
  "welcome(rich)": "Welcome $name. Please ${clickHere(click here)}!"
}
```

**Custom Contexts:**

```json
{
  "greet(context=GenderContext)": {
    "male": "Hello Mr $name",
    "female": "Hello Ms $name"
  }
}
```

**Namespaces (cho project lớn):**

```yaml
# slang.yaml
namespaces: true
```

---

**🎯 Kết quả:** App sẽ có internationalization production-ready với slang hỗ trợ **tiếng Anh và tiếng Việt**, type-safe translations, persistent locale management, comprehensive test coverage, và tích hợp hoàn hảo với Makefile workflow hiện có.

**🚀 Key Benefits:**

- ✅ **Production-Ready Locale Management**: SharedPreferences persistence with system locale fallback
- ✅ **Enhanced State Management**: Riverpod integration with reactive UI updates
- ✅ **Automated Quality Assurance**: Pre-commit hooks, automated cleanup scripts
- ✅ **Makefile Integration**: Complete command suite (i18n-generate, i18n-watch, i18n-check, deps-check)
- ✅ **Type-safe translations**: Real content with parameterized strings và rich text support
- ✅ **Hot-reload friendly**: Development experience tối ưu với slang watch
- ✅ **Comprehensive Testing**: TDD approach với edge cases, pluralization, BDD scenarios
- ✅ **100% test coverage**: Enforced bởi Makefile requirements với robust validation
- ✅ **Vietnamese language support**: First-class support với proper pluralization
- ✅ **Clean migration**: Automated cleanup scripts với git tracking
- ✅ **Developer Experience**: Dynamic locale switcher, system fallback, persistent preferences
- ✅ **Maintainable Documentation**: Version update procedures và maintenance schedule

**🔧 Development Workflow:**

```bash
# Daily development
make i18n-watch          # Watch translation changes
make run-dev             # Test with manual locale setting
make test                # TDD approach với 100% coverage
make check-all           # Complete quality checks

# Manual locale testing
# Edit bootstrap.dart: LocaleSettings.setLocale(AppLocale.vi);
make run-dev             # Immediate Vietnamese testing
```
