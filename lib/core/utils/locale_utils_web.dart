// Web-specific implementation requires dart:html
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html show window;

/// Web implementation of locale detection using browser APIs
String getWebLocale() {
  return html.window.navigator.language.split('-').first;
}
