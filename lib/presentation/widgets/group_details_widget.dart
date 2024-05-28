import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class GroupDetailsWidget extends ConsumerWidget {
  final Group group;
  final bool isOwner;

  const GroupDetailsWidget({
    required this.group,
    required this.isOwner,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.goNamed(
        Globals.routes.groupDetails,
        pathParameters: {
          'group': jsonEncode(group),
        },
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
      trailing: isOwner
          ? IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () =>
                  ref.read(Providers.nakamaGroupsProvider.notifier).deleteGroup(
                        group: group,
                      ),
            )
          : IconButton(
              icon: const Icon(
                Icons.group,
                color: Colors.white,
              ),
              onPressed: () =>
                  ref.read(Providers.nakamaGroupsProvider.notifier).joinGroup(
                        group: group,
                      ),
            ),
    );
  }
}
