import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/theme/sport_visuals.dart';
import 'package:quickslot_app/core/widgets/app_empty_view.dart';
import 'package:quickslot_app/core/widgets/app_error_view.dart';
import 'package:quickslot_app/core/widgets/app_loading_view.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_state.dart';
import 'package:quickslot_app/features/bookings/presentation/widgets/booking_confirmation_sheet.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_cubit.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_state.dart';
import 'package:quickslot_app/features/venues/presentation/widgets/slot_date_picker.dart';
import 'package:quickslot_app/features/venues/presentation/widgets/slot_schedule_list.dart';
import 'package:quickslot_app/features/venues/presentation/widgets/slot_sport_filter_bar.dart';
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
              context.read<SlotsCubit>().loadSlots();
            case BookingStatus.failure:
              break;
          }
        },
        child: _VenueDetailBody(venue: venue),
      ),
    );
  }
}

class _VenueDetailBody extends StatefulWidget {
  const _VenueDetailBody({required this.venue});

  final Venue venue;

  @override
  State<_VenueDetailBody> createState() => _VenueDetailBodyState();
}

class _VenueDetailBodyState extends State<_VenueDetailBody> {
  int? _selectedSlotId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final filter = context.read<SlotsCubit>().state.timeFilter;
      if (filter == SlotTimeFilter.all) {
        context.read<SlotsCubit>().setTimeFilter(SlotTimeFilter.morning);
      }
    });
  }

  void _handleSlotTap(Slot slot, Venue venue, DateTime date) {
    if (!slot.isAvailable) {
      return;
    }

    setState(() => _selectedSlotId = slot.id);

    showBookingConfirmationSheet(
      context: context,
      slot: slot,
      venue: venue,
      date: date,
    ).whenComplete(() {
      if (mounted) {
        setState(() => _selectedSlotId = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;
    final style = SportVisuals.forVenue(venue);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: BlocBuilder<SlotsCubit, SlotsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _VenueHeader(
                    venue: venue,
                    style: style,
                    isRealtimeConnected: state.isRealtimeConnected,
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SlotDatePicker(
                                  selectedDate: state.selectedDate,
                                  onDateSelected: (date) {
                                    setState(() => _selectedSlotId = null);
                                    context
                                        .read<SlotsCubit>()
                                        .changeDate(date);
                                  },
                                ),
                                const SizedBox(height: 16),
                                SlotSportFilterBar(
                                  sports: state.availableSports,
                                  selectedSport: state.selectedSport,
                                  onSportSelected: (sport) {
                                    setState(() => _selectedSlotId = null);
                                    context
                                        .read<SlotsCubit>()
                                        .setSportFilter(sport);
                                  },
                                ),
                                const SizedBox(height: 16),
                                SlotTimeFilterBar(
                                  selectedFilter: state.timeFilter,
                                  onFilterSelected: (filter) {
                                    setState(() => _selectedSlotId = null);
                                    context
                                        .read<SlotsCubit>()
                                        .setTimeFilter(filter);
                                  },
                                ),
                                if (!state.isRealtimeConnected) ...[
                                  const SizedBox(height: 12),
                                  const _RealtimeStatusBanner(),
                                ],
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverToBoxAdapter(
                            child: switch (state.status) {
                              SlotsStatus.initial || SlotsStatus.loading =>
                                const AppLoadingView(),
                              SlotsStatus.error => AppErrorView(
                                  title: 'Could not load slots',
                                  message: state.errorMessage ??
                                      'Failed to load slots',
                                  onRetry: () =>
                                      context.read<SlotsCubit>().loadSlots(),
                                ),
                              SlotsStatus.empty => const AppEmptyView(
                                  icon: Icons.event_busy_outlined,
                                  title: 'No slots for this date',
                                  subtitle:
                                      'Try selecting a different date.',
                                ),
                              SlotsStatus.loaded =>
                                state.filteredSlots.isEmpty
                                    ? const AppEmptyView(
                                        icon: Icons.filter_alt_outlined,
                                        title: 'No slots in this time range',
                                        subtitle:
                                            'Try another filter or select a different date.',
                                      )
                                    : SlotScheduleList(
                                        slots: state.filteredSlots,
                                        venueName: venue.name,
                                        venueLocation: venue.location,
                                        selectedSlotId: _selectedSlotId,
                                        onSlotTap: (slot) => _handleSlotTap(
                                          slot,
                                          venue,
                                          state.selectedDate,
                                        ),
                                      ),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VenueHeader extends StatelessWidget {
  const _VenueHeader({
    required this.venue,
    required this.style,
    required this.isRealtimeConnected,
  });

  final Venue venue;
  final SportStyle style;
  final bool isRealtimeConnected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (venue.location != null && venue.location!.isNotEmpty)
                  Text(
                    venue.location!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: style.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: style.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(style.icon, size: 14, color: style.accent),
                const SizedBox(width: 4),
                Text(
                  venue.hasMultipleSports
                      ? '${venue.sports.length} sports'
                      : style.sport,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: style.accent,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          if (isRealtimeConnected) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.bolt_rounded,
              size: 18,
              color: style.accent,
            ),
          ],
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Live updates offline. Start the server locally or check your Railway deployment.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
