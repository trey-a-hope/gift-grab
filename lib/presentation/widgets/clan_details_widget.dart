import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:nakama/nakama.dart';

class ClanDetailsWidget extends ConsumerWidget {
  final Group group;
  final String currentUserId;

  const ClanDetailsWidget({
    required this.group,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        group.name ?? 'No Name',
        style: theme.textTheme.displayMedium,
      ),
      subtitle: Text(
        '"${group.description ?? 'No Description'}"',
        style: theme.textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
      ),
      trailing: group.creatorId == currentUserId
          ? IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () =>
                  ref.read(Providers.nakamaGroupsProvider.notifier).deleteGroup(
                        group: group,
                      ),
            )
          : null,
    );
  }
}
