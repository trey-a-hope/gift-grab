part of 'group_bloc.dart';

abstract class GroupEvent {}

class LoadGroupsEvent extends GroupEvent {}

class CreateGroupEvent extends GroupEvent {
  final String name;
  final String description;
  final int maxCount;
  final bool open;

  CreateGroupEvent({
    required this.name,
    required this.description,
    required this.maxCount,
    required this.open,
  });
}

class DeleteGroupEvent extends GroupEvent {
  final String groupId;

  DeleteGroupEvent({required this.groupId});
}

class JoinGroupEvent extends GroupEvent {
  final String groupId;

  JoinGroupEvent({required this.groupId});
}
