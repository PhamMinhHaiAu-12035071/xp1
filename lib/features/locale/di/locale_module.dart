import 'package:injectable/injectable.dart';
import 'package:xp1/core/platform/platform_detector.dart';
import 'package:xp1/features/locale/cubit/locale_cubit.dart';
import 'package:xp1/features/locale/domain/services/platform_locale_provider.dart';
import 'package:xp1/features/locale/infrastructure/default_platform_locale_provider.dart';

/// Injectable module for locale-related dependencies.
///
/// This module provides simplified dependency injection for the new
/// LocaleCubit-based architecture, eliminating the need for repository
/// pattern complexity while maintaining proper dependency injection.
@module
abstract class LocaleModule {
  /// Provides PlatformLocaleProvider implementation.
  ///
  /// Uses DefaultPlatformLocaleProvider with platform detection for
  /// cross-platform locale detection support.
  @lazySingleton
  PlatformLocaleProvider platformLocaleProvider(
    PlatformDetector platformDetector,
  ) {
    return DefaultPlatformLocaleProvider(
      platformDetector: platformDetector,
    );
  }

  /// Provides LocaleCubit with HydratedBloc persistence.
  ///
  /// This cubit replaces the entire repository pattern and automatically
  /// handles state persistence via HydratedBloc. Dependencies are injected
  /// through Injectable for proper testability and modularity.
  @lazySingleton
  LocaleCubit localeCubit(
    PlatformLocaleProvider platformProvider,
  ) {
    return LocaleCubit(
      platformProvider: platformProvider,
    );
  }
}
