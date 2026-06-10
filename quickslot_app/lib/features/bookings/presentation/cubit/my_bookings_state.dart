import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';

enum MyBookingsStatus { initial, loading, loaded, empty, error }

class MyBookingsState extends Equatable {
  const MyBookingsState({
    this.status = MyBookingsStatus.initial,
    this.bookings = const [],
    this.errorMessage,
  });

  final MyBookingsStatus status;
  final List<UserBooking> bookings;
  final String? errorMessage;

  MyBookingsState copyWith({
    MyBookingsStatus? status,
    List<UserBooking>? bookings,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookings, errorMessage];
}
