part of 'group_my_bloc.dart';

abstract class GroupMyState {
  GroupMyState();
}

class GroupMyInitial extends GroupMyState {
  GroupMyInitial();
}

class GroupMyLoading extends GroupMyState {
  GroupMyLoading();
}

class GroupMyLoaded extends GroupMyState {
  final List<Group> groups;
  final bool hasMore;
  GroupMyLoaded({
    required this.groups,
    required this.hasMore,
  });
}

class GroupMyError extends GroupMyState {
  final String message;

  GroupMyError({required this.message});
}
