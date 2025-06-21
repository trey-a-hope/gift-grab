part of 'groups_list_bloc.dart';

sealed class GroupsListEvent {
  const GroupsListEvent();
}

class ListGroups extends GroupsListEvent {
  final bool clearCursor;
  const ListGroups({required this.clearCursor});
}
