import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/blocs/friendship_group/view/friendship_group_page.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';
import 'package:nakama/nakama.dart';

class FriendsPage extends StatelessWidget {
  static const _tabs = [
    Tab(text: 'Friends'),
    Tab(text: 'Invites'),
    Tab(text: 'Requests'),
    Tab(text: 'Blocked'),
  ];

  static const List<Widget> _tabsContent = [
    FriendshipGroupPage(FriendshipState.mutual),
    FriendshipGroupPage(FriendshipState.incomingRequest),
    FriendshipGroupPage(FriendshipState.outgoingRequest),
    FriendshipGroupPage(FriendshipState.blocked),
  ];

  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Friends',
      child: DefaultTabController(
        length: _tabs.length,
        child: Column(
          children: [
            TabBar(
              padding: EdgeInsets.all(8),
              labelColor: Colors.white,
              labelStyle: theme.textTheme.displaySmall,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: _tabs,
            ),
            Expanded(child: TabBarView(children: _tabsContent)),
          ],
        ),
      ),
    );
  }
}
