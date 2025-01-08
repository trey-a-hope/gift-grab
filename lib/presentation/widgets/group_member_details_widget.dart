import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:nakama/nakama.dart';

class GroupMemberDetailsWidget extends StatelessWidget {
  final GroupUser groupUser;
  final bool isMe;
  final void Function()? kickUserAction;

  const GroupMemberDetailsWidget({
    required this.groupUser,
    required this.isMe,
    this.kickUserAction,
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
      title: Text(
        user.username ?? 'No Display Name',
        style: theme.textTheme.displayMedium,
      ),
      subtitle: Text(
        groupMembershipState.name,
        style: theme.textTheme.displaySmall,
      ),
      trailing: kickUserAction != null
          ? IconButton(
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
          : null,
    );
  }
}
