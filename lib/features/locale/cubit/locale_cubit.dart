import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/errors/locale_errors.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Simplified cubit for session-only locale management.
///
/// This cubit implements Vietnamese-first locale behavior:
/// - Always starts with Vietnamese default
/// - Session-only language switching (no persistence)
/// - Synchronous operations for fast performance
/// - Delegates business logic to LocaleDomainService
class LocaleCubit extends Cubit<LocaleConfiguration> {
  /// Creates a LocaleCubit with domain service dependency.
  LocaleCubit({
    required LocaleDomainService domainService,
  }) : _domainService = domainService,
       super(LocaleConfigurationExtension.defaultFallback());

  final LocaleDomainService _domainService;

  /// Initializes locale to Vietnamese default.
  ///
  /// This method synchronously initializes the locale system with Vietnamese
  /// default. No async operations or persistence involved for fast startup.
  void initialize() {
    final configuration = _domainService.resolveLocaleConfiguration();
    emit(configuration);
  }

  /// Updates user's locale preference for current session only.
  ///
  /// This method handles session-only locale changes:
  /// - Validates locale is supported via domain service
  /// - Updates session state only (no persistence)
  /// - Returns [Right] with success, or [Left] with [LocaleError] for failure
  Either<LocaleError, void> updateUserLocale(String languageCode) {
    try {
      final configuration = _domainService.updateUserLocale(languageCode);
      emit(configuration);
      return const Right(null);
    } on UnsupportedLocaleException {
      return Left(
        LocaleError.unsupportedLocale(
          invalidLocaleCode: languageCode,
          supportedLocales: _getSupportedLocaleCodes(),
        ),
      );
    }
  }

  /// Resets locale to Vietnamese default for current session.
  ///
  /// This clears any session locale and returns to Vietnamese default.
  /// Synchronous operation with no persistence.
  void resetToSystemDefault() {
    final configuration = _domainService.resetToSystemDefault();
    emit(configuration);
  }

  /// Gets list of supported locale codes for error messages.
  List<String> _getSupportedLocaleCodes() {
    return AppLocale.values.map((locale) => locale.languageCode).toList();
  }
}
