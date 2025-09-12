import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/core/themes/extensions/app_theme_extension.dart';
import 'package:xp1/features/authentication/application/blocs/auth_bloc.dart';
import 'package:xp1/features/authentication/application/blocs/auth_event.dart';
import 'package:xp1/features/authentication/application/blocs/auth_state.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_state.dart';
import 'package:xp1/features/splash/presentation/widgets/splash_content.dart';

/// Splash page with authentication check during startup.
///
/// This page displays the welcome image while checking authentication status.
/// Navigates to main app if authenticated, or to login if not authenticated.
@RoutePage()
class SplashPage extends StatelessWidget {
  /// Creates splash page with authentication check.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<SplashCubit>()..startSplash(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<AuthBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SplashCubit, SplashState>(
            listener: (context, state) {
              state.when(
                loading: () {
                  // Stay on splash screen
                },
                ready: () {
                  // Start authentication check after splash timer
                  context.read<AuthBloc>().add(
                    const AuthEvent.authCheckRequested(),
                  );
                },
              );
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              switch (state.authStatus) {
                case AuthenticationStatus.initial:
                // No action needed for initial state
                case AuthenticationStatus.loading:
                // Stay on splash screen during auth check
                case AuthenticationStatus.authenticated:
                  // User is authenticated, navigate to main app
                  context.router.replaceAll([const MainWrapperRoute()]);
                case AuthenticationStatus.unauthenticated:
                case AuthenticationStatus.error:
                  // User is not authenticated or auth check failed
                  context.router.replaceAll([const LoginRoute()]);
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: context.colors.orangeNormal,
          body: const SplashContent(),
        ),
      ),
    );
  }
}
