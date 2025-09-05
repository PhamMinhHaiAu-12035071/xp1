import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Interface for detecting the current platform.
///
/// This abstraction allows for easy testing by providing a mockable
/// interface for platform-specific detection logic.
abstract class PlatformDetector {
  /// Whether the current platform is web.
  ///
  /// Returns true if running on web platform, false otherwise.
  bool get isWeb;
}

/// Default implementation of [PlatformDetector] that uses Flutter's kIsWeb.
///
/// This is the production implementation that delegates to Flutter's
/// built-in platform detection.
@LazySingleton(as: PlatformDetector)
class DefaultPlatformDetector implements PlatformDetector {
  /// Creates a default platform detector.
  const DefaultPlatformDetector();

  @override
  bool get isWeb => kIsWeb;
}
