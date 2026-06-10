import 'package:quickslot_app/features/auth/data/repositories/user_repository.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';

class AppDependencies {
  AppDependencies._();

  static final UserSession userSession = UserSession();
  static final UserRepository userRepository = const UserRepository();
}
