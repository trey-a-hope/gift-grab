import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/group_user/group_user_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/group_member_details_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

import '../widgets/gg_scaffold_widget.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  const GroupDetailsScreen({
    required this.group,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      child: SafeArea(
        child: BlocProvider(
          create: (context) => GroupUserBloc()
            ..add(
              LoadGroupUsersEvent(groupId: group.id),
            ),
          child: BlocBuilder<GroupUserBloc, GroupUserState>(
            builder: (context, state) => switch (state) {
              GroupUserLoading() => const CircularProgressIndicator(),
              GroupUsersLoaded() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      group.name ?? 'No Name...',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Gap(16),
                    Text(
                      group.description ?? 'No Description...',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Expanded(
                      child: state.users.isEmpty
                          ? const Center(
                              child: Text('No Members'),
                            )
                          : ListView.builder(
                              itemCount: state.users.length,
                              itemBuilder: (c, i) => GroupMemberDetailsWidget(
                                groupUser: state.users[i],
                              ),
                            ),
                    ),
                    GGButtonWidget(
                      title: 'Back',
                      onPressed: () => context.goNamed(Globals.routes.groups),
                    ),
                  ],
                ),
              GroupUsersError() => const Text('ERROR'),
              _ => const SizedBox(),
            },
          ),
        ),
      ),
    );
  }
}
