import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/auth/domain/entities/user.dart';
import 'package:quickslot_app/features/bookings/data/repositories/my_bookings_repository.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/my_bookings_state.dart';

class _FakeMyBookingsRepository extends MyBookingsRepository {
  _FakeMyBookingsRepository(this._result) : super(apiClient: ApiClient());

  final Future<List<UserBooking>> Function(int userId) _result;

  @override
  Future<List<UserBooking>> getUserBookings({required int userId}) {
    return _result(userId);
  }
}

void main() {
  final testDate = DateUtils.dateOnly(DateTime(2026, 6, 10));

  group('MyBookingsCubit', () {
    test('emits loaded when bookings are returned', () async {
      final userSession = UserSession()
        ..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = MyBookingsCubit(
        myBookingsRepository: _FakeMyBookingsRepository(
          (_) async => [
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
        myBookingsRepository: _FakeMyBookingsRepository((_) async => const []),
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
