import 'package:flutter/foundation.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/core/storage/hive_initializer.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_repository.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/bookings/data/local/my_bookings_local_data_source.dart';
import 'package:quickslot_app/features/bookings/data/remote/booking_remote_data_source.dart';
import 'package:quickslot_app/features/bookings/data/remote/my_bookings_remote_data_source.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/data/repositories/my_bookings_repository.dart';
import 'package:quickslot_app/features/venues/data/repositories/slot_repository.dart';
import 'package:quickslot_app/features/venues/data/repositories/venue_repository.dart';
import 'package:quickslot_app/features/venues/data/services/slot_realtime_service.dart';

class AppDependencies {
  AppDependencies._();

  static bool _initialized = false;

  static final UserSession userSession = UserSession();
  static final UserRepository userRepository = const UserRepository();
  static final ApiClient apiClient = ApiClient();
  static final VenueRepository venueRepository =
      VenueRepository(apiClient: apiClient);
  static final SlotRepository slotRepository =
      SlotRepository(apiClient: apiClient);

  static late final MyBookingsLocalDataSource myBookingsLocalDataSource;
  static late final MyBookingsRemoteDataSource myBookingsRemoteDataSource;
  static late final BookingRemoteDataSource bookingRemoteDataSource;
  static late final MyBookingsRepository myBookingsRepository;
  static late final BookingRepository bookingRepository;
  static late final SlotRealtimeService slotRealtimeService;

  static final ValueNotifier<int> slotsRefreshSignal = ValueNotifier(0);

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    await HiveInitializer.init();

    myBookingsLocalDataSource = MyBookingsLocalDataSource();
    myBookingsRemoteDataSource =
        MyBookingsRemoteDataSource(apiClient: apiClient);
    bookingRemoteDataSource = BookingRemoteDataSource(apiClient: apiClient);

    myBookingsRepository = MyBookingsRepository(
      remoteDataSource: myBookingsRemoteDataSource,
      localDataSource: myBookingsLocalDataSource,
    );

    bookingRepository = BookingRepository(
      remoteDataSource: bookingRemoteDataSource,
      localDataSource: myBookingsLocalDataSource,
    );

    slotRealtimeService = SlotRealtimeService()..connect();

    _initialized = true;
  }

  static void requestSlotsRefresh() {
    slotsRefreshSignal.value++;
  }
}
