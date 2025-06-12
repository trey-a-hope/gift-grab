import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/presentation/blocs/friendship_state/bloc/friendship_state_bloc.dart';
import 'package:gift_grab/presentation/widgets/clickable_avatar.dart';
import 'package:nakama/nakama.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;

  const FriendListTile(this.friend, {super.key});

  @override
  Widget build(BuildContext context) {
    final friendshipStateBloc = context.read<FriendshipStateBloc>();

    final theme = Theme.of(context);

    final user = friend.user;
    final friendshipState = friendshipStateBloc.friendshipState;

    return ListTile(
      leading: AbsorbPointer(
        absorbing: friendshipState == FriendshipState.blocked,
        child: ClickableAvatar(
          user,
          onProfileReturnCallback: () {
            friendshipStateBloc.add(
              ListFriends(clearCursor: true),
            );
          },
        ),
      ),
      title: Text(
        user.username ?? 'Unknown Name',
        style: theme.textTheme.titleLarge,
      ),
      subtitle: Text(
        user.id,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
