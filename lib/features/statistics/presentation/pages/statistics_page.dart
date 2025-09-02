import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Statistics page showing analytics and data.
@RoutePage()
class StatisticsPage extends StatelessWidget {
  /// Creates a statistics page.
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello World - Statistics',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
