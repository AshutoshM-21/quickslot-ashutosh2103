import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/domain/entities/booking.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_cubit.dart';
import 'package:quickslot_app/features/bookings/presentation/cubit/cancel_booking_state.dart';

class _FakeBookingRepository extends BookingRepository {
  _FakeBookingRepository({
    Future<void> Function(int bookingId)? onCancel,
  })  : _onCancel = onCancel,
        super(apiClient: ApiClient());

  final Future<void> Function(int bookingId)? _onCancel;

  @override
  Future<void> cancelBooking({required int bookingId}) {
    if (_onCancel != null) {
      return _onCancel!(bookingId);
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
  group('CancelBookingCubit', () {
    test('emits success when cancellation succeeds', () async {
      final cubit = CancelBookingCubit(
        bookingRepository: _FakeBookingRepository(),
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
      final cubit = CancelBookingCubit(
        bookingRepository: _FakeBookingRepository(
          onCancel: (_) async => throw Exception('Booking not found'),
        ),
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
