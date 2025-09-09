import 'package:flutter/material.dart';

/// Full screen container atom component.
///
/// A basic atom that provides a container with full screen dimensions using
/// ScreenUtil responsive values (1.sw x 1.sh). This atom is useful for creating
/// full-screen layouts that adapt to different screen sizes.
class FullScreenContainer extends StatelessWidget {
  /// Creates a full screen container atom.
  ///
  /// [child] The widget to display within the full screen container.
  const FullScreenContainer({required this.child, super.key});

  /// The child widget to display within the container.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Use combination of sizing strategies to ensure full screen coverage
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          // Use the maximum available space from parent constraints
          width: constraints.maxWidth == double.infinity
              ? MediaQuery.of(context).size.width
              : constraints.maxWidth,
          height: constraints.maxHeight == double.infinity
              ? MediaQuery.of(context).size.height
              : constraints.maxHeight,
          child: child,
        );
      },
    );
  }
}
