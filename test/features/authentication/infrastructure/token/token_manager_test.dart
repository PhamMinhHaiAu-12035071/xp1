import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/core/storage/secure_storage_service.dart';
import 'package:xp1/features/authentication/domain/entities/token_state.dart';
import 'package:xp1/features/authentication/domain/failures/auth_failure.dart';
import 'package:xp1/features/authentication/infrastructure/services/auth_api_service.dart';
import 'package:xp1/features/authentication/infrastructure/token/token_manager.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockLogger extends Mock implements ILoggerService {}

class MockAuthApiService extends Mock implements AuthApiService {}

void main() {
  group('TokenManager', () {
    late TokenManager tokenManager;
    late MockSecureStorageService mockStorageService;
    late MockLogger mockLogger;
    late MockAuthApiService mockAuthApiService;

    setUp(() {
      mockStorageService = MockSecureStorageService();
      mockLogger = MockLogger();
      mockAuthApiService = MockAuthApiService();
      tokenManager = TokenManager(
        mockStorageService,
        mockLogger,
        mockAuthApiService,
      );
    });

    tearDown(() {
      tokenManager.dispose();
    });

    group('getValidAccessToken', () {
      testWidgets('should return stored token when valid', (tester) async {
        // Arrange
        const storedToken = 'valid_access_token';
        when(
          () => mockStorageService.getAccessToken(),
        ).thenAnswer((_) async => storedToken);

        // Act
        final result = await tokenManager.getValidAccessToken();

        // Assert
        expect(result, equals(storedToken));
        verify(() => mockStorageService.getAccessToken()).called(1);
      });

      testWidgets('should return null when no token stored', (tester) async {
        // Arrange
        when(
          () => mockStorageService.getAccessToken(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await tokenManager.getValidAccessToken();

        // Assert
        expect(result, isNull);
        verify(() => mockStorageService.getAccessToken()).called(1);
      });
    });

    group('initializeFromStorage', () {
      testWidgets('should set authenticated state when tokens exist', (
        tester,
      ) async {
        // Arrange - Use valid JWT format tokens
        const accessToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
            'eyJzdWIiOiIxMjM0IiwibmFtZSI6IkpvaG4iLCJpYXQiOjE1MTZ9.'
            'SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        const refreshToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
            'eyJzdWIiOiIxMjM0NTY3ODkwIiwicmVmcmVzaCI6dHJ1ZX0.'
            'example_refresh_token_signature';

        when(
          () => mockStorageService.getAccessToken(),
        ).thenAnswer((_) async => accessToken);
        when(
          () => mockStorageService.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);

        // Act
        await tokenManager.initializeFromStorage();

        // Assert
        expect(tokenManager.currentState.isAuthenticated, isTrue);
        verify(() => mockStorageService.getAccessToken()).called(1);
        verify(() => mockStorageService.getRefreshToken()).called(1);
      });

      testWidgets('should set unauthenticated state when no tokens', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockStorageService.getAccessToken(),
        ).thenAnswer((_) async => null);
        when(
          () => mockStorageService.getRefreshToken(),
        ).thenAnswer((_) async => null);

        // Act
        await tokenManager.initializeFromStorage();

        // Assert
        expect(
          tokenManager.currentState,
          equals(const TokenState.unauthenticated()),
        );
        verify(() => mockStorageService.getAccessToken()).called(1);
        verify(() => mockStorageService.getRefreshToken()).called(1);
      });
    });

    group('state management', () {
      testWidgets('should handle state transitions correctly', (tester) async {
        // Arrange - test that states transition

        // Mock storage service to return valid tokens
        const accessToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
            'eyJzdWIiOiIxMjM0IiwibmFtZSI6IkpvaG4iLCJpYXQiOjE1MTZ9.'
            'SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        const refreshToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
            'eyJzdWIiOiIxMjM0NTY3ODkwIiwicmVmcmVzaCI6dHJ1ZX0.'
            'example_refresh_token_signature';

        when(
          () => mockStorageService.getAccessToken(),
        ).thenAnswer((_) async => accessToken);
        when(
          () => mockStorageService.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);

        // Assert initial state is unauthenticated
        expect(
          tokenManager.currentState,
          equals(const TokenState.unauthenticated()),
        );

        // Act
        await tokenManager.initializeFromStorage();

        // Assert final state is authenticated with correct tokens
        expect(tokenManager.currentState.isAuthenticated, isTrue);
        final authenticatedState =
            tokenManager.currentState as TokenAuthenticated;
        expect(authenticatedState.accessToken, equals(accessToken));
        expect(authenticatedState.refreshToken, equals(refreshToken));

        // Verify storage service was called correctly
        verify(() => mockStorageService.getAccessToken()).called(1);
        verify(() => mockStorageService.getRefreshToken()).called(1);
      });

      testWidgets('should track current state correctly', (tester) async {
        // Arrange
        expect(
          tokenManager.currentState,
          equals(const TokenState.unauthenticated()),
        );

        // Mock storage service to return null tokens
        when(
          () => mockStorageService.getAccessToken(),
        ).thenAnswer((_) async => null);
        when(
          () => mockStorageService.getRefreshToken(),
        ).thenAnswer((_) async => null);

        // Act
        await tokenManager.initializeFromStorage();

        // Assert - state should be updated
        expect(tokenManager.currentState, isA<TokenState>());
      });
    });

    group('refreshToken failure scenarios', () {
      testWidgets('should return noRefreshToken failure when no token stored', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockStorageService.getRefreshToken(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await tokenManager.refreshToken();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) =>
              expect(failure, equals(const AuthFailure.noRefreshToken())),
          (token) => fail('Expected failure'),
        );
      });
    });

    group('waitForValidToken', () {
      testWidgets('should return immediately when no refresh in progress', (
        tester,
      ) async {
        // Arrange
        const storedToken = 'valid_token';
        when(
          () => mockStorageService.getAccessToken(),
        ).thenAnswer((_) async => storedToken);

        // Act
        final result = await tokenManager.waitForValidToken();

        // Assert
        expect(result, equals(storedToken));
      });
    });

    group('logging', () {
      testWidgets('should log refresh operations appropriately', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockStorageService.getRefreshToken(),
        ).thenAnswer((_) async => null);

        // Act
        await tokenManager.refreshToken();

        // Assert
        verify(
          () => mockLogger.log(
            any(that: contains('Token refresh')),
            LogLevel.info,
          ),
        ).called(1);
      });
    });
  });
}
