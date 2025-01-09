part of 'group_all_bloc.dart';

abstract class GroupAllState {
  GroupAllState();
}

class GroupAllInitial extends GroupAllState {
  GroupAllInitial();
}

class GroupAllLoading extends GroupAllState {
  GroupAllLoading();
}

class GroupAllLoaded extends GroupAllState {
  final List<Group> groups;
  final bool hasMore;
  GroupAllLoaded({
    required this.groups,
    required this.hasMore,
  });
}

class GroupAllError extends GroupAllState {
  final String message;

  GroupAllError({required this.message});
}
