import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/authentication/domain/entities/token_state.dart';

void main() {
  group('TokenState', () {
    group('factory constructors', () {
      testWidgets('should create authenticated state correctly', (
        tester,
      ) async {
        // Arrange
        const accessToken = 'access_token';
        const refreshToken = 'refresh_token';

        // Act
        const state = TokenState.authenticated(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        // Assert
        expect(state, isA<TokenAuthenticated>());
        expect((state as TokenAuthenticated).accessToken, equals(accessToken));
        expect(state.refreshToken, equals(refreshToken));
      });

      testWidgets('should create refreshing state correctly', (tester) async {
        // Arrange
        const refreshToken = 'refresh_token';

        // Act
        const state = TokenState.refreshing(refreshToken: refreshToken);

        // Assert
        expect(state, isA<TokenRefreshing>());
        expect((state as TokenRefreshing).refreshToken, equals(refreshToken));
      });

      testWidgets('should create unauthenticated state correctly', (
        tester,
      ) async {
        // Act
        const state = TokenState.unauthenticated();

        // Assert
        expect(state, isA<TokenUnauthenticated>());
      });

      testWidgets('should create expired state correctly', (tester) async {
        // Arrange
        const refreshToken = 'refresh_token';

        // Act
        const state = TokenState.expired(refreshToken: refreshToken);

        // Assert
        expect(state, isA<TokenExpired>());
        expect((state as TokenExpired).refreshToken, equals(refreshToken));
      });
    });

    group('TokenStateX extensions', () {
      group('isAuthenticated', () {
        testWidgets('should return true for authenticated state', (
          tester,
        ) async {
          // Arrange
          const state = TokenState.authenticated(
            accessToken: 'token',
            refreshToken: 'refresh',
          );

          // Act & Assert
          expect(state.isAuthenticated, isTrue);
        });

        testWidgets('should return false for non-authenticated states', (
          tester,
        ) async {
          // Arrange
          const refreshingState = TokenState.refreshing(
            refreshToken: 'refresh',
          );
          const unauthenticatedState = TokenState.unauthenticated();
          const expiredState = TokenState.expired(refreshToken: 'refresh');

          // Act & Assert
          expect(refreshingState.isAuthenticated, isFalse);
          expect(unauthenticatedState.isAuthenticated, isFalse);
          expect(expiredState.isAuthenticated, isFalse);
        });
      });

      group('isRefreshing', () {
        testWidgets('should return true for refreshing state', (tester) async {
          // Arrange
          const state = TokenState.refreshing(refreshToken: 'refresh');

          // Act & Assert
          expect(state.isRefreshing, isTrue);
        });

        testWidgets('should return false for non-refreshing states', (
          tester,
        ) async {
          // Arrange
          const authenticatedState = TokenState.authenticated(
            accessToken: 'token',
            refreshToken: 'refresh',
          );
          const unauthenticatedState = TokenState.unauthenticated();
          const expiredState = TokenState.expired(refreshToken: 'refresh');

          // Act & Assert
          expect(authenticatedState.isRefreshing, isFalse);
          expect(unauthenticatedState.isRefreshing, isFalse);
          expect(expiredState.isRefreshing, isFalse);
        });
      });
    });

    group('equality and hashing', () {
      testWidgets('should compare states correctly', (tester) async {
        // Arrange
        const state1 = TokenState.authenticated(
          accessToken: 'token',
          refreshToken: 'refresh',
        );
        const state2 = TokenState.authenticated(
          accessToken: 'token',
          refreshToken: 'refresh',
        );
        const state3 = TokenState.authenticated(
          accessToken: 'different_token',
          refreshToken: 'refresh',
        );

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      testWidgets('should have consistent hash codes', (tester) async {
        // Arrange
        const state1 = TokenState.authenticated(
          accessToken: 'token',
          refreshToken: 'refresh',
        );
        const state2 = TokenState.authenticated(
          accessToken: 'token',
          refreshToken: 'refresh',
        );

        // Act & Assert
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });
  });
}
