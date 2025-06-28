import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/groups_list/groups_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';
import 'package:go_router/go_router.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  static const _tabs = [
    Tab(text: 'All'),
    Tab(text: 'Me'),
  ];

  late GroupsListBloc allGroupsListBloc;
  late GroupsListBloc myGroupsListBloc;

  @override
  void initState() {
    super.initState();

    allGroupsListBloc = GroupsListBloc(
      context.read<SessionService>(),
      all: true,
    )..add(ListGroups(clearCursor: true));

    myGroupsListBloc = GroupsListBloc(
      context.read<SessionService>(),
      all: false,
    )..add(ListGroups(clearCursor: true));
  }

  @override
  void dispose() {
    allGroupsListBloc.close();
    myGroupsListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Groups',
      actions: [
        IconButton.filledTonal(
          onPressed: () async {
            allGroupsListBloc.add(ListGroups(clearCursor: true));
            myGroupsListBloc.add(ListGroups(clearCursor: true));
          },
          icon: const Icon(Icons.refresh),
        ),
        IconButton.filledTonal(
          onPressed: () async => await context.pushNamed<bool>(
            Globals.routes.createGroup,
          ),
          icon: const Icon(Icons.add),
        ),
      ],
      child: DefaultTabController(
        length: _tabs.length,
        child: Column(
          children: [
            TabBar(
              padding: const EdgeInsets.all(8),
              labelColor: Colors.white,
              labelStyle: theme.textTheme.displaySmall,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: _tabs,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BlocProvider<GroupsListBloc>.value(
                    value: allGroupsListBloc,
                    child: const GroupsListPage(),
                  ),
                  BlocProvider<GroupsListBloc>.value(
                    value: myGroupsListBloc,
                    child: const GroupsListPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
