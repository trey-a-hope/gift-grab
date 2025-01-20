part of 'groups_bloc.dart';

abstract class GroupsState {
  final String? cursor;

  GroupsState({required this.cursor});
}

class GroupsInitial extends GroupsState {
  GroupsInitial({required super.cursor});
}

class GroupsLoading extends GroupsState {
  GroupsLoading({required super.cursor});
}

class GroupsLoaded extends GroupsState {
  final List<Group> groups;

  GroupsLoaded({
    required this.groups,
    required super.cursor,
  });
}

class GroupsError extends GroupsState {
  final String message;

  GroupsError({required this.message, required super.cursor});
}

class GroupsSuccess extends GroupsState {
  final String message;

  GroupsSuccess({required this.message, required super.cursor});
}
