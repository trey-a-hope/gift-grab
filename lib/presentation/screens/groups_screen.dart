import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/widgets/group_details_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    context.read<AllGroupsBloc>().add(FetchGroups());
    context.read<MyGroupsBloc>().add(FetchGroups());

    return GGScaffoldWidget(
      title: 'Groups',
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                padding: EdgeInsets.all(8),
                labelColor: Colors.white,
                labelStyle: theme.textTheme.displaySmall,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'All Groups'),
                  Tab(text: 'My Groups'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _AllGroupsTab(),
                    _MyGroupsTab(),
                  ],
                ),
              ),
              const Gap(16),
              ElevatedButton(
                child: Text('Create Group'),
                onPressed: () => context.goNamed(
                  Globals.routes.createGroup,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllGroupsTab extends SmartBloc<AllGroupsBloc, GroupsState> {
  const _AllGroupsTab();

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as GroupsLoaded;
    final groups = state.groups;

    return Column(
      children: [
        Expanded(
          child: groups.isEmpty
              ? NoResultsWidget(NoResultsEnum.allGroups)
              : ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GroupDetailsWidget(
                    group: groups[index],
                    isOwner: false,
                  ),
                ),
        ),
        if (state.cursor != null) ...[
          ElevatedButton(
            child: const Text('Fetch More Groups'),
            onPressed: () => context.read<GroupsBloc>().add(
                  FetchMoreGroups(groups: groups),
                ),
          )
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllGroupsBloc, GroupsState>(
      listener: listener,
      builder: builder,
    );
  }
}

class _MyGroupsTab extends SmartBloc<MyGroupsBloc, GroupsState> {
  const _MyGroupsTab();

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as GroupsLoaded;
    final groups = state.groups;

    return Column(
      children: [
        Expanded(
          child: groups.isEmpty
              ? NoResultsWidget(NoResultsEnum.myGroups)
              : ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GroupDetailsWidget(
                    group: groups[index],
                    isOwner: false,
                  ),
                ),
        ),
        if (state.cursor != null) ...[
          ElevatedButton(
            child: const Text('Fetch More Groups'),
            onPressed: () => context.read<MyGroupsBloc>().add(
                  FetchMoreGroups(groups: groups),
                ),
          )
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyGroupsBloc, GroupsState>(
      listener: listener,
      builder: builder,
    );
  }
}
