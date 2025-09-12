import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/features/locale/cubit/locale_cubit.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Simplified bootstrap module responsible for locale initialization.
///
/// This module has been refactored to use LocaleCubit with HydratedBloc
/// for automatic persistence, eliminating the need for repository pattern
/// and complex dependency setup. Following the principle: "Simplicity is
/// the ultimate sophistication."
class LocaleBootstrap {
  /// Creates locale bootstrap with required dependencies.
  const LocaleBootstrap({
    required LoggerService logger,
  }) : _logger = logger;

  final LoggerService _logger;

  /// Initializes application locale using LocaleCubit.
  ///
  /// This simplified method:
  /// 1. Gets LocaleCubit from dependency injection
  /// 2. Resolves locale configuration using cubit business rules
  /// 3. Applies locale to Slang translation system
  /// 4. Logs initialization results
  ///
  /// LocaleCubit handles all persistence automatically via HydratedBloc.
  /// Failures are handled gracefully with fallback to default locale.
  Future<LocaleConfiguration> initializeLocale() async {
    try {
      _logger.info('🌐 Starting locale initialization...');

      // Get LocaleCubit from dependency injection and initialize
      final localeCubit = getIt<LocaleCubit>()..initialize();
      final configuration = localeCubit.state;

      // Apply locale to translation system
      await _applyLocaleConfiguration(configuration);

      _logger.info(
        '✅ Locale initialized: ${configuration.languageCode} '
        '(source: ${configuration.source.name})',
      );

      return configuration;
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to initialize locale', e, stackTrace);

      // Graceful fallback to default locale
      return _initializeFallbackLocale();
    }
  }

  /// Applies locale configuration to Slang translation system.
  ///
  /// This bridges between our domain model and the Slang library's
  /// locale management system.
  Future<void> _applyLocaleConfiguration(
    LocaleConfiguration configuration,
  ) async {
    // Convert our domain locale to Slang AppLocale
    final appLocale = _convertToAppLocale(configuration.languageCode);

    // Apply to Slang system
    await LocaleSettings.setLocale(appLocale);
  }

  /// Converts language code to Slang AppLocale enum.
  ///
  /// This encapsulates the mapping between our domain model and
  /// the Slang library's type system.
  AppLocale _convertToAppLocale(String languageCode) {
    for (final locale in AppLocale.values) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }

    // Fallback to default if mapping fails
    _logger.warning(
      'Unknown locale code: $languageCode, falling back to default',
    );
    return AppLocale.vi; // Project default
  }

  /// Initializes fallback locale when primary initialization fails.
  ///
  /// This ensures the app always has a working locale configuration,
  /// even if storage or platform detection fails completely.
  Future<LocaleConfiguration> _initializeFallbackLocale() async {
    try {
      await LocaleSettings.setLocale(AppLocale.vi);
      _logger.info('🔄 Fallback locale initialized: vi');

      return LocaleConfigurationExtension.defaultFallback();
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Even fallback locale initialization failed',
        e,
        stackTrace,
      );

      // Last resort - return configuration but don't set Slang locale
      return LocaleConfigurationExtension.defaultFallback();
    }
  }
}
