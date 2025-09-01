import 'package:injectable/injectable.dart';

import 'package:xp1/features/env/domain/env_config_repository.dart';
import 'package:xp1/features/env/infrastructure/env_config_factory.dart';

/// Implementation of [EnvConfigRepository] that provides environment
/// configuration through [EnvConfigFactory].
///
/// This repository acts as a bridge between the domain layer and the
/// infrastructure layer, delegating configuration access to the factory.
@Singleton(as: EnvConfigRepository)
class EnvConfigRepositoryImpl implements EnvConfigRepository {
  @override
  String get apiUrl => EnvConfigFactory.apiUrl;

  @override
  String get appName => EnvConfigFactory.appName;

  @override
  String get environmentName => EnvConfigFactory.environmentName;

  @override
  bool get isDebugMode => EnvConfigFactory.isDebugMode;

  @override
  int get apiTimeoutMs => EnvConfigFactory.apiTimeoutMs;
}
