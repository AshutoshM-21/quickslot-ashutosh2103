import 'package:equatable/equatable.dart';
import 'package:quickslot_app/features/auth/domain/entities/user.dart';

class UserSelectionState extends Equatable {
  const UserSelectionState({
    required this.users,
    this.selectedUser,
    this.isCompleted = false,
  });

  final List<User> users;
  final User? selectedUser;
  final bool isCompleted;

  bool get canContinue => selectedUser != null;

  UserSelectionState copyWith({
    List<User>? users,
    User? selectedUser,
    bool clearSelectedUser = false,
    bool? isCompleted,
  }) {
    return UserSelectionState(
      users: users ?? this.users,
      selectedUser: clearSelectedUser ? null : selectedUser ?? this.selectedUser,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [users, selectedUser, isCompleted];
}
