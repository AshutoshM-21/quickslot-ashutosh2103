import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/theme/sport_visuals.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/core/widgets/app_loading_indicator.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_state.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

Future<void> showBookingConfirmationSheet({
  required BuildContext context,
  required Slot slot,
  required Venue venue,
  required DateTime date,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: BookingConfirmationSheet(
          slot: slot,
          venue: venue,
          date: date,
        ),
      );
    },
  );
}

class BookingConfirmationSheet extends StatelessWidget {
  const BookingConfirmationSheet({
    super.key,
    required this.slot,
    required this.venue,
    required this.date,
  });

  final Slot slot;
  final Venue venue;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == BookingStatus.success && state.slotId == slot.id) {
          return;
        }
      },
      builder: (context, state) {
        final isCurrentSlot = state.slotId == slot.id;
        final isBooking = state.isBooking && isCurrentSlot;
        final isSuccess = state.status == BookingStatus.success && isCurrentSlot;
        final isFailure = state.status == BookingStatus.failure && isCurrentSlot;

        if (isSuccess) {
          return _BookingSuccessView(
            venue: venue,
            date: date,
            slot: slot,
            onDone: () {
              context.read<BookingCubit>().reset();
              Navigator.of(context).pop();
            },
          );
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: 24 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Review booking',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Confirm your slot details before booking.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 20),
              _BookingSummaryCard(
                venue: venue,
                date: date,
                slot: slot,
              ),
              if (isFailure) ...[
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? 'Booking failed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isBooking
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: isBooking
                          ? null
                          : () {
                              context.read<BookingCubit>().bookSlot(slot.id);
                            },
                      child: isBooking
                          ? const AppLoadingIndicator(color: AppColors.white)
                          : const Text('Confirm booking'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BookingSummaryCard extends StatelessWidget {
  const _BookingSummaryCard({
    required this.venue,
    required this.date,
    required this.slot,
  });

  final Venue venue;
  final DateTime date;
  final Slot slot;

  @override
  Widget build(BuildContext context) {
    final style = SportVisuals.forSport(slot.sport);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _SummaryRow(
            icon: Icons.stadium_outlined,
            label: 'Venue',
            value: venue.name,
            accent: style.accent,
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.calendar_month_rounded,
            label: 'Date',
            value: DateUtils.formatForDisplay(date),
            accent: style.accent,
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.schedule_rounded,
            label: 'Time',
            value: slot.displayTimeRange,
            accent: style.accent,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking summary',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${slot.sport} slot · ${slot.displayTimeRange}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookingSuccessView extends StatelessWidget {
  const _BookingSuccessView({
    required this.venue,
    required this.date,
    required this.slot,
    required this.onDone,
  });

  final Venue venue;
  final DateTime date;
  final Slot slot;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Booking confirmed',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Your slot at ${venue.name} is reserved.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 20),
          _BookingSummaryCard(
            venue: venue,
            date: date,
            slot: slot,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDone,
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
