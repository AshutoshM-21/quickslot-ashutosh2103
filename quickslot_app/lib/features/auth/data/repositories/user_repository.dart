import 'package:quickslot_app/features/auth/domain/entities/user.dart';

class UserRepository {
  const UserRepository();

  List<User> getAvailableUsers() {
    return const [
      User(id: 1, name: 'Ashu'),
      User(id: 2, name: 'Test User'),
    ];
  }
}
