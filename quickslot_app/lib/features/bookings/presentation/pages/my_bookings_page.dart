import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/utils/responsive_utils.dart';
import 'package:quickslot_app/core/widgets/app_empty_view.dart';
import 'package:quickslot_app/core/widgets/app_error_view.dart';
import 'package:quickslot_app/core/widgets/app_loading_view.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/widgets/app_scaffold.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_state.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_state.dart';
import 'package:quickslot_app/features/bookings/presentation/widgets/cached_data_banner.dart';
import 'package:quickslot_app/features/bookings/presentation/widgets/cancel_booking_dialog.dart';
import 'package:quickslot_app/features/bookings/presentation/widgets/user_booking_card.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelBookingCubit, CancelBookingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case CancelBookingStatus.idle:
          case CancelBookingStatus.cancelling:
            break;
          case CancelBookingStatus.success:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking cancelled'),
              ),
            );
            context.read<MyBookingsCubit>().loadBookings();
            AppDependencies.requestSlotsRefresh();
            context.read<CancelBookingCubit>().reset();
          case CancelBookingStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Cancellation failed',
                ),
              ),
            );
            context.read<CancelBookingCubit>().reset();
        }
      },
      child: AppScaffold(
        title: 'My Bookings',
        showBackButton: true,
        body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            return switch (state.status) {
              MyBookingsStatus.initial || MyBookingsStatus.loading =>
                const AppLoadingView(),
              MyBookingsStatus.error => AppErrorView(
                  title: 'Could not load bookings',
                  message: state.errorMessage ?? 'Failed to load bookings',
                  onRetry: () =>
                      context.read<MyBookingsCubit>().loadBookings(),
                ),
              MyBookingsStatus.empty => const AppEmptyView(
                  icon: Icons.event_busy_outlined,
                  title: 'No bookings yet',
                  subtitle: 'Book a slot from a venue to see it here.',
                ),
              MyBookingsStatus.loaded => _MyBookingsListView(
                  bookings: state.bookings,
                  showCachedBanner: state.isShowingCachedData,
                ),
            };
          },
        ),
      ),
    );
  }
}

class _MyBookingsListView extends StatelessWidget {
  const _MyBookingsListView({
    required this.bookings,
    this.showCachedBanner = false,
  });

  final List<UserBooking> bookings;
  final bool showCachedBanner;

  Future<void> _handleCancel(
    BuildContext context,
    UserBooking booking,
  ) async {
    final confirmed = await showCancelBookingDialog(
      context: context,
      booking: booking,
    );

    if (!context.mounted || !confirmed) {
      return;
    }

    context.read<CancelBookingCubit>().cancelBooking(booking.id);
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    return BlocBuilder<CancelBookingCubit, CancelBookingState>(
      builder: (context, cancelState) {
        return RefreshIndicator(
          onRefresh: () => context.read<MyBookingsCubit>().loadBookings(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(padding),
            itemCount: bookings.length + (showCachedBanner ? 2 : 1),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your reservations',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manage upcoming and confirmed bookings.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                );
              }

              if (showCachedBanner && index == 1) {
                return const CachedDataBanner();
              }

              final headerOffset = showCachedBanner ? 2 : 1;
              final bookingIndex = index - headerOffset;
              final booking = bookings[bookingIndex];
              final isCancelling = cancelState.isCancelling &&
                  cancelState.bookingId == booking.id;

              return UserBookingCard(
                booking: booking,
                isCancelling: isCancelling,
                onCancel: () => _handleCancel(context, booking),
              );
            },
          ),
        );
      },
    );
  }
}
