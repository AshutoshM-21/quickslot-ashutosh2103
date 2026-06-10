import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/features/venues/data/repositories/venue_repository.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/venues_state.dart';

class VenuesCubit extends Cubit<VenuesState> {
  VenuesCubit({required VenueRepository venueRepository})
      : _venueRepository = venueRepository,
        super(const VenuesState());

  final VenueRepository _venueRepository;

  Future<void> loadVenues() async {
    emit(
      state.copyWith(
        status: VenuesStatus.loading,
        clearError: true,
      ),
    );

    try {
      final venues = await _venueRepository.getVenues();

      if (venues.isEmpty) {
        emit(
          state.copyWith(
            status: VenuesStatus.empty,
            venues: venues,
            clearError: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: VenuesStatus.loaded,
          venues: venues,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: VenuesStatus.error,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
