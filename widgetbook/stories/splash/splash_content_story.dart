import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/core/services/asset_image_service.dart';
import 'package:xp1/core/widgets/widgets.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_state.dart';
import 'package:xp1/features/splash/presentation/widgets/splash_content.dart';

// Mock classes for dependencies
class MockSplashCubit extends Mock implements SplashCubit {}

class MockAssetImageService extends Mock implements AssetImageService {}

class MockAppImages extends Mock implements AppImages {}

/// Setup fallback values for mocktail to prevent StateError.
/// This is required for type-safe mocking in sound null safety.
void _setupMocktailFallbacks() {
  registerFallbackValue(BoxFit.contain);
  registerFallbackValue('');
}

/// Helper function to build the SplashContent widget with a specific state.
/// This function also handles the setup of mock dependencies in GetIt.
Widget _buildSplashContentWithState(BuildContext context, SplashState state) {
  // Setup fallback values for mocktail
  _setupMocktailFallbacks();

  final getIt = GetIt.instance;

  // Ensure mocks are always fresh for each story build
  if (getIt.isRegistered<AssetImageService>()) {
    getIt.unregister<AssetImageService>();
  }
  if (getIt.isRegistered<AppImages>()) {
    getIt.unregister<AppImages>();
  }

  final mockCubit = MockSplashCubit();
  final mockAssetImageService = MockAssetImageService();
  final mockAppImages = MockAppImages();

  // Stubbing the cubit state
  when(() => mockCubit.state).thenReturn(state);
  when(() => mockCubit.stream).thenAnswer((_) => Stream.value(state));
  when(mockCubit.close).thenAnswer((_) async {});

  // Stubbing the AppImages service
  const backgroundImagePath = 'assets/images/splash/background.png';
  const logoImagePath = 'assets/images/splash/logo.png';
  when(() => mockAppImages.splashBackground).thenReturn(backgroundImagePath);
  when(() => mockAppImages.splashLogo).thenReturn(logoImagePath);

  // Mock background image service call with fit support
  when(
    () => mockAssetImageService.assetImage(
      backgroundImagePath,
      fit: any(named: 'fit'),
    ),
  ).thenReturn(
    Image.asset(
      backgroundImagePath,
      fit: BoxFit.contain,
    ),
  );

  // Mock logo image service call
  when(
    () => mockAssetImageService.assetImage(
      logoImagePath,
    ),
  ).thenReturn(
    Image.asset(
      logoImagePath,
    ),
  );

  // Registering mock instances with GetIt
  getIt
    ..registerSingleton<AssetImageService>(mockAssetImageService)
    ..registerSingleton<AppImages>(mockAppImages);

  return ResponsiveInitializer(
    builder: (context) {
      return BlocProvider<SplashCubit>.value(
        value: mockCubit,
        child: const Material(
          child: SplashContent(),
        ),
      );
    },
  );
}

@UseCase(
  name: 'Default State',
  type: SplashContent,
  path: '[Splash]',
)
Widget splashContentDefault(BuildContext context) {
  return _buildSplashContentWithState(context, const SplashState.loading());
}
