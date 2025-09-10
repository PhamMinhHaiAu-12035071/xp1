import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xp1/core/assets/app_icons.dart';
import 'package:xp1/core/assets/app_icons_impl.dart';
import 'package:xp1/core/assets/app_images.dart';
import 'package:xp1/core/assets/app_images_impl.dart';
import 'package:xp1/core/infrastructure/logging/i_logger_service.dart';
import 'package:xp1/core/services/asset_image_service.dart';
import 'package:xp1/core/services/asset_image_service_impl.dart';
import 'package:xp1/core/services/svg_icon_service.dart';
import 'package:xp1/core/services/svg_icon_service_impl.dart';
import 'package:xp1/core/sizes/app_sizes.dart';
import 'package:xp1/core/sizes/app_sizes_impl.dart';
import 'package:xp1/core/styles/app_text_styles.dart';
import 'package:xp1/core/styles/app_text_styles_impl.dart';
import 'package:xp1/core/styles/colors/app_colors.dart';
import 'package:xp1/core/styles/colors/app_colors_impl.dart';
import 'package:xp1/features/env/domain/env_config_repository.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_cubit.dart';

/// Mock services for testing.
class MockLoggerService extends Mock implements ILoggerService {}

class MockEnvConfigRepository extends Mock implements EnvConfigRepository {}

/// Test DI container setup for widget tests.
class TestDependencyContainer {
  /// Setup test dependencies with mocks.
  static Future<void> setupTestDependencies() async {
    // Register fallback values for mocktail
    registerFallbackValue(LogLevel.info);

    // Mock SharedPreferences for locale initialization
    SharedPreferences.setMockInitialValues({});

    // Clear existing registrations
    await GetIt.instance.reset();

    // Register mock services
    GetIt.instance
      ..registerLazySingleton<ILoggerService>(MockLoggerService.new)
      ..registerLazySingleton<EnvConfigRepository>(MockEnvConfigRepository.new)
      // Register theme services required by AppTheme
      ..registerLazySingleton<AppColors>(() => const AppColorsImpl())
      ..registerLazySingleton<AppSizes>(() => const AppSizesImpl())
      ..registerLazySingleton<AppTextStyles>(AppTextStylesImpl.new)
      // Register asset services required by SplashContent and LoginForm
      ..registerLazySingleton<AppIcons>(() => const AppIconsImpl())
      ..registerLazySingleton<AppImages>(() => const AppImagesImpl())
      ..registerLazySingleton<AssetImageService>(
        () => const AssetImageServiceImpl(),
      )
      ..registerLazySingleton<SvgIconService>(
        () => const SvgIconServiceImpl(),
      )
      // Register SplashCubit for splash screen functionality
      ..registerFactory<SplashCubit>(SplashCubit.new);

    // Setup default mock behaviors
    final mockEnvConfig =
        GetIt.instance<EnvConfigRepository>() as MockEnvConfigRepository;
    when(() => mockEnvConfig.apiUrl).thenReturn('https://test-api.example.com');
    when(() => mockEnvConfig.appName).thenReturn('Test App');
    when(() => mockEnvConfig.environmentName).thenReturn('test');
    when(() => mockEnvConfig.isDebugMode).thenReturn(true);
    when(() => mockEnvConfig.apiTimeoutMs).thenReturn(5000);
  }

  /// Reset test dependencies.
  static Future<void> resetTestDependencies() async {
    await GetIt.instance.reset();
  }
}
