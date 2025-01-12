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

    final username = user.username ?? 'No Display Name';

    return ListTile(
      leading: _buildAvatar(user, isMe),
      title: Row(
        children: [
          Text(
            user.username ?? 'No Display Name',
            style: theme.textTheme.displayLarge,
          ),
          Spacer(),
          if (kickUserAction != null)
            _buildActionButton(
              icon: Icons.logout,
              action: 'Kick',
              onAction: kickUserAction!,
              context: context,
              username: username,
            ),
          if (banUserAction != null)
            _buildActionButton(
              icon: Icons.cancel,
              action: 'Ban',
              onAction: banUserAction!,
              context: context,
              username: username,
            ),
          if (promoteUserAction != null)
            _buildActionButton(
              icon: Icons.arrow_upward_sharp,
              action: 'Promote',
              onAction: promoteUserAction!,
              context: context,
              username: username,
            ),
          if (demoteUserAction != null)
            _buildActionButton(
              icon: Icons.arrow_downward_sharp,
              action: 'Demote',
              onAction: demoteUserAction!,
              context: context,
              username: username,
            ),
          if (acceptUserAction != null)
            _buildActionButton(
              icon: Icons.check,
              action: 'Accept',
              onAction: acceptUserAction!,
              context: context,
              username: username,
            ),
        ],
      ),
      subtitle: Text(
        switch (groupMembershipState) {
          GroupMembershipState.superadmin => 'Super Admin',
          GroupMembershipState.admin => 'Admin',
          GroupMembershipState.member => 'Member',
          GroupMembershipState.joinRequest => 'Waiting Approval...',
        },
        style: theme.textTheme.headlineMedium,
      ),
    );
  }

  Future<bool> _showConfirmationDialog(
    BuildContext context,
    String username,
    String action,
  ) async {
    final confirm = await ModalService.showConfirmation(
      context: context,
      title: '$action $username in group?',
      message: 'Are you sure?',
    );
    return confirm ?? false;
  }

  Widget _buildActionButton({
    required IconData icon,
    required String action,
    required VoidCallback onAction,
    required BuildContext context,
    required String username,
  }) {
    return IconButton.filled(
      color: Colors.black,
      onPressed: () async {
        if (await _showConfirmationDialog(context, username, action)) {
          if (context.mounted) onAction();
        }
      },
      icon: Icon(icon),
    );
  }

  Widget _buildAvatar(User user, bool isMe) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.purple,
          width: isMe ? 3.0 : 0.0,
        ),
      ),
      child: CircleAvatar(
        backgroundImage: Image.network(
          user.avatarUrl?.isEmpty ?? true
              ? Globals.emptyProfile
              : user.avatarUrl!,
        ).image,
      ),
    );
  }
}
