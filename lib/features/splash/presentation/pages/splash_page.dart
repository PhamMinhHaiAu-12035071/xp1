import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:xp1/core/routing/app_router.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_state.dart';
import 'package:xp1/features/splash/presentation/widgets/splash_content.dart';

/// Simplified splash page with timer-based navigation.
///
/// This page displays the welcome image for 2 seconds and then
/// navigates to the main app. No complex error handling or fallback logic.
@RoutePage()
class SplashPage extends StatelessWidget {
  /// Creates simplified splash page.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<SplashCubit>()..startSplash(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          // Simple pattern matching with only loading and ready states
          state.when(
            loading: () {
              // Stay on splash screen
            },
            ready: () {
              // Navigate to main app after 2 seconds
              context.router.replaceAll([const MainWrapperRoute()]);
            },
          );
        },
        child: const Scaffold(
          backgroundColor: Colors.orange, // Simple color, no design system dep
          body: SplashContent(),
        ),
      ),
    );
  }
}
