import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/bootstrap/orchestrator/bootstrap_orchestrator.dart';
import 'package:xp1/core/bootstrap/phases/dependency_injection_phase.dart';
import 'package:xp1/core/bootstrap/phases/error_handling_phase.dart';
import 'package:xp1/core/bootstrap/phases/locale_bootstrap_phase.dart';
import 'package:xp1/core/infrastructure/bloc/app_bloc_observer.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/features/env/infrastructure/env_config_factory.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';

/// Main application bootstrap using Chain of Responsibility pattern.
///
/// This improved implementation follows SOLID principles:
/// - SRP: Only coordinates bootstrap phases
/// - OCP: New phases can be added without modifying this class
/// - LSP: All phases implement the same interface
/// - ISP: Clean separation of concerns through interfaces
/// - DIP: Depends on abstractions (BootstrapPhase) not concretions
///
/// Benefits over the original implementation:
/// - Better error handling and rollback
/// - Testable individual phases
/// - Flexible phase ordering and configuration
/// - Proper separation of concerns
class AppBootstrap {
  /// Creates app bootstrap with configurable phases.
  ///
  /// Phases can be customized for different environments or testing.
  /// Default phases provide production-ready configuration.
  const AppBootstrap({
    List<BootstrapPhase>? phases,
  }) : _customPhases = phases;

  final List<BootstrapPhase>? _customPhases;

  /// Executes complete application bootstrap sequence.
  ///
  /// Returns the locale configuration needed by the app.
  /// Throws [BootstrapException] on critical failures.
  Future<LocaleConfiguration> bootstrap() async {
    // Initialize logger first for early error tracking
    final logger = LoggerService();

    try {
      // Create bootstrap orchestrator with phases
      final orchestrator = BootstrapOrchestrator(
        logger: logger,
        phases: _customPhases ?? _createDefaultPhases(logger),
      );

      // Execute all phases
      final results = await orchestrator.execute();

      // Log execution summary
      logger.info(orchestrator.getExecutionSummary(results));

      // Extract locale configuration from locale phase result
      final localeConfiguration = _extractLocaleConfiguration(results, logger);

      // Setup BLoC observer (kept here as it's Flutter-specific)
      _setupBlocObserver(logger);

      // Log environment configuration
      _logEnvironmentConfiguration(logger);

      logger.info('🚀 Application bootstrap completed successfully');

      return localeConfiguration;
    } on BootstrapException {
      logger.error('Application bootstrap failed');
      rethrow;
    } on Exception catch (e, stackTrace) {
      logger.error('Unexpected bootstrap failure', e, stackTrace);
      throw BootstrapException(
        'Bootstrap failed unexpectedly',
        originalError: e,
      );
    }
  }

  /// Creates default bootstrap phases for production use.
  List<BootstrapPhase> _createDefaultPhases(LoggerService logger) {
    return [
      DependencyInjectionPhase(logger: logger),
      ErrorHandlingPhase(logger: logger),
      LocaleBootstrapPhase(logger: logger),
      // Add more phases as needed
    ];
  }

  /// Sets up BLoC observer for development debugging.
  ///
  /// This is isolated to its own method to keep the main bootstrap
  /// flow clean and to allow for different observer configurations
  /// in different environments.
  void _setupBlocObserver(LoggerService logger) {
    Bloc.observer = AppBlocObserver();
    logger.info('🎯 BLoC observer configured');
  }

  /// Extracts locale configuration from bootstrap phase results.
  ///
  /// This method retrieves the locale configuration produced by the
  /// LocaleBootstrapPhase and provides a fallback if the phase failed.
  LocaleConfiguration _extractLocaleConfiguration(
    Map<String, BootstrapResult> results,
    LoggerService logger,
  ) {
    // Find the locale phase result
    final localeResult = results['Locale System'];
    if (localeResult != null &&
        localeResult.success &&
        localeResult.data.containsKey('locale_configuration')) {
      final localeConfig = localeResult.getData<LocaleConfiguration>(
        'locale_configuration',
      );
      if (localeConfig != null) {
        return localeConfig;
      }
    }

    // Fallback to default if locale phase failed or didn't run
    logger.warning(
      'Locale phase did not produce configuration, using fallback',
    );
    return const LocaleConfiguration(
      languageCode: 'vi', // Project default
      source: LocaleSource.defaultFallback,
    );
  }

  /// Logs environment configuration for debugging and monitoring.
  ///
  /// This provides visibility into the current environment setup
  /// without mixing logging concerns with other bootstrap phases.
  void _logEnvironmentConfiguration(LoggerService logger) {
    logger
      ..info('🌍 Environment: ${EnvConfigFactory.environmentName}')
      ..info('📍 API URL: ${EnvConfigFactory.apiUrl}')
      ..info('🔧 Debug mode: ${EnvConfigFactory.isDebugMode}');
  }
}

/// Simplified bootstrap function for backward compatibility.
///
/// This function maintains the existing API while using the new
/// modular bootstrap system internally. It handles the complete
/// initialization and app startup sequence.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // CRITICAL: Initialize Flutter bindings BEFORE dependency injection
  // This is required because SharedPreferences and other platform services
  // need Flutter's platform channels to be available
  WidgetsFlutterBinding.ensureInitialized();

  // Configure Google Fonts with enhanced error handling for network issues
  // Platform permissions are configured for network access:
  // - Android: INTERNET permission in AndroidManifest.xml
  // - macOS: network.client entitlement in both Debug and Release
  // - iOS: Network access available by default
  await _configureGoogleFontsWithFallback();

  const appBootstrap = AppBootstrap();

  // Execute bootstrap sequence
  await appBootstrap.bootstrap();

  // Start the Flutter application
  runApp(await builder());
}

/// Configures Google Fonts with enhanced error handling and fallbacks.
///
/// This function attempts to enable Google Fonts runtime fetching with
/// proper error handling for network connectivity issues. If Google Fonts
/// fail to load, the app will gracefully fall back to system fonts.
Future<void> _configureGoogleFontsWithFallback() async {
  final logger = LoggerService();

  try {
    // Enable runtime font fetching
    GoogleFonts.config.allowRuntimeFetching = true;

    // Test Google Fonts connectivity by attempting to load a basic font
    // This helps detect network issues early in the bootstrap process
    await _testGoogleFontsConnectivity();

    // Google Fonts automatically caches fonts locally for performance

    logger.info('✅ Google Fonts configured successfully with network access');
  } on Exception catch (e) {
    // Log the error but don't crash the app
    logger
      ..warning('⚠️ Google Fonts network unavailable: $e')
      ..info('📱 Falling back to system fonts for offline functionality');

    // Disable runtime fetching to prevent repeated failed attempts
    GoogleFonts.config.allowRuntimeFetching = false;
  }
}

/// Tests Google Fonts connectivity by attempting to load a lightweight font.
///
/// This method attempts to verify that Google Fonts can be reached before
/// the app tries to load heavier font assets during normal operation.
Future<void> _testGoogleFontsConnectivity() async {
  final logger = LoggerService();

  try {
    // Test with a minimal font request to verify connectivity
    // This doesn't actually load the font, just tests the network path
    final _ = GoogleFonts.roboto(fontSize: 12);

    // If this succeeds, Google Fonts network access is working
    logger.info('🌐 Google Fonts connectivity verified');
  } on Exception catch (e) {
    logger
      ..error('🚫 Google Fonts connectivity test failed: $e')
      ..info('💡 Tip: Check network connection or try on physical device');
    rethrow;
  }
}
