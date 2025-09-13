import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/widgets/atoms/responsive_initializer.dart';
import 'package:xp1/core/widgets/molecules/animated_text_field.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('AnimatedTextField', () {
    setUpAll(TestDependencyContainer.setupTestDependencies);
    tearDownAll(TestDependencyContainer.resetTestDependencies);

    late TextEditingController controller;
    late FocusNode focusNode;
    late AnimationController animationController;
    late Animation<double> animation;

    Widget createTestWidget({
      required Widget child,
    }) {
      return ResponsiveInitializer(
        designSize: const Size(375, 812),
        builder: (context) => MaterialApp(
          home: Scaffold(
            body: Center(child: child),
          ),
        ),
      );
    }

    AnimatedTextFieldConfig createTestConfig({
      String label = 'Test Field',
      TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      Widget? suffixIcon,
      TextInputAction textInputAction = TextInputAction.next,
      void Function(String)? onFieldSubmitted,
      void Function(String)? onChanged,
    }) {
      return AnimatedTextFieldConfig(
        controller: controller,
        focusNode: focusNode,
        animationController: animationController,
        animation: animation,
        prefixIcon: const Icon(Icons.person),
        label: label,
        keyboardType: keyboardType,
        obscureText: obscureText,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      );
    }

    setUp(() {
      controller = TextEditingController();
      focusNode = FocusNode();
      // Initialize animation controller with a default vsync
      animationController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: const TestVSync(),
      );
      animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    });

    tearDown(() {
      controller.dispose();
      focusNode.dispose();
      animationController.dispose();
    });

    Widget buildTestWidget(TickerProvider vsync) {
      animationController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: vsync,
      );
      animation = Tween<double>(begin: 0, end: 1).animate(animationController);

      return createTestWidget(
        child: AnimatedTextField(
          config: createTestConfig(),
          isLoading: false,
        ),
      );
    }

    group('Basic Functionality', () {
      testWidgets('should display text field with label', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        expect(find.byType(AnimatedTextField), findsOneWidget);
        expect(find.text('Test Field'), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should accept text input', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Hello World');
        await tester.pump();

        expect(controller.text, 'Hello World');
        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('should show prefix icon', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('should show suffix icon when provided', (tester) async {
        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(
                suffixIcon: const Icon(Icons.visibility),
              ),
              isLoading: false,
            ),
          ),
        );

        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('should be disabled when loading', (tester) async {
        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(),
              isLoading: true,
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(textField.enabled, isFalse);
      });

      testWidgets('should be enabled when not loading', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(textField.enabled, isTrue);
      });
    });

    group('Text Input Behavior', () {
      testWidgets('should handle different keyboard types', (tester) async {
        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(
                keyboardType: TextInputType.emailAddress,
              ),
              isLoading: false,
            ),
          ),
        );

        // Test passes if widget builds without errors
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should handle password obscuring', (tester) async {
        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(obscureText: true),
              isLoading: false,
            ),
          ),
        );

        // Test passes if widget builds without errors
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should handle text input actions', (tester) async {
        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(
                textInputAction: TextInputAction.done,
              ),
              isLoading: false,
            ),
          ),
        );

        // Test passes if widget builds without errors
        expect(find.byType(TextFormField), findsOneWidget);
      });
    });

    group('Callbacks', () {
      testWidgets('should call onChanged when text changes', (tester) async {
        var callbackValue = '';
        void onChanged(String value) {
          callbackValue = value;
        }

        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(onChanged: onChanged),
              isLoading: false,
            ),
          ),
        );

        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Test input');
        await tester.pump();

        expect(callbackValue, 'Test input');
      });

      testWidgets('should call onFieldSubmitted when submitted', (
        tester,
      ) async {
        var submittedValue = '';
        void onFieldSubmitted(String value) {
          submittedValue = value;
        }

        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(onFieldSubmitted: onFieldSubmitted),
              isLoading: false,
            ),
          ),
        );

        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Submit test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(submittedValue, 'Submit test');
      });
    });

    group('Focus Behavior', () {
      testWidgets('should handle focus changes', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        expect(focusNode.hasFocus, isFalse);

        // Tap the text field to focus it
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        expect(focusNode.hasFocus, isTrue);
      });

      testWidgets('should respond to focus state changes', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        // Initially, animation should be at 0
        expect(animationController.value, 0);

        // Focus the field
        focusNode.requestFocus();
        await tester.pump();

        // Verify the widget responds to focus state
        expect(focusNode.hasFocus, isTrue);
        expect(find.byType(AnimatedTextField), findsOneWidget);

        // Unfocus the field
        focusNode.unfocus();
        await tester.pump();

        expect(focusNode.hasFocus, isFalse);
        expect(find.byType(AnimatedTextField), findsOneWidget);
      });
    });

    group('Visual Components', () {
      testWidgets('should have proper container structure', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      });

      testWidgets('should display custom paint for border animation', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(tester));

        expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
      });

      testWidgets('should have animated positioned label', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        expect(find.byType(AnimatedPositioned), findsOneWidget);
        expect(find.byType(AnimatedDefaultTextStyle), findsAtLeastNWidgets(1));
      });
    });

    group('Label Animation', () {
      testWidgets('should move label when focused', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        // Verify the label text exists
        expect(find.text('Test Field'), findsOneWidget);

        // Focus the field and trigger animation
        focusNode.requestFocus();
        await tester.pump();
        await tester.pumpAndSettle();

        // Verify widget still exists after focus
        expect(find.text('Test Field'), findsOneWidget);
        expect(find.byType(AnimatedTextField), findsOneWidget);
      });

      testWidgets('should move label when text is entered', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        // Verify the label text exists
        expect(find.text('Test Field'), findsOneWidget);

        // Enter text
        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Some text');
        await tester.pump();
        await tester.pumpAndSettle();

        // Verify widget still exists and text was entered
        expect(find.text('Test Field'), findsOneWidget);
        expect(find.text('Some text'), findsOneWidget);
        expect(controller.text, 'Some text');
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty text gracefully', (tester) async {
        await tester.pumpWidget(buildTestWidget(tester));

        final textField = find.byType(TextFormField);
        await tester.enterText(textField, '');
        await tester.pump();

        expect(controller.text, '');
        expect(find.byType(AnimatedTextField), findsOneWidget);
      });

      testWidgets('should handle null callbacks gracefully', (tester) async {
        animationController = AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: tester,
        );
        animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animationController);

        await tester.pumpWidget(
          createTestWidget(
            child: AnimatedTextField(
              config: createTestConfig(),
              isLoading: false,
            ),
          ),
        );

        // Should not crash when entering text
        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(find.byType(AnimatedTextField), findsOneWidget);
      });

      testWidgets('should handle animation controller disposal', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(tester));

        expect(find.byType(AnimatedTextField), findsOneWidget);

        // Dispose and rebuild
        await tester.pumpWidget(const SizedBox());
        expect(find.byType(AnimatedTextField), findsNothing);
      });
    });

    group('Platform Specific Behavior', () {
      testWidgets('should handle different design sizes', (tester) async {
        await tester.pumpWidget(
          ResponsiveInitializer(
            designSize: const Size(414, 896), // Different design size
            builder: (context) {
              animationController = AnimationController(
                duration: const Duration(milliseconds: 400),
                vsync: tester,
              );
              animation = Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animationController);

              return MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: AnimatedTextField(
                      config: createTestConfig(),
                      isLoading: false,
                    ),
                  ),
                ),
              );
            },
          ),
        );

        expect(find.byType(AnimatedTextField), findsOneWidget);
        expect(find.text('Test Field'), findsOneWidget);
      });
    });
  });

  group('AnimatedTextFieldConfig', () {
    test('should create configuration with required parameters', () {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      final animationController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: const TestVSync(),
      );
      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animationController);

      final config = AnimatedTextFieldConfig(
        controller: controller,
        focusNode: focusNode,
        animationController: animationController,
        animation: animation,
        prefixIcon: const Icon(Icons.person),
        label: 'Test Label',
        keyboardType: TextInputType.text,
      );

      expect(config.controller, controller);
      expect(config.focusNode, focusNode);
      expect(config.animationController, animationController);
      expect(config.animation, animation);
      expect(config.label, 'Test Label');
      expect(config.keyboardType, TextInputType.text);
      expect(config.obscureText, isFalse);
      expect(config.textInputAction, TextInputAction.next);

      controller.dispose();
      focusNode.dispose();
      animationController.dispose();
    });

    test('should handle optional parameters', () {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      final animationController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: const TestVSync(),
      );
      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animationController);
      const suffixIcon = Icon(Icons.visibility);

      void onChanged(String value) {}
      void onFieldSubmitted(String value) {}

      final config = AnimatedTextFieldConfig(
        controller: controller,
        focusNode: focusNode,
        animationController: animationController,
        animation: animation,
        prefixIcon: const Icon(Icons.person),
        label: 'Password',
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        suffixIcon: suffixIcon,
        textInputAction: TextInputAction.done,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      );

      expect(config.obscureText, isTrue);
      expect(config.suffixIcon, suffixIcon);
      expect(config.textInputAction, TextInputAction.done);
      expect(config.onChanged, onChanged);
      expect(config.onFieldSubmitted, onFieldSubmitted);

      controller.dispose();
      focusNode.dispose();
      animationController.dispose();
    });
  });
}

class TestVSync extends TickerProvider {
  const TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
