import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

enum VenuesStatus { initial, loading, loaded, empty, error }

class VenuesState extends Equatable {
  const VenuesState({
    this.status = VenuesStatus.initial,
    this.venues = const [],
    this.errorMessage,
  });

  final VenuesStatus status;
  final List<Venue> venues;
  final String? errorMessage;

  VenuesState copyWith({
    VenuesStatus? status,
    List<Venue>? venues,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VenuesState(
      status: status ?? this.status,
      venues: venues ?? this.venues,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, venues, errorMessage];
}
