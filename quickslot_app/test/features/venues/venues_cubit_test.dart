import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/features/venues/data/repositories/venue_repository.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/venues_cubit.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/venues_state.dart';

class _FakeVenueRepository extends VenueRepository {
  _FakeVenueRepository(this._result) : super(apiClient: ApiClient());

  final Future<List<Venue>> Function() _result;

  @override
  Future<List<Venue>> getVenues() => _result();
}

void main() {
  group('VenuesCubit', () {
    test('emits loaded when venues are returned', () async {
      final cubit = VenuesCubit(
        venueRepository: _FakeVenueRepository(
          () async => const [
            Venue(id: 1, name: 'Arena 1'),
          ],
        ),
      );

      expect(cubit.state.status, VenuesStatus.initial);

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<VenuesState>().having(
            (state) => state.status,
            'status',
            VenuesStatus.loading,
          ),
          isA<VenuesState>()
              .having((state) => state.status, 'status', VenuesStatus.loaded)
              .having((state) => state.venues.length, 'venues length', 1),
        ]),
      );

      await cubit.loadVenues();
      await expectation;
      await cubit.close();
    });

    test('emits empty when no venues are returned', () async {
      final cubit = VenuesCubit(
        venueRepository: _FakeVenueRepository(() async => const []),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<VenuesState>().having(
            (state) => state.status,
            'status',
            VenuesStatus.loading,
          ),
          isA<VenuesState>().having(
            (state) => state.status,
            'status',
            VenuesStatus.empty,
          ),
        ]),
      );

      await cubit.loadVenues();
      await expectation;
      await cubit.close();
    });

    test('emits error when repository throws', () async {
      final cubit = VenuesCubit(
        venueRepository: _FakeVenueRepository(
          () async => throw Exception('Network error'),
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<VenuesState>().having(
            (state) => state.status,
            'status',
            VenuesStatus.loading,
          ),
          isA<VenuesState>()
              .having((state) => state.status, 'status', VenuesStatus.error)
              .having(
                (state) => state.errorMessage,
                'error message',
                'Network error',
              ),
        ]),
      );

      await cubit.loadVenues();
      await expectation;
      await cubit.close();
    });
  });
}
