import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Attendance page for time tracking and check-in/out.
@RoutePage()
class AttendancePage extends StatelessWidget {
  /// Creates an attendance page.
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello World - Attendance',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
