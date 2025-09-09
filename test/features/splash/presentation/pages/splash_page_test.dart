import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/core/services/asset_image_service.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_state.dart';
import 'package:xp1/features/splash/presentation/pages/splash_page.dart';
import 'package:xp1/features/splash/presentation/widgets/splash_content.dart';

class MockSplashCubit extends Mock implements SplashCubit {}

class MockAssetImageService extends Mock implements AssetImageService {}

class MockAppImages extends Mock implements AppImages {}

class MockStackRouter extends Mock implements StackRouter {}

// Fake for auto_route
class FakePageRouteInfo extends Fake implements PageRouteInfo {}

/// Tests for simplified SplashPage implementation.
///
/// These tests validate the simplified splash screen that:
/// - Uses only loading and ready states
/// - Shows background.png via SplashContent with orange background
/// - Uses simple orange background without design system
/// - Has timer-based navigation without complex error handling
void main() {
  group('SplashPage (Simplified) Tests', () {
    late MockSplashCubit mockSplashCubit;
    late MockAssetImageService mockAssetImageService;
    late MockAppImages mockAppImages;
    late MockStackRouter mockRouter;
    late StreamController<SplashState> splashStreamController;

    setUp(() {
      mockSplashCubit = MockSplashCubit();
      mockAssetImageService = MockAssetImageService();
      mockAppImages = MockAppImages();
      mockRouter = MockStackRouter();
      splashStreamController = StreamController<SplashState>.broadcast();

      // Register fake for auto_route
      registerFallbackValue(FakePageRouteInfo());
      registerFallbackValue(const MainWrapperRoute());
      registerFallbackValue(const LoginRoute());
      registerFallbackValue(
        <PageRouteInfo>[const LoginRoute()],
      );
      registerFallbackValue(BoxFit.cover);

      // Setup GetIt mocks for simplified dependencies
      GetIt.instance.registerSingleton<SplashCubit>(mockSplashCubit);
      GetIt.instance.registerSingleton<AssetImageService>(
        mockAssetImageService,
      );
      GetIt.instance.registerSingleton<AppImages>(mockAppImages);

      // Setup router mocks
      when(() => mockRouter.replaceAll(any())).thenAnswer((_) async => {});

      // Setup asset service mocks
      when(
        () => mockAppImages.splashBackground,
      ).thenReturn('assets/images/splash/background.png');
      when(
        () => mockAssetImageService.assetImage(
          'assets/images/splash/background.png',
          fit: any(named: 'fit'),
        ),
      ).thenReturn(
        Image.asset('assets/images/splash/background.png'),
      );

      // Setup cubit mocks
      when(() => mockSplashCubit.state).thenReturn(const SplashState.loading());
      when(() => mockSplashCubit.startSplash()).thenAnswer((_) async {});
      when(
        () => mockSplashCubit.stream,
      ).thenAnswer((_) => splashStreamController.stream);
      when(() => mockSplashCubit.close()).thenAnswer((_) async {});
    });

    tearDown(() {
      splashStreamController.close();
      GetIt.instance.reset();
    });

    testWidgets('should build with simple orange background', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(375, 812),
          child: MaterialApp(
            home: SplashPage(),
          ),
        ),
      );

      // Should build successfully
      expect(find.byType(SplashPage), findsOneWidget);

      // Should have orange background (not design system color)
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.orange));
    });

    testWidgets('should contain simplified dependencies', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(375, 812),
          child: MaterialApp(
            home: SplashPage(),
          ),
        ),
      );

      // Should have BlocProvider and BlocListener
      expect(find.byType(BlocProvider<SplashCubit>), findsOneWidget);
      expect(
        find.byType(BlocListener<SplashCubit, SplashState>),
        findsOneWidget,
      );

      // Should contain SplashContent widget
      expect(find.byType(SplashContent), findsOneWidget);
    });

    testWidgets('should start splash on cubit creation', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(375, 812),
          child: MaterialApp(
            home: SplashPage(),
          ),
        ),
      );

      // Verify startSplash was called
      verify(() => mockSplashCubit.startSplash()).called(1);
    });

    testWidgets('should stay on splash when loading', (tester) async {
      when(() => mockSplashCubit.state).thenReturn(const SplashState.loading());
      when(() => mockSplashCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([const SplashState.loading()]),
      );

      await tester.pumpWidget(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: const MaterialApp(
            home: ScreenUtilInit(
              designSize: Size(375, 812),
              child: SplashPage(),
            ),
          ),
        ),
      );
      await tester.pump(); // Trigger listener

      // Should stay on splash (no navigation call)
      verifyNever(() => mockRouter.replaceAll(any()));
      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('should navigate when ready', (tester) async {
      when(() => mockSplashCubit.state).thenReturn(const SplashState.loading());
      when(() => mockSplashCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const SplashState.loading(),
          const SplashState.ready(),
        ]),
      );

      await tester.pumpWidget(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: const MaterialApp(
            home: ScreenUtilInit(
              designSize: Size(375, 812),
              child: SplashPage(),
            ),
          ),
        ),
      );

      await tester.pump(); // Initial pump
      await tester.pump(); // State change pump

      // Should navigate to Login
      verify(() => mockRouter.replaceAll([const LoginRoute()])).called(1);
    });

    testWidgets('should handle state changes correctly', (tester) async {
      when(() => mockSplashCubit.state).thenReturn(const SplashState.loading());
      when(() => mockSplashCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const SplashState.loading(),
          const SplashState.ready(),
        ]),
      );

      await tester.pumpWidget(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: const MaterialApp(
            home: ScreenUtilInit(
              designSize: Size(375, 812),
              child: SplashPage(),
            ),
          ),
        ),
      );

      // Pump through state changes
      await tester.pump(); // loading
      await tester.pump(); // ready

      // Should navigate once for ready state
      verify(() => mockRouter.replaceAll([const LoginRoute()])).called(1);
    });

    testWidgets('should complete quickly for user experience', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        const ScreenUtilInit(
          designSize: Size(375, 812),
          child: MaterialApp(
            home: SplashPage(),
          ),
        ),
      );

      await tester.pump();
      stopwatch.stop();

      // Should build quickly (users abandon apps after 3 seconds)
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });
  });
}
