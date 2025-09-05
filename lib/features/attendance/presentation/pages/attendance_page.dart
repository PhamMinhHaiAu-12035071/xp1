import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xp1/l10n/gen/strings.g.dart';

/// Attendance page for time tracking and check-in/out.
@RoutePage()
class AttendancePage extends StatelessWidget {
  /// Creates an attendance page.
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.attendance.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.pages.attendance.welcomeMessage.replaceAll(
                '{pageName}',
                t.pages.attendance.title,
              ),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      t.pages.attendance.currentStatus.replaceAll(
                        '{status}',
                        t.pages.attendance.status.notCheckedIn,
                      ),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle check in
                          },
                          child: Text(t.pages.attendance.checkIn),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle check out
                          },
                          child: Text(t.pages.attendance.checkOut),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
