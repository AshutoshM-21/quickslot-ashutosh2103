import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/router/app_routes.dart';
import 'package:quickslot_app/features/auth/presentation/cubit/user_selection_cubit.dart';
import 'package:quickslot_app/features/auth/presentation/pages/user_selection_page.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_cubit.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/venues_cubit.dart';
import 'package:quickslot_app/features/venues/presentation/pages/venue_detail_page.dart';
import 'package:quickslot_app/features/venues/presentation/pages/venue_list_page.dart';

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
        builder: (context, state) {
          return BlocProvider(
            create: (_) =>
                VenuesCubit(venueRepository: AppDependencies.venueRepository)
                  ..loadVenues(),
            child: const VenueListPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.venueDetail,
        name: AppRoutes.venueDetail,
        builder: (context, state) {
          final venueId = int.parse(state.pathParameters['venueId']!);
          final venue = state.extra as Venue?;
          final resolvedVenue = venue ?? Venue(id: venueId, name: 'Venue');

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => SlotsCubit(
                  slotRepository: AppDependencies.slotRepository,
                  venueId: venueId,
                )..loadSlots(),
              ),
              BlocProvider(
                create: (_) => BookingCubit(
                  bookingRepository: AppDependencies.bookingRepository,
                  userSession: AppDependencies.userSession,
                ),
              ),
            ],
            child: VenueDetailPage(venue: resolvedVenue),
          );
        },
      ),
    ],
  );
}
