import 'package:nakama/nakama.dart';

extension ListFriendExtensions on List<Friend> {
  FriendshipState? getFriendshipState(String uid) {
    if (isEmpty) {
      return null;
    }

    final friend = firstWhere((friend) => friend.user.id == uid);

    return friend.state;
  }
}
