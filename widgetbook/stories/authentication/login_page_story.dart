import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/core/services/asset_image_service.dart';
import 'package:xp1/core/widgets/widgets.dart';
import 'package:xp1/features/authentication/presentation/pages/login_page.dart';

// Mock classes for dependencies
class MockAssetImageService extends Mock implements AssetImageService {}

class MockAppImages extends Mock implements AppImages {}

/// Setup fallback values for mocktail to prevent StateError.
/// This is required for type-safe mocking in sound null safety.
void _setupMocktailFallbacks() {
  registerFallbackValue(BoxFit.contain);
  registerFallbackValue('');
}

/// Helper function to build the LoginPage widget with mock dependencies.
/// This function handles the setup of mock dependencies in GetIt.
Widget _buildLoginPageWithMocks(BuildContext context) {
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

  final mockAssetImageService = MockAssetImageService();
  final mockAppImages = MockAppImages();

  // Stubbing the AppImages service for login background
  const backgroundImagePath = 'assets/images/login/background.png';
  when(() => mockAppImages.loginBackground).thenReturn(backgroundImagePath);

  // Mock background image service call with fit support
  when(
    () => mockAssetImageService.assetImage(
      backgroundImagePath,
      fit: any(named: 'fit'),
    ),
  ).thenReturn(
    Image.asset(
      backgroundImagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const ColoredBox(
        color: Color(0xFFFF6B35),
        child: Center(
          child: Icon(
            Icons.image,
            size: 64,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );

  // Also mock the simple call without parameters
  when(
    () => mockAssetImageService.assetImage(backgroundImagePath),
  ).thenReturn(
    Image.asset(
      backgroundImagePath,
      errorBuilder: (context, error, stackTrace) => const ColoredBox(
        color: Color(0xFFFF6B35),
        child: Center(
          child: Icon(
            Icons.image,
            size: 64,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );

  // Registering mock instances with GetIt
  getIt
    ..registerSingleton<AssetImageService>(mockAssetImageService)
    ..registerSingleton<AppImages>(mockAppImages);

  return ResponsiveInitializer(
    builder: (context) {
      return const Material(
        child: LoginPage(),
      );
    },
  );
}

@UseCase(
  name: 'Default State',
  type: LoginPage,
  path: '[Authentication]',
)
Widget loginPageDefault(BuildContext context) {
  return _buildLoginPageWithMocks(context);
}
