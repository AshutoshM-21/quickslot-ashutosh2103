import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';

class UserBookingModel extends UserBooking {
  const UserBookingModel({
    required super.id,
    required super.venueName,
    required super.slotDate,
    required super.startTime,
    required super.endTime,
    required super.createdAt,
  });

  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    return UserBookingModel(
      id: (json['id'] as num).toInt(),
      venueName: json['venue_name'] as String,
      slotDate: DateUtils.dateOnly(
        DateTime.parse(json['slot_date'].toString()),
      ),
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venue_name': venueName,
      'slot_date': DateUtils.formatForApi(slotDate),
      'start_time': startTime,
      'end_time': endTime,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
