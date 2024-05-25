import 'package:flutter/material.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:nakama/nakama.dart';
import 'package:toastification/toastification.dart';

class ClanDetailsWidget extends StatelessWidget {
  final Group group;
  final String currentUserId;

  const ClanDetailsWidget({
    required this.group,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => ModalService.showToast(
                title: 'TODO: Delete group "${group.name}"...',
                toastificationType: ToastificationType.error,
                icon: const Icon(Icons.error),
                primaryColor: Colors.red,
              ),
            )
          : null,
    );
  }
}
