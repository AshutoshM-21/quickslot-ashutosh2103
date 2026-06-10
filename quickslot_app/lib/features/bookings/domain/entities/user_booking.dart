import 'package:equatable/equatable.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/core/utils/time_formatter.dart';

class UserBooking extends Equatable {
  const UserBooking({
    required this.id,
    required this.venueName,
    required this.slotDate,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    this.sport = 'Sports',
  });

  final int id;
  final String venueName;
  final DateTime slotDate;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final String sport;

  String get displayDate => DateUtils.formatForDisplay(slotDate);

  String get displayTimeRange {
    return '${TimeFormatter.format(startTime)} - '
        '${TimeFormatter.format(endTime)}';
  }

  @override
  List<Object?> get props => [
        id,
        venueName,
        slotDate,
        startTime,
        endTime,
        createdAt,
        sport,
      ];
}
