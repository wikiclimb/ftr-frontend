import 'core/app.dart';
import 'package:flutter/material.dart';
import 'di.dart' as di;

void main() async {
  await di.init();
  runApp(const App());
}
