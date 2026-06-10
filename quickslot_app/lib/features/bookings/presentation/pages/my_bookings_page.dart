import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/widgets/app_scaffold.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_state.dart';
import 'package:quickslot_app/features/bookings/presentation/widgets/user_booking_card.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
                onRetry: () => context.read<MyBookingsCubit>().loadBookings(),
              ),
            MyBookingsStatus.empty => const _MyBookingsEmptyView(),
            MyBookingsStatus.loaded => _MyBookingsListView(
                bookings: state.bookings,
              ),
          };
        },
      ),
    );
  }
}

class _MyBookingsListView extends StatelessWidget {
  const _MyBookingsListView({required this.bookings});

  final List<UserBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<MyBookingsCubit>().loadBookings(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return UserBookingCard(booking: bookings[index]);
        },
      ),
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
