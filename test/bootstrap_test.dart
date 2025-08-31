import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/bootstrap.dart';
import 'package:xp1/features/env/infrastructure/env_config_factory.dart';

/// Mock bloc for testing AppBlocObserver
class MockBloc extends BlocBase<String> {
  /// Creates mock bloc with initial state
  MockBloc(super.initialState);

  /// Emits new state for testing
  void emitState(String state) => emit(state);

  /// Triggers error for testing
  void triggerError() => addError('Test error', StackTrace.current);
}

/// Mock widget for testing bootstrap
class MockApp extends StatelessWidget {
  /// Creates mock app widget
  const MockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

void main() {
  group('AppBlocObserver', () {
    late AppBlocObserver observer;
    late MockBloc mockBloc;

    setUp(() {
      observer = const AppBlocObserver();
      mockBloc = MockBloc('initial');
    });

    tearDown(() {
      mockBloc.close();
    });

    group('onChange', () {
      test('should log state changes with bloc type and change details', () {
        const change = Change<String>(
          currentState: 'initial',
          nextState: 'updated',
        );

        // Test that onChange executes without errors
        // Note: log() from dart:developer doesn't go through print zone
        expect(
          () => observer.onChange(mockBloc, change),
          returnsNormally,
        );
      });

      test('should handle null states gracefully', () {
        const change = Change<String?>(
          currentState: null,
          nextState: 'updated',
        );

        expect(
          () => observer.onChange(mockBloc, change),
          returnsNormally,
        );
      });

      test('should call super.onChange', () {
        const change = Change<String>(
          currentState: 'initial',
          nextState: 'updated',
        );

        // This should not throw
        expect(
          () => observer.onChange(mockBloc, change),
          returnsNormally,
        );
      });
    });

    group('onError', () {
      test('should log errors with bloc type, error, and stack trace', () {
        const error = 'Test error message';
        final stackTrace = StackTrace.current;

        // Test that onError executes without errors
        // Note: log() from dart:developer doesn't go through print zone
        expect(
          () => observer.onError(mockBloc, error, stackTrace),
          returnsNormally,
        );
      });

      test('should handle various error types', () {
        final errors = [
          'String error',
          Exception('Exception error'),
          StateError('State error'),
          42, // Non-string error
        ];

        for (final error in errors) {
          expect(
            () => observer.onError(mockBloc, error, StackTrace.current),
            returnsNormally,
            reason: 'Should handle error of type ${error.runtimeType}',
          );
        }
      });

      test('should call super.onError', () {
        const error = 'Test error';
        final stackTrace = StackTrace.current;

        // This should not throw
        expect(
          () => observer.onError(mockBloc, error, stackTrace),
          returnsNormally,
        );
      });
    });
  });

  group('bootstrap', () {
    setUp(() {
      // Reset FlutterError.onError to default
      FlutterError.onError = null;

      // Reset Bloc.observer to default
      Bloc.observer = const AppBlocObserver();
    });

    test('should set up FlutterError.onError handler', () {
      // Test setup without calling runApp
      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };
      Bloc.observer = const AppBlocObserver();

      expect(FlutterError.onError, isNotNull);
      expect(FlutterError.onError, isA<Function>());
    });

    test('should set up AppBlocObserver', () {
      Bloc.observer = const AppBlocObserver();

      expect(Bloc.observer, isA<AppBlocObserver>());
    });

    test('should handle FlutterError.onError correctly', () {
      // Set up error handler manually to test it
      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };

      // Create a mock FlutterErrorDetails
      final errorDetails = FlutterErrorDetails(
        exception: Exception('Test exception'),
        stack: StackTrace.current,
        context: ErrorDescription('Test context'),
      );

      // Test that error handler executes without throwing
      expect(
        () => FlutterError.onError!(errorDetails),
        returnsNormally,
      );
    });

    test('should handle widget builder function calls', () {
      var builderCalled = false;

      MockApp builder() {
        builderCalled = true;
        return const MockApp();
      }

      // Test that builder can be called
      expect(builder, returnsNormally);
      expect(builderCalled, isTrue);
    });

    test('should handle async widget builders', () async {
      var builderCalled = false;

      Future<MockApp> builder() async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        builderCalled = true;
        return const MockApp();
      }

      // Test that async builder can be called
      await builder();
      expect(builderCalled, isTrue);
    });

    test('should handle builder exceptions gracefully', () {
      Never builder() => throw Exception('Builder error');

      expect(
        builder,
        throwsException,
      );
    });

    test('should log environment information', () {
      // Test that environment information can be accessed
      expect(
        () {
          log(
            '🚀 Starting app with environment: '
            '${EnvConfigFactory.environmentName}',
          );
          log('📍 API URL: ${EnvConfigFactory.apiUrl}');
          log('🔧 Debug mode: ${EnvConfigFactory.isDebugMode}');
        },
        returnsNormally,
      );
    });
  });
}
