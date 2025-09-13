import 'package:flutter/material.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/molecules/immersive_system_container.dart';
import 'package:xp1/features/splash/presentation/widgets/atomic/organisms/splash_layout.dart';

/// Refactored splash content widget using Atomic Design principles.
///
/// This widget now uses composition of atomic design components:
/// - ImmersiveSystemContainer (molecule) for SystemUI management
/// - SplashLayout (organism) for complete layout composition
///
/// Benefits of atomic design refactor:
/// - Single responsibility principle
/// - Improved testability
/// - Better maintainability
/// - Reusable components
/// - Cleaner code structure
class SplashContent extends StatelessWidget {
  /// Creates splash content widget.
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImmersiveSystemContainer(child: SplashLayout());
  }
}
