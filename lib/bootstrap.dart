import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';
import 'package:xp1/features/env/infrastructure/env_config_factory.dart';

/// BlocObserver for logging state changes and errors during development.
class AppBlocObserver extends BlocObserver {
  /// Creates bloc observer.
  AppBlocObserver() : _logger = LoggerService();

  final LoggerService _logger;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.debug('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.error('${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

/// Sets up error handling, logging, and bloc observation.
///
/// This function is testable as it doesn't call runApp.
void setupBootstrap() {
  // Initialize logger immediately - no separate init call needed
  final logger = LoggerService();

  FlutterError.onError = (details) {
    logger.error(details.exceptionAsString(), details.exception, details.stack);
  };

  Bloc.observer = AppBlocObserver();

  // Environment configuration initialization
  logger
    ..info(
      '🚀 Starting app with environment: '
      '${EnvConfigFactory.environmentName}',
    )
    ..info('📍 API URL: ${EnvConfigFactory.apiUrl}')
    ..info('🔧 Debug mode: ${EnvConfigFactory.isDebugMode}');
}

/// App bootstrap with error handling, bloc observation, and widget builder.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  setupBootstrap();
  runApp(await builder());
}
