import 'dart:io';

import 'package:hive/hive.dart';

Future<void> initTestHive() async {
  final dir = Directory.systemTemp.createTempSync('quickslot_hive_test');
  Hive.init(dir.path);
}
