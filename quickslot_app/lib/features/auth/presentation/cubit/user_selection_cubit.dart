import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_repository.dart';
import 'package:quickslot_app/features/auth/data/repositories/user_session.dart';
import 'package:quickslot_app/features/auth/domain/entities/user.dart';
import 'package:quickslot_app/features/auth/presentation/cubit/user_selection_state.dart';

class UserSelectionCubit extends Cubit<UserSelectionState> {
  UserSelectionCubit({
    required UserRepository userRepository,
    required UserSession userSession,
  })  : _userSession = userSession,
        super(
          UserSelectionState(
            users: userRepository.getAvailableUsers(),
          ),
        );

  final UserSession _userSession;

  void selectUser(User user) {
    emit(state.copyWith(selectedUser: user));
  }

  void continueWithSelection() {
    final user = state.selectedUser;
    if (user == null) {
      return;
    }

    _userSession.selectUser(user);
    emit(state.copyWith(isCompleted: true));
  }
}
