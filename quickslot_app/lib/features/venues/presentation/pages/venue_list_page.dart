import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickslot_app/core/constants/app_constants.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/router/app_routes.dart';
import 'package:quickslot_app/core/utils/responsive_utils.dart';
import 'package:quickslot_app/core/widgets/app_empty_view.dart';
import 'package:quickslot_app/core/widgets/app_error_view.dart';
import 'package:quickslot_app/core/widgets/app_loading_view.dart';
import 'package:quickslot_app/core/widgets/app_scaffold.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/venues_cubit.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/venues_state.dart';
import 'package:quickslot_app/features/venues/presentation/widgets/venue_card.dart';

class VenueListPage extends StatelessWidget {
  const VenueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedUser = AppDependencies.userSession.selectedUser;

    return AppScaffold(
      title: AppConstants.appName,
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.myBookings),
          icon: const Icon(Icons.event_note_outlined),
          tooltip: 'My bookings',
        ),
      ],
      body: BlocBuilder<VenuesCubit, VenuesState>(
        builder: (context, state) {
          return switch (state.status) {
            VenuesStatus.initial || VenuesStatus.loading =>
              const AppLoadingView(),
            VenuesStatus.error => AppErrorView(
                title: 'Could not load venues',
                message: state.errorMessage ?? 'Failed to load venues',
                onRetry: () => context.read<VenuesCubit>().loadVenues(),
              ),
            VenuesStatus.empty => const AppEmptyView(
                icon: Icons.location_off_outlined,
                title: 'No venues available',
                subtitle: 'Check back later for new venues.',
              ),
            VenuesStatus.loaded => _VenueListView(
                venues: state.venues,
                greeting: selectedUser?.name,
              ),
          };
        },
      ),
    );
  }
}

class _VenueListView extends StatelessWidget {
  const _VenueListView({
    required this.venues,
    this.greeting,
  });

  final List<Venue> venues;
  final String? greeting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = ResponsiveUtils.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    return RefreshIndicator(
      onRefresh: () => context.read<VenuesCubit>().loadVenues(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(padding),
        itemCount: venues.length + 1,
        separatorBuilder: (_, index) {
          if (index == 0) {
            return const SizedBox(height: 16);
          }
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting != null ? 'Hi, $greeting' : 'Browse venues',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pick a venue to view available slots.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          }

          final venue = venues[index - 1];
          return VenueCard(
            venue: venue,
            onTap: () {
              context.push(
                AppRoutes.venueDetailPath(venue.id),
                extra: venue,
              );
            },
          );
        },
      ),
    );
  }
}
