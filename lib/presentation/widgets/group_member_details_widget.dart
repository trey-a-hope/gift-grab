import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:nakama/nakama.dart';

class GroupMemberDetailsWidget extends StatelessWidget {
  final GroupUser groupUser;
  final bool isMe;
  final void Function()? kickUserAction;
  final void Function()? banUserAction;
  final void Function()? promoteUserAction;
  final void Function()? demoteUserAction;
  final void Function()? acceptUserAction;

  const GroupMemberDetailsWidget({
    required this.groupUser,
    required this.isMe,
    this.kickUserAction,
    this.banUserAction,
    this.promoteUserAction,
    this.demoteUserAction,
    this.acceptUserAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final groupMembershipState = groupUser.state;

    final user = groupUser.user;

    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.purple,
            width: isMe ? 3.0 : 0.0,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: Image.network(
            user.avatarUrl == null || user.avatarUrl!.isEmpty
                ? Globals.emptyProfile
                : user.avatarUrl!,
          ).image,
        ),
      ),
      title: Row(
        children: [
          Text(
            user.username ?? 'No Display Name',
            style: theme.textTheme.displayMedium,
          ),
          Spacer(),
          // Kick user
          if (kickUserAction != null) ...[
            IconButton.filled(
              color: Colors.black,
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context: context,
                  title: 'Kick ${user.username} from group?',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                if (!context.mounted) return;

                kickUserAction!();
              },
              icon: Icon(
                Icons.logout,
              ),
            )
          ],
          // Ban user
          if (banUserAction != null) ...[
            IconButton.filled(
              color: Colors.black,
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context: context,
                  title: 'Ban ${user.username} from group?',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                if (!context.mounted) return;

                banUserAction!();
              },
              icon: Icon(
                Icons.cancel,
              ),
            )
          ],
          // Promote user
          if (promoteUserAction != null) ...[
            IconButton.filled(
              color: Colors.black,
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context: context,
                  title: 'Promote ${user.username} in group?',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                if (!context.mounted) return;

                promoteUserAction!();
              },
              icon: Icon(
                Icons.arrow_upward_sharp,
              ),
            )
          ],
          // Demote user
          if (demoteUserAction != null) ...[
            IconButton.filled(
              color: Colors.black,
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context: context,
                  title: 'Demote ${user.username} in group?',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                if (!context.mounted) return;

                demoteUserAction!();
              },
              icon: Icon(
                Icons.arrow_downward_sharp,
              ),
            )
          ],
          // Accept user
          if (acceptUserAction != null) ...[
            IconButton.filled(
              color: Colors.black,
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context: context,
                  title: 'Accept ${user.username} into group?',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                if (!context.mounted) return;

                acceptUserAction!();
              },
              icon: Icon(
                Icons.check,
              ),
            )
          ],
        ],
      ),
      subtitle: Text(
        groupMembershipState.name,
        style: theme.textTheme.displaySmall,
      ),
    );
  }
}
