import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

class SlotModel extends Slot {
  const SlotModel({
    required super.id,
    required super.startTime,
    required super.endTime,
    required super.status,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: (json['id'] as num).toInt(),
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
      status: _parseStatus(json['status'] as String),
    );
  }

  static SlotStatus _parseStatus(String value) {
    switch (value.toUpperCase()) {
      case 'AVAILABLE':
        return SlotStatus.available;
      case 'BOOKED':
        return SlotStatus.booked;
      default:
        return SlotStatus.booked;
    }
  }
}
