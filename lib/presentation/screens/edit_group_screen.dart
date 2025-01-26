import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/screens/base_group_form.dart';
import 'package:nakama/nakama.dart';

class EditGroupScreen extends StatelessWidget {
  final Group group;

  const EditGroupScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGroupForm(
      title: 'Edit Group',
      initialName: group.name,
      initialDescription: group.description,
      initialGroupCount: group.maxCount ?? 10,
      initialIsOpen: group.open ?? true,
      submitButtonText: 'Update',
      onSubmit: (name, description, count, isOpen) {
        context.read<AllGroupsBloc>().add(
              UpdateGroupEvent(
                groupId: group.id,
                name: name,
                description: description,
                maxCount: count,
                open: isOpen,
              ),
            );
      },
    );
  }
}
