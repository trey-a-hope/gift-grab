part of 'group_users_bloc.dart';

abstract class GroupUsersEvent {}

class FetchGroupUsers extends GroupUsersEvent {
  final String groupId;

  FetchGroupUsers({required this.groupId});
}

class JoinGroup extends GroupUsersEvent {
  final String groupId;

  JoinGroup({required this.groupId});
}

class LeaveGroup extends GroupUsersEvent {
  final String groupId;

  LeaveGroup({required this.groupId});
}

class DeleteGroup extends GroupUsersEvent {
  final String groupId;

  DeleteGroup({required this.groupId});
}

class KickUserFromGroup extends GroupUsersEvent {
  final String groupId;
  final String uid;

  KickUserFromGroup({required this.groupId, required this.uid});
}
