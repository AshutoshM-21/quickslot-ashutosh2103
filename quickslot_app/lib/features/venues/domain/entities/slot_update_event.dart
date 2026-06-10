import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

class SlotUpdateEvent extends Equatable {
  const SlotUpdateEvent({
    required this.venueId,
    required this.slotId,
    required this.date,
    required this.status,
  });

  final int venueId;
  final int slotId;
  final String date;
  final String status;

  SlotStatus get slotStatus {
    return status.toUpperCase() == 'BOOKED'
        ? SlotStatus.booked
        : SlotStatus.available;
  }

  factory SlotUpdateEvent.fromJson(Map<String, dynamic> json) {
    return SlotUpdateEvent(
      venueId: (json['venueId'] as num).toInt(),
      slotId: (json['slotId'] as num).toInt(),
      date: json['date'].toString(),
      status: json['status'] as String,
    );
  }

  @override
  List<Object?> get props => [venueId, slotId, date, status];
}
