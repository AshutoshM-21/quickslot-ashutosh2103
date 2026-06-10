import 'package:equatable/equatable.dart';

class Venue extends Equatable {
  const Venue({
    required this.id,
    required this.name,
    this.description,
    this.location,
    this.sports = const [],
  });

  final int id;
  final String name;
  final String? description;
  final String? location;
  final List<String> sports;

  bool get hasMultipleSports => sports.length > 1;

  String get primarySport => sports.isNotEmpty ? sports.first : 'Sports';

  @override
  List<Object?> get props => [id, name, description, location, sports];
}
