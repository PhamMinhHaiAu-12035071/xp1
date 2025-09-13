import 'package:injectable/injectable.dart';
import 'package:xp1/core/assets/app_images.dart';

/// Minimal implementation of AppImages to pass RED tests.
///
/// Uses dependency injection pattern following AppSizes example.
@LazySingleton(as: AppImages)
class AppImagesImpl implements AppImages {
  /// Creates app images implementation.
  const AppImagesImpl();

  // Minimal implementation - just enough to pass tests
  @override
  String get splashLogo => 'assets/images/splash/logo.png';

  @override
  String get splashBackground => 'assets/images/splash/background.png';

  @override
  String get loginLogo => 'assets/images/login/logo.png';

  @override
  String get loginBackground => 'assets/images/login/background.png';

  @override
  String get loginCarouselSlide1 => 'assets/images/login/slide_1.png';

  @override
  String get loginCarouselSlide2 => 'assets/images/login/slide_2.png';

  @override
  String get loginCarouselSlide3 => 'assets/images/login/slide_3.png';

  @override
  String get employeeAvatar => 'assets/images/employee/avatar.png';

  @override
  String get employeeBadge => 'assets/images/employee/badge.png';

  @override
  String get forgotPasswordImage =>
      'assets/images/forgot_password/forgot_password.png';

  @override
  List<String> get criticalAssets => [splashLogo, loginLogo];

  @override
  ImageSizeConstants get imageSizes => const ImageSizeConstants();
}
