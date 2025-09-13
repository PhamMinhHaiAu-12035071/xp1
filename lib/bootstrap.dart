// Legacy bootstrap.dart - now delegates to modular bootstrap system
// This file is maintained for backward compatibility

import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/features/locale/application/locale_application_service.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/services/locale_domain_service.dart'
    show UnsupportedLocaleException;
import 'package:xp1/l10n/gen/strings.g.dart';

export 'package:xp1/core/bootstrap/app_bootstrap.dart' show bootstrap;
export 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
export 'package:xp1/l10n/gen/strings.g.dart' show AppLocale, LocaleSettings;

/// Utility function for manual locale switching with improved DDD compliance.
///
/// This function provides a clean API for locale switching while maintaining
/// proper architectural boundaries. It uses the application service layer
/// to coordinate between domain and infrastructure concerns.
///
/// The locale setting will be validated, persisted, and applied following
/// clean architecture principles.
///
/// Throws [UnsupportedLocaleException] if the locale is not supported.
Future<LocaleConfiguration> switchLocale(AppLocale locale) async {
  // Retrieve the singleton instance from GetIt for efficiency and consistency
  final applicationService = getIt<LocaleApplicationService>();

  return applicationService.switchLocale(locale);
}
