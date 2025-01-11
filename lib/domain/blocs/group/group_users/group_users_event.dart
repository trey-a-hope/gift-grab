part of 'group_users_bloc.dart';

abstract class GroupUsersEvent {}

class FetchGroupUsers extends GroupUsersEvent {
  final String groupId;

  FetchGroupUsers({required this.groupId});
}

class JoinGroup extends GroupUsersEvent {
  final String groupId;
  final bool isJoinRequest;

  JoinGroup({
    required this.groupId,
    required this.isJoinRequest,
  });
}

class LeaveGroup extends GroupUsersEvent {
  final String groupId;
  final bool isJoinRequest;

  LeaveGroup({
    required this.groupId,
    required this.isJoinRequest,
  });
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

class BanUserFromGroup extends GroupUsersEvent {
  final String groupId;
  final String uid;

  BanUserFromGroup({required this.groupId, required this.uid});
}

class PromoteUserInGroup extends GroupUsersEvent {
  final String groupId;
  final String uid;

  PromoteUserInGroup({required this.groupId, required this.uid});
}

class DemoteUserInGroup extends GroupUsersEvent {
  final String groupId;
  final String uid;

  DemoteUserInGroup({required this.groupId, required this.uid});
}

class AddUserIntoGroup extends GroupUsersEvent {
  final String groupId;
  final String uid;

  AddUserIntoGroup({required this.groupId, required this.uid});
}
