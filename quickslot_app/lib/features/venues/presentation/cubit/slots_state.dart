import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';

enum SlotsStatus { initial, loading, loaded, empty, error }

class SlotsState extends Equatable {
  const SlotsState({
    required this.venueId,
    required this.selectedDate,
    this.venueSports = const [],
    this.status = SlotsStatus.initial,
    this.slots = const [],
    this.timeFilter = SlotTimeFilter.all,
    this.selectedSport,
    this.errorMessage,
    this.isRealtimeConnected = false,
  });

  final int venueId;
  final DateTime selectedDate;
  final List<String> venueSports;
  final SlotsStatus status;
  final List<Slot> slots;
  final SlotTimeFilter timeFilter;
  final String? selectedSport;
  final String? errorMessage;
  final bool isRealtimeConnected;

  List<String> get availableSports {
    if (venueSports.isNotEmpty) {
      return venueSports;
    }

    final sports = slots.map((slot) => slot.sport).toSet().toList();
    sports.sort();
    return sports;
  }

  List<Slot> get filteredSlots {
    return slots
        .where(
          (slot) => selectedSport == null || slot.sport == selectedSport,
        )
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
    List<String>? venueSports,
    SlotsStatus? status,
    List<Slot>? slots,
    SlotTimeFilter? timeFilter,
    String? selectedSport,
    String? errorMessage,
    bool? isRealtimeConnected,
    bool clearError = false,
    bool clearSelectedSport = false,
  }) {
    return SlotsState(
      venueId: venueId ?? this.venueId,
      selectedDate: selectedDate ?? this.selectedDate,
      venueSports: venueSports ?? this.venueSports,
      status: status ?? this.status,
      slots: slots ?? this.slots,
      timeFilter: timeFilter ?? this.timeFilter,
      selectedSport:
          clearSelectedSport ? null : selectedSport ?? this.selectedSport,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isRealtimeConnected: isRealtimeConnected ?? this.isRealtimeConnected,
    );
  }

  @override
  List<Object?> get props => [
        venueId,
        selectedDate,
        venueSports,
        status,
        slots,
        timeFilter,
        selectedSport,
        errorMessage,
        isRealtimeConnected,
      ];
}
