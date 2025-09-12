import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/authentication/domain/failures/auth_failure.dart';

void main() {
  group('AuthFailure', () {
    test('should create InvalidCredentialsFailure', () {
      // Act
      const failure = AuthFailure.invalidCredentials();

      // Assert
      expect(failure, isA<InvalidCredentialsFailure>());
      expect(failure, isA<AuthFailure>());
    });

    test('should create NetworkFailure with message', () {
      // Arrange
      const message = 'No internet connection';

      // Act
      const failure = AuthFailure.networkError(message);

      // Assert
      expect(failure, isA<NetworkFailure>());
      expect(failure, isA<AuthFailure>());
      expect(
        failure.when(
          invalidCredentials: () => null,
          networkError: (msg) => msg,
          serverError: (_) => null,
          tokenExpired: () => null,
          unauthorized: () => null,
          unknown: (_) => null,
        ),
        equals(message),
      );
    });

    test('should create ServerFailure with status code', () {
      // Arrange
      const statusCode = 500;

      // Act
      const failure = AuthFailure.serverError(statusCode);

      // Assert
      expect(failure, isA<ServerFailure>());
      expect(failure, isA<AuthFailure>());
      expect(
        failure.when(
          invalidCredentials: () => null,
          networkError: (_) => null,
          serverError: (code) => code,
          tokenExpired: () => null,
          unauthorized: () => null,
          unknown: (_) => null,
        ),
        equals(statusCode),
      );
    });

    test('should create TokenExpiredFailure', () {
      // Act
      const failure = AuthFailure.tokenExpired();

      // Assert
      expect(failure, isA<TokenExpiredFailure>());
      expect(failure, isA<AuthFailure>());
    });

    test('should create UnauthorizedFailure', () {
      // Act
      const failure = AuthFailure.unauthorized();

      // Assert
      expect(failure, isA<UnauthorizedFailure>());
      expect(failure, isA<AuthFailure>());
    });

    test('should create UnknownFailure with message', () {
      // Arrange
      const message = 'An unexpected error occurred';

      // Act
      const failure = AuthFailure.unknown(message);

      // Assert
      expect(failure, isA<UnknownFailure>());
      expect(failure, isA<AuthFailure>());
      expect(
        failure.when(
          invalidCredentials: () => null,
          networkError: (_) => null,
          serverError: (_) => null,
          tokenExpired: () => null,
          unauthorized: () => null,
          unknown: (msg) => msg,
        ),
        equals(message),
      );
    });

    test('should support pattern matching with when method', () {
      // Arrange
      const failures = [
        AuthFailure.invalidCredentials(),
        AuthFailure.networkError('Network error'),
        AuthFailure.serverError(500),
        AuthFailure.tokenExpired(),
        AuthFailure.unauthorized(),
        AuthFailure.unknown('Unknown error'),
      ];

      // Act & Assert
      for (final failure in failures) {
        final result = failure.when(
          invalidCredentials: () => 'invalid-credentials',
          networkError: (_) => 'network-error',
          serverError: (_) => 'server-error',
          tokenExpired: () => 'token-expired',
          unauthorized: () => 'unauthorized',
          unknown: (_) => 'unknown',
        );

        expect(result, isA<String>());
        expect(result.isNotEmpty, isTrue);
      }
    });

    test('should support pattern matching with maybeWhen method', () {
      // Arrange
      const failure = AuthFailure.invalidCredentials();

      // Act
      final result = failure.maybeWhen(
        invalidCredentials: () => 'handled',
        orElse: () => 'not-handled',
      );

      // Assert
      expect(result, equals('handled'));
    });

    test('should support value equality for same failure types', () {
      // Arrange
      const failure1 = AuthFailure.invalidCredentials();
      const failure2 = AuthFailure.invalidCredentials();
      const failure3 = AuthFailure.unauthorized();

      const networkFailure1 = AuthFailure.networkError('Network error');
      const networkFailure2 = AuthFailure.networkError('Network error');
      const networkFailure3 = AuthFailure.networkError('Different error');

      // Assert
      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
      expect(failure1, isNot(equals(failure3)));

      expect(networkFailure1, equals(networkFailure2));
      expect(networkFailure1.hashCode, equals(networkFailure2.hashCode));
      expect(networkFailure1, isNot(equals(networkFailure3)));
    });

    test('should have toString representation', () {
      // Arrange
      const failures = [
        AuthFailure.invalidCredentials(),
        AuthFailure.networkError('Network error'),
        AuthFailure.serverError(500),
        AuthFailure.tokenExpired(),
        AuthFailure.unauthorized(),
        AuthFailure.unknown('Unknown error'),
      ];

      // Act & Assert
      for (final failure in failures) {
        final stringRepresentation = failure.toString();
        expect(stringRepresentation, isA<String>());
        expect(stringRepresentation.isNotEmpty, isTrue);
        expect(stringRepresentation, contains('Failure'));
      }
    });
  });
}
