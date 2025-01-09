part of 'groups_bloc.dart';

abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsError extends GroupsState {
  final String message;

  GroupsError({required this.message});
}

class GroupsActionSuccess extends GroupsState {
  final String message;

  GroupsActionSuccess(this.message);
}
