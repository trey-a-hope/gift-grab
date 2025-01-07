import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group/group_bloc.dart';
import 'package:gift_grab/presentation/screens/base_group_form.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class EditGroupScreen extends StatelessWidget {
  final Group group;

  const EditGroupScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupEventSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<GroupBloc>().add(LoadGroupsEvent());
          context.goNamed(Globals.routes.groups);
        }
      },
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
          context.read<GroupBloc>().add(
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
  }
}
