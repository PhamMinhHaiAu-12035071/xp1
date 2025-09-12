import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/features/authentication/domain/entities/token_entity.dart';
import 'package:xp1/features/authentication/domain/failures/auth_failure.dart';
import 'package:xp1/features/authentication/domain/repositories/auth_repository.dart';
import 'package:xp1/features/authentication/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(
      const LoginInput(
        username: 'fallback-user',
        password: 'fallback-password',
      ),
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginInput', () {
    test('should create LoginInput with required properties', () {
      // Act
      const loginInput = LoginInput(
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(loginInput.username, equals('testuser'));
      expect(loginInput.password, equals('password123'));
    });

    test('should support value equality', () {
      // Arrange
      const loginInput1 = LoginInput(
        username: 'testuser',
        password: 'password123',
      );
      const loginInput2 = LoginInput(
        username: 'testuser',
        password: 'password123',
      );
      const loginInput3 = LoginInput(
        username: 'different',
        password: 'password123',
      );

      // Assert
      expect(loginInput1, equals(loginInput2));
      expect(loginInput1.hashCode, equals(loginInput2.hashCode));
      expect(loginInput1, isNot(equals(loginInput3)));
    });
  });

  group('LoginResult', () {
    test('should create LoginResult with required properties', () {
      // Arrange
      const token = TokenEntity(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        tokenType: 'Bearer',
        ttl: 3600,
      );

      // Act
      const loginResult = LoginResult(token: token);

      // Assert
      expect(loginResult.token, equals(token));
    });
  });

  group('LoginUseCase', () {
    const testLoginInput = LoginInput(
      username: 'testuser',
      password: 'password123',
    );

    test('should return LoginResult when login succeeds', () async {
      // Arrange
      const expectedToken = TokenEntity(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        tokenType: 'Bearer',
        ttl: 3600,
      );
      const expectedResult = LoginResult(token: expectedToken);

      when(
        () => mockAuthRepository.login(testLoginInput),
      ).thenAnswer((_) async => const Right(expectedResult));

      // Act
      final result = await loginUseCase.call(testLoginInput);

      // Assert
      expect(result, isA<Right<AuthFailure, LoginResult>>());
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (loginResult) {
          expect(loginResult.token, equals(expectedToken));
        },
      );

      verify(() => mockAuthRepository.login(testLoginInput)).called(1);
    });

    test('should return AuthFailure when login fails', () async {
      // Arrange
      const expectedFailure = AuthFailure.invalidCredentials();

      when(
        () => mockAuthRepository.login(testLoginInput),
      ).thenAnswer((_) async => const Left(expectedFailure));

      // Act
      final result = await loginUseCase.call(testLoginInput);

      // Assert
      expect(result, isA<Left<AuthFailure, LoginResult>>());
      result.fold(
        (failure) => expect(failure, equals(expectedFailure)),
        (loginResult) => fail('Expected Left but got Right: $loginResult'),
      );

      verify(() => mockAuthRepository.login(testLoginInput)).called(1);
    });

    test('should delegate to repository with correct input', () async {
      // Arrange
      const loginResult = LoginResult(
        token: TokenEntity(
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
          tokenType: 'Bearer',
          ttl: 3600,
        ),
      );

      when(
        () => mockAuthRepository.login(any()),
      ).thenAnswer((_) async => const Right(loginResult));

      // Act
      await loginUseCase.call(testLoginInput);

      // Assert
      verify(() => mockAuthRepository.login(testLoginInput)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
