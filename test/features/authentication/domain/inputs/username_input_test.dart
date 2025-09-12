import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/authentication/domain/inputs/username_input.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

void main() {
  group('Username', () {
    group('constructor', () {
      test('pure() creates pure username with empty value', () {
        const username = Username.pure();
        expect(username.value, '');
        expect(username.isPure, isTrue);
        expect(username.isValid, isFalse);
      });

      test('dirty() creates dirty username with provided value', () {
        const username = Username.dirty(value: 'testuser');
        expect(username.value, 'testuser');
        expect(username.isPure, isFalse);
        expect(username.isValid, isTrue);
      });

      test(
        'dirty() creates dirty username with empty value when not provided',
        () {
          const username = Username.dirty();
          expect(username.value, '');
          expect(username.isPure, isFalse);
          expect(username.isValid, isFalse);
        },
      );
    });

    group('validator', () {
      test('returns empty error when value is empty', () {
        const username = Username.dirty();
        expect(username.error, UsernameValidationError.empty);
        expect(username.isValid, isFalse);
      });

      test('returns null when value is not empty', () {
        const username = Username.dirty(value: 'testuser');
        expect(username.error, isNull);
        expect(username.isValid, isTrue);
      });

      test('returns null for single character username', () {
        const username = Username.dirty(value: 'a');
        expect(username.error, isNull);
        expect(username.isValid, isTrue);
      });

      test('returns null for two character username', () {
        const username = Username.dirty(value: 'ab');
        expect(username.error, isNull);
        expect(username.isValid, isTrue);
      });

      test('returns null for username with spaces', () {
        const username = Username.dirty(value: 'test user');
        expect(username.error, isNull);
        expect(username.isValid, isTrue);
      });

      test('returns null for username with special characters', () {
        const username = Username.dirty(value: 'test@user.com');
        expect(username.error, isNull);
        expect(username.isValid, isTrue);
      });
    });

    group('state transitions', () {
      test('pure to dirty with valid value becomes valid', () {
        const pureUsername = Username.pure();
        expect(pureUsername.isPure, isTrue);
        expect(pureUsername.isValid, isFalse);

        const dirtyUsername = Username.dirty(value: 'testuser');
        expect(dirtyUsername.isPure, isFalse);
        expect(dirtyUsername.isValid, isTrue);
      });

      test('pure to dirty with invalid value becomes invalid', () {
        const pureUsername = Username.pure();
        expect(pureUsername.isPure, isTrue);
        expect(pureUsername.isValid, isFalse);

        const dirtyUsername = Username.dirty();
        expect(dirtyUsername.isPure, isFalse);
        expect(dirtyUsername.isValid, isFalse);
      });
    });

    group('localized error messages', () {
      test('empty error returns localized required message', () {
        const error = UsernameValidationError.empty;
        expect(error.message, t.pages.login.validation.usernameRequired);
      });
    });
  });
}
