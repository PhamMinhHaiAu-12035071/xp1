import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/platform/platform_detector.dart';

void main() {
  group('PlatformDetector', () {
    group('DefaultPlatformDetector', () {
      late DefaultPlatformDetector platformDetector;

      setUp(() {
        platformDetector = const DefaultPlatformDetector();
      });

      test('should be properly injectable as PlatformDetector', () {
        expect(platformDetector, isA<PlatformDetector>());
      });

      test('should return kIsWeb value for isWeb getter', () {
        // Act
        final result = platformDetector.isWeb;

        // Assert
        expect(result, equals(kIsWeb));
        expect(result, isA<bool>());
      });

      test('should consistently return same value for isWeb', () {
        // Act
        final result1 = platformDetector.isWeb;
        final result2 = platformDetector.isWeb;

        // Assert
        expect(result1, equals(result2));
      });

      test('should create const instance successfully', () {
        // Act & Assert
        expect(() => const DefaultPlatformDetector(), returnsNormally);
      });

      group('web platform behavior', () {
        test('should return false when running on non-web platforms', () {
          // This test validates the actual behavior on the current platform
          // In test environment (non-web), kIsWeb should be false
          final result = platformDetector.isWeb;

          // In Flutter test environment, kIsWeb is typically false
          expect(result, isFalse);
        });
      });
    });

    group('PlatformDetector interface', () {
      test('should define isWeb getter contract', () {
        // Verify the abstract interface exists and can be implemented
        const detector = DefaultPlatformDetector();
        expect(detector, isA<PlatformDetector>());

        // Verify the interface contract is fulfilled
        expect(detector.isWeb, isA<bool>());
      });
    });
  });
}
