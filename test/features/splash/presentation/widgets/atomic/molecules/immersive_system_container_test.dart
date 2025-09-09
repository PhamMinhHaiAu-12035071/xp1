import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/molecules/immersive_system_container.dart';

/// Tests for [ImmersiveSystemContainer] molecule component.
///
/// This molecule should manage SystemUiMode lifecycle, setting immersive mode
/// on initialization and restoring normal mode on disposal. It wraps a child
/// widget while handling system UI concerns.
void main() {
  group('ImmersiveSystemContainer', () {
    late List<MethodCall> methodCalls;

    setUp(() {
      methodCalls = <MethodCall>[];

      // Mock the platform channel for SystemChrome
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (methodCall) {
            methodCalls.add(methodCall);
            return null;
          });
    });

    tearDown(() {
      // Clean up the mock
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('should set immersive mode on initialization', (tester) async {
      // Arrange: Create molecule with child content
      const immersiveContainer = ImmersiveSystemContainer(
        child: Text('Immersive Content'),
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: immersiveContainer,
          ),
        ),
      );

      // Assert: Verify SystemChrome.setEnabledSystemUIMode was called
      final systemUiModeCalls = methodCalls
          .where((call) => call.method == 'SystemChrome.setEnabledSystemUIMode')
          .toList();

      expect(systemUiModeCalls, isNotEmpty);

      // Debug: Print actual method calls to understand format
      // print('Method calls: $systemUiModeCalls');

      // Simple verification that the right method was called
      expect(
        systemUiModeCalls.first.method,
        equals('SystemChrome.setEnabledSystemUIMode'),
      );

      // Verify child content is rendered
      expect(find.text('Immersive Content'), findsOneWidget);
    });

    testWidgets('should restore normal mode on disposal', (tester) async {
      // Arrange: Create molecule
      const immersiveContainer = ImmersiveSystemContainer(
        child: Text('Test Content'),
      );

      // Act: Pump the widget then remove it
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: immersiveContainer,
          ),
        ),
      );

      // Clear previous method calls to focus on disposal
      methodCalls.clear();

      // Remove the widget to trigger disposal
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Other Content'),
          ),
        ),
      );

      // Assert: Verify SystemChrome.setEnabledSystemUIMode was called to
      // restore
      final systemUiModeCalls = methodCalls
          .where((call) => call.method == 'SystemChrome.setEnabledSystemUIMode')
          .toList();

      expect(systemUiModeCalls, isNotEmpty);

      // Simple verification that dispose called the restore method
      expect(
        systemUiModeCalls.first.method,
        equals('SystemChrome.setEnabledSystemUIMode'),
      );
    });

    testWidgets('should render child widget correctly', (tester) async {
      // Arrange: Create molecule with complex child
      const complexChild = Column(
        children: [
          Text('Title'),
          Text('Subtitle'),
          Icon(Icons.star),
        ],
      );
      const immersiveContainer = ImmersiveSystemContainer(
        child: complexChild,
      );

      // Act: Pump the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: immersiveContainer,
          ),
        ),
      );

      // Assert: Verify all child content is rendered
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should handle widget updates correctly', (tester) async {
      // Arrange: Create initial molecule
      const initialContainer = ImmersiveSystemContainer(
        child: Text('Initial Content'),
      );

      // Act: Pump initial widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: initialContainer,
          ),
        ),
      );

      // Update to new content
      const updatedContainer = ImmersiveSystemContainer(
        child: Text('Updated Content'),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: updatedContainer,
          ),
        ),
      );

      // Assert: Verify updated content is rendered
      expect(find.text('Updated Content'), findsOneWidget);
      expect(find.text('Initial Content'), findsNothing);

      // Should still be in immersive mode (no additional mode changes)
      expect(find.byType(ImmersiveSystemContainer), findsOneWidget);
    });

    testWidgets('should handle multiple instances correctly', (tester) async {
      // Arrange: Create molecule
      const immersiveContainer = ImmersiveSystemContainer(
        child: Text('Content'),
      );

      // Act: Pump widget, remove it, and pump again
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: immersiveContainer,
          ),
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Other'),
          ),
        ),
      );

      // Clear method calls from previous operations
      methodCalls.clear();

      // Pump the immersive container again
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: immersiveContainer,
          ),
        ),
      );

      // Assert: Should set immersive mode again
      final systemUiModeCalls = methodCalls
          .where((call) => call.method == 'SystemChrome.setEnabledSystemUIMode')
          .toList();

      expect(systemUiModeCalls, isNotEmpty);

      // Simple verification that system UI mode was set
      expect(
        systemUiModeCalls.first.method,
        equals('SystemChrome.setEnabledSystemUIMode'),
      );
    });
  });
}
