import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class GroupDetailsListTile extends StatelessWidget {
  final Group group;
  final bool isOwner;

  const GroupDetailsListTile({
    required this.group,
    required this.isOwner,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(
              '${group.edgeCount}/${group.maxCount}',
            ),
          ),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name ?? 'No Name',
                style: theme.textTheme.displayMedium,
              ),
              Text(
                '(${group.open != null && group.open! ? 'Public' : 'Private'} Group)',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          const Gap(16),
          InkWell(
            onTap: () => context.pushNamed(
              Globals.routes.groupDetails,
              pathParameters: {'groupId': group.id},
              extra: group,
            ),
            child: Card(
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Text(
                  'View',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          if (isOwner) ...[
            InkWell(
              onTap: () => context.pushNamed(
                Globals.routes.editGroup,
                pathParameters: {'groupId': group.id},
                extra: group,
              ),
              child: Card(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Text(
                    'Edit',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
