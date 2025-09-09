import 'package:flutter/material.dart';

/// Orange background atom component.
///
/// A basic atom that provides an orange background container. This atom takes
/// full available space and can optionally display a child widget on top of
/// the orange background.
class OrangeBackground extends StatelessWidget {
  /// Creates an orange background atom.
  ///
  /// [child] Optional widget to display on top of the orange background.
  const OrangeBackground({super.key, this.child});

  /// Optional child widget to overlay on the orange background.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFF8C00), // Orange color for now - will refactor later
      ),
      child: child,
    );
  }
}
