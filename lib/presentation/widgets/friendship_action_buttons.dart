import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/blocs/friendship_state/bloc/friendship_state_bloc.dart';
import 'package:nakama/nakama.dart';

class FriendshipActionButtons extends StatelessWidget {
  final Friend friend;
  final FriendshipState friendshipState;

  const FriendshipActionButtons({
    super.key,
    required this.friend,
    required this.friendshipState,
  });

  @override
  Widget build(BuildContext context) {
    final user = friend.user;

    final friendshipStateBloc = context.read<FriendshipStateBloc>();

    switch (friendshipState) {
      case FriendshipState.mutual:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                title: 'Block ${user.username ?? 'Unknown Name'} from friends?',
                action: () => friendshipStateBloc.add(BlockFriend(user.id)),
              ),
              child: const Text('Block'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                title:
                    'Remove ${user.username ?? 'Unknown Name'} from friends?',
                action: () => friendshipStateBloc.add(DeleteFriend(user.id)),
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      case FriendshipState.incomingRequest:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                title:
                    'Accept request from ${user.username ?? 'Unknown Name'}?',
                action: () => friendshipStateBloc.add(
                  AcceptIncomingRequest(user.id),
                ),
              ),
              child: const Text('Accept'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                title:
                    'Reject request from ${user.username ?? 'Unknown Name'}?',
                action: () =>
                    friendshipStateBloc.add(RejectIncomingRequest(user.id)),
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () => _buttonAction(context,
              title: 'Cancel request for ${user.username ?? 'Unknown Name'}?',
              action: () =>
                  friendshipStateBloc.add(CancelOutgoingRequest(user.id))),
          child: const Text('Cancel'),
        );
      case FriendshipState.blocked:
        return ElevatedButton(
          onPressed: () => _buttonAction(
            context,
            title:
                'Unblock ${user.username ?? 'Unknown Name'} (you will need to send a new request)?',
            action: () => friendshipStateBloc.add(UnblockFriend(user.id)),
          ),
          child: const Text('Unblock'),
        );
    }
  }

  Future<void> _buttonAction(
    BuildContext context, {
    required String title,
    required VoidCallback action,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: Text(title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      action();
    }
  }
}
