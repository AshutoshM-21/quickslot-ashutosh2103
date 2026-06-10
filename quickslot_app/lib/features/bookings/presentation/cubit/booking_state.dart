import 'package:equatable/equatable.dart';

enum BookingStatus { idle, booking, success, failure }

class BookingState extends Equatable {
  const BookingState({
    this.status = BookingStatus.idle,
    this.slotId,
    this.errorMessage,
  });

  final BookingStatus status;
  final int? slotId;
  final String? errorMessage;

  bool get isBooking => status == BookingStatus.booking;

  BookingState copyWith({
    BookingStatus? status,
    int? slotId,
    String? errorMessage,
    bool clearSlotId = false,
    bool clearError = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      slotId: clearSlotId ? null : slotId ?? this.slotId,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, slotId, errorMessage];
}
