import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/friends/friends_bloc.dart';
import 'package:gift_grab/presentation/widgets/friend_list_tile.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:nakama/nakama.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GGScaffoldWidget(
      title: 'Friends',
      child: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              TabBar(
                padding: EdgeInsets.all(8),
                labelColor: Colors.white,
                labelStyle: theme.textTheme.displaySmall,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Friends'),
                  Tab(text: 'Invites'),
                  Tab(text: 'Requests'),
                  Tab(text: 'Blocked'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _FriendsTab(friendshipState: FriendshipState.mutual),
                    _FriendsTab(
                        friendshipState: FriendshipState.incomingRequest),
                    _FriendsTab(
                        friendshipState: FriendshipState.outgoingRequest),
                    _FriendsTab(friendshipState: FriendshipState.blocked),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FriendsTab extends SmartBloc<FriendsBloc, FriendsState> {
  final FriendshipState friendshipState;

  const _FriendsTab({
    required this.friendshipState,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as FriendsLoaded;
    final friends = state.friends;

    return Column(
      children: [
        Expanded(
          child: friends.isEmpty
              ? _buildNoResults(friendshipState)
              : ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (c, i) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: FriendListTile(friends[i])),
                        _buildActionButtons(context, friends[i]),
                      ],
                    ),
                  ),
                ),
        ),
        if (state.cursor != null) ...[
          ElevatedButton(
            child: const Text('Fetch More Friends'),
            onPressed: () => context.read<FriendsBloc>().add(
                  FetchMoreFriends(),
                ),
          )
        ]
      ],
    );
  }

  void _buttonAction(
    BuildContext context,
    String title,
    void Function() action,
  ) async {
    final confirm = await ModalService.showConfirmation(
      context: context,
      title: title,
      message: 'Are you sure?',
    );

    if (confirm == null || confirm == false) {
      return;
    }

    if (!context.mounted) return;

    action();
  }

  Widget _buildNoResults(FriendshipState state) => switch (friendshipState) {
        FriendshipState.mutual => NoResultsWidget(NoResultsEnum.friends),
        FriendshipState.outgoingRequest =>
          NoResultsWidget(NoResultsEnum.requests),
        FriendshipState.incomingRequest =>
          NoResultsWidget(NoResultsEnum.invites),
        FriendshipState.blocked => NoResultsWidget(NoResultsEnum.blocks),
      };

  Widget _buildActionButtons(BuildContext context, Friend friend) {
    final user = friend.user;

    switch (friendshipState) {
      case FriendshipState.mutual:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                'Block ${user.username ?? 'Unknown Name'}',
                () => context.read<FriendsBloc>().add(
                      BlockFriend(uid: user.id),
                    ),
              ),
              child: const Text('Block'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                'Remove ${user.username ?? 'Unknown Name'} from friends',
                () => context.read<FriendsBloc>().add(
                      DeleteFriend(uid: user.id),
                    ),
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
                'Accept request from ${user.username ?? 'Unknown Name'}',
                () => context.read<FriendsBloc>().add(
                      AddFriend(uid: user.id),
                    ),
              ),
              child: const Text('Accept'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () => _buttonAction(
                context,
                'Reject request from ${user.username ?? 'Unknown Name'}',
                () => context.read<FriendsBloc>().add(
                      DeleteFriend(uid: user.id),
                    ),
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () => _buttonAction(
            context,
            'Cancel request for ${user.username ?? 'Unknown Name'}',
            () => context.read<FriendsBloc>().add(
                  DeleteFriend(uid: user.id),
                ),
          ),
          child: const Text('Cancel'),
        );
      case FriendshipState.blocked:
        return ElevatedButton(
          onPressed: () => _buttonAction(
            context,
            'Unblock ${user.username ?? 'Unknown Name'} (you will need to send a new request)',
            () => context.read<FriendsBloc>().add(
                  DeleteFriend(uid: user.id),
                ),
          ),
          child: const Text('Unblock'),
        );
    }
  }

  @override
  void onAfterMessage(BuildContext context) => context.read<FriendsBloc>().add(
        FetchFriends(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc(
        authBloc: context.read<AuthBloc>(),
        friendshipState: friendshipState,
      )..add(FetchFriends()),
      child: BlocConsumer<FriendsBloc, FriendsState>(
        listener: listener,
        builder: builder,
      ),
    );
  }
}
