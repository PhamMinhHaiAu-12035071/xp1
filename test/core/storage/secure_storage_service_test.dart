import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/storage/secure_storage_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageService secureStorageService;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorageService = SecureStorageService(mockStorage);
  });

  group('SecureStorageService', () {
    const testAccessToken = 'test-access-token';
    const testRefreshToken = 'test-refresh-token';

    group('storeAccessToken', () {
      test('should store access token successfully', () async {
        // Arrange
        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        // Act & Assert
        expect(
          () => secureStorageService.storeAccessToken(testAccessToken),
          returnsNormally,
        );

        // Verify the correct key and value were used
        verify(
          () => mockStorage.write(key: 'access_token', value: testAccessToken),
        ).called(1);
      });
    });

    group('storeRefreshToken', () {
      test('should store refresh token successfully', () async {
        // Arrange
        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        // Act & Assert
        expect(
          () => secureStorageService.storeRefreshToken(testRefreshToken),
          returnsNormally,
        );

        // Verify the correct key and value were used
        verify(
          () =>
              mockStorage.write(key: 'refresh_token', value: testRefreshToken),
        ).called(1);
      });
    });

    group('getAccessToken', () {
      test('should return access token when it exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => testAccessToken);

        // Act
        final result = await secureStorageService.getAccessToken();

        // Assert
        expect(result, equals(testAccessToken));
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });

      test('should return null when no access token exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => null);

        // Act
        final result = await secureStorageService.getAccessToken();

        // Assert
        expect(result, isNull);
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });
    });

    group('getRefreshToken', () {
      test('should return refresh token when it exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => testRefreshToken);

        // Act
        final result = await secureStorageService.getRefreshToken();

        // Assert
        expect(result, equals(testRefreshToken));
        verify(() => mockStorage.read(key: 'refresh_token')).called(1);
      });

      test('should return null when no refresh token exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => null);

        // Act
        final result = await secureStorageService.getRefreshToken();

        // Assert
        expect(result, isNull);
        verify(() => mockStorage.read(key: 'refresh_token')).called(1);
      });
    });

    group('clearTokens', () {
      test('should clear all stored tokens', () async {
        // Arrange
        when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

        // Act
        await secureStorageService.clearTokens();

        // Assert
        verify(() => mockStorage.deleteAll()).called(1);
      });
    });

    group('hasAccessToken', () {
      test('should return true when access token exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => testAccessToken);

        // Act
        final result = await secureStorageService.hasAccessToken();

        // Assert
        expect(result, isTrue);
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });

      test('should return false when no access token exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => null);

        // Act
        final result = await secureStorageService.hasAccessToken();

        // Assert
        expect(result, isFalse);
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });

      test('should return false when access token is empty string', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => '');

        // Act
        final result = await secureStorageService.hasAccessToken();

        // Assert
        expect(result, isFalse);
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });
    });

    group('hasRefreshToken', () {
      test('should return true when refresh token exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => testRefreshToken);

        // Act
        final result = await secureStorageService.hasRefreshToken();

        // Assert
        expect(result, isTrue);
        verify(() => mockStorage.read(key: 'refresh_token')).called(1);
      });

      test('should return false when no refresh token exists', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => null);

        // Act
        final result = await secureStorageService.hasRefreshToken();

        // Assert
        expect(result, isFalse);
        verify(() => mockStorage.read(key: 'refresh_token')).called(1);
      });

      test('should return false when refresh token is empty string', () async {
        // Arrange
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => '');

        // Act
        final result = await secureStorageService.hasRefreshToken();

        // Assert
        expect(result, isFalse);
        verify(() => mockStorage.read(key: 'refresh_token')).called(1);
      });
    });

    group('integration tests', () {
      test('should handle complete token lifecycle', () async {
        // Arrange - Mock the complete lifecycle
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => null);
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => null);
        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});
        when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

        // Initially no tokens
        expect(await secureStorageService.hasAccessToken(), isFalse);
        expect(await secureStorageService.hasRefreshToken(), isFalse);

        // Store tokens
        await secureStorageService.storeAccessToken(testAccessToken);
        await secureStorageService.storeRefreshToken(testRefreshToken);

        // Update mocks to return stored tokens
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => testAccessToken);
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => testRefreshToken);

        // Verify tokens are stored
        expect(await secureStorageService.hasAccessToken(), isTrue);
        expect(await secureStorageService.hasRefreshToken(), isTrue);
        expect(
          await secureStorageService.getAccessToken(),
          equals(testAccessToken),
        );
        expect(
          await secureStorageService.getRefreshToken(),
          equals(testRefreshToken),
        );

        // Clear tokens
        await secureStorageService.clearTokens();

        // Update mocks to return null after clearing
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => null);
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => null);

        // Verify tokens are cleared
        expect(await secureStorageService.hasAccessToken(), isFalse);
        expect(await secureStorageService.hasRefreshToken(), isFalse);
        expect(await secureStorageService.getAccessToken(), isNull);
        expect(await secureStorageService.getRefreshToken(), isNull);

        // Verify all methods were called
        verify(
          () => mockStorage.write(key: 'access_token', value: testAccessToken),
        ).called(1);
        verify(
          () =>
              mockStorage.write(key: 'refresh_token', value: testRefreshToken),
        ).called(1);
        verify(() => mockStorage.deleteAll()).called(1);
      });
    });
  });
}
