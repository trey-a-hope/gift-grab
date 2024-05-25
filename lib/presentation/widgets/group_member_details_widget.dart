import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';

class GroupMemberDetailsWidget extends StatelessWidget {
  final GroupUser groupUser;

  const GroupMemberDetailsWidget({
    required this.groupUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final user = groupUser.user;

    return Text(
      user.username ?? 'No Display Name',
      style: theme.textTheme.headlineLarge,
    );
  }
}
