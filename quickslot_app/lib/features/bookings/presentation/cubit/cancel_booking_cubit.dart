import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_state.dart';

class CancelBookingCubit extends Cubit<CancelBookingState> {
  CancelBookingCubit({
    required BookingRepository bookingRepository,
    required UserSession userSession,
  })  : _bookingRepository = bookingRepository,
        _userSession = userSession,
        super(const CancelBookingState());

  final BookingRepository _bookingRepository;
  final UserSession _userSession;

  Future<void> cancelBooking(int bookingId) async {
    final user = _userSession.selectedUser;
    if (user == null) {
      emit(
        state.copyWith(
          status: CancelBookingStatus.failure,
          bookingId: bookingId,
          errorMessage: 'No user selected',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CancelBookingStatus.cancelling,
        bookingId: bookingId,
        clearError: true,
      ),
    );

    try {
      await _bookingRepository.cancelBooking(
        bookingId: bookingId,
        userId: user.id,
      );

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
