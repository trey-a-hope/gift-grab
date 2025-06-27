part of 'group_users_bloc.dart';

class GroupUsersState extends Equatable implements ErrorState {
  final List<GroupUser> groupUsers;

  final bool isLoading;
  final String? error;

  GroupUsersState({
    this.groupUsers = const [],
    this.isLoading = true,
    this.error,
  });

  GroupUsersState copyWith({
    List<GroupUser>? groupUsers,
    bool? isLoading,
    String? error,
  }) =>
      GroupUsersState(
        groupUsers: groupUsers ?? this.groupUsers,
        isLoading: isLoading == true ? true : false,
        error: error,
      );

  @override
  List<Object?> get props => [
        groupUsers,
        isLoading,
        error,
      ];
}
