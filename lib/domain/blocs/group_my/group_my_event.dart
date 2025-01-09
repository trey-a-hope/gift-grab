part of 'group_my_bloc.dart';

abstract class GroupMyEvent {}

class FetchGroups extends GroupMyEvent {}

class FetchMoreGroups extends GroupMyEvent {
  final List<Group> groups;

  FetchMoreGroups({required this.groups});
}

class RefreshGroups extends GroupMyEvent {} // New event
