// Platform-specific conditional imports for locale detection
export 'locale_utils_stub.dart' if (dart.library.html) 'locale_utils_web.dart';
