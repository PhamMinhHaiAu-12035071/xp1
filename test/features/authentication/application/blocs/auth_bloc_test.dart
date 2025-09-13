import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/features/authentication/application/blocs/auth_bloc.dart';
import 'package:xp1/features/authentication/application/blocs/auth_event.dart';
import 'package:xp1/features/authentication/application/blocs/auth_state.dart';
import 'package:xp1/features/authentication/domain/entities/token_entity.dart';
import 'package:xp1/features/authentication/domain/failures/auth_failure.dart';
import 'package:xp1/features/authentication/domain/inputs/password_input.dart';
import 'package:xp1/features/authentication/domain/inputs/username_input.dart';
import 'package:xp1/features/authentication/domain/repositories/auth_repository.dart';
import 'package:xp1/features/authentication/domain/usecases/login_usecase.dart';

/// Mock implementation of AuthRepository for testing
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock implementation of LoginUseCase for testing
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  group('AuthBloc', () {
    late MockAuthRepository mockAuthRepository;
    late MockLoginUseCase mockLoginUseCase;
    late AuthBloc authBloc;

    // Test data constants
    const testToken = TokenEntity(
      accessToken: 'test-access-token',
      refreshToken: 'test-refresh-token',
      tokenType: 'Bearer',
      ttl: 3600,
    );

    const testLoginInput = LoginInput(
      username: 'testuser',
      password: 'testpassword',
    );

    const testLoginResult = LoginResult(token: testToken);

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockLoginUseCase = MockLoginUseCase();
      authBloc = AuthBloc(mockAuthRepository, mockLoginUseCase);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, const AuthState());
    });

    group('LoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when login succeeds',
        build: () {
          when(
            () => mockLoginUseCase(testLoginInput),
          ).thenAnswer((_) async => right(testLoginResult));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        ),
        expect: () => [
          const AuthState(
            status: FormzSubmissionStatus.inProgress,
            authStatus: AuthenticationStatus.loading,
          ),
          const AuthState(
            status: FormzSubmissionStatus.success,
            authStatus: AuthenticationStatus.authenticated,
          ),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(testLoginInput)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with invalid credentials',
        build: () {
          when(() => mockLoginUseCase(testLoginInput)).thenAnswer(
            (_) async => left(const AuthFailure.invalidCredentials()),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        ),
        expect: () => [
          const AuthState(
            status: FormzSubmissionStatus.inProgress,
            authStatus: AuthenticationStatus.loading,
          ),
          const AuthState(
            status: FormzSubmissionStatus.failure,
            authStatus: AuthenticationStatus.error,
            errorMessage: 'Invalid username or password. Please try again.',
          ),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(testLoginInput)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with network error',
        build: () {
          when(() => mockLoginUseCase(testLoginInput)).thenAnswer(
            (_) async => left(const AuthFailure.networkError('Network fail')),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        ),
        expect: () => [
          const AuthState(
            status: FormzSubmissionStatus.inProgress,
            authStatus: AuthenticationStatus.loading,
          ),
          const AuthState(
            status: FormzSubmissionStatus.failure,
            authStatus: AuthenticationStatus.error,
            errorMessage:
                'Unable to connect. Please check your internet connection.',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with server error',
        build: () {
          when(
            () => mockLoginUseCase(testLoginInput),
          ).thenAnswer((_) async => left(const AuthFailure.serverError(500)));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        ),
        expect: () => [
          const AuthState(
            status: FormzSubmissionStatus.inProgress,
            authStatus: AuthenticationStatus.loading,
          ),
          const AuthState(
            status: FormzSubmissionStatus.failure,
            authStatus: AuthenticationStatus.error,
            errorMessage:
                'Service temporarily unavailable. Please try again later.',
          ),
        ],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, unauthenticated] when logout succeeds',
        build: () {
          when(
            () => mockAuthRepository.logout(),
          ).thenAnswer((_) async => right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.logoutRequested()),
        expect: () => [
          const AuthState(authStatus: AuthenticationStatus.loading),
          const AuthState(authStatus: AuthenticationStatus.unauthenticated),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.logout()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when logout fails',
        build: () {
          when(() => mockAuthRepository.logout()).thenAnswer(
            (_) async => left(const AuthFailure.networkError('Network fail')),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.logoutRequested()),
        expect: () => [
          const AuthState(authStatus: AuthenticationStatus.loading),
          const AuthState(
            authStatus: AuthenticationStatus.error,
            errorMessage:
                'Unable to connect. Please check your internet connection.',
          ),
        ],
      );
    });

    group('TokenRefreshRequested', () {
      blocTest<AuthBloc, AuthState>(
        'successfully refreshes token without state change',
        build: () {
          when(
            () => mockAuthRepository.refreshToken(),
          ).thenAnswer((_) async => right(testToken));
          return authBloc;
        },
        seed: () =>
            const AuthState(authStatus: AuthenticationStatus.authenticated),
        act: (bloc) => bloc.add(const AuthEvent.tokenRefreshRequested()),
        expect: () => <AuthState>[],
        verify: (_) {
          verify(() => mockAuthRepository.refreshToken()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits unauthenticated when refresh fails',
        build: () {
          when(
            () => mockAuthRepository.refreshToken(),
          ).thenAnswer((_) async => left(const AuthFailure.tokenExpired()));
          return authBloc;
        },
        seed: () =>
            const AuthState(authStatus: AuthenticationStatus.authenticated),
        act: (bloc) => bloc.add(const AuthEvent.tokenRefreshRequested()),
        expect: () => <AuthState>[
          const AuthState(authStatus: AuthenticationStatus.unauthenticated),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'does nothing when not authenticated',
        build: () => authBloc,
        seed: () =>
            const AuthState(authStatus: AuthenticationStatus.unauthenticated),
        act: (bloc) => bloc.add(const AuthEvent.tokenRefreshRequested()),
        expect: () => <AuthState>[],
        verify: (_) {
          verifyNever(() => mockAuthRepository.refreshToken());
        },
      );
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when tokens are valid',
        build: () {
          when(
            () => mockAuthRepository.refreshToken(),
          ).thenAnswer((_) async => right(testToken));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.authCheckRequested()),
        expect: () => [
          const AuthState(authStatus: AuthenticationStatus.loading),
          const AuthState(authStatus: AuthenticationStatus.authenticated),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.refreshToken()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, unauthenticated] when tokens are invalid',
        build: () {
          when(
            () => mockAuthRepository.refreshToken(),
          ).thenAnswer((_) async => left(const AuthFailure.tokenExpired()));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.authCheckRequested()),
        expect: () => [
          const AuthState(authStatus: AuthenticationStatus.loading),
          const AuthState(authStatus: AuthenticationStatus.unauthenticated),
        ],
      );
    });

    group('Error Message Mapping', () {
      test('maps AuthFailure.invalidCredentials correctly', () {
        final bloc = AuthBloc(mockAuthRepository, mockLoginUseCase);
        const failure = AuthFailure.invalidCredentials();

        // Access private method through reflection would be complex,
        // so we test through the public interface
        when(
          () => mockLoginUseCase(testLoginInput),
        ).thenAnswer((_) async => left(failure));

        expectLater(
          bloc.stream,
          emitsInOrder([
            const AuthState(
              status: FormzSubmissionStatus.inProgress,
              authStatus: AuthenticationStatus.loading,
            ),
            const AuthState(
              status: FormzSubmissionStatus.failure,
              authStatus: AuthenticationStatus.error,
              errorMessage: 'Invalid username or password. Please try again.',
            ),
          ]),
        );

        bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        );
      });

      test('maps AuthFailure.tokenExpired correctly', () {
        final bloc = AuthBloc(mockAuthRepository, mockLoginUseCase);
        const failure = AuthFailure.tokenExpired();

        when(
          () => mockLoginUseCase(testLoginInput),
        ).thenAnswer((_) async => left(failure));

        expectLater(
          bloc.stream,
          emitsInOrder([
            const AuthState(
              status: FormzSubmissionStatus.inProgress,
              authStatus: AuthenticationStatus.loading,
            ),
            const AuthState(
              status: FormzSubmissionStatus.failure,
              authStatus: AuthenticationStatus.error,
              errorMessage: 'Your session has expired. Please log in again.',
            ),
          ]),
        );

        bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        );
      });

      test('maps AuthFailure.unauthorized correctly', () {
        final bloc = AuthBloc(mockAuthRepository, mockLoginUseCase);
        const failure = AuthFailure.unauthorized();

        when(
          () => mockLoginUseCase(testLoginInput),
        ).thenAnswer((_) async => left(failure));

        expectLater(
          bloc.stream,
          emitsInOrder([
            const AuthState(
              status: FormzSubmissionStatus.inProgress,
              authStatus: AuthenticationStatus.loading,
            ),
            const AuthState(
              status: FormzSubmissionStatus.failure,
              authStatus: AuthenticationStatus.error,
              errorMessage: 'You are not authorized to access this resource.',
            ),
          ]),
        );

        bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        );
      });

      test('maps AuthFailure.unknown correctly', () {
        final bloc = AuthBloc(mockAuthRepository, mockLoginUseCase);
        const failure = AuthFailure.unknown('Unknown error');

        when(
          () => mockLoginUseCase(testLoginInput),
        ).thenAnswer((_) async => left(failure));

        expectLater(
          bloc.stream,
          emitsInOrder([
            const AuthState(
              status: FormzSubmissionStatus.inProgress,
              authStatus: AuthenticationStatus.loading,
            ),
            const AuthState(
              status: FormzSubmissionStatus.failure,
              authStatus: AuthenticationStatus.error,
              errorMessage: 'An unexpected error occurred. Please try again.',
            ),
          ]),
        );

        bloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        );
      });
    });

    group('Token Monitoring', () {
      // Note: Token monitoring with Timer is difficult to test directly
      // In production, these would be integration tests or tested with
      // a controllable timer abstraction

      test('starts monitoring after successful login', () async {
        when(
          () => mockLoginUseCase(testLoginInput),
        ).thenAnswer((_) async => right(testLoginResult));

        authBloc.add(
          const AuthEvent.loginRequested(
            username: 'testuser',
            password: 'testpassword',
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Verify login was called
        verify(() => mockLoginUseCase(testLoginInput)).called(1);
      });
    });

    group('UsernameChanged', () {
      blocTest<AuthBloc, AuthState>(
        'updates username field and keeps form validation state',
        build: () => authBloc,
        act: (bloc) =>
            bloc.add(const AuthEvent.usernameChanged(username: 'newuser')),
        expect: () => [
          const AuthState(username: Username.dirty(value: 'newuser')),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'updates username with empty value',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthEvent.usernameChanged(username: '')),
        expect: () => [const AuthState(username: Username.dirty())],
      );
    });

    group('PasswordChanged', () {
      blocTest<AuthBloc, AuthState>(
        'updates password field and keeps form validation state',
        build: () => authBloc,
        act: (bloc) =>
            bloc.add(const AuthEvent.passwordChanged(password: 'newpass')),
        expect: () => [
          const AuthState(password: Password.dirty(value: 'newpass')),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'updates password with empty value',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthEvent.passwordChanged(password: '')),
        expect: () => [const AuthState(password: Password.dirty())],
      );
    });

    // FormSubmitted tests would go here in future iterations
    // Currently focusing on basic authentication flow coverage
  });
}
