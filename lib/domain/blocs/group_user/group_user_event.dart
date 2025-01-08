part of 'group_user_bloc.dart';

abstract class GroupUserEvent {}

class LoadGroupUsersEvent extends GroupUserEvent {
  final String groupId;

  LoadGroupUsersEvent({required this.groupId});
}

class JoinGroupEvent extends GroupUserEvent {
  final String groupId;

  JoinGroupEvent({required this.groupId});
}

class LeaveGroupEvent extends GroupUserEvent {
  final String groupId;

  LeaveGroupEvent({required this.groupId});
}

class DeleteGroupEvent extends GroupUserEvent {
  final String groupId;

  DeleteGroupEvent({required this.groupId});
}

class KickUserEvent extends GroupUserEvent {
  final String groupId;
  final String uid;

  KickUserEvent({
    required this.groupId,
    required this.uid,
  });
}
