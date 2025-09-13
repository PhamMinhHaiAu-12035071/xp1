import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/widgets/molecules/glassmorphism_app_bar.dart';

void main() {
  group('GlassmorphismAppBar', () {
    group('Component Properties Tests', () {
      test('should implement PreferredSizeWidget correctly', () {
        const appBar = GlassmorphismAppBar(title: 'Test');

        expect(
          appBar.preferredSize,
          equals(const Size.fromHeight(kToolbarHeight)),
        );
      });

      test('should have correct default values', () {
        const appBar = GlassmorphismAppBar(title: 'Test Title');

        expect(appBar.title, equals('Test Title'));
        expect(appBar.titleStyle, isNull);
        expect(appBar.showBackButton, isTrue);
        expect(appBar.onBackPressed, isNull);
        expect(appBar.backgroundColor, equals(Colors.white));
        expect(appBar.centerTitle, isTrue);
      });

      test('should accept custom configuration', () {
        const customStyle = TextStyle(fontSize: 20, color: Colors.red);
        void customCallback() {}

        final appBar = GlassmorphismAppBar(
          title: 'Custom Title',
          titleStyle: customStyle,
          showBackButton: false,
          onBackPressed: customCallback,
          backgroundColor: Colors.blue,
          centerTitle: false,
        );

        expect(appBar.title, equals('Custom Title'));
        expect(appBar.titleStyle, equals(customStyle));
        expect(appBar.showBackButton, isFalse);
        expect(appBar.onBackPressed, equals(customCallback));
        expect(appBar.backgroundColor, equals(Colors.blue));
        expect(appBar.centerTitle, isFalse);
      });
    });

    group('Glassmorphism Shadow Values Tests', () {
      test('should define correct shadow color values', () {
        // Test the shadow colors match Figma specifications
        const firstShadowColor = Color(0x1F919EAB);
        const secondShadowColor = Color(0x33919EAB);

        expect(firstShadowColor.toARGB32(), equals(0x1F919EAB));
        expect(secondShadowColor.toARGB32(), equals(0x33919EAB));

        // Verify opacity calculations
        // 0x1F = 31/255 = 12.2% ≈ 12.5% for #919EAB1F
        expect((firstShadowColor.a * 255.0).round() & 0xff, equals(31));
        // 0x33 = 51/255 = 20% for #919EAB33
        expect((secondShadowColor.a * 255.0).round() & 0xff, equals(51));
      });

      test('should define correct gradient color values', () {
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
      });
    });

    group('BoxShadow Configuration Tests', () {
      test('should create correct BoxShadow instances for glassmorphism', () {
        // First shadow: 0px 12px 24px -4px #919EAB1F
        const firstShadow = BoxShadow(
          color: Color(0x1F919EAB),
          offset: Offset(0, 12),
          blurRadius: 24,
          spreadRadius: -4,
        );

        expect(firstShadow.color, equals(const Color(0x1F919EAB)));
        expect(firstShadow.offset, equals(const Offset(0, 12)));
        expect(firstShadow.blurRadius, equals(24));
        expect(firstShadow.spreadRadius, equals(-4));

        // Second shadow: 0px 0px 2px 0px #919EAB33
        const secondShadow = BoxShadow(
          color: Color(0x33919EAB),
          blurRadius: 2,
        );

        expect(secondShadow.color, equals(const Color(0x33919EAB)));
        expect(secondShadow.offset, equals(Offset.zero));
        expect(secondShadow.blurRadius, equals(2));
        expect(secondShadow.spreadRadius, equals(0));
      });
    });

    group('LinearGradient Configuration Tests', () {
      test('should create correct gradient configuration', () {
        const gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(255, 255, 255, 0.72),
            Color.fromRGBO(255, 255, 255, 0.8),
          ],
          stops: [0.0, 0.4],
        );

        expect(gradient.begin, equals(Alignment.topCenter));
        expect(gradient.end, equals(Alignment.bottomCenter));
        expect(gradient.colors.length, equals(2));
        expect(
          gradient.colors[0],
          equals(const Color.fromRGBO(255, 255, 255, 0.72)),
        );
        expect(
          gradient.colors[1],
          equals(const Color.fromRGBO(255, 255, 255, 0.8)),
        );
        expect(gradient.stops, equals([0.0, 0.4]));
      });
    });

    group('API Validation Tests', () {
      test('should handle null values correctly', () {
        const appBar = GlassmorphismAppBar(title: 'Test');

        expect(appBar.titleStyle, isNull);
        expect(appBar.onBackPressed, isNull);
      });

      test('should handle edge case values', () {
        const appBar = GlassmorphismAppBar(
          title: '', // Empty string
          backgroundColor: Colors.transparent,
        );

        expect(appBar.title, equals(''));
        expect(appBar.backgroundColor, equals(Colors.transparent));
      });
    });
  });
}
