import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/widgets/paginated_all_groups.dart';
import 'package:gift_grab/presentation/widgets/paginated_user_groups.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/stateful_bloc.dart';
import 'package:go_router/go_router.dart';

class GroupsScreen extends StatefulBloc<GroupsBloc, GroupsState> {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState
    extends StatefulBlocState<GroupsScreen, GroupsBloc, GroupsState>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) =>
      throw UnimplementedError();

  @override
  bool shouldShowMessage(GroupsState state) => state is GroupsError;

  @override
  void onAfterMessage(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Groups',
      goBack: () => context.goNamed(Globals.routes.main),
      child: BlocListener<GroupsBloc, GroupsState>(
        listener: listener,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                padding: EdgeInsets.all(16),
                labelColor: Colors.white,
                labelStyle: theme.textTheme.displayLarge,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                controller: _tabController,
                tabs: const [
                  Text('All Groups'),
                  Text('My Groups'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PaginatedAllGroups(),
                    PaginatedUserGroups(),
                  ],
                ),
              ),
              const Gap(16),
              ElevatedButton(
                child: Text('Create Group'),
                onPressed: () => context.goNamed(Globals.routes.createGroup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
