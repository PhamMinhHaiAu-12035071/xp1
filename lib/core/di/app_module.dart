import 'package:injectable/injectable.dart';

import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// App module for providing services that require custom initialization.
@module
abstract class AppModule {
  /// Provides LoggerService instance.
  @singleton
  ILoggerService get loggerService => LoggerService();
}
