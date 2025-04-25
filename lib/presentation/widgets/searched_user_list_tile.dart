import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/widgets/clickable_avatar.dart';
import 'package:nakama/nakama.dart';

class SearchedUserListTile extends StatelessWidget {
  final User user;

  const SearchedUserListTile(
    this.user, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClickableAvatar(user),
      title: Text(user.username ?? 'No Name'),
    );
  }
}
