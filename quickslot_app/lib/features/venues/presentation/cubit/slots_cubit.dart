import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/features/venues/data/repositories/slot_repository.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_state.dart';

class SlotsCubit extends Cubit<SlotsState> {
  SlotsCubit({
    required SlotRepository slotRepository,
    required int venueId,
    DateTime? initialDate,
  })  : _slotRepository = slotRepository,
        super(
          SlotsState(
            venueId: venueId,
            selectedDate: DateUtils.dateOnly(initialDate ?? DateTime.now()),
          ),
        );

  final SlotRepository _slotRepository;

  Future<void> loadSlots() async {
    emit(
      state.copyWith(
        status: SlotsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final slots = await _slotRepository.getSlots(
        venueId: state.venueId,
        date: state.selectedDate,
      );

      if (slots.isEmpty) {
        emit(
          state.copyWith(
            status: SlotsStatus.empty,
            slots: slots,
            clearError: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: SlotsStatus.loaded,
          slots: slots,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SlotsStatus.error,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> changeDate(DateTime date) async {
    emit(
      state.copyWith(
        selectedDate: DateUtils.dateOnly(date),
        clearError: true,
      ),
    );
    await loadSlots();
  }
}
