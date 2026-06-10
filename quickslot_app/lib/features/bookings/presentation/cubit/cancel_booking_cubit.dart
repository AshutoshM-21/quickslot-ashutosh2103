import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_state.dart';

class CancelBookingCubit extends Cubit<CancelBookingState> {
  CancelBookingCubit({
    required BookingRepository bookingRepository,
  })  : _bookingRepository = bookingRepository,
        super(const CancelBookingState());

  final BookingRepository _bookingRepository;

  Future<void> cancelBooking(int bookingId) async {
    emit(
      state.copyWith(
        status: CancelBookingStatus.cancelling,
        bookingId: bookingId,
        clearError: true,
      ),
    );

    try {
      await _bookingRepository.cancelBooking(bookingId: bookingId);

      emit(
        state.copyWith(
          status: CancelBookingStatus.success,
          bookingId: bookingId,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CancelBookingStatus.failure,
          bookingId: bookingId,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void reset() {
    emit(const CancelBookingState());
  }
}
