import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/widgets/app_scaffold.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_state.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_state.dart';
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
                const Center(
                  child: CircularProgressIndicator(),
                ),
              MyBookingsStatus.error => _MyBookingsErrorView(
                  message: state.errorMessage ?? 'Failed to load bookings',
                  onRetry: () =>
                      context.read<MyBookingsCubit>().loadBookings(),
                ),
              MyBookingsStatus.empty => const _MyBookingsEmptyView(),
              MyBookingsStatus.loaded => _MyBookingsListView(
                  bookings: state.bookings,
                ),
            };
          },
        ),
      ),
    );
  }
}

class _MyBookingsListView extends StatelessWidget {
  const _MyBookingsListView({required this.bookings});

  final List<UserBooking> bookings;

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
    return BlocBuilder<CancelBookingCubit, CancelBookingState>(
      builder: (context, cancelState) {
        return RefreshIndicator(
          onRefresh: () => context.read<MyBookingsCubit>().loadBookings(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final booking = bookings[index];
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

class _MyBookingsEmptyView extends StatelessWidget {
  const _MyBookingsEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Book a slot from a venue to see it here.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyBookingsErrorView extends StatelessWidget {
  const _MyBookingsErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load bookings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
