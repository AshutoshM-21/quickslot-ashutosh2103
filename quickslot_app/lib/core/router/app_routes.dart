class AppRoutes {
  AppRoutes._();

  static const String userSelection = '/';
  static const String home = '/home';
  static const String venueDetail = '/venues/:venueId';

  static String venueDetailPath(int venueId) => '/venues/$venueId';
}
