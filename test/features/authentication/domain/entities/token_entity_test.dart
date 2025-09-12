import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/authentication/domain/entities/token_entity.dart';

void main() {
  group('TokenEntity', () {
    const testAccessToken = 'test-access-token';
    const testRefreshToken = 'test-refresh-token';
    const testTokenType = 'Bearer';
    const testTtl = 10800; // 3 hours (matching API example)

    test('should create TokenEntity with required properties', () {
      // Act
      const tokenEntity = TokenEntity(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
        tokenType: testTokenType,
        ttl: testTtl,
      );

      // Assert
      expect(tokenEntity.accessToken, equals(testAccessToken));
      expect(tokenEntity.refreshToken, equals(testRefreshToken));
      expect(tokenEntity.tokenType, equals(testTokenType));
      expect(tokenEntity.ttl, equals(testTtl));
    });

    test('should support value equality', () {
      // Arrange
      const tokenEntity1 = TokenEntity(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
        tokenType: testTokenType,
        ttl: testTtl,
      );
      const tokenEntity2 = TokenEntity(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
        tokenType: testTokenType,
        ttl: testTtl,
      );
      const tokenEntity3 = TokenEntity(
        accessToken: 'different-token',
        refreshToken: testRefreshToken,
        tokenType: testTokenType,
        ttl: testTtl,
      );

      // Assert
      expect(tokenEntity1, equals(tokenEntity2));
      expect(tokenEntity1.hashCode, equals(tokenEntity2.hashCode));
      expect(tokenEntity1, isNot(equals(tokenEntity3)));
    });

    test('should support copyWith for immutable updates', () {
      // Arrange
      const originalToken = TokenEntity(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
        tokenType: testTokenType,
        ttl: testTtl,
      );

      // Act
      final updatedToken = originalToken.copyWith(
        accessToken: 'new-access-token',
      );

      // Assert
      expect(updatedToken.accessToken, equals('new-access-token'));
      expect(updatedToken.refreshToken, equals(testRefreshToken));
      expect(updatedToken.tokenType, equals(testTokenType));
      expect(updatedToken.ttl, equals(testTtl));
      expect(
        originalToken.accessToken,
        equals(testAccessToken),
      ); // Original unchanged
    });

    test('should have toString representation', () {
      // Arrange
      const tokenEntity = TokenEntity(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
        tokenType: testTokenType,
        ttl: testTtl,
      );

      // Act
      final stringRepresentation = tokenEntity.toString();

      // Assert
      expect(stringRepresentation, contains('TokenEntity'));
      expect(stringRepresentation, contains(testAccessToken));
      expect(stringRepresentation, contains(testRefreshToken));
      expect(stringRepresentation, contains(testTokenType));
      expect(stringRepresentation, contains(testTtl.toString()));
    });

    group('factory constructors', () {
      test(
        'should create TokenEntity from API response with fromApiResponse',
        () {
          // Act
          final tokenEntity = TokenEntity.fromApiResponse(
            accessToken: testAccessToken,
            refreshToken: testRefreshToken,
            tokenType: testTokenType,
            ttl: testTtl,
          );

          // Assert
          expect(tokenEntity.accessToken, equals(testAccessToken));
          expect(tokenEntity.refreshToken, equals(testRefreshToken));
          expect(tokenEntity.tokenType, equals(testTokenType));
          expect(tokenEntity.ttl, equals(testTtl));
        },
      );

      test(
        'should create TokenEntity from JSON with correct field mapping',
        () {
          // Arrange - JSON data matching API response format
          final jsonData = <String, dynamic>{
            'access_token': testAccessToken,
            'refresh_token': testRefreshToken,
            'token_type': testTokenType,
            'ttl': testTtl,
          };

          // Act
          final tokenEntity = TokenEntity.fromJson(jsonData);

          // Assert
          expect(tokenEntity.accessToken, equals(testAccessToken));
          expect(tokenEntity.refreshToken, equals(testRefreshToken));
          expect(tokenEntity.tokenType, equals(testTokenType));
          expect(tokenEntity.ttl, equals(testTtl));
        },
      );

      test('should serialize to JSON with correct field mapping', () {
        // Arrange
        const tokenEntity = TokenEntity(
          accessToken: testAccessToken,
          refreshToken: testRefreshToken,
          tokenType: testTokenType,
          ttl: testTtl,
        );

        // Act
        final json = tokenEntity.toJson();

        // Assert
        expect(json['access_token'], equals(testAccessToken));
        expect(json['refresh_token'], equals(testRefreshToken));
        expect(json['token_type'], equals(testTokenType));
        expect(json['ttl'], equals(testTtl));
      });

      test('should handle full API response JSON structure', () {
        // Arrange - Full API response as provided in the example
        final fullApiResponse = <String, dynamic>{
          'status': 'success',
          'code': 200,
          'data': {
            'access_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test',
            'refresh_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.refresh',
            'token_type': 'Bearer',
            'ttl': 10800,
          },
        };

        // Act
        final tokenData = fullApiResponse['data'] as Map<String, dynamic>;
        final tokenEntity = TokenEntity.fromJson(tokenData);

        // Assert
        expect(tokenEntity.accessToken, contains('eyJhbGciOiJIUzI1NiI'));
        expect(tokenEntity.refreshToken, contains('eyJhbGciOiJIUzI1NiI'));
        expect(tokenEntity.tokenType, equals('Bearer'));
        expect(tokenEntity.ttl, equals(10800));
      });
    });
  });
}
