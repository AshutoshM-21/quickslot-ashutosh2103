import 'package:flutter/material.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';

Future<bool> showCancelBookingDialog({
  required BuildContext context,
  required UserBooking booking,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text(
          'Cancel your booking at ${booking.venueName} on '
          '${booking.displayDate} (${booking.displayTimeRange})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      );
    },
  );

  return confirmed ?? false;
}
