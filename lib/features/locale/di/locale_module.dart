import 'package:injectable/injectable.dart';
import 'package:xp1/features/locale/cubit/locale_cubit.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';

/// Injectable module for Vietnamese-first locale dependencies.
///
/// This simplified module provides dependency injection for the streamlined
/// Vietnamese-first locale architecture with no persistence or complex
/// platform detection.
@module
abstract class LocaleModule {
  /// Provides LocaleCubit with domain service dependency.
  ///
  /// This cubit handles session-only locale management with Vietnamese
  /// default. All operations are synchronous for fast performance.
  @lazySingleton
  LocaleCubit localeCubit(
    LocaleDomainService domainService,
  ) {
    return LocaleCubit(
      domainService: domainService,
    );
  }
}
