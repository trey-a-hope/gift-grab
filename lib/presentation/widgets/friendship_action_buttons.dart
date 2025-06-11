import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/blocs/friends/bloc/friends_bloc.dart';
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

    final friendsBloc = context.read<FriendsBloc>();
    final friendshipStateBloc = context.read<FriendshipStateBloc>();

    switch (friendshipState) {
      case FriendshipState.mutual:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                title: 'Remove ${user.username ?? 'Unknown Name'} from friends',
                action: () => friendsBloc.add(DeleteFriend(user.id)),
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
                title: 'Accept request from ${user.username ?? 'Unknown Name'}',
                action: () => friendsBloc.add(AddFriend(user.id)),
              ),
              child: const Text('Accept'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                title: 'Reject request from ${user.username ?? 'Unknown Name'}',
                action: () => friendsBloc.add(DeleteFriend(user.id)),
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () => _buttonAction(context,
              title: 'Cancel request for ${user.username ?? 'Unknown Name'}',
              action: () => friendshipStateBloc.add(CancelRequest(user.id))),
          child: const Text('Cancel'),
        );
      case FriendshipState.blocked:
        return ElevatedButton(
          onPressed: () => _buttonAction(
            context,
            title:
                'Unblock ${user.username ?? 'Unknown Name'} (you will need to send a new request)',
            action: () => friendsBloc.add(DeleteFriend(user.id)),
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
