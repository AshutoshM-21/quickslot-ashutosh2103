import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class VenueImages {
  VenueImages._();

  static const String badminton =
      'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=900&q=80&auto=format&fit=crop';

  static const String football =
      'https://plus.unsplash.com/premium_photo-1661868926397-0083f0503c07?w=900&q=80&auto=format&fit=crop';

  static const String cricket =
      'https://images.unsplash.com/photo-1531415074968-036ba1b575da?w=900&q=80&auto=format&fit=crop';

  static const String swimming =
      'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=900&q=80&auto=format&fit=crop';

  static const String tennis =
      'https://images.unsplash.com/photo-1595435934249-5df7ed6e1c30?w=900&q=80&auto=format&fit=crop';

  static const String defaultSport =
      'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=900&q=80&auto=format&fit=crop';

  static String resolveForVenue(Venue venue) {
    if (venue.hasImage) {
      return venue.imageUrl!;
    }

    return forSport(venue.primarySport);
  }

  static String forSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'badminton':
        return badminton;
      case 'football':
        return football;
      case 'cricket':
        return cricket;
      case 'swimming':
        return swimming;
      case 'tennis':
      case 'table tennis':
        return tennis;
      default:
        return defaultSport;
    }
  }
}
