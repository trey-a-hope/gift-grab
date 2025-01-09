import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/group/group_bloc.dart';
import 'package:gift_grab/domain/blocs/group/group_persmissions.dart';
import 'package:gift_grab/domain/blocs/group_my/group_my_bloc.dart' as m;
import 'package:gift_grab/domain/blocs/group_user/group_user_bloc.dart';
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
            ),
            BlocProvider.value(
              value: context.read<m.GroupMyBloc>(), //
            ),
          ],
          child: BlocConsumer<GroupUserBloc, GroupUserState>(
            listener: (context, state) {
              if (state is GroupUserEventSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                context.read<GroupUserBloc>().add(
                      LoadGroupUsersEvent(
                        groupId: group.id,
                      ),
                    );

                context.read<m.GroupMyBloc>().add(
                      m.RefreshGroups(),
                    );

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
                                isMe: state.users[i].user.id == state.uid,
                                kickUserAction: canKick(
                                  state.users,
                                  state.uid,
                                  state.users[i].user.id,
                                )
                                    ? () {
                                        context.read<GroupUserBloc>().add(
                                              KickUserEvent(
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
                        if (canLeave(state.users, state.uid)) ...[
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
                        if (canDelete(state.users, state.uid)) ...[
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
      ),
    );
  }
}
