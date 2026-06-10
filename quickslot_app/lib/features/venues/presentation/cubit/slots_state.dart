import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';

enum SlotsStatus { initial, loading, loaded, empty, error }

class SlotsState extends Equatable {
  const SlotsState({
    required this.venueId,
    required this.selectedDate,
    this.status = SlotsStatus.initial,
    this.slots = const [],
    this.timeFilter = SlotTimeFilter.all,
    this.errorMessage,
    this.isRealtimeConnected = false,
  });

  final int venueId;
  final DateTime selectedDate;
  final SlotsStatus status;
  final List<Slot> slots;
  final SlotTimeFilter timeFilter;
  final String? errorMessage;
  final bool isRealtimeConnected;

  List<Slot> get filteredSlots {
    return slots
        .where(
          (slot) => SlotTimeFilterUtils.matchesFilter(
            startTime: slot.startTime,
            filter: timeFilter,
          ),
        )
        .toList();
  }

  SlotsState copyWith({
    int? venueId,
    DateTime? selectedDate,
    SlotsStatus? status,
    List<Slot>? slots,
    SlotTimeFilter? timeFilter,
    String? errorMessage,
    bool? isRealtimeConnected,
    bool clearError = false,
  }) {
    return SlotsState(
      venueId: venueId ?? this.venueId,
      selectedDate: selectedDate ?? this.selectedDate,
      status: status ?? this.status,
      slots: slots ?? this.slots,
      timeFilter: timeFilter ?? this.timeFilter,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isRealtimeConnected: isRealtimeConnected ?? this.isRealtimeConnected,
    );
  }

  @override
  List<Object?> get props => [
        venueId,
        selectedDate,
        status,
        slots,
        timeFilter,
        errorMessage,
        isRealtimeConnected,
      ];
}
