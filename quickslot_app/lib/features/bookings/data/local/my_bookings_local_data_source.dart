import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickslot_app/features/bookings/data/local/booking_cache_keys.dart';
import 'package:quickslot_app/features/bookings/data/models/user_booking_model.dart';
import 'package:quickslot_app/features/bookings/domain/entities/user_booking.dart';

class MyBookingsLocalDataSource {
  MyBookingsLocalDataSource({Box<String>? box}) : _box = box;

  Box<String>? _box;

  Future<Box<String>> _getBox() async {
    _box ??= await Hive.openBox<String>(BookingCacheKeys.myBookingsBox);
    return _box!;
  }

  Future<void> cacheBookings({
    required int userId,
    required List<UserBooking> bookings,
  }) async {
    final box = await _getBox();
    final payload = bookings
        .map((booking) => UserBookingModel(
              id: booking.id,
              venueName: booking.venueName,
              slotDate: booking.slotDate,
              startTime: booking.startTime,
              endTime: booking.endTime,
              createdAt: booking.createdAt,
            ).toJson())
        .toList();

    await box.put(
      BookingCacheKeys.userBookingsKey(userId),
      jsonEncode(payload),
    );
  }

  Future<List<UserBooking>?> getCachedBookings({required int userId}) async {
    final box = await _getBox();
    final raw = box.get(BookingCacheKeys.userBookingsKey(userId));

    if (raw == null) {
      return null;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;

    return decoded
        .map(
          (item) => UserBookingModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> removeBooking({
    required int userId,
    required int bookingId,
  }) async {
    final cached = await getCachedBookings(userId: userId);
    if (cached == null) {
      return;
    }

    final updated = cached.where((booking) => booking.id != bookingId).toList();
    await cacheBookings(userId: userId, bookings: updated);
  }
}
