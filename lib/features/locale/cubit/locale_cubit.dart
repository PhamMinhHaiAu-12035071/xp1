import 'package:fpdart/fpdart.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/errors/locale_errors.dart';
import 'package:xp1/features/locale/domain/services/platform_locale_provider.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Cubit for managing locale state with automatic persistence.
///
/// This cubit replaces the repository pattern by using HydratedCubit
/// for automatic state persistence. It encapsulates all locale business
/// logic following Clean Architecture principles while simplifying
/// the infrastructure layer.
///
/// Features:
/// - Automatic persistence with HydratedCubit
/// - Platform locale detection
/// - User locale selection with validation
/// - Fallback to default locale
class LocaleCubit extends HydratedCubit<LocaleConfiguration> {
  /// Creates a LocaleCubit with platform locale provider dependency.
  LocaleCubit({
    required PlatformLocaleProvider platformProvider,
  }) : _platformProvider = platformProvider,
       super(LocaleConfigurationExtension.defaultFallback());

  final PlatformLocaleProvider _platformProvider;

  /// Resolves the best locale configuration for the current context.
  ///
  /// This method implements the locale resolution strategy:
  /// 1. Use saved user preference if available (from HydratedCubit state)
  /// 2. Detect and validate system locale
  /// 3. Fall back to default project locale (Vietnamese)
  ///
  /// The resolved locale is automatically persisted via HydratedCubit.
  Future<void> resolveLocale() async {
    // Strategy 1: Current state already contains saved user preference
    // HydratedCubit automatically loads from storage
    if (_isLocaleSupported(state.languageCode) && state.isUserSelected) {
      return; // Use existing saved preference
    }

    // Strategy 2: Detect and validate system locale
    final systemLocaleCode = _platformProvider.getSystemLocale();
    if (_isLocaleSupported(systemLocaleCode)) {
      final systemLocale = LocaleConfigurationExtension.systemDetected(
        systemLocaleCode,
      );
      emit(systemLocale); // Automatically persisted by HydratedCubit
      return;
    }

    // Strategy 3: Default fallback
    final defaultLocale = LocaleConfigurationExtension.defaultFallback();
    emit(defaultLocale); // Automatically persisted by HydratedCubit
  }

  /// Updates user's locale preference with validation.
  ///
  /// This method handles the business rules around locale changes:
  /// - Validates locale is supported
  /// - Persists the choice automatically via HydratedCubit
  /// - Updates the current state
  ///
  /// Returns [Right] with success, or [Left] with [LocaleError] if validation
  /// fails. Uses functional programming approach for better error handling.
  Future<Either<LocaleError, void>> updateUserLocale(
    String languageCode,
  ) async {
    if (!_isLocaleSupported(languageCode)) {
      return Left(
        LocaleError.unsupportedLocale(
          invalidLocaleCode: languageCode,
          supportedLocales: _getSupportedLocaleCodes(),
        ),
      );
    }

    final configuration = LocaleConfigurationExtension.userSelected(
      languageCode,
    );
    emit(configuration); // Automatically persisted by HydratedCubit
    return const Right(null);
  }

  /// Resets locale to system default, clearing user preference.
  ///
  /// This is useful for "reset to default" functionality or testing.
  /// The reset state is automatically persisted via HydratedCubit.
  Future<void> resetToSystemDefault() async {
    final systemLocaleCode = _platformProvider.getSystemLocale();

    if (_isLocaleSupported(systemLocaleCode)) {
      final systemLocale = LocaleConfigurationExtension.systemDetected(
        systemLocaleCode,
      );
      emit(systemLocale);
    } else {
      final defaultLocale = LocaleConfigurationExtension.defaultFallback();
      emit(defaultLocale);
    }
  }

  /// Validates if a locale is supported by the application.
  ///
  /// This encapsulates the business rule of what locales are valid,
  /// keeping this logic centralized and testable.
  bool _isLocaleSupported(String languageCode) {
    return AppLocale.values.any(
      (locale) => locale.languageCode == languageCode,
    );
  }

  /// Gets list of supported locale codes for error messages.
  List<String> _getSupportedLocaleCodes() {
    return AppLocale.values.map((locale) => locale.languageCode).toList();
  }

  /// Deserializes state from JSON storage.
  ///
  /// Used by HydratedCubit to restore state from persistent storage.
  /// Returns null if deserialization fails, triggering default state.
  @override
  LocaleConfiguration? fromJson(Map<String, dynamic> json) {
    try {
      return LocaleConfiguration.fromJson(json);
    } on FormatException {
      return null;
    } on Exception {
      return null;
    }
  }

  /// Serializes state to JSON for storage.
  ///
  /// Used by HydratedCubit to persist state to storage.
  @override
  Map<String, dynamic>? toJson(LocaleConfiguration state) {
    return state.toJson();
  }

  /// Override storage prefix for persistent storage across code changes.
  ///
  /// This ensures the storage key remains consistent even if the class
  /// name changes during refactoring or code obfuscation.
  @override
  String get storagePrefix => 'LocaleCubit';
}
