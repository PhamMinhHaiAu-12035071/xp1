import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/env/domain/env_config_repository.dart';
import 'package:xp1/features/env/infrastructure/env_config_repository_impl.dart';

void main() {
  group('EnvConfigRepositoryImpl', () {
    late EnvConfigRepository repository;

    setUp(() {
      repository = EnvConfigRepositoryImpl();
    });

    test('should provide non-empty API URL', () {
      expect(repository.apiUrl, isNotEmpty);
      expect(repository.apiUrl, contains('api'));
    });

    test('should provide non-empty app name', () {
      expect(repository.appName, isNotEmpty);
      expect(repository.appName, contains('XP1'));
    });

    test('should provide non-empty environment name', () {
      expect(repository.environmentName, isNotEmpty);
    });

    test('should provide valid debug mode flag', () {
      expect(repository.isDebugMode, isA<bool>());
    });

    test('should provide valid API timeout', () {
      expect(repository.apiTimeoutMs, isA<int>());
      expect(repository.apiTimeoutMs, greaterThan(0));
    });

    test('should implement EnvConfigRepository interface', () {
      expect(repository, isA<EnvConfigRepository>());
    });
  });
}
