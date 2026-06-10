import 'package:equatable/equatable.dart';

enum CancelBookingStatus { idle, cancelling, success, failure }

class CancelBookingState extends Equatable {
  const CancelBookingState({
    this.status = CancelBookingStatus.idle,
    this.bookingId,
    this.errorMessage,
  });

  final CancelBookingStatus status;
  final int? bookingId;
  final String? errorMessage;

  bool get isCancelling => status == CancelBookingStatus.cancelling;

  CancelBookingState copyWith({
    CancelBookingStatus? status,
    int? bookingId,
    String? errorMessage,
    bool clearBookingId = false,
    bool clearError = false,
  }) {
    return CancelBookingState(
      status: status ?? this.status,
      bookingId: clearBookingId ? null : bookingId ?? this.bookingId,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookingId, errorMessage];
}
