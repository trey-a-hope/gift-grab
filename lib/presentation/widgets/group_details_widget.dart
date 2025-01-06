import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/group/group_bloc.dart';
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

    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group deleted successfully')),
          );
          context.goNamed(Globals.routes.groups);
        }
      },
      child: ListTile(
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
                onPressed: () => context.read<GroupBloc>().add(
                      DeleteGroupEvent(
                        groupId: group.id,
                      ),
                    ),
              )
            : IconButton(
                icon: const Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                onPressed: () {}
                // ref.read(Providers.nakamaGroupsProvider.notifier).joinGroup(
                //       group: group,
                //     ),
                ),
      ),
    );
  }
}
