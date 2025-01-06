part of 'group_user_bloc.dart';

abstract class GroupUserState {}

class GroupUserInitial extends GroupUserState {}

class GroupUserLoading extends GroupUserState {}

class GroupUsersLoaded extends GroupUserState {
  final String uid;
  final List<GroupUser> users;

  GroupUsersLoaded({
    required this.uid,
    required this.users,
  });
}

class GroupUsersError extends GroupUserState {
  final String message;

  GroupUsersError({required this.message});
}

class GroupUserEventSuccess extends GroupUserState {
  final String message;
  final bool goBack;

  GroupUserEventSuccess(this.message, this.goBack);
}
