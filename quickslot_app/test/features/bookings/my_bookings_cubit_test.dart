import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/auth/domain/entities/user.dart';
import 'package:quickslot_app/features/bookings/data/local/my_bookings_local_data_source.dart';
import 'package:quickslot_app/features/bookings/data/models/my_bookings_result.dart';
import 'package:quickslot_app/features/bookings/data/remote/my_bookings_remote_data_source.dart';
import 'package:quickslot_app/features/bookings/data/repositories/my_bookings_repository.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_state.dart';
import '../../test_helpers.dart';

class _FakeMyBookingsRepository extends MyBookingsRepository {
  _FakeMyBookingsRepository(this._result)
      : super(
          remoteDataSource: MyBookingsRemoteDataSource(apiClient: ApiClient()),
          localDataSource: MyBookingsLocalDataSource(),
        );

  final Future<MyBookingsResult> Function(int userId) _result;

  @override
  Future<MyBookingsResult> getUserBookings({required int userId}) {
    return _result(userId);
  }
}

void main() {
  setUpAll(() async {
    await initTestHive();
  });

  final testDate = DateUtils.dateOnly(DateTime(2026, 6, 10));

  group('MyBookingsCubit', () {
    test('emits loaded when bookings are returned', () async {
      final userSession = UserSession()
        ..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = MyBookingsCubit(
        myBookingsRepository: _FakeMyBookingsRepository(
          (_) async => MyBookingsResult(
            bookings: [
              UserBooking(
                id: 1,
                venueName: 'Arena 1',
                slotDate: testDate,
                startTime: '10:00:00',
                endTime: '11:00:00',
                createdAt: DateTime(2026, 6, 9),
              ),
            ],
          ),
        ),
        userSession: userSession,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<MyBookingsState>().having(
            (state) => state.status,
            'status',
            MyBookingsStatus.loading,
          ),
          isA<MyBookingsState>()
              .having((state) => state.status, 'status', MyBookingsStatus.loaded)
              .having((state) => state.bookings.length, 'bookings length', 1),
        ]),
      );

      await cubit.loadBookings();
      await expectation;
      await cubit.close();
    });

    test('emits empty when no bookings are returned', () async {
      final userSession = UserSession()
        ..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = MyBookingsCubit(
        myBookingsRepository: _FakeMyBookingsRepository(
          (_) async => const MyBookingsResult(bookings: []),
        ),
        userSession: userSession,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<MyBookingsState>().having(
            (state) => state.status,
            'status',
            MyBookingsStatus.loading,
          ),
          isA<MyBookingsState>().having(
            (state) => state.status,
            'status',
            MyBookingsStatus.empty,
          ),
        ]),
      );

      await cubit.loadBookings();
      await expectation;
      await cubit.close();
    });

    test('emits loaded with cached flag when repository returns cache', () async {
      final userSession = UserSession()
        ..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = MyBookingsCubit(
        myBookingsRepository: _FakeMyBookingsRepository(
          (_) async => MyBookingsResult(
            bookings: [
              UserBooking(
                id: 1,
                venueName: 'Arena 1',
                slotDate: testDate,
                startTime: '10:00:00',
                endTime: '11:00:00',
                createdAt: DateTime(2026, 6, 9),
              ),
            ],
            isFromCache: true,
          ),
        ),
        userSession: userSession,
      );

      await cubit.loadBookings();

      expect(cubit.state.isShowingCachedData, isTrue);
      await cubit.close();
    });

    test('emits error when repository throws', () async {
      final userSession = UserSession()
        ..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = MyBookingsCubit(
        myBookingsRepository: _FakeMyBookingsRepository(
          (_) async => throw Exception('Network error'),
        ),
        userSession: userSession,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<MyBookingsState>().having(
            (state) => state.status,
            'status',
            MyBookingsStatus.loading,
          ),
          isA<MyBookingsState>()
              .having((state) => state.status, 'status', MyBookingsStatus.error)
              .having(
                (state) => state.errorMessage,
                'error message',
                'Network error',
              ),
        ]),
      );

      await cubit.loadBookings();
      await expectation;
      await cubit.close();
    });
  });
}
