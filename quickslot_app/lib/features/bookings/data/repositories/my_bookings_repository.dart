import 'package:quickslot_app/features/bookings/data/local/my_bookings_local_data_source.dart';
import 'package:quickslot_app/features/bookings/data/models/my_bookings_result.dart';
import 'package:quickslot_app/features/bookings/data/remote/my_bookings_remote_data_source.dart';

class MyBookingsRepository {
  MyBookingsRepository({
    required MyBookingsRemoteDataSource remoteDataSource,
    required MyBookingsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final MyBookingsRemoteDataSource _remoteDataSource;
  final MyBookingsLocalDataSource _localDataSource;

  Future<MyBookingsResult> getUserBookings({required int userId}) async {
    try {
      final bookings = await _remoteDataSource.fetchBookings(userId: userId);
      await _localDataSource.cacheBookings(
        userId: userId,
        bookings: bookings,
      );

      return MyBookingsResult(bookings: bookings);
    } catch (error) {
      final cached = await _localDataSource.getCachedBookings(userId: userId);

      if (cached != null) {
        return MyBookingsResult(
          bookings: cached,
          isFromCache: true,
        );
      }

      rethrow;
    }
  }

  Future<void> removeCachedBooking({
    required int userId,
    required int bookingId,
  }) {
    return _localDataSource.removeBooking(
      userId: userId,
      bookingId: bookingId,
    );
  }
}
