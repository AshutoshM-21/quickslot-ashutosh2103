import 'package:equatable/equatable.dart';

class Venue extends Equatable {
  const Venue({
    required this.id,
    required this.name,
    this.description,
    this.location,
  });

  final int id;
  final String name;
  final String? description;
  final String? location;

  @override
  List<Object?> get props => [id, name, description, location];
}
