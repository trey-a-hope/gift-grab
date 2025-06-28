import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/blocs/friendship_group/friendship_group.dart';
import 'package:gift_grab/presentation/widgets/user_list_tile.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';
import 'package:nakama/nakama.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;

  const FriendListTile(this.friend, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Row(
        children: [
          Expanded(
            child: UserListTile(
              friend.user,
              onProfileReturnCallback: () {
                context.read<FriendshipGroupBloc>().add(
                      ListFriends(clearCursor: true),
                    );
              },
            ),
          ),
          _FriendshipActionButtons(friend: friend)
        ],
      ),
    );
  }
}

class _FriendshipActionButtons extends StatelessWidget {
  final Friend friend;

  const _FriendshipActionButtons({required this.friend});

  @override
  Widget build(BuildContext context) {
    final friendshipGroupBloc = context.read<FriendshipGroupBloc>();

    final user = friend.user;

    switch (friend.state) {
      case FriendshipState.mutual:
        return ElevatedButton(
          onPressed: () async {
            final confirm = await ModalUtil.showConfirmation(
              context,
              title: 'Delete friend ${user.username}',
              message: 'Are you sure?',
            );

            if (confirm == null || confirm == false) return;

            friendshipGroupBloc.add(DeleteFriend(user.id));
          },
          child: Text('Delete'),
        );
      case FriendshipState.incomingRequest:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final confirm = await ModalUtil.showConfirmation(
                  context,
                  title: 'Accept request from ${user.username}',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) return;

                friendshipGroupBloc.add(AcceptIncomingRequest(user.id));
              },
              child: Text('Accept Request'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () async {
                final confirm = await ModalUtil.showConfirmation(
                  context,
                  title: 'Reject invite from ${user.username}',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) return;

                friendshipGroupBloc.add(RejectIncomingRequest(user.id));
              },
              child: Text('Reject Request'),
            ),
          ],
        );
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () async {
            final confirm = await ModalUtil.showConfirmation(
              context,
              title: 'Cancel request from ${user.username}',
              message: 'Are you sure?',
            );

            if (confirm == null || confirm == false) return;

            friendshipGroupBloc.add(CancelOutgoingRequest(user.id));
          },
          child: Text('Cancel Request'),
        );
      case FriendshipState.blocked:
        return SizedBox.shrink();
    }
  }
}
