import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/group_details_list_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

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

    final session = ref.read(Providers.nakamaSessionDataProvider);
    if (!session.hasValue) {
      return const CircularProgressIndicator();
    }

    final groups = ref.watch(Providers.nakamaGroupsProvider);
    final myUserGroups = ref.watch(
      Providers.nakamaUserGroupsProvider(session.value!.uid),
    );

    String? currentUid = session.value?.uid;

    return GGScaffoldWidget(
      child: Center(
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
                Text('All Groups'),
                Text('My Groups'),
              ],
            ),
            if (currentUid != null) ...[
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    groups.when(
                      data: (list) => GroupDetailsListWidget(
                        groups: list,
                        currentUid: currentUid,
                      ),
                      error: (err, stack) => Text(
                        err.toString(),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    myUserGroups.when(
                      data: (myUserGroups) {
                        final myGroups = myUserGroups
                            .map((myUserGroup) => myUserGroup.group)
                            .toList();
                        return GroupDetailsListWidget(
                          groups: myGroups,
                          currentUid: currentUid,
                        );
                      },
                      error: (err, stack) => Text(
                        err.toString(),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Gap(20),
            GGButtonWidget(
              title: 'Create Group',
              onPressed: () => context.goNamed(
                Globals.routes.createGroup,
              ),
            ),
            const Gap(20),
            GGButtonWidget(
              title: 'Back',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
