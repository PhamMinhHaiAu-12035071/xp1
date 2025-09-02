import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Features page showing available application features.
@RoutePage()
class FeaturesPage extends StatelessWidget {
  /// Creates a features page.
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello World - Features',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
