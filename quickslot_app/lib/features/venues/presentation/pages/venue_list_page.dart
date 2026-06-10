import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickslot_app/core/constants/app_constants.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/router/app_routes.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
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
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilledButton.tonalIcon(
            onPressed: () => context.push(AppRoutes.myBookings),
            icon: const Icon(Icons.event_note_rounded, size: 18),
            label: const Text('Bookings'),
          ),
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
    final padding = ResponsiveUtils.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    return RefreshIndicator(
      onRefresh: () => context.read<VenuesCubit>().loadVenues(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(padding, padding, padding, padding + 8),
        itemCount: venues.length + 1,
        separatorBuilder: (_, index) {
          if (index == 0) {
            return const SizedBox(height: 20);
          }
          return const SizedBox(height: 16);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting != null ? 'Hi, $greeting' : 'Find your court',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Book premium sports venues near you.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
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
