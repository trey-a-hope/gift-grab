import 'package:nakama/nakama.dart';

mixin GroupPermissionsMixin {
  GroupUser? findUserInGroup(List<GroupUser> users, String uid) =>
      users.where((item) => item.user.id == uid).firstOrNull;

  // 0 - Superadmin - There must at least be 1 superadmin in any group. The superadmin has all the privileges of the admin and can additionally delete the group and promote admin members.
  // 1 - Admin - There can be one of more admins. Admins can update groups as well as accept, kick, promote, demote, ban or add members.
  // 2 - Member - Regular group member. They cannot accept join requests from new users.
  // 3 - Join request - A new join request from a new user. This does not count towards the maximum group member count.

  bool canEdit(List<GroupUser> users, String uid) {
    final me = findUserInGroup(users, uid);
    return me?.state == GroupMembershipState.superadmin ||
        me?.state == GroupMembershipState.admin;
  }

  /// Helper method to check if current user can perform actions on target user
  bool _canPerformActionOnTarget(
    List<GroupUser> users,
    String currentUid,
    String targetUid, {
    bool allowSelfAction = false,
    bool requireJoinRequest = false,
    bool excludeJoinRequest = true,
  }) {
    if (!allowSelfAction && currentUid == targetUid) return false;

    final me = findUserInGroup(users, currentUid);
    if (me == null) return false;

    final target = findUserInGroup(users, targetUid);
    if (target == null) return false;

    // Check join request requirements
    if (requireJoinRequest &&
        target.state != GroupMembershipState.joinRequest) {
      return false;
    }
    if (excludeJoinRequest &&
        target.state == GroupMembershipState.joinRequest) {
      return false;
    }

    return _hasPermissionOverTarget(me.state, target.state);
  }

  /// Helper method to determine if current user has permission over target user
  bool _hasPermissionOverTarget(
    GroupMembershipState currentState,
    GroupMembershipState targetState,
  ) {
    // Superadmins can perform actions on anyone except other superadmins in some cases
    if (currentState == GroupMembershipState.superadmin) {
      return true;
    }

    // Admins can perform actions on members only
    if (currentState == GroupMembershipState.admin) {
      return targetState != GroupMembershipState.superadmin;
    }

    return false;
  }

  bool canKick(List<GroupUser> users, String currentUid, String targetUid) =>
      _canPerformActionOnTarget(users, currentUid, targetUid);

  bool canBan(List<GroupUser> users, String currentUid, String targetUid) =>
      _canPerformActionOnTarget(users, currentUid, targetUid);

  bool canPromote(List<GroupUser> users, String currentUid, String targetUid) {
    final target = findUserInGroup(users, targetUid);
    // Cannot promote someone who is already superadmin
    if (target?.state == GroupMembershipState.superadmin) return false;

    return _canPerformActionOnTarget(users, currentUid, targetUid);
  }

  bool canDemote(List<GroupUser> users, String currentUid, String targetUid) {
    final target = findUserInGroup(users, targetUid);
    // Cannot demote someone who is already a member
    if (target?.state == GroupMembershipState.member) return false;

    return _canPerformActionOnTarget(users, currentUid, targetUid);
  }

  bool canAccept(List<GroupUser> users, String currentUid, String targetUid) =>
      _canPerformActionOnTarget(
        users,
        currentUid,
        targetUid,
        requireJoinRequest: true,
        excludeJoinRequest: false,
      );

  bool canDelete(List<GroupUser> users, String uid) {
    final me = findUserInGroup(users, uid);
    return me?.state == GroupMembershipState.superadmin;
  }

  bool canLeave(List<GroupUser> users, String uid) {
    final me = findUserInGroup(users, uid);
    return me != null && me.state != GroupMembershipState.superadmin;
  }

  bool canJoin(List<GroupUser> users, String uid, Group group) {
    if (group.maxCount == null) {
      throw Exception('Max count is null');
    }

    return !_inGroup(users, uid) && group.maxCount! > users.length;
  }

  bool _inGroup(List<GroupUser> users, String uid) =>
      findUserInGroup(users, uid) != null;
}
