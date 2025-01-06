part of 'group_user_bloc.dart';

abstract class GroupUserEvent {}

class LoadGroupUsersEvent extends GroupUserEvent {
  final String groupId;

  LoadGroupUsersEvent({required this.groupId});
}
