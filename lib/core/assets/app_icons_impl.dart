import 'package:injectable/injectable.dart';
import 'package:xp1/core/assets/app_icons.dart';

/// Minimal implementation of AppIcons to pass RED tests.
///
/// Uses dependency injection pattern following AppImages example.
@LazySingleton(as: AppIcons)
class AppIconsImpl implements AppIcons {
  /// Creates app icons implementation.
  const AppIconsImpl();

  // Minimal implementation - just enough to pass tests
  @override
  String get arrowBack => 'assets/icons/ui/arrow_back.svg';

  @override
  String get search => 'assets/icons/ui/search.svg';

  @override
  String get menu => 'assets/icons/ui/menu.svg';

  @override
  String get notification => 'assets/icons/ui/notification.svg';

  @override
  String get close => 'assets/icons/ui/close.svg';

  @override
  String get success => 'assets/icons/status/success.svg';

  @override
  String get error => 'assets/icons/status/error.svg';

  @override
  String get warning => 'assets/icons/status/warning.svg';

  @override
  String get info => 'assets/icons/status/info.svg';

  @override
  String get edit => 'assets/icons/action/edit.svg';

  @override
  String get delete => 'assets/icons/action/delete.svg';

  @override
  String get add => 'assets/icons/action/add.svg';

  @override
  String get filter => 'assets/icons/action/filter.svg';

  @override
  String get logo => 'assets/icons/brand/logo.svg';

  @override
  String get logoText => 'assets/icons/brand/logo_text.svg';

  @override
  List<String> get criticalIcons => [
    logo,
    arrowBack,
    search,
    menu,
  ];

  @override
  IconSizeConstants get iconSizes => const IconSizeConstants();
}
