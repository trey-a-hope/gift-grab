import 'package:nakama/nakama.dart';

mixin GroupPermissions {
  GroupUser? findUserInGroup(List<GroupUser> users, String uid) =>
      users.where((item) => item.user.id == uid).firstOrNull;

  // 0 - Superadmin - There must at least be 1 superadmin in any group. The superadmin has all the privileges of the admin and can additionally delete the group and promote admin members.
  // 1 - Admin - There can be one of more admins. Admins can update groups as well as accept, kick, promote, demote, ban or add members.
  // 2 - Member - Regular group member. They cannot accept join requests from new users.
  // 3 - Join request - A new join request from a new user. This does not count towards the maximum group member count.

  bool canEdit(List<GroupUser> users, String uid) {
    final me = findUserInGroup(users, uid);
    if (me == null) return false;

    return me.state == GroupMembershipState.superadmin ||
        me.state == GroupMembershipState.admin;
  }

  // TODO: Rename this to admin permissions? accept, kick, promote, demote, ban or add members are similar...
  bool canKick(List<GroupUser> users, String currentUid, String targetUid) {
    if (currentUid == targetUid) return false;

    final me = findUserInGroup(users, currentUid);
    if (me == null) return false;

    final target = findUserInGroup(users, targetUid);
    if (target == null) return false;

    // Superadmins can kick anyone.
    if (me.state == GroupMembershipState.superadmin) {
      return true;
    }

    // Admins can remove all but superadmins.
    if (me.state == GroupMembershipState.admin &&
        target.state != GroupMembershipState.superadmin) {
      return true;
    }

    return false;
  }

  bool canBan(List<GroupUser> users, String currentUid, String targetUid) =>
      canKick(users, currentUid, targetUid);

  bool canPromote(List<GroupUser> users, String currentUid, String targetUid) =>
      canKick(users, currentUid, targetUid);

  bool canDelete(List<GroupUser> users, String uid) {
    final me = findUserInGroup(users, uid);
    if (me == null) return false;

    return me.state == GroupMembershipState.superadmin;
  }

  bool canLeave(List<GroupUser> users, String uid) {
    final me = findUserInGroup(users, uid);
    if (me == null) return false;

    return me.state != GroupMembershipState.superadmin;
  }

  bool canJoin(List<GroupUser> users, String uid, Group group) {
    if (group.maxCount == null) {
      throw Exception('Max count is null');
    }

    final notInGroup = findUserInGroup(users, uid) == null;
    final notFull = group.maxCount! > users.length;

    return notInGroup && notFull;
  }
}
