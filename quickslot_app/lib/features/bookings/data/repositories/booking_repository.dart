import 'package:quickslot_app/features/bookings/data/local/my_bookings_local_data_source.dart';
import 'package:quickslot_app/features/bookings/data/remote/booking_remote_data_source.dart';
import 'package:quickslot_app/features/bookings/domain/entities/booking.dart';

class BookingRepository {
  BookingRepository({
    required BookingRemoteDataSource remoteDataSource,
    required MyBookingsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final BookingRemoteDataSource _remoteDataSource;
  final MyBookingsLocalDataSource _localDataSource;

  Future<Booking> createBooking({
    required int slotId,
    required int userId,
  }) async {
    return _remoteDataSource.createBooking(
      slotId: slotId,
      userId: userId,
    );
  }

  Future<void> cancelBooking({
    required int bookingId,
    required int userId,
  }) async {
    await _remoteDataSource.cancelBooking(bookingId: bookingId);
    await _localDataSource.removeBooking(
      userId: userId,
      bookingId: bookingId,
    );
  }
}
