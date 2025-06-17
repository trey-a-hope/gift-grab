import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/widgets/clickable_avatar.dart';
import 'package:nakama/nakama.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final VoidCallback? onProfileReturnCallback;

  const UserListTile(
    this.user, {
    this.onProfileReturnCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: ClickableAvatar(
        user,
        onProfileReturnCallback: onProfileReturnCallback,
      ),
      title: Text(
        user.username ?? 'No Name',
        style: theme.textTheme.headlineLarge,
      ),
    );
  }
}
