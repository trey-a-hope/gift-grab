import 'package:nakama/nakama.dart';

abstract class GroupAllEvent {}

class FetchGroups extends GroupAllEvent {}

class FetchMoreGroups extends GroupAllEvent {
  final List<Group> groups;

  FetchMoreGroups({required this.groups});
}
