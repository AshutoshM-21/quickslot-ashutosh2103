import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/utils/responsive_utils.dart';
import 'package:quickslot_app/core/widgets/app_empty_view.dart';
import 'package:quickslot_app/core/widgets/app_error_view.dart';
import 'package:quickslot_app/core/widgets/app_loading_view.dart';
import 'package:quickslot_app/core/widgets/app_scaffold.dart';
import 'package:quickslot_app/core/widgets/responsive_padding.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_state.dart';
import 'package:quickslot_app/features/bookings/presentation/widgets/booking_confirmation_sheet.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_cubit.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_state.dart';
import 'package:quickslot_app/features/venues/presentation/widgets/slot_date_picker.dart';
import 'package:quickslot_app/core/widgets/app_status_chip.dart';
import 'package:quickslot_app/features/venues/presentation/widgets/slot_grid_tile.dart';
import 'package:quickslot_app/features/venues/presentation/widgets/slot_time_filter_bar.dart';

class VenueDetailPage extends StatelessWidget {
  const VenueDetailPage({
    super.key,
    required this.venue,
  });

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return _SlotsRefreshListener(
      child: BlocListener<BookingCubit, BookingState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case BookingStatus.idle:
            case BookingStatus.booking:
              break;
            case BookingStatus.success:
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Slot booked successfully'),
                ),
              );
              context.read<SlotsCubit>().loadSlots();
              context.read<BookingCubit>().reset();
            case BookingStatus.failure:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Booking failed',
                  ),
                ),
              );
              context.read<BookingCubit>().reset();
          }
        },
        child: AppScaffold(
          title: venue.name,
          showBackButton: true,
          body: BlocBuilder<SlotsCubit, SlotsState>(
            builder: (context, state) {
              return ResponsivePadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SlotDatePicker(
                      selectedDate: state.selectedDate,
                      onDateSelected: (date) {
                        context.read<SlotsCubit>().changeDate(date);
                      },
                    ),
                    const SizedBox(height: 16),
                    const _SlotLegend(),
                    const SizedBox(height: 12),
                    SlotTimeFilterBar(
                      selectedFilter: state.timeFilter,
                      onFilterSelected: (filter) {
                        context.read<SlotsCubit>().setTimeFilter(filter);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (!state.isRealtimeConnected)
                      const _RealtimeStatusBanner(),
                    Expanded(
                      child: switch (state.status) {
                        SlotsStatus.initial || SlotsStatus.loading =>
                          const AppLoadingView(),
                        SlotsStatus.error => AppErrorView(
                            title: 'Could not load slots',
                            message:
                                state.errorMessage ?? 'Failed to load slots',
                            onRetry: () =>
                                context.read<SlotsCubit>().loadSlots(),
                          ),
                        SlotsStatus.empty => const AppEmptyView(
                            icon: Icons.event_busy_outlined,
                            title: 'No slots for this date',
                            subtitle: 'Try selecting a different date.',
                          ),
                        SlotsStatus.loaded =>
                          state.filteredSlots.isEmpty
                              ? const AppEmptyView(
                                  icon: Icons.filter_alt_outlined,
                                  title: 'No slots in this time range',
                                  subtitle:
                                      'Try another filter or select a different date.',
                                )
                              : _SlotsGridView(
                                  slots: state.filteredSlots,
                                  onSlotTap: (slot) {
                                    showBookingConfirmationSheet(
                                      context: context,
                                      slot: slot,
                                    );
                                  },
                                ),
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SlotsRefreshListener extends StatefulWidget {
  const _SlotsRefreshListener({required this.child});

  final Widget child;

  @override
  State<_SlotsRefreshListener> createState() => _SlotsRefreshListenerState();
}

class _SlotsRefreshListenerState extends State<_SlotsRefreshListener> {
  @override
  void initState() {
    super.initState();
    AppDependencies.slotsRefreshSignal.addListener(_refreshSlots);
  }

  @override
  void dispose() {
    AppDependencies.slotsRefreshSignal.removeListener(_refreshSlots);
    super.dispose();
  }

  void _refreshSlots() {
    if (!mounted) {
      return;
    }
    context.read<SlotsCubit>().loadSlots();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _RealtimeStatusBanner extends StatelessWidget {
  const _RealtimeStatusBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        'Live updates unavailable. Pull to refresh slots manually.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}

class _SlotLegend extends StatelessWidget {
  const _SlotLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Legend',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 12),
        const AppStatusChip(
          label: 'Available',
          variant: AppStatusChipVariant.available,
        ),
        const SizedBox(width: 8),
        const AppStatusChip(
          label: 'Booked',
          variant: AppStatusChipVariant.booked,
        ),
      ],
    );
  }
}

class _SlotsGridView extends StatelessWidget {
  const _SlotsGridView({
    required this.slots,
    required this.onSlotTap,
  });

  final List<Slot> slots;
  final ValueChanged<Slot> onSlotTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveUtils.slotGridCrossAxisCount(
          constraints.maxWidth,
        );

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            return SlotGridTile(
              slot: slot,
              onTap: slot.isAvailable ? () => onSlotTap(slot) : null,
            );
          },
        );
      },
    );
  }
}
