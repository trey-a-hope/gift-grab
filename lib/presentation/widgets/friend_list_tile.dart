import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/widgets/clickable_avatar.dart';
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
      leading: ClickableAvatar(user),
      title: Text(
        user.username ?? 'No Name',
      ),
    );
  }
}
