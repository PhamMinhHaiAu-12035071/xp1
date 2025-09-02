import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Home page showing main dashboard content.
@RoutePage()
class HomePage extends StatelessWidget {
  /// Creates a home page.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello World - Home',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
