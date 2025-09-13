/// Route constants for the application navigation.
///
/// Abstract final class approach with inheritance prevention.
/// Note: This approach goes against Dart best practices but provides
/// a namespace for route constants while preventing inheritance.
library;

/// Route constants using abstract final class pattern.
///
/// This class cannot be instantiated or extended, providing a namespace
/// for route constants while preventing inheritance.
///
/// Usage:
/// - For top-level routes: `path: '/${RouteConstants.login}'`
/// - For nested routes: `path: RouteConstants.home`
/// - For programmatic navigation: `context.router.pushNamed('/${RouteConstants.login}')`
abstract final class RouteConstants {
  // Private constructor to prevent instantiation
  const RouteConstants._();

  /// Splash route path.
  static const String splash = 'splash';

  /// Login route path.
  static const String login = 'login';

  /// Forgot password route path.
  static const String forgotPassword = 'forgot-password';

  /// Main navigation route path.
  static const String mainWrapper = 'main';

  /// Home route path.
  static const String home = 'home';

  /// Statistics route path.
  static const String statistics = 'statistics';

  /// Attendance route path.
  static const String attendance = 'attendance';

  /// Features route path.
  static const String features = 'features';

  /// Profile route path.
  static const String profile = 'profile';
}
