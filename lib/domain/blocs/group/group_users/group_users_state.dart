part of 'group_users_bloc.dart';

abstract class GroupUsersState {}

class GroupUsersInitial extends GroupUsersState {}

class GroupUsersLoading extends GroupUsersState {}

class GroupUsersLoaded extends GroupUsersState {
  final String uid;
  final List<GroupUser> users;

  GroupUsersLoaded({
    required this.uid,
    required this.users,
  });
}

class GroupUsersError extends GroupUsersState {
  final String message;

  GroupUsersError({required this.message});
}

class GroupUsersSuccess extends GroupUsersState {
  final String message;
  final bool goBack;

  GroupUsersSuccess(this.message, this.goBack);
}

class GroupUsersGoToRoute extends GroupUsersState {
  final String route;

  GroupUsersGoToRoute(this.route);
}
