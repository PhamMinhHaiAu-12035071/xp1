import 'package:flutter/widgets.dart';
import 'package:xp1/l10n/gen/app_localizations.dart';

export 'package:xp1/l10n/gen/app_localizations.dart';

/// Extension providing convenient localization access on BuildContext.
extension AppLocalizationsX on BuildContext {
  /// Gets localization instance for this context.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
