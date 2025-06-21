import 'package:nakama/nakama.dart';

extension ListUserGroupExtensions on List<UserGroup> {
  List<Group> toGroups() => map((u) => u.group).toList();
}
