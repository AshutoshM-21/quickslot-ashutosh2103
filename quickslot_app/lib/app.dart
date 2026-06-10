import 'package:flutter/material.dart';
import 'package:quickslot_app/core/constants/app_constants.dart';
import 'package:quickslot_app/core/router/app_router.dart';
import 'package:quickslot_app/core/theme/app_theme.dart';

class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
