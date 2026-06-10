class BookingCacheKeys {
  BookingCacheKeys._();

  static const String myBookingsBox = 'my_bookings_cache';

  static String userBookingsKey(int userId) => 'user_$userId';
}
