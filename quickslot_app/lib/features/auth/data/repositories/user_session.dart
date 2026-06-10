import 'package:quickslot_app/features/auth/domain/entities/user.dart';

class UserSession {
  User? _selectedUser;

  User? get selectedUser => _selectedUser;

  bool get hasUser => _selectedUser != null;

  void selectUser(User user) {
    _selectedUser = user;
  }

  void clear() {
    _selectedUser = null;
  }
}
