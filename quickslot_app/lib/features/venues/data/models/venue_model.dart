import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class VenueModel extends Venue {
  const VenueModel({
    required super.id,
    required super.name,
    super.description,
    super.location,
    super.sports,
    super.imageUrl,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      sports: _parseSports(json),
      imageUrl: _parseImageUrl(json),
    );
  }

  static String? _parseImageUrl(Map<String, dynamic> json) {
    final value = json['imageUrl'] ?? json['image_url'];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
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
