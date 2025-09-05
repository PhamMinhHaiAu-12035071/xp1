/// Interface for platform locale detection to enable testability.
///
/// Following Linus principle: "Bad programmers worry about the code.
/// Good programmers worry about data structures and their relationships."
///
/// This interface abstracts platform-specific locale detection to enable
/// dependency injection and testing without platform dependencies.
abstract class PlatformLocaleProvider {
  /// Get system locale code from the platform.
  String getSystemLocale();

  /// Get list of supported locales for validation.
  ///
  /// This eliminates the one_member_abstracts lint warning by providing
  /// a meaningful second method instead of ignoring the rule like a coward.
  List<String> getSupportedLocales();
}
