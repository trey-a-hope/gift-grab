part of 'user_groups_bloc.dart';

abstract class UserGroupsState {}

class UserGroupsInitial extends UserGroupsState {}

class UserGroupsLoading extends UserGroupsState {}

class UserGroupsLoaded extends UserGroupsState {
  final List<Group> groups;
  final bool hasMore;

  UserGroupsLoaded({
    required this.groups,
    required this.hasMore,
  });
}

class UserGroupsError extends UserGroupsState {
  final String message;

  UserGroupsError({required this.message});
}
