import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/friends.dart';
import 'package:gift_grab/presentation/widgets/friend_list_tile.dart';
import 'package:gift_grab/presentation/widgets/friendship_action_buttons.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:nakama/nakama.dart';

import '../friendship_state.dart';

class FriendshipStatePage extends StatelessWidget {
  final FriendshipState friendshipState;

  const FriendshipStatePage(this.friendshipState, {super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final friendsBloc = context.read<FriendsBloc>();

    return BlocProvider(
      create: (_) => FriendshipStateBloc(
        authBloc,
        friendsBloc,
        friendshipState,
      ),
      child: const FriendshipStateView(),
    );
  }
}

class FriendshipStateView extends StatelessWidget {
  const FriendshipStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendshipStateBloc, FriendshipStateState>(
      listener: (context, state) {
        if (state.success != null) {
          ModalService.showSuccess(title: state.success!);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final friendshipState = state.friendshipState;
        final friends = state.friends;
        final cursor = state.cursor;

        return Column(
          children: [
            Expanded(
              child: friends.isEmpty
                  ? switch (friendshipState) {
                      FriendshipState.mutual =>
                        NoResultsWidget(NoResultsEnum.friends),
                      FriendshipState.outgoingRequest =>
                        NoResultsWidget(NoResultsEnum.requests),
                      FriendshipState.incomingRequest =>
                        NoResultsWidget(NoResultsEnum.invites),
                      FriendshipState.blocked =>
                        NoResultsWidget(NoResultsEnum.blocks),
                    }
                  : ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (c, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: FriendListTile(friends[i]),
                            ),
                            FriendshipActionButtons(
                              friend: friends[i],
                              friendshipState: friendshipState,
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            if (cursor != null) ...[
              ElevatedButton(
                child: const Text('Fetch More Friends'),
                onPressed: () => context.read<FriendshipStateBloc>().add(
                      ListFriends(clearCursor: false),
                    ),
              )
            ]
          ],
        );
      },
    );
  }
}
