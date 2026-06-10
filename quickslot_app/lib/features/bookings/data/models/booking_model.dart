import 'package:quickslot_app/features/bookings/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.slotId,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      slotId: (json['slot_id'] as num).toInt(),
    );
  }
}
