import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/constants/app_constants.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/repositories/locale_repository.dart';

/// SharedPreferences implementation of locale repository.
///
/// This infrastructure class handles the concrete persistence mechanism
/// while keeping the domain layer clean of storage implementation details.
/// Following Dependency Inversion Principle from SOLID.
@LazySingleton(as: LocaleRepository)
class SharedPreferencesLocaleRepository implements LocaleRepository {
  /// Creates repository with SharedPreferences dependency.
  ///
  /// [preferences] should be injected rather than created here to support
  /// testing and different storage strategies.
  const SharedPreferencesLocaleRepository({
    required SharedPreferences preferences,
  }) : _preferences = preferences;

  final SharedPreferences _preferences;

  @override
  Future<LocaleConfiguration?> getCurrentLocale() async {
    try {
      final languageCode = _preferences.getString(
        LocaleConstants.localeStorageKey,
      );
      if (languageCode == null) {
        return null;
      }

      // Reconstruct configuration based on stored data
      // For now, we assume stored locales are user-selected
      // This could be enhanced to store source information
      return LocaleConfigurationExtension.userSelected(languageCode);
    } on Exception catch (e) {
      // Log error but don't crash the app - graceful degradation
      // In production, this would use proper logging service
      throw LocaleRepositoryException(
        'Failed to retrieve saved locale configuration',
        e,
      );
    }
  }

  @override
  Future<void> saveLocale(LocaleConfiguration configuration) async {
    try {
      await _preferences.setString(
        LocaleConstants.localeStorageKey,
        configuration.languageCode,
      );
    } on Exception catch (e) {
      throw LocaleRepositoryException(
        'Failed to save locale configuration: ${configuration.languageCode}',
        e,
      );
    }
  }

  @override
  Future<void> clearSavedLocale() async {
    try {
      await _preferences.remove(LocaleConstants.localeStorageKey);
    } on Exception catch (e) {
      throw LocaleRepositoryException(
        'Failed to clear saved locale configuration',
        e,
      );
    }
  }

  @override
  Future<bool> hasExistingLocale() async {
    try {
      return _preferences.containsKey(LocaleConstants.localeStorageKey);
    } on Exception catch (e) {
      throw LocaleRepositoryException(
        'Failed to check for existing locale configuration',
        e,
      );
    }
  }
}

/// Exception thrown when locale repository operations fail.
///
/// This infrastructure exception wraps storage-specific errors while
/// providing context about the failed operation.
class LocaleRepositoryException implements Exception {
  /// Creates repository exception with context and original error.
  const LocaleRepositoryException(this.message, [this.originalError]);

  /// Description of the failed operation.
  final String message;

  /// Original error that caused the repository operation to fail.
  final Object? originalError;

  @override
  String toString() =>
      'LocaleRepositoryException: $message'
      '${originalError != null ? ' (caused by: $originalError)' : ''}';
}
