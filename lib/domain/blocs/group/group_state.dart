part of 'group_bloc.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupsLoaded extends GroupState {
  final String uid;
  final GroupsEntry entry;

  GroupsLoaded({
    required this.uid,
    required this.entry,
  });
}

class GroupError extends GroupState {
  final String message;

  GroupError({required this.message});
}

class GroupCreatedSuccess extends GroupState {}

class GroupDeleteSuccess extends GroupState {}
