import 'package:nakama/nakama.dart';

class GroupsEntry {
  final List<Group> allGroups;
  final List<Group> myGroups;

  GroupsEntry({
    required this.allGroups,
    required this.myGroups,
  });
}
