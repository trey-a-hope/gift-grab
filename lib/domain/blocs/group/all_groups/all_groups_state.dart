part of 'all_groups_bloc.dart';

abstract class AllGroupsState {}

class AllGroupsInitial extends AllGroupsState {
  AllGroupsInitial();
}

class AllGroupsLoading extends AllGroupsState {
  AllGroupsLoading();
}

class AllGroupsLoaded extends AllGroupsState {
  final List<Group> groups;
  final bool hasMore;

  AllGroupsLoaded({
    required this.groups,
    required this.hasMore,
  });
}

class AllGroupsError extends AllGroupsState {
  final String message;

  AllGroupsError({required this.message});
}
