import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      title: group.name ?? 'Unknown Name',
      goBack: () => context.goNamed(Globals.routes.groups),
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

              if (state is GroupUsersError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) => switch (state) {
              GroupUserLoading() =>
                Center(child: const CircularProgressIndicator()),
              GroupUsersLoaded() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        group.description ?? 'No Description...',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
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
                        if (_canJoin(users: state.users, uid: state.uid)) ...[
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
                        if (_canEdit(users: state.users, uid: state.uid)) ...[
                          GGButtonWidget(
                            title: 'Edit',
                            onPressed: () => context.goNamed(
                              Globals.routes.editGroup,
                              pathParameters: {'groupId': group.id},
                              extra: group,
                            ),
                          ),
                        ],
                      ],
                    )
                  ],
                ),
              GroupUsersError() => Center(),
              _ => const SizedBox(),
            },
          ),
        ),
      ),
    );
  }

  // 0:Superadmin:There must at least be 1 superadmin in any group. The superadmin has all the privileges of the admin and can additionally delete the group and promote admin members.
  // 1:Admin:There can be one of more admins. Admins can update groups as well as accept, kick, promote, demote, ban or add members.
  // 2:Member:Regular group member. They cannot accept join requests from new users.
  // 3:Join request:A new join request from a new user. This does not count towards the maximum group member count.
  bool _canEdit({required List<GroupUser> users, required String uid}) {
    final me = users.where((item) => item.user.id == uid).firstOrNull;
    if (me == null) return false;
    return me.state == GroupMembershipState.superadmin ||
        me.state == GroupMembershipState.admin;
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

  bool _canJoin({required List<GroupUser> users, required String uid}) {
    if (group.maxCount == null) {
      throw Exception('Max count is null');
    }

    final notPresent = !users.any((groupUser) => groupUser.user.id == uid);
    final notFull = group.maxCount! > users.length;

    return notPresent && notFull;
  }
}
