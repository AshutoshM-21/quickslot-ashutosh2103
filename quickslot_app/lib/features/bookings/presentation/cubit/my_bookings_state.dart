import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';

enum MyBookingsStatus { initial, loading, loaded, empty, error }

class MyBookingsState extends Equatable {
  const MyBookingsState({
    this.status = MyBookingsStatus.initial,
    this.bookings = const [],
    this.errorMessage,
    this.isShowingCachedData = false,
  });

  final MyBookingsStatus status;
  final List<UserBooking> bookings;
  final String? errorMessage;
  final bool isShowingCachedData;

  MyBookingsState copyWith({
    MyBookingsStatus? status,
    List<UserBooking>? bookings,
    String? errorMessage,
    bool? isShowingCachedData,
    bool clearError = false,
    bool clearCachedFlag = false,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isShowingCachedData: clearCachedFlag
          ? false
          : isShowingCachedData ?? this.isShowingCachedData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bookings,
        errorMessage,
        isShowingCachedData,
      ];
}
