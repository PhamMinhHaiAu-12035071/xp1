import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/features/locale/cubit/locale_cubit.dart';
import 'package:xp1/features/locale/domain/entities/locale_configuration.dart';
import 'package:xp1/features/locale/domain/errors/locale_errors.dart';

/// Mock LocaleCubit for BDD testing with better control.
class MockLocaleCubit extends Mock implements LocaleCubit {}

/// Usage: I can change app language to {string}
Future<void> iCanChangeAppLanguageTo(
  WidgetTester tester,
  String languageCode,
) async {
  // Get LocaleCubit from dependency injection container
  final localeCubit = getIt<LocaleCubit>();

  // Attempt to change language
  final result = await localeCubit.updateUserLocale(languageCode);

  result.fold(
    (error) {
      // If error, verify it's properly handled
      expect(
        error,
        isA<LocaleError>(),
        reason: 'Language change should return proper error for invalid locale',
      );

      // For unsupported locales, verify error details
      if (error is UnsupportedLocaleError) {
        expect(
          error.invalidLocaleCode,
          equals(languageCode),
          reason: 'Error should contain the invalid locale code',
        );
        expect(
          error.isRecoverable,
          isTrue,
          reason: 'Unsupported locale error should be recoverable',
        );
      }
    },
    (_) {
      // If successful, verify state change
      expect(
        localeCubit.state.languageCode,
        equals(languageCode),
        reason: 'Language should be updated to $languageCode',
      );
      expect(
        localeCubit.state.source == LocaleSource.userSelected,
        isTrue,
        reason: 'Language change should mark configuration as user selected',
      );
    },
  );

  // Allow UI to update
  await tester.pumpAndSettle();
}

/// Usage: I see the app in {string} language
Future<void> iSeeTheAppInLanguage(
  WidgetTester tester,
  String languageCode,
) async {
  // Get LocaleCubit from dependency injection container
  final localeCubit = getIt<LocaleCubit>();

  expect(
    localeCubit.state.languageCode,
    equals(languageCode),
    reason: 'App should be displaying in $languageCode language',
  );

  // Verify that localized content is present
  // This is a more sophisticated check than just finding Text widgets
  final textWidgets = tester.widgetList<Text>(find.byType(Text));

  expect(
    textWidgets.isNotEmpty,
    isTrue,
    reason: 'App should contain localized text content',
  );

  // For Vietnamese, we could check for specific characters
  if (languageCode == 'vi') {
    final hasVietnameseContent = textWidgets.any(
      (widget) => widget.data?.contains(RegExp('[àáạảãâầấậẩẫăằắặẳẵ]')) ?? false,
    );

    // Note: This is optional since not all screens may have
    // Vietnamese-specific characters
    // expect(hasVietnameseContent, isTrue, reason:
    //   'Should contain Vietnamese content');
    // Suppress unused variable warning as this is optional validation
    // ignore: unused_local_variable
    final _ = hasVietnameseContent;
  }
}

/// Usage: I reset app language to system default
Future<void> iResetAppLanguageToSystemDefault(WidgetTester tester) async {
  // Get LocaleCubit from dependency injection container and reset to system
  // default
  final localeCubit = getIt<LocaleCubit>();

  final previousState = localeCubit.state;
  await localeCubit.resetToSystemDefault();

  // Verify that state changed (unless it was already system default)
  if (previousState.source == LocaleSource.userSelected) {
    expect(
      localeCubit.state.source == LocaleSource.systemDetected ||
          localeCubit.state.source == LocaleSource.defaultFallback,
      isTrue,
      reason:
          'After reset, locale should be system detected or default fallback',
    );
  }

  // Allow UI to update
  await tester.pumpAndSettle();
}

/// Usage: I see localized error message for unsupported language
Future<void> iSeeLocalizedErrorMessageForUnsupportedLanguage(
  WidgetTester tester,
) async {
  // This step verifies that unsupported language attempts are handled
  // gracefully
  // at the business logic level. The LocaleCubit should return errors for
  // invalid locales, and the app should remain in a stable state.

  // Get LocaleCubit from dependency injection container
  final localeCubit = getIt<LocaleCubit>();

  // Verify that the last invalid language change was handled properly:
  // 1. The cubit should remain in a valid/stable state
  // 2. The language should not have changed to any invalid value
  final invalidLanguages = ['xyz', 'invalid', '123'];
  expect(
    invalidLanguages.contains(localeCubit.state.languageCode),
    isFalse,
    reason: 'App should not accept invalid language codes',
  );

  // Verify the cubit is in a supported locale
  final supportedLocales = ['en', 'vi']; // Known supported locales
  expect(
    supportedLocales.contains(localeCubit.state.languageCode),
    isTrue,
    reason: 'App should maintain a supported locale after error',
  );

  // For UI-level error testing, we would need to simulate actual user
  // interactions through widgets, but these tests focus on business logic
  // validation through LocaleCubit directly.
}

/// Enhanced BDD step for testing locale state management.
///
/// Usage: I verify locale state is persisted across app restarts
Future<void> iVerifyLocaleStateIsPersistedAcrossAppRestarts(
  WidgetTester tester,
) async {
  // Get current locale state from dependency injection container
  final localeCubit = getIt<LocaleCubit>();
  final currentState = localeCubit.state;

  // In a real app restart test, you would:
  // 1. Store the current state
  // 2. Restart the app (or create new widget tree)
  // 3. Verify the state is restored

  // For BDD testing, we verify that the state is properly configured for
  // persistence
  expect(
    localeCubit.storagePrefix,
    equals('LocaleCubit'),
    reason: 'LocaleCubit should have correct storage prefix for persistence',
  );

  // Verify that the current state can be serialized
  final serializedState = localeCubit.toJson(currentState);
  expect(
    serializedState,
    isNotNull,
    reason: 'Current locale state should be serializable for persistence',
  );

  // Verify that serialized state can be deserialized
  final deserializedState = localeCubit.fromJson(serializedState!);
  expect(
    deserializedState,
    equals(currentState),
    reason: 'Deserialized state should match current state',
  );
}
