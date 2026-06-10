import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class VenueModel extends Venue {
  const VenueModel({
    required super.id,
    required super.name,
    super.description,
    super.location,
    super.sports,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      sports: _parseSports(json),
    );
  }

  static List<String> _parseSports(Map<String, dynamic> json) {
    final sportsValue = json['sports'];
    if (sportsValue is List) {
      return sportsValue.map((sport) => sport.toString()).toList();
    }

    final legacySport = json['sport'];
    if (legacySport is String && legacySport.isNotEmpty) {
      return legacySport
          .split(',')
          .map((sport) => sport.trim())
          .where((sport) => sport.isNotEmpty)
          .toList();
    }

    return const [];
  }
}
