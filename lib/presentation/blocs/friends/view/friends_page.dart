import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/bloc/friends_bloc.dart';
import 'package:gift_grab/presentation/widgets/friend_list_tile.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:nakama/nakama.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GGScaffoldWidget(
      title: 'Friends',
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              padding: const EdgeInsets.all(8),
              labelColor: Colors.white,
              labelStyle: theme.textTheme.displaySmall,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
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
                  _FriendsTab(friendshipState: FriendshipState.incomingRequest),
                  _FriendsTab(friendshipState: FriendshipState.outgoingRequest),
                  _FriendsTab(friendshipState: FriendshipState.blocked),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendsTab extends StatelessWidget {
  final FriendshipState friendshipState;

  const _FriendsTab({
    required this.friendshipState,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc(
        context.read<AuthBloc>(),
        friendshipState: friendshipState,
      )..add(FetchFriends()),
      child: BlocBuilder<FriendsBloc, FriendsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

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
                const Gap(16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<FriendsBloc>().add(FetchFriends()),
                  child: const Text('Load More'),
                ),
                const Gap(16),
              ]
            ],
          );
        },
      ),
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
        FriendshipState.mutual => const NoResultsWidget(NoResultsEnum.friends),
        FriendshipState.outgoingRequest =>
          const NoResultsWidget(NoResultsEnum.requests),
        FriendshipState.incomingRequest =>
          const NoResultsWidget(NoResultsEnum.invites),
        FriendshipState.blocked => const NoResultsWidget(NoResultsEnum.blocks),
      };

  Widget _buildActionButtons(BuildContext context, Friend friend) {
    final user = friend.user;

    switch (friendshipState) {
      case FriendshipState.mutual:
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
              onPressed: () {},
              child: const Text('Reject'),
            ),
          ],
        );
      case FriendshipState.outgoingRequest:
        return ElevatedButton(
          onPressed: () {},
          child: const Text('Cancel'),
        );
      case FriendshipState.blocked:
        return ElevatedButton(
          onPressed: () {},
          child: const Text('Unblock'),
        );
    }
  }
}
