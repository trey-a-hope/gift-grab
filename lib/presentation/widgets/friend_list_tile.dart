import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:nakama/nakama.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;

  const FriendListTile(
    this.friend, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = friend.user;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: Image.network(
          user.avatarUrl?.isEmpty ?? true
              ? Globals.emptyProfile
              : user.avatarUrl!,
        ).image,
      ),
      title: Text(
        user.username ?? 'No Name',
      ),
    );
  }
}
