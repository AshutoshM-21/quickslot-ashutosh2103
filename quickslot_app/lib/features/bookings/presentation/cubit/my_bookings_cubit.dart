import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/bookings/data/repositories/my_bookings_repository.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit({
    required MyBookingsRepository myBookingsRepository,
    required UserSession userSession,
  })  : _myBookingsRepository = myBookingsRepository,
        _userSession = userSession,
        super(const MyBookingsState());

  final MyBookingsRepository _myBookingsRepository;
  final UserSession _userSession;

  Future<void> loadBookings() async {
    final user = _userSession.selectedUser;
    if (user == null) {
      emit(
        state.copyWith(
          status: MyBookingsStatus.error,
          errorMessage: 'No user selected',
          clearCachedFlag: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: MyBookingsStatus.loading,
        clearError: true,
        clearCachedFlag: true,
      ),
    );

    try {
      final result = await _myBookingsRepository.getUserBookings(
        userId: user.id,
      );

      if (result.bookings.isEmpty) {
        emit(
          state.copyWith(
            status: MyBookingsStatus.empty,
            bookings: result.bookings,
            isShowingCachedData: result.isFromCache,
            clearError: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: MyBookingsStatus.loaded,
          bookings: result.bookings,
          isShowingCachedData: result.isFromCache,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: MyBookingsStatus.error,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
          clearCachedFlag: true,
        ),
      );
    }
  }
}
