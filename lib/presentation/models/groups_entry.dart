import 'package:nakama/nakama.dart';

class GroupsEntry {
  final List<Group> allGroups;
  final List<Group> adminGroups;
  final List<Group> superAdminGroups;
  final List<Group> memberGroups;
  final List<Group> joinRequestGroups;

  GroupsEntry({
    required this.allGroups,
    required this.adminGroups,
    required this.superAdminGroups,
    required this.memberGroups,
    required this.joinRequestGroups,
  });
}
