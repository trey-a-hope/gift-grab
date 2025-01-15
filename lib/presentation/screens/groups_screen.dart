import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/paginated_all_groups.dart';
import 'package:gift_grab/presentation/widgets/paginated_user_groups.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class GroupsScreen extends SmartBloc<GroupsBloc, GroupsState> {
  const GroupsScreen({super.key});

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) =>
      throw UnimplementedError(); // Only need to listen for changes...

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Groups',
      goBack: () => context.goNamed(Globals.routes.main),
      child: BlocListener<GroupsBloc, GroupsState>(
        listenWhen: (previous, current) => context.listenWhen('groups'),
        listener: listener,
        child: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBar(
                  padding: EdgeInsets.all(16),
                  labelColor: Colors.white,
                  labelStyle: theme.textTheme.displayLarge,
                  indicatorColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Text('All Groups'),
                    Text('My Groups'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
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
      ),
    );
  }
}
