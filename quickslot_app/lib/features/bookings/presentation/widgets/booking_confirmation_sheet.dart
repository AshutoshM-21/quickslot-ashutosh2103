import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/widgets/app_loading_indicator.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_state.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

Future<void> showBookingConfirmationSheet({
  required BuildContext context,
  required Slot slot,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: BookingConfirmationSheet(slot: slot),
      );
    },
  );
}

class BookingConfirmationSheet extends StatelessWidget {
  const BookingConfirmationSheet({
    super.key,
    required this.slot,
  });

  final Slot slot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
            const SizedBox(height: 24),
            Text(
              'Confirm booking',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'You are about to reserve this time slot.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryMuted),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    slot.displayTimeRange,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryDark,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                final isBooking = state.isBooking && state.slotId == slot.id;

                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isBooking
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Not now'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: isBooking
                            ? null
                            : () {
                                context.read<BookingCubit>().bookSlot(slot.id);
                              },
                        child: isBooking
                            ? const AppLoadingIndicator(
                                color: AppColors.white,
                              )
                            : const Text('Confirm'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
