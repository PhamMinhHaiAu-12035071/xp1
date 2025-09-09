import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Immersive system container molecule component.
///
/// A molecule that manages SystemUiMode lifecycle while wrapping a child
/// widget.
/// This molecule handles the system UI concerns by setting immersive mode on
/// initialization and restoring normal mode on disposal.
class ImmersiveSystemContainer extends StatefulWidget {
  /// Creates an immersive system container molecule.
  ///
  /// [child] The widget to display within the immersive container.
  const ImmersiveSystemContainer({required this.child, super.key});

  /// The child widget to display within the container.
  final Widget child;

  @override
  State<ImmersiveSystemContainer> createState() =>
      _ImmersiveSystemContainerState();
}

class _ImmersiveSystemContainerState extends State<ImmersiveSystemContainer> {
  @override
  void initState() {
    super.initState();
    // Set immersive sticky mode when the widget initializes
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore edge-to-edge mode when the widget is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simply return the child widget - the system UI management
    // is handled in the lifecycle methods
    return widget.child;
  }
}
