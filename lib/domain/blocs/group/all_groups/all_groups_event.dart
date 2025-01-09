part of 'all_groups_bloc.dart';

abstract class AllGroupsEvent {}

class FetchGroups extends AllGroupsEvent {}

class FetchMoreGroups extends AllGroupsEvent {
  final List<Group> groups;

  FetchMoreGroups({required this.groups});
}
