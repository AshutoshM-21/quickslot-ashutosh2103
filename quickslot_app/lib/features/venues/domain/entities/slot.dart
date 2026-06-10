import 'package:equatable/equatable.dart';
import 'package:quickslot_app/core/utils/time_formatter.dart';

enum SlotStatus { available, booked }

class Slot extends Equatable {
  const Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.sport,
  });

  final int id;
  final String startTime;
  final String endTime;
  final SlotStatus status;
  final String sport;

  bool get isAvailable => status == SlotStatus.available;

  bool get isBooked => status == SlotStatus.booked;

  String get displayTimeRange {
    return '${TimeFormatter.format(startTime)} - '
        '${TimeFormatter.format(endTime)}';
  }

  @override
  List<Object?> get props => [id, startTime, endTime, status, sport];
}
