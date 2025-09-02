import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/routing/app_router.dart';

/// Navigation tab configuration data structure.
///
/// Eliminates special cases following Linus's principle:
/// "Good code has no special cases"
class NavTabConfig {
  /// Creates a navigation tab configuration.
  const NavTabConfig({
    required this.route,
    required this.icon,
    required this.label,
  });

  /// The route for this tab.
  final PageRouteInfo route;

  /// The icon for this tab.
  final IconData icon;

  /// The label for this tab.
  final String label;
}

/// Main navigation wrapper page with bottom navigation.
@RoutePage()
class MainWrapperPage extends StatelessWidget {
  /// Creates a main wrapper page.
  const MainWrapperPage({super.key});

  /// Navigation tabs configuration - single source of truth.
  ///
  /// Eliminates code duplication between routes list and navigation items.
  /// Following Linus's data structure principle: worry about data first.
  static const List<NavTabConfig> _navTabs = [
    NavTabConfig(
      route: HomeRoute(),
      icon: Icons.home,
      label: 'Home',
    ),
    NavTabConfig(
      route: StatisticsRoute(),
      icon: Icons.analytics,
      label: 'Statistics',
    ),
    NavTabConfig(
      route: AttendanceRoute(),
      icon: Icons.access_time,
      label: 'Attendance',
    ),
    NavTabConfig(
      route: FeaturesRoute(),
      icon: Icons.apps,
      label: 'Features',
    ),
    NavTabConfig(
      route: ProfileRoute(),
      icon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: _navTabs.map((tab) => tab.route).toList(),
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          type: BottomNavigationBarType.fixed,
          items: _navTabs
              .map(
                (tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
