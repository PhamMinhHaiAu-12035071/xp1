/// Application-wide constants following Clean Code principles.
///
/// Centralizes magic strings and values to eliminate scattered literals
/// throughout the codebase. As Linus says: "Good taste eliminates
/// special cases."
library;

/// Locale-related constants for consistent storage and configuration.
abstract final class LocaleConstants {
  /// SharedPreferences key for storing user's selected locale.
  static const String localeStorageKey = 'app_locale';

  /// Default fallback locale when system locale is not supported.
  static const String defaultLocaleCode = 'vi';

  /// Maximum time to wait for locale initialization during bootstrap.
  static const Duration initializationTimeout = Duration(seconds: 2);
}

/// Test-related constants to eliminate magic numbers in test code.
abstract final class TestConstants {
  /// Standard timeout for widget tests to prevent hanging.
  static const Duration widgetTestTimeout = Duration(seconds: 3);

  /// Frame pump interval for controlled UI testing.
  static const Duration framePumpInterval = Duration(milliseconds: 100);

  /// Maximum frames to pump before considering test complete.
  static const int maxFramesToPump = 30;
}

/// Bootstrap and dependency injection constants.
abstract final class BootstrapConstants {
  /// Maximum time allowed for dependency injection setup.
  static const Duration dependencySetupTimeout = Duration(seconds: 5);

  /// Environment configuration check timeout.
  static const Duration environmentCheckTimeout = Duration(seconds: 1);
}
