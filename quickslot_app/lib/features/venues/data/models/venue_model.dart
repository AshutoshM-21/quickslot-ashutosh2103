import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class VenueModel extends Venue {
  const VenueModel({
    required super.id,
    required super.name,
    super.description,
    super.location,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
    );
  }
}
