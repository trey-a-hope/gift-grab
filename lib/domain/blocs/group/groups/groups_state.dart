part of 'groups_bloc.dart';

abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsError extends GroupsState {
  final String message;

  GroupsError({required this.message});
}

class GroupsSuccess extends GroupsState {
  final String message;

  GroupsSuccess(this.message);
}
