import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/group/group_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/group_details_list_widget.dart';
import 'package:go_router/go_router.dart';

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
      length: 5,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      child: SafeArea(
        child: BlocProvider(
          create: (context) => GroupBloc(
            accountBloc: context.read<AccountBloc>(),
          )..add(LoadGroupsEvent()),
          child: BlocConsumer<GroupBloc, GroupState>(
            listener: (context, state) {
              if (state is GroupEventSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                context.read<GroupBloc>().add(LoadGroupsEvent());
              }
            },
            builder: (context, state) => switch (state) {
              GroupLoading() =>
                Center(child: const CircularProgressIndicator()),
              GroupsLoaded() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TabBar(
                        labelColor: Colors.white,
                        labelStyle: theme.textTheme.displayLarge,
                        indicatorColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        controller: _tabController,
                        tabs: const [
                          Text('All'),
                          Text('Admin'),
                          Text('Super Admin'),
                          Text('Member'),
                          Text('Join Request')
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            GroupDetailsListWidget(
                              groups: state.entry.allGroups,
                              currentUid: state.uid,
                            ),
                            GroupDetailsListWidget(
                              groups: state.entry.adminGroups,
                              currentUid: state.uid,
                            ),
                            GroupDetailsListWidget(
                              groups: state.entry.superAdminGroups,
                              currentUid: state.uid,
                            ),
                            GroupDetailsListWidget(
                              groups: state.entry.memberGroups,
                              currentUid: state.uid,
                            ),
                            GroupDetailsListWidget(
                              groups: state.entry.joinRequestGroups,
                              currentUid: state.uid,
                            )
                          ],
                        ),
                      ),
                      const Gap(16),
                      GGButtonWidget(
                        title: 'Create Group',
                        onPressed: () =>
                            context.goNamed(Globals.routes.createGroup),
                      ),
                      const Gap(16),
                      GGButtonWidget(
                        title: 'Back',
                        onPressed: () => context.goNamed(Globals.routes.main),
                      ),
                    ],
                  ),
                ),
              GroupError() => Text(state.message),
              _ => Text('Unknown State')
            },
          ),
        ),
      ),
    );
  }
}
