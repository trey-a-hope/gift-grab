import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class GroupDetailsWidget extends StatelessWidget {
  final Group group;
  final bool isOwner;

  const GroupDetailsWidget({
    required this.group,
    required this.isOwner,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.goNamed(
        Globals.routes.groupDetails,
        pathParameters: {'groupId': group.id},
        extra: group,
      ),
      leading: CircleAvatar(
        child: Text(
          '${group.edgeCount}/${group.maxCount}',
        ),
      ),
      title: Text(
        group.name ?? 'No Name',
        style: theme.textTheme.displayMedium,
      ),
      subtitle: Text(
        '(${group.open != null && group.open! ? 'Public' : 'Private'} Group)',
        style: theme.textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
