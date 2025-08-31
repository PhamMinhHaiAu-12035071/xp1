import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:xp1/features/env/infrastructure/env_config_factory.dart';

/// BlocObserver for logging state changes and errors during development.
class AppBlocObserver extends BlocObserver {
  /// Creates bloc observer.
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// App bootstrap with error handling, bloc observation, and widget builder.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Environment configuration initialization
  log(
    '🚀 Starting app with environment: '
    '${EnvConfigFactory.environmentName}',
  );
  log('📍 API URL: ${EnvConfigFactory.apiUrl}');
  log('🔧 Debug mode: ${EnvConfigFactory.isDebugMode}');

  runApp(await builder());
}
