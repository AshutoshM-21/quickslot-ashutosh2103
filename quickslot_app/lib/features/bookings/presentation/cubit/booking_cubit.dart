import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required BookingRepository bookingRepository,
    required UserSession userSession,
  })  : _bookingRepository = bookingRepository,
        _userSession = userSession,
        super(const BookingState());

  final BookingRepository _bookingRepository;
  final UserSession _userSession;

  Future<void> bookSlot(int slotId) async {
    final user = _userSession.selectedUser;
    if (user == null) {
      emit(
        BookingState(
          status: BookingStatus.failure,
          slotId: slotId,
          errorMessage: 'No user selected',
        ),
      );
      return;
    }

    emit(
      BookingState(
        status: BookingStatus.booking,
        slotId: slotId,
        clearError: true,
      ),
    );

    try {
      await _bookingRepository.createBooking(
        slotId: slotId,
        userId: user.id,
      );

      emit(
        BookingState(
          status: BookingStatus.success,
          slotId: slotId,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        BookingState(
          status: BookingStatus.failure,
          slotId: slotId,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void reset() {
    emit(const BookingState());
  }
}
