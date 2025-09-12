import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/security/jwt_service.dart';

void main() {
  late JwtService jwtService;

  setUp(() {
    jwtService = JwtService();
  });

  group('JwtService', () {
    // Valid JWT token for testing (header.payload.signature)
    // Payload: {"sub":"1234567890","name":"John Doe","iat":1516239022,
    // "exp":9999999999}
    const validJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2M'
        'jM5MDIyLCJleHAiOjk5OTk5OTk5OTl9.'
        'Lqa7rMmq2cQ6GQHnY9RZhZ-9kX7c_p0vXVtHhE-JQS0';

    // Expired JWT token for testing
    // Payload: {"sub":"1234567890","name":"John Doe","iat":1516239022,
    // "exp":1516239022}
    const expiredJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2M'
        'jM5MDIyLCJleHAiOjE1MTYyMzkwMjJ9.'
        'MjLYYm9VSyEGF8BaX-bDGCnZR4qRzEkXGCOG-mYjfKc';

    group('decodeToken', () {
      test('should decode valid JWT token', () {
        // Act
        final result = jwtService.decodeToken(validJwt);

        // Assert
        expect(result, isNotNull);
        expect(result!['sub'], equals('1234567890'));
        expect(result['name'], equals('John Doe'));
        expect(result['iat'], equals(1516239022));
        expect(result['exp'], equals(9999999999));
      });

      test('should return null for malformed JWT (wrong number of parts)', () {
        // Arrange
        const malformedJwt = 'header.payload'; // Missing signature

        // Act
        final result = jwtService.decodeToken(malformedJwt);

        // Assert
        expect(result, isNull);
      });

      test('should return null for invalid base64 encoding', () {
        // Arrange
        const invalidJwt = 'invalid.invalid.invalid';

        // Act
        final result = jwtService.decodeToken(invalidJwt);

        // Assert
        expect(result, isNull);
      });

      test('should return null for invalid JSON in payload', () {
        // Arrange
        // Create JWT with invalid JSON payload
        final invalidJsonPayload = base64Url.encode(
          utf8.encode('{invalid json'),
        );
        final invalidJwt = 'header.$invalidJsonPayload.signature';

        // Act
        final result = jwtService.decodeToken(invalidJwt);

        // Assert
        expect(result, isNull);
      });

      test('should return null for empty token', () {
        // Act
        final result = jwtService.decodeToken('');

        // Assert
        expect(result, isNull);
      });
    });

    group('isTokenExpired', () {
      test('should return false for valid non-expired token', () {
        // Act
        final result = jwtService.isTokenExpired(validJwt);

        // Assert
        expect(result, isFalse);
      });

      test('should return true for expired token', () {
        // Act
        final result = jwtService.isTokenExpired(expiredJwt);

        // Assert
        expect(result, isTrue);
      });

      test('should return true for token without exp claim', () {
        // Arrange - create JWT without exp claim
        final payloadWithoutExp = {
          'sub': '1234567890',
          'name': 'John Doe',
          'iat': 1516239022,
        };
        final encodedPayload = base64Url.encode(
          utf8.encode(jsonEncode(payloadWithoutExp)),
        );
        final jwtWithoutExp = 'header.$encodedPayload.signature';

        // Act
        final result = jwtService.isTokenExpired(jwtWithoutExp);

        // Assert
        expect(result, isTrue);
      });

      test('should return true for malformed token', () {
        // Act
        final result = jwtService.isTokenExpired('invalid-token');

        // Assert
        expect(result, isTrue);
      });

      test('should return true for token with non-numeric exp claim', () {
        // Arrange - create JWT with string exp claim
        final payloadWithStringExp = {
          'sub': '1234567890',
          'name': 'John Doe',
          'iat': 1516239022,
          'exp': 'not-a-number',
        };
        final encodedPayload = base64Url.encode(
          utf8.encode(jsonEncode(payloadWithStringExp)),
        );
        final jwtWithStringExp = 'header.$encodedPayload.signature';

        // Act
        final result = jwtService.isTokenExpired(jwtWithStringExp);

        // Assert
        expect(result, isTrue);
      });
    });

    group('willTokenExpireSoon', () {
      test(
        'should return false for token with more than default threshold',
        () {
          // Act
          final result = jwtService.willTokenExpireSoon(validJwt);

          // Assert
          expect(result, isFalse);
        },
      );

      test('should return true for expired token', () {
        // Act
        final result = jwtService.willTokenExpireSoon(expiredJwt);

        // Assert
        expect(result, isTrue);
      });

      test('should return true with custom threshold', () {
        // Arrange - create token that expires in the future but within custom
        // threshold
        final futureExp =
            (DateTime.now().millisecondsSinceEpoch / 1000).round() +
            120; // 2 minutes
        final payload = {
          'sub': '1234567890',
          'name': 'John Doe',
          'iat': 1516239022,
          'exp': futureExp,
        };
        final encodedPayload = base64Url.encode(
          utf8.encode(jsonEncode(payload)),
        );
        final jwtExpiringSoon = 'header.$encodedPayload.signature';

        // Act - check with 5 minute threshold
        final result = jwtService.willTokenExpireSoon(
          jwtExpiringSoon,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should return true for malformed token', () {
        // Act
        final result = jwtService.willTokenExpireSoon('invalid-token');

        // Assert
        expect(result, isTrue);
      });
    });

    group('getUserInfo', () {
      test('should return user info from valid token', () {
        // Act
        final result = jwtService.getUserInfo(validJwt);

        // Assert
        expect(result, isNotNull);
        expect(result!['sub'], equals('1234567890'));
        expect(result['name'], equals('John Doe'));
      });

      test('should return null for invalid token', () {
        // Act
        final result = jwtService.getUserInfo('invalid-token');

        // Assert
        expect(result, isNull);
      });
    });

    group('validateTokenStructure', () {
      test('should return true for valid JWT structure', () {
        // Act
        final result = jwtService.validateTokenStructure(validJwt);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for empty token', () {
        // Act
        final result = jwtService.validateTokenStructure('');

        // Assert
        expect(result, isFalse);
      });

      test('should return false for wrong number of parts', () {
        // Act
        final result = jwtService.validateTokenStructure('header.payload');

        // Assert
        expect(result, isFalse);
      });

      test('should return false for invalid base64 payload', () {
        // Act
        final result = jwtService.validateTokenStructure(
          'header.invalid.signature',
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('getTokenExpiration', () {
      test('should return expiration date for valid token', () {
        // Act
        final result = jwtService.getTokenExpiration(validJwt);

        // Assert
        expect(result, isNotNull);
        expect(result!.millisecondsSinceEpoch, equals(9999999999 * 1000));
      });

      test('should return null for token without exp claim', () {
        // Arrange - create JWT without exp claim
        final payloadWithoutExp = {
          'sub': '1234567890',
          'name': 'John Doe',
        };
        final encodedPayload = base64Url.encode(
          utf8.encode(jsonEncode(payloadWithoutExp)),
        );
        final jwtWithoutExp = 'header.$encodedPayload.signature';

        // Act
        final result = jwtService.getTokenExpiration(jwtWithoutExp);

        // Assert
        expect(result, isNull);
      });

      test('should return null for invalid token', () {
        // Act
        final result = jwtService.getTokenExpiration('invalid-token');

        // Assert
        expect(result, isNull);
      });
    });

    group('getTokenIssuedAt', () {
      test('should return issued date for valid token', () {
        // Act
        final result = jwtService.getTokenIssuedAt(validJwt);

        // Assert
        expect(result, isNotNull);
        expect(result!.millisecondsSinceEpoch, equals(1516239022 * 1000));
      });

      test('should return null for token without iat claim', () {
        // Arrange - create JWT without iat claim
        final payloadWithoutIat = {
          'sub': '1234567890',
          'name': 'John Doe',
          'exp': 9999999999,
        };
        final encodedPayload = base64Url.encode(
          utf8.encode(jsonEncode(payloadWithoutIat)),
        );
        final jwtWithoutIat = 'header.$encodedPayload.signature';

        // Act
        final result = jwtService.getTokenIssuedAt(jwtWithoutIat);

        // Assert
        expect(result, isNull);
      });

      test('should return null for invalid token', () {
        // Act
        final result = jwtService.getTokenIssuedAt('invalid-token');

        // Assert
        expect(result, isNull);
      });
    });
  });
}
