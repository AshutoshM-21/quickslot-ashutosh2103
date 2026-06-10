import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Confirm booking',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book this slot?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                slot.displayTimeRange,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
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
                        child: const Text('Cancel'),
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
                            ? const AppLoadingIndicator()
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
