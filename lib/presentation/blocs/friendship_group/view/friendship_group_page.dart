import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/friends/bloc/friends_bloc.dart';
import 'package:gift_grab/presentation/widgets/friends_list_tile.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:nakama/nakama.dart';

import '../friendship_group.dart';

class FriendshipGroupPage extends StatelessWidget {
  final FriendshipState friendshipState;

  const FriendshipGroupPage(this.friendshipState, {super.key});

  @override
  Widget build(BuildContext context) {
    final friendsBloc = context.read<FriendsBloc>();

    return BlocProvider(
      create: (_) => FriendshipGroupBloc(
        friendsBloc,
        friendshipState,
        context.read<SessionService>(),
      ),
      child: const FriendshipGroupView(),
    );
  }
}

class FriendshipGroupView extends StatelessWidget {
  const FriendshipGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendshipGroupBloc, FriendshipGroupState>(
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
        // final cursor = state.cursor;

        return Column(
          children: [
            Expanded(
              child: friends.isEmpty
                  ? switch (friendshipState) {
                      FriendshipState.mutual => NoResultsWidget(
                          NoResultsEnum.mutual,
                        ),
                      FriendshipState.outgoingRequest => NoResultsWidget(
                          NoResultsEnum.outgoingRequest,
                        ),
                      FriendshipState.incomingRequest => NoResultsWidget(
                          NoResultsEnum.incomingRequest,
                        ),
                      FriendshipState.blocked => NoResultsWidget(
                          NoResultsEnum.blocked,
                        ),
                    }
                  : ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: FriendListTile(friends[index]),
                      ),
                    ),
            )
          ],
        );
      },
    );
  }
}
