import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';

class MyBookingsResult extends Equatable {
  const MyBookingsResult({
    required this.bookings,
    this.isFromCache = false,
  });

  final List<UserBooking> bookings;
  final bool isFromCache;

  @override
  List<Object?> get props => [bookings, isFromCache];
}
