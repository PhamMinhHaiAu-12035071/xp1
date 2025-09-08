// test/core/services/svg_icon_service_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/core/services/svg_icon_service.dart';
import 'package:xp1/core/services/svg_icon_service_impl.dart';

void main() {
  group('SvgIconService Tests (RED PHASE)', () {
    late SvgIconService service;

    setUp(() {
      // ❌ This will fail initially - no service exists
      service = const SvgIconServiceImpl();
    });

    testWidgets('should implement SvgIconService interface', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            // ❌ FAILS: Interface doesn't exist
            expect(service, isA<SvgIconService>());
            return Container();
          },
        ),
      );
    });

    testWidgets('should display SVG icon with responsive sizing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No svgIcon method
              return service.svgIcon(
                'assets/icons/test/icon.svg',
                color: Colors.blue,
              );
            },
          ),
        ),
      );

      // ❌ FAILS: No SvgPicture widget rendered
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should handle tap events when provided', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No onTap support
              return service.svgIcon(
                'assets/icons/test/icon.svg',
                onTap: () => tapped = true,
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('should not wrap in GestureDetector when onTap is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(375, 812));
              // ❌ FAILS: No conditional wrapping
              return service.svgIcon('assets/icons/test/icon.svg');
            },
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
