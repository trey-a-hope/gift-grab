import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/screens/base_group_form.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/stateless_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';
import 'package:gift_grab/domain/blocs/group/all_groups/all_groups_bloc.dart'
    as agb;
import 'package:gift_grab/domain/blocs/group/user_groups/user_groups_bloc.dart'
    as ugb;

class EditGroupScreen extends StatelessBloc<GroupsBloc, GroupsState> {
  final Group group;

  const EditGroupScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) => BlocListener<GroupsBloc, GroupsState>(
        listener: listener,
        child: BaseGroupForm(
          title: 'Edit Group',
          goBack: () => context.goNamed(
            Globals.routes.groupDetails,
            pathParameters: {'groupId': group.id},
            extra: group,
          ),
          initialName: group.name,
          initialDescription: group.description,
          initialGroupCount: group.maxCount ?? 10,
          initialIsOpen: group.open ?? true,
          submitButtonText: 'Update',
          onSubmit: (name, description, count, isOpen) {
            context.read<GroupsBloc>().add(
                  UpdateGroupEvent(
                    groupId: group.id,
                    name: name,
                    description: description,
                    maxCount: count,
                    open: isOpen,
                  ),
                );
          },
        ),
      );

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    throw UnimplementedError();
  }

  @override
  bool shouldShowMessage(GroupsState state) => state is GroupsActionSuccess;

  @override
  void onAfterMessage(BuildContext context) {
    context.read<ugb.UserGroupsBloc>().add(ugb.FetchGroups());
    context.read<agb.AllGroupsBloc>().add(agb.FetchGroups());

    context.goNamed(Globals.routes.groups);
  }
}
