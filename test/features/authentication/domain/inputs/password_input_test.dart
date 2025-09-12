import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/authentication/domain/inputs/password_input.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

void main() {
  group('Password', () {
    group('constructor', () {
      test('pure() creates pure password with empty value', () {
        const password = Password.pure();
        expect(password.value, '');
        expect(password.isPure, isTrue);
        expect(password.isValid, isFalse);
      });

      test('dirty() creates dirty password with provided value', () {
        const password = Password.dirty(value: 'testpass');
        expect(password.value, 'testpass');
        expect(password.isPure, isFalse);
        expect(password.isValid, isTrue);
      });

      test(
        'dirty() creates dirty password with empty value when not provided',
        () {
          const password = Password.dirty();
          expect(password.value, '');
          expect(password.isPure, isFalse);
          expect(password.isValid, isFalse);
        },
      );
    });

    group('validator', () {
      test('returns empty error when value is empty', () {
        const password = Password.dirty();
        expect(password.error, PasswordValidationError.empty);
        expect(password.isValid, isFalse);
      });

      test('returns null when value is not empty', () {
        const password = Password.dirty(value: 'testpass');
        expect(password.error, isNull);
        expect(password.isValid, isTrue);
      });

      test('returns null for single character password', () {
        const password = Password.dirty(value: 'a');
        expect(password.error, isNull);
        expect(password.isValid, isTrue);
      });

      test('returns null for short password', () {
        const password = Password.dirty(value: '123');
        expect(password.error, isNull);
        expect(password.isValid, isTrue);
      });

      test('returns null for weak password', () {
        const password = Password.dirty(value: 'password');
        expect(password.error, isNull);
        expect(password.isValid, isTrue);
      });
    });

    group('state transitions', () {
      test('pure to dirty with valid value becomes valid', () {
        const purePassword = Password.pure();
        expect(purePassword.isPure, isTrue);
        expect(purePassword.isValid, isFalse);

        const dirtyPassword = Password.dirty(value: 'testpass');
        expect(dirtyPassword.isPure, isFalse);
        expect(dirtyPassword.isValid, isTrue);
      });

      test('pure to dirty with invalid value becomes invalid', () {
        const purePassword = Password.pure();
        expect(purePassword.isPure, isTrue);
        expect(purePassword.isValid, isFalse);

        const dirtyPassword = Password.dirty();
        expect(dirtyPassword.isPure, isFalse);
        expect(dirtyPassword.isValid, isFalse);
      });
    });

    group('localized error messages', () {
      test('empty error returns localized required message', () {
        const error = PasswordValidationError.empty;
        expect(error.message, t.pages.login.validation.passwordRequired);
      });
    });
  });
}
