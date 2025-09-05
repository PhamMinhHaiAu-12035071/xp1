import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

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
  List<NavTabConfig> _buildNavTabs() => [
    NavTabConfig(
      route: const HomeRoute(),
      icon: Icons.home,
      label: t.navigation.home,
    ),
    NavTabConfig(
      route: const StatisticsRoute(),
      icon: Icons.analytics,
      label: t.navigation.statistics,
    ),
    NavTabConfig(
      route: const AttendanceRoute(),
      icon: Icons.access_time,
      label: t.navigation.attendance,
    ),
    NavTabConfig(
      route: const FeaturesRoute(),
      icon: Icons.apps,
      label: t.navigation.features,
    ),
    NavTabConfig(
      route: const ProfileRoute(),
      icon: Icons.person,
      label: t.navigation.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final navTabs = _buildNavTabs();

    return AutoTabsScaffold(
      routes: navTabs.map((tab) => tab.route).toList(),
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          type: BottomNavigationBarType.fixed,
          items: navTabs
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
