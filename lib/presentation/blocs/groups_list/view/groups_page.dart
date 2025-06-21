import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/blocs/groups_list/groups_list.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  static const _tabs = [
    Tab(text: 'All Groups'),
    Tab(text: 'My Groups'),
  ];

  late GroupsListBloc allGroupsListBloc;
  late GroupsListBloc myGroupsListBloc;

  @override
  void initState() {
    final authBloc = context.read<AuthBloc>();

    allGroupsListBloc = GroupsListBloc(
      authBloc,
      all: true,
    )..add(ListGroups(clearCursor: true));

    myGroupsListBloc = GroupsListBloc(
      authBloc,
      all: false,
    )..add(ListGroups(clearCursor: true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Groups',
      actions: [
        IconButton.filledTonal(
          onPressed: () async {
            final success = await context.pushNamed<bool>(
              Globals.routes.createGroup,
            );
            if (success == true) {
              allGroupsListBloc.add(ListGroups(clearCursor: true));
              myGroupsListBloc.add(ListGroups(clearCursor: true));
            }
          },
          icon: const Icon(Icons.add),
        ),
      ],
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
            Expanded(
              child: TabBarView(
                children: [
                  BlocProvider<GroupsListBloc>.value(
                    value: allGroupsListBloc,
                    child: GroupsListPage(),
                  ),
                  BlocProvider<GroupsListBloc>.value(
                    value: myGroupsListBloc,
                    child: GroupsListPage(),
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
