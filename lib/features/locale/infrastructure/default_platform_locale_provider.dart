import 'dart:io';

import 'package:xp1/core/platform/platform_detector.dart';
import 'package:xp1/core/utils/locale_utils.dart';
import 'package:xp1/features/locale/domain/services/platform_locale_provider.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Default implementation of platform locale provider.
///
/// Uses proper dependency injection instead of global variables.
/// Following Linus: "Good taste eliminates special cases."
///
/// This implementation provides cross-platform locale detection with
/// proper web support through platform detection abstraction.
class DefaultPlatformLocaleProvider implements PlatformLocaleProvider {
  /// Creates a default platform locale provider.
  ///
  /// [platformDetector] Platform detector for web/native detection.
  const DefaultPlatformLocaleProvider({
    required PlatformDetector platformDetector,
  }) : _platformDetector = platformDetector;

  final PlatformDetector _platformDetector;

  @override
  String getSystemLocale() {
    if (_platformDetector.isWeb) {
      return getWebLocale();
    } else {
      return Platform.localeName.split('_').first;
    }
  }

  @override
  List<String> getSupportedLocales() {
    // Return supported locale codes from AppLocale enum
    return AppLocale.values.map((locale) => locale.languageCode).toList();
  }
}
