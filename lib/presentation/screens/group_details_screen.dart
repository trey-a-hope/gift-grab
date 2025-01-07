import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/group/group_bloc.dart';
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
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  GroupUserBloc(accountBloc: context.read<AccountBloc>())
                    ..add(
                      LoadGroupUsersEvent(groupId: group.id),
                    ),
            ),
            BlocProvider(
              create: (context) =>
                  GroupBloc(accountBloc: context.read<AccountBloc>())
                    ..add(
                      LoadGroupsEvent(),
                    ),
            )
          ],
          child: BlocConsumer<GroupUserBloc, GroupUserState>(
            listener: (context, state) {
              if (state is GroupUserEventSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                context.read<GroupUserBloc>().add(LoadGroupUsersEvent(
                      groupId: group.id,
                    ));
                if (state.goBack) {
                  context.goNamed(Globals.routes.groups);
                }
              }
            },
            builder: (context, state) => switch (state) {
              GroupUserLoading() =>
                Center(child: const CircularProgressIndicator()),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!state.users.any(
                            (groupUser) => groupUser.user.id == state.uid)) ...[
                          GGButtonWidget(
                            title: 'Join',
                            onPressed: () async {
                              final confirm =
                                  await ModalService.showConfirmation(
                                context: context,
                                title: 'Join Group?',
                                message: 'Are you sure?',
                              );

                              if (confirm == null || confirm == false) {
                                return;
                              }

                              if (!context.mounted) return;

                              context.read<GroupUserBloc>().add(
                                    JoinGroupEvent(
                                      groupId: group.id,
                                    ),
                                  );
                            },
                          ),
                        ],
                        if (_canLeave(users: state.users, uid: state.uid)) ...[
                          GGButtonWidget(
                            title: 'Leave',
                            onPressed: () async {
                              final confirm =
                                  await ModalService.showConfirmation(
                                context: context,
                                title: 'Leave Group?',
                                message: 'Are you sure?',
                              );

                              if (confirm == null || confirm == false) {
                                return;
                              }

                              if (!context.mounted) return;

                              context.read<GroupUserBloc>().add(
                                    LeaveGroupEvent(
                                      groupId: group.id,
                                    ),
                                  );
                            },
                          ),
                        ],
                        if (_canDelete(users: state.users, uid: state.uid)) ...[
                          GGButtonWidget(
                            title: 'Delete',
                            onPressed: () async {
                              final confirm =
                                  await ModalService.showConfirmation(
                                context: context,
                                title: 'Delete Group?',
                                message: 'Are you sure?',
                              );

                              if (confirm == null || confirm == false) {
                                return;
                              }

                              if (!context.mounted) return;

                              context.read<GroupUserBloc>().add(
                                    DeleteGroupEvent(
                                      groupId: group.id,
                                    ),
                                  );
                            },
                          ),
                        ],
                        GGButtonWidget(
                          title: 'Back',
                          onPressed: () =>
                              context.goNamed(Globals.routes.groups),
                        ),
                      ],
                    )
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

  bool _canDelete({required List<GroupUser> users, required String uid}) {
    final me = users.where((item) => item.user.id == uid).firstOrNull;
    if (me == null) return false;
    return me.state == GroupMembershipState.superadmin;
  }

  bool _canLeave({required List<GroupUser> users, required String uid}) {
    final me = users.where((item) => item.user.id == uid).firstOrNull;
    if (me == null) return false;
    return me.state != GroupMembershipState.superadmin;
  }
}
