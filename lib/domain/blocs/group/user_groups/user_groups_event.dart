part of 'user_groups_bloc.dart';

abstract class UserGroupsEvent {}

class FetchGroups extends UserGroupsEvent {}

class FetchMoreGroups extends UserGroupsEvent {
  final List<Group> groups;

  FetchMoreGroups({required this.groups});
}
