import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/domain/mixins/group_persmissions.dart';
import 'package:gift_grab/domain/blocs/group/group_users/group_users_bloc.dart';
import 'package:gift_grab/presentation/widgets/group_member_details_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';
import '../widgets/gg_scaffold_widget.dart';

// TODO: Currently no api for fetching a single group, so group details on this screen cannot be updated after a successful edit.
class GroupDetailsScreen extends SmartBloc<GroupUsersBloc, GroupUsersState>
    with GroupPermissions {
  final Group group;
  // "initialContext" is used to make single call to FetchGroupUsers, and only once when the page is present.
  // Do this on any page that needs to request fresh data but also has modals or any widgets that could
  // cause the widget to rebuilt.
  final BuildContext initialContext;

  GroupDetailsScreen({
    required this.group,
    required this.initialContext,
    super.key,
  }) {
    initialContext.read<GroupUsersBloc>().add(
          FetchGroupUsers(groupId: group.id),
        );
  }

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as GroupUsersLoaded;

    return Column(
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
          child: ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (c, i) => GroupMemberDetailsWidget(
              groupUser: state.users[i],
              banUserAction: canBan(
                state.users,
                state.uid,
                state.users[i].user.id,
              )
                  ? () {
                      context.read<GroupUsersBloc>().add(
                            BanUserFromGroup(
                                groupId: group.id, uid: state.users[i].user.id),
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
                                groupId: group.id, uid: state.users[i].user.id),
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
                                groupId: group.id, uid: state.users[i].user.id),
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
                                groupId: group.id, uid: state.users[i].user.id),
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
                                groupId: group.id, uid: state.users[i].user.id),
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
                              findUserInGroup(state.users, state.uid)?.state ==
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
                onPressed: () async {
                  await context.pushNamed(
                    Globals.routes.editGroup,
                    pathParameters: {'groupId': group.id},
                    extra: group,
                  );
                  if (!context.mounted) return;

                  context.read<GroupUsersBloc>().add(
                        FetchGroupUsers(groupId: group.id),
                      );
                },
              ),
            ],
          ],
        )
      ],
    );
  }

  @override
  void listener(BuildContext context, GroupUsersState state) {
    super.listener(context, state);

    context.read<AllGroupsBloc>().add(FetchGroups());
    context.read<MyGroupsBloc>().add(FetchGroups());

    if (state is GroupUsersLoaded) {
      if (state.users.isEmpty) {
        context.pop(true);
      }
    }

    if (state is GroupUsersSuccess) {
      context.read<GroupUsersBloc>().add(
            FetchGroupUsers(groupId: group.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) => GGScaffoldWidget(
        title: 'Group',
        child: BlocConsumer<GroupUsersBloc, GroupUsersState>(
          listener: listener,
          builder: builder,
        ),
      );
}
