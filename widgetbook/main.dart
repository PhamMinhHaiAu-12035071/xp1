import 'package:flutter/material.dart';
import 'core/widgetbook_bootstrap.dart';
import 'widgetbook.dart';

Future<void> main() async {
  await initWidgetbook();
  runApp(const WidgetbookApp());
}
