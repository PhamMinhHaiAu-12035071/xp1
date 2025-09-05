/// Stub implementation for non-web platforms
String getWebLocale() {
  throw UnsupportedError(
    'Web locale detection is not supported on this platform',
  );
}
