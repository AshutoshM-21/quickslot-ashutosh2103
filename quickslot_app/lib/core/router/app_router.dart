import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickslot_app/core/presentation/pages/home_page.dart';
import 'package:quickslot_app/core/router/app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
