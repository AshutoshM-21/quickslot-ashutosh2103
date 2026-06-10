import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

enum SlotsStatus { initial, loading, loaded, empty, error }

class SlotsState extends Equatable {
  const SlotsState({
    required this.venueId,
    required this.selectedDate,
    this.status = SlotsStatus.initial,
    this.slots = const [],
    this.errorMessage,
  });

  final int venueId;
  final DateTime selectedDate;
  final SlotsStatus status;
  final List<Slot> slots;
  final String? errorMessage;

  SlotsState copyWith({
    int? venueId,
    DateTime? selectedDate,
    SlotsStatus? status,
    List<Slot>? slots,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SlotsState(
      venueId: venueId ?? this.venueId,
      selectedDate: selectedDate ?? this.selectedDate,
      status: status ?? this.status,
      slots: slots ?? this.slots,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [venueId, selectedDate, status, slots, errorMessage];
}
