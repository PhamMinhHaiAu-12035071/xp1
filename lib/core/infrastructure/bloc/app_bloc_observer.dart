import 'package:bloc/bloc.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// BlocObserver for logging state changes and errors during development.
///
/// This observer provides comprehensive logging of BLoC state changes and
/// errors, enabling better debugging and monitoring of application state
/// management throughout the development lifecycle.
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
