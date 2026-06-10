import 'package:flutter/material.dart';
import 'package:quickslot_app/app.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.init();
  runApp(const QuickSlotApp());
}
