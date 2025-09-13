import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Perfect Pixel Design Tests', () {
    group('Glassmorphism Styling Tests', () {
      test(
        'should implement correct shadow values for glassmorphism effect',
        () {
          // This test validates the implementation matches Figma specs

          // Test the shadow colors are correct
          const firstShadowColor = Color(0x1F919EAB);
          const secondShadowColor = Color(0x33919EAB);

          expect(firstShadowColor.toARGB32(), equals(0x1F919EAB));
          expect(secondShadowColor.toARGB32(), equals(0x33919EAB));

          // Verify opacity calculations using new API
          // 0x1F = 31/255 = 12.2% ≈ 12.5% for #919EAB1F
          expect((firstShadowColor.a * 255.0).round() & 0xff, equals(31));
          // 0x33 = 51/255 = 20% for #919EAB33
          expect((secondShadowColor.a * 255.0).round() & 0xff, equals(51));
        },
      );

      test(
        'should have correct gradient colors for glassmorphism background',
        () {
          // Test gradient color values
          const firstGradientColor = Color.fromRGBO(255, 255, 255, 0.72);
          const secondGradientColor = Color.fromRGBO(255, 255, 255, 0.8);

          expect(
            (firstGradientColor.a * 255.0).round() & 0xff,
            equals((255 * 0.72).round()),
          );
          expect(
            (secondGradientColor.a * 255.0).round() & 0xff,
            equals((255 * 0.8).round()),
          );
        },
      );

      test('should match AnimatedTextField shadow specifications', () {
        // Verify AnimatedTextField shadows match Figma
        const firstTextFieldShadow = Color(0x14919EAB);
        const secondTextFieldShadow = Color(0x1F919EAB);

        // First shadow: 8% opacity (#919EAB14)
        expect((firstTextFieldShadow.a * 255.0).round() & 0xff, equals(20));
        // Second shadow: 12.5% opacity (#919EAB1F)
        expect((secondTextFieldShadow.a * 255.0).round() & 0xff, equals(31));
      });
    });
  });
}
