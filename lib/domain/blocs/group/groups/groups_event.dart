part of 'groups_bloc.dart';

abstract class GroupsEvent {}

class FetchGroups extends GroupsEvent {}

class FetchMoreGroups extends GroupsEvent {
  final List<Group> groups;

  FetchMoreGroups({required this.groups});
}

class UpdateGroupEvent extends GroupsEvent {
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

class CreateGroupEvent extends GroupsEvent {
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
