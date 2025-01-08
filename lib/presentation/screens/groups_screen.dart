import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/group_all/group_all_bloc.dart';
import 'package:gift_grab/domain/blocs/group_all/group_all_list_view.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

import '../../domain/blocs/group_all/group_all_event.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Groups',
      goBack: () => context.goNamed(Globals.routes.main),
      child: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<GroupAllBloc>(
                create: (context) => GroupAllBloc()..add(FetchGroups())),
          ],
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
                  Text('All'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    GroupAllListView(),
                  ],
                ),
              ),
              const Gap(16),
              GGButtonWidget(
                title: 'Create Group',
                onPressed: () => context.goNamed(Globals.routes.createGroup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
