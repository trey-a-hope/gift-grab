import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/screens/base_group_form.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseGroupForm(
      title: 'Create Group',
      submitButtonText: 'Create',
      onSubmit: (name, description, count, isOpen) {
        context.read<AllGroupsBloc>().add(
              CreateGroupEvent(
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
