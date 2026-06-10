import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/auth/domain/entities/user.dart';
import 'package:quickslot_app/features/bookings/data/local/my_bookings_local_data_source.dart';
import 'package:quickslot_app/features/bookings/data/remote/booking_remote_data_source.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/domain/entities/booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_state.dart';
import '../../test_helpers.dart';

class _FakeBookingRepository extends BookingRepository {
  _FakeBookingRepository({
    Future<void> Function(int bookingId, int userId)? onCancel,
  })  : _onCancel = onCancel,
        super(
          remoteDataSource: BookingRemoteDataSource(apiClient: ApiClient()),
          localDataSource: MyBookingsLocalDataSource(),
        );

  final Future<void> Function(int bookingId, int userId)? _onCancel;

  @override
  Future<void> cancelBooking({
    required int bookingId,
    required int userId,
  }) {
    if (_onCancel != null) {
      return _onCancel!(bookingId, userId);
    }
    return Future.value();
  }

  @override
  Future<Booking> createBooking({
    required int slotId,
    required int userId,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  setUpAll(() async {
    await initTestHive();
  });

  group('CancelBookingCubit', () {
    test('emits success when cancellation succeeds', () async {
      final userSession = UserSession()
        ..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = CancelBookingCubit(
        bookingRepository: _FakeBookingRepository(),
        userSession: userSession,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CancelBookingState>()
              .having((state) => state.status, 'status', CancelBookingStatus.cancelling)
              .having((state) => state.bookingId, 'bookingId', 7),
          isA<CancelBookingState>()
              .having((state) => state.status, 'status', CancelBookingStatus.success)
              .having((state) => state.bookingId, 'bookingId', 7),
        ]),
      );

      await cubit.cancelBooking(7);
      await expectation;
      await cubit.close();
    });

    test('emits failure when repository throws', () async {
      final userSession = UserSession()
        ..selectUser(const User(id: 1, name: 'Ashu'));
      final cubit = CancelBookingCubit(
        bookingRepository: _FakeBookingRepository(
          onCancel: (_, __) async => throw Exception('Booking not found'),
        ),
        userSession: userSession,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CancelBookingState>().having(
            (state) => state.status,
            'status',
            CancelBookingStatus.cancelling,
          ),
          isA<CancelBookingState>()
              .having((state) => state.status, 'status', CancelBookingStatus.failure)
              .having(
                (state) => state.errorMessage,
                'error message',
                'Booking not found',
              ),
        ]),
      );

      await cubit.cancelBooking(7);
      await expectation;
      await cubit.close();
    });
  });
}
