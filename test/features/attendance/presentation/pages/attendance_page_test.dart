import 'package:flutter_test/flutter_test.dart';
import 'package:xp1/features/attendance/presentation/pages/attendance_page.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('AttendancePage', () {
    // Use comprehensive helper that includes environment setup,
    // navigation testing, and memory management - following Linus's
    // principle of proper resource management
    PageTestHelpers.testComprehensivePage<AttendancePage>(
      const AttendancePage(),
      'Hello World - Attendance',
      () => const AttendancePage(),
      (key) => AttendancePage(key: key),
      pageRoute: '/main/attendance',
    );
  });
}
