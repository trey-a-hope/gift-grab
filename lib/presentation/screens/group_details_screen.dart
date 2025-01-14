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
import 'package:gift_grab/presentation/widgets/group_member_details_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';
import '../widgets/gg_scaffold_widget.dart';

// https://heroiclabs.com/docs/nakama/concepts/groups/

class GroupDetailsScreen extends SmartBloc<GroupUsersBloc, GroupUsersState>
    with GroupPermissions {
  final Group group;

  const GroupDetailsScreen({
    required this.group,
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) => Column(
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
                      banUserAction: canBan(
                        state.users,
                        state.uid,
                        state.users[i].user.id,
                      )
                          ? () {
                              context.read<GroupUsersBloc>().add(
                                    BanUserFromGroup(
                                        groupId: group.id,
                                        uid: state.users[i].user.id),
                                  );
                            }
                          : null,
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
                      promoteUserAction: canPromote(
                        state.users,
                        state.uid,
                        state.users[i].user.id,
                      )
                          ? () {
                              context.read<GroupUsersBloc>().add(
                                    PromoteUserInGroup(
                                        groupId: group.id,
                                        uid: state.users[i].user.id),
                                  );
                            }
                          : null,
                      demoteUserAction: canDemote(
                        state.users,
                        state.uid,
                        state.users[i].user.id,
                      )
                          ? () {
                              context.read<GroupUsersBloc>().add(
                                    DemoteUserInGroup(
                                        groupId: group.id,
                                        uid: state.users[i].user.id),
                                  );
                            }
                          : null,
                      acceptUserAction: canAccept(
                        state.users,
                        state.uid,
                        state.users[i].user.id,
                      )
                          ? () {
                              context.read<GroupUsersBloc>().add(
                                    AddUserIntoGroup(
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
                ElevatedButton(
                  child:
                      Text(group.open == true ? 'Join' : 'Submit Join Request'),
                  onPressed: () async {
                    final confirm = await ModalService.showConfirmation(
                      context: context,
                      title: group.open == true
                          ? 'Join Group?'
                          : 'Submit Join Request',
                      message: 'Are you sure?',
                    );

                    if (confirm == null || confirm == false) {
                      return;
                    }

                    if (!context.mounted) return;

                    context.read<GroupUsersBloc>().add(
                          JoinGroup(
                            groupId: group.id,
                            isJoinRequest:
                                findUserInGroup(state.users, state.uid) == null,
                          ),
                        );
                  },
                ),
              ],
              if (canLeave(state.users, state.uid)) ...[
                ElevatedButton(
                  child: Text(findUserInGroup(state.users, state.uid)?.state ==
                          GroupMembershipState.joinRequest
                      ? 'Remove Request'
                      : 'Leave'),
                  onPressed: () async {
                    final confirm = await ModalService.showConfirmation(
                      context: context,
                      title: findUserInGroup(state.users, state.uid)?.state ==
                              GroupMembershipState.joinRequest
                          ? 'Delete Join Request?'
                          : 'Leave Group?',
                      message: 'Are you sure?',
                    );

                    if (confirm == null || confirm == false) {
                      return;
                    }

                    if (!context.mounted) return;

                    context.read<GroupUsersBloc>().add(
                          LeaveGroup(
                            groupId: group.id,
                            isJoinRequest:
                                findUserInGroup(state.users, state.uid)
                                        ?.state ==
                                    GroupMembershipState.joinRequest,
                          ),
                        );
                  },
                ),
              ],
              if (canDelete(state.users, state.uid)) ...[
                ElevatedButton(
                  child: Text('Delete'),
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
                ElevatedButton(
                  child: Text('Edit'),
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
      );

  @override
  bool shouldShowMessage(GroupUsersState state) =>
      state is GroupUsersActionSuccess || state is GroupUsersError;

  @override
  void onAfterMessage(BuildContext context) {
    context.read<GroupUsersBloc>().add(
          FetchGroupUsers(groupId: group.id),
        );

    context.read<ugb.UserGroupsBloc>().add(ugb.FetchGroups());
    context.read<agb.AllGroupsBloc>().add(agb.FetchGroups());

    // TODO: Provide better way for navigating back...
    // if (state.goBack) {
    //   context.goNamed(Globals.routes.groups);
    // }
  }

  @override
  Widget build(BuildContext context) {
    context.read<GroupUsersBloc>().add(FetchGroupUsers(groupId: group.id));

    return GGScaffoldWidget(
      title: group.name ?? 'Unknown Name',
      goBack: () => context.goNamed(Globals.routes.groups),
      child: SafeArea(
        child: BlocConsumer<GroupUsersBloc, GroupUsersState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
