import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveInitializer {
  HiveInitializer._();

  static Future<void> init() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
    } on MissingPluginException {
      // Native plugins are not re-registered on hot restart after adding Hive.
      // Fall back to a temp directory so the app keeps running in debug.
      if (kIsWeb) {
        await Hive.initFlutter();
        return;
      }

      final fallbackDir =
          Directory.systemTemp.createTempSync('quickslot_hive');
      Hive.init(fallbackDir.path);
    }
  }
}
