part of 'groups_list_bloc.dart';

class GroupsListState extends BaseState {
  final bool all;
  final List<Group> groups;
  final String? cursor;
  final bool isLoading;
  final String? success;
  final String? error;

  GroupsListState(
    this.all, {
    this.groups = const [],
    this.cursor,
    this.isLoading = true,
    this.success,
    this.error,
  });

  GroupsListState copyWith({
    List<Group>? groups,
    String? cursor,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      GroupsListState(
        this.all,
        groups: groups ?? this.groups,
        cursor: cursor ?? this.cursor,
        isLoading: isLoading == true ? true : false,
        success: success,
        error: error,
      );
}
