import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/blocs/friendship_state/view/friendship_state_page.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:nakama/nakama.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

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
                  FriendshipStatePage(FriendshipState.mutual),
                  FriendshipStatePage(FriendshipState.incomingRequest),
                  FriendshipStatePage(FriendshipState.outgoingRequest),
                  FriendshipStatePage(FriendshipState.blocked),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
