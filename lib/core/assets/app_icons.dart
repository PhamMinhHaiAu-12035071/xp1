/// Abstract contract for SVG icon paths following codebase DI pattern.
///
/// This abstract class enables dependency injection and mocking in tests,
/// following the same pattern as AppImages for 100% test coverage.
abstract class AppIcons {
  // UI Navigation Icons
  /// Back arrow navigation icon path
  String get arrowBack;

  /// Search functionality icon path
  String get search;

  /// Menu hamburger icon path
  String get menu;

  /// Notification bell icon path
  String get notification;

  /// Close X icon path
  String get close;

  // Status Icons
  /// Success checkmark icon path
  String get success;

  /// Error warning icon path
  String get error;

  /// Warning alert icon path
  String get warning;

  /// Information icon path
  String get info;

  // Action Icons
  /// Edit pencil icon path
  String get edit;

  /// Delete trash icon path
  String get delete;

  /// Add plus icon path
  String get add;

  /// Filter funnel icon path
  String get filter;

  // Brand Assets
  /// Company logo icon path
  String get logo;

  /// Company logo with text path
  String get logoText;

  // Critical icons for preloading
  /// List of critical SVG icon paths for preloading
  List<String> get criticalIcons;

  /// Standard icon size constants for consistency
  IconSizeConstants get iconSizes;
}

/// Icon size constants for consistent sizing
class IconSizeConstants {
  /// Creates icon size constants.
  const IconSizeConstants();

  /// Small icon size (16px)
  double get small => 16;

  /// Medium icon size (24px) - default size
  double get medium => 24;

  /// Large icon size (32px)
  double get large => 32;

  /// Extra large icon size (48px)
  double get xLarge => 48;
}
