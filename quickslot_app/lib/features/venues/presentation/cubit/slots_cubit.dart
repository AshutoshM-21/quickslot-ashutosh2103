import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/features/venues/data/repositories/slot_repository.dart';
import 'package:quickslot_app/features/venues/data/services/slot_realtime_service.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_update_event.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_state.dart';

class SlotsCubit extends Cubit<SlotsState> {
  SlotsCubit({
    required SlotRepository slotRepository,
    required int venueId,
    SlotRealtimeService? slotRealtimeService,
    DateTime? initialDate,
  })  : _slotRepository = slotRepository,
        _slotRealtimeService = slotRealtimeService,
        super(
          SlotsState(
            venueId: venueId,
            selectedDate: DateUtils.dateOnly(initialDate ?? DateTime.now()),
          ),
        ) {
    _bindRealtimeService();
  }

  final SlotRepository _slotRepository;
  final SlotRealtimeService? _slotRealtimeService;

  void _bindRealtimeService() {
    final service = _slotRealtimeService;
    if (service == null) {
      return;
    }

    service.onSlotUpdated = _handleSlotUpdate;
    service.onReconnected = loadSlots;
    service.connectionStatus.addListener(_handleConnectionStatus);
    emit(
      state.copyWith(
        isRealtimeConnected:
            service.connectionStatus.value == RealtimeConnectionStatus.connected,
      ),
    );
  }

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

  void setTimeFilter(SlotTimeFilter filter) {
    emit(state.copyWith(timeFilter: filter));
  }

  void _handleSlotUpdate(SlotUpdateEvent event) {
    if (event.venueId != state.venueId) {
      return;
    }

    if (event.date != DateUtils.formatForApi(state.selectedDate)) {
      return;
    }

    if (state.slots.isEmpty) {
      loadSlots();
      return;
    }

    final updatedSlots = state.slots.map((slot) {
      if (slot.id != event.slotId) {
        return slot;
      }

      return Slot(
        id: slot.id,
        startTime: slot.startTime,
        endTime: slot.endTime,
        status: event.slotStatus,
      );
    }).toList();

    emit(
      state.copyWith(
        slots: updatedSlots,
        status: updatedSlots.isEmpty ? SlotsStatus.empty : SlotsStatus.loaded,
      ),
    );
  }

  void _handleConnectionStatus() {
    final isConnected = _slotRealtimeService?.connectionStatus.value ==
        RealtimeConnectionStatus.connected;

    emit(state.copyWith(isRealtimeConnected: isConnected));
  }

  @override
  Future<void> close() {
    final service = _slotRealtimeService;
    if (service != null) {
      service.connectionStatus.removeListener(_handleConnectionStatus);
      if (service.onSlotUpdated == _handleSlotUpdate) {
        service.onSlotUpdated = null;
      }
      if (service.onReconnected == loadSlots) {
        service.onReconnected = null;
      }
    }

    return super.close();
  }
}
