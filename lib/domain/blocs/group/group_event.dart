part of 'group_bloc.dart';

abstract class GroupEvent {}

class LoadGroupsEvent extends GroupEvent {}

class LoadGroupEvent extends GroupEvent {
  final String groupId;

  LoadGroupEvent(this.groupId);
}

class UpdateGroupEvent extends GroupEvent {
  final String groupId;
  final bool open;
  final String? name;
  final String? avatarUrl;
  final String? description;
  final String? langTag;
  final int? maxCount;

  UpdateGroupEvent({
    required this.groupId,
    required this.open,
    this.name,
    this.avatarUrl,
    this.description,
    this.langTag,
    this.maxCount,
  });
}

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
