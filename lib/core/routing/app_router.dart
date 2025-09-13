import 'package:auto_route/auto_route.dart';

import '../../features/attendance/presentation/pages/attendance_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/features/presentation/pages/features_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/main_navigation/presentation/pages/main_wrapper_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../constants/route_constants.dart';
import '../guards/auth_guard.dart';

part 'app_router.gr.dart';

/// Application router configuration using AutoRoute.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  /// Global guards for route protection.
  ///
  /// Following Auto Route v9+ best practices with guards as instances.
  /// Implements Linus's principle: "Never break userspace" by ensuring
  /// smooth authentication flow without breaking existing navigation.
  @override
  List<AutoRouteGuard> get guards => [AuthGuard()];

  @override
  List<AutoRoute> get routes => [
    /// Splash Route - NEW: Initial route for app startup
    AutoRoute(
      page: SplashRoute.page,
      path: '/splash',
      initial: true, // Make splash the initial route
    ),

    /// Login Route - No longer initial
    AutoRoute(page: LoginRoute.page, path: '/${RouteConstants.login}'),

    /// Main App Routes with Bottom Navigation
    AutoRoute(
      page: MainWrapperRoute.page,
      path: '/${RouteConstants.mainWrapper}',
      children: [
        AutoRoute(page: HomeRoute.page, path: RouteConstants.home),
        AutoRoute(page: StatisticsRoute.page, path: RouteConstants.statistics),
        AutoRoute(page: AttendanceRoute.page, path: RouteConstants.attendance),
        AutoRoute(page: FeaturesRoute.page, path: RouteConstants.features),
        AutoRoute(page: ProfileRoute.page, path: RouteConstants.profile),
      ],
    ),
  ];
}
