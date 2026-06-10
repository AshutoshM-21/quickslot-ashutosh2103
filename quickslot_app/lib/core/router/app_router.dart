import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/presentation/pages/home_page.dart';
import 'package:quickslot_app/core/router/app_routes.dart';
import 'package:quickslot_app/features/auth/presentation/cubit/user_selection_cubit.dart';
import 'package:quickslot_app/features/auth/presentation/pages/user_selection_page.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.userSelection,
    routes: [
      GoRoute(
        path: AppRoutes.userSelection,
        name: AppRoutes.userSelection,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => UserSelectionCubit(
              userRepository: AppDependencies.userRepository,
              userSession: AppDependencies.userSession,
            ),
            child: const UserSelectionPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
