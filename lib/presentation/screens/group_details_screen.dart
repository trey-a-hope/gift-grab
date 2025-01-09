import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/mixins/group_persmissions.dart';
import 'package:gift_grab/domain/blocs/group/user_groups/user_groups_bloc.dart'
    as ugb;
import 'package:gift_grab/domain/blocs/group/all_groups/all_groups_bloc.dart'
    as agb;
import 'package:gift_grab/domain/blocs/group/group_users/group_users_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/group_member_details_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';
import '../widgets/gg_scaffold_widget.dart';

// https://heroiclabs.com/docs/nakama/concepts/groups/

class GroupDetailsScreen extends StatelessWidget with GroupPermissions {
  final Group group;

  const GroupDetailsScreen({
    required this.group,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<GroupUsersBloc>().add(FetchGroupUsers(groupId: group.id));

    return GGScaffoldWidget(
      title: group.name ?? 'Unknown Name',
      goBack: () => context.goNamed(Globals.routes.groups),
      child: SafeArea(
        child: BlocConsumer<GroupUsersBloc, GroupUsersState>(
          listener: (context, state) {
            if (state is GroupUsersActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              context.read<GroupUsersBloc>().add(
                    FetchGroupUsers(groupId: group.id),
                  );

              context.read<ugb.UserGroupsBloc>().add(ugb.FetchGroups());
              context.read<agb.AllGroupsBloc>().add(agb.FetchGroups());

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
            GroupUsersLoading() =>
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
                              isMe: state.users[i].user.id == state.uid,
                              kickUserAction: canKick(
                                state.users,
                                state.uid,
                                state.users[i].user.id,
                              )
                                  ? () {
                                      context.read<GroupUsersBloc>().add(
                                            KickUserFromGroup(
                                                groupId: group.id,
                                                uid: state.users[i].user.id),
                                          );
                                    }
                                  : null,
                            ),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (canJoin(state.users, state.uid, group)) ...[
                        GGButtonWidget(
                          title: 'Join',
                          onPressed: () async {
                            final confirm = await ModalService.showConfirmation(
                              context: context,
                              title: 'Join Group?',
                              message: 'Are you sure?',
                            );

                            if (confirm == null || confirm == false) {
                              return;
                            }

                            if (!context.mounted) return;

                            context.read<GroupUsersBloc>().add(
                                  JoinGroup(groupId: group.id),
                                );
                          },
                        ),
                      ],
                      if (canLeave(state.users, state.uid)) ...[
                        GGButtonWidget(
                          title: 'Leave',
                          onPressed: () async {
                            final confirm = await ModalService.showConfirmation(
                              context: context,
                              title: 'Leave Group?',
                              message: 'Are you sure?',
                            );

                            if (confirm == null || confirm == false) {
                              return;
                            }

                            if (!context.mounted) return;

                            context.read<GroupUsersBloc>().add(
                                  LeaveGroup(groupId: group.id),
                                );
                          },
                        ),
                      ],
                      if (canDelete(state.users, state.uid)) ...[
                        GGButtonWidget(
                          title: 'Delete',
                          onPressed: () async {
                            final confirm = await ModalService.showConfirmation(
                              context: context,
                              title: 'Delete Group?',
                              message: 'Are you sure?',
                            );

                            if (confirm == null || confirm == false) {
                              return;
                            }

                            if (!context.mounted) return;

                            context.read<GroupUsersBloc>().add(
                                  DeleteGroup(groupId: group.id),
                                );
                          },
                        ),
                      ],
                      if (canEdit(state.users, state.uid)) ...[
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
    );
  }
}
