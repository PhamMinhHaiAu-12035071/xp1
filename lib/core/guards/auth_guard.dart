import 'package:auto_route/auto_route.dart';

/// Authentication guard for protecting routes.
///
/// Following Linus's principle: "Never break userspace" - this guard
/// ensures smooth navigation without breaking existing user flows.
/// Implements Auto Route best practices for route protection.
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // For now, we allow all navigation for development
    // In production, implement proper authentication check:
    // if (isAuthenticated) {
    //   resolver.next();
    // } else {
    //   resolver.redirectUntil(
    //     LoginRoute(onResult: (success) => resolver.next(success)),
    //   );
    // }

    // Development mode: allow all navigation
    resolver.next();
  }
}
