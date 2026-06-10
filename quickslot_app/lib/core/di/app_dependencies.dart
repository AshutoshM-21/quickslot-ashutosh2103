import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_repository.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/bookings/data/repositories/booking_repository.dart';
import 'package:quickslot_app/features/bookings/data/repositories/my_bookings_repository.dart';
import 'package:quickslot_app/features/venues/data/repositories/slot_repository.dart';
import 'package:quickslot_app/features/venues/data/repositories/venue_repository.dart';

class AppDependencies {
  AppDependencies._();

  static final UserSession userSession = UserSession();
  static final UserRepository userRepository = const UserRepository();
  static final ApiClient apiClient = ApiClient();
  static final VenueRepository venueRepository =
      VenueRepository(apiClient: apiClient);
  static final SlotRepository slotRepository =
      SlotRepository(apiClient: apiClient);
  static final BookingRepository bookingRepository =
      BookingRepository(apiClient: apiClient);
  static final MyBookingsRepository myBookingsRepository =
      MyBookingsRepository(apiClient: apiClient);
}
