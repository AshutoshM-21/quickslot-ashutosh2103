import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.userId,
    required this.slotId,
  });

  final int id;
  final int userId;
  final int slotId;

  @override
  List<Object?> get props => [id, userId, slotId];
}
