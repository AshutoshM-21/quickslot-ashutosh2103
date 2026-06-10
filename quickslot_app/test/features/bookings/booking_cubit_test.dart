import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/auth/domain/entities/user.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/domain/entities/booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/booking_state.dart';

class _FakeBookingRepository extends BookingRepository {
  _FakeBookingRepository(this._result) : super(apiClient: ApiClient());

  final Future<Booking> Function(int slotId, int userId) _result;

  @override
  Future<Booking> createBooking({
    required int slotId,
    required int userId,
  }) {
    return _result(slotId, userId);
  }
}

void main() {
  group('BookingCubit', () {
    test('emits success when booking succeeds', () async {
      final userSession = UserSession()..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = BookingCubit(
        bookingRepository: _FakeBookingRepository(
          (slotId, userId) async => Booking(
            id: 10,
            userId: userId,
            slotId: slotId,
          ),
        ),
        userSession: userSession,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<BookingState>()
              .having((state) => state.status, 'status', BookingStatus.booking)
              .having((state) => state.slotId, 'slotId', 5),
          isA<BookingState>()
              .having((state) => state.status, 'status', BookingStatus.success)
              .having((state) => state.slotId, 'slotId', 5),
        ]),
      );

      await cubit.bookSlot(5);
      await expectation;
      await cubit.close();
    });

    test('emits failure when repository throws', () async {
      final userSession = UserSession()..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = BookingCubit(
        bookingRepository: _FakeBookingRepository(
          (_, __) async => throw Exception('Slot already booked'),
        ),
        userSession: userSession,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<BookingState>().having(
            (state) => state.status,
            'status',
            BookingStatus.booking,
          ),
          isA<BookingState>()
              .having((state) => state.status, 'status', BookingStatus.failure)
              .having(
                (state) => state.errorMessage,
                'error message',
                'Slot already booked',
              ),
        ]),
      );

      await cubit.bookSlot(5);
      await expectation;
      await cubit.close();
    });

    test('emits failure when no user is selected', () async {
      final cubit = BookingCubit(
        bookingRepository: _FakeBookingRepository(
          (slotId, userId) async => Booking(
            id: 10,
            userId: userId,
            slotId: slotId,
          ),
        ),
        userSession: UserSession(),
      );

      final expectation = expectLater(
        cubit.stream,
        emits(
          isA<BookingState>()
              .having((state) => state.status, 'status', BookingStatus.failure)
              .having(
                (state) => state.errorMessage,
                'error message',
                'No user selected',
              ),
        ),
      );

      await cubit.bookSlot(5);
      await expectation;
      await cubit.close();
    });
  });
}
