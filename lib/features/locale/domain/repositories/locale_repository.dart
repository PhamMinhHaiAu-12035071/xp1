import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';

/// Repository interface for locale persistence and retrieval.
///
/// Following DDD Repository pattern, this interface defines the contract
/// for locale data access without exposing implementation details.
/// As Eric Evans states: "Repositories encapsulate the logic needed to obtain
/// object references and eliminate duplication of infrastructure code."
abstract class LocaleRepository {
  /// Retrieves the currently saved locale configuration.
  ///
  /// Returns null if no locale has been previously saved.
  /// Implementations should handle storage errors gracefully.
  Future<LocaleConfiguration?> getCurrentLocale();

  /// Saves the given locale configuration for future use.
  ///
  /// This persists the user's locale preference across app sessions.
  /// Implementations should handle storage failures appropriately.
  Future<void> saveLocale(LocaleConfiguration configuration);

  /// Clears any saved locale configuration.
  ///
  /// This forces the app to re-detect locale on next startup.
  /// Useful for testing or reset functionality.
  Future<void> clearSavedLocale();

  /// Checks if a locale configuration has been previously saved.
  ///
  /// This is a convenience method that can be optimized by implementations
  /// to avoid loading the full configuration when only existence matters.
  Future<bool> hasExistingLocale();
}
