import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/group/all_groups/all_groups_bloc.dart'
    as agb;
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/screens/base_group_form.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateGroupScreen extends SmartBloc<GroupsBloc, GroupsState> {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsBloc, GroupsState>(
      listener: listener,
      child: BaseGroupForm(
        title: 'Create Group',
        goBack: () => context.goNamed(Globals.routes.groups),
        submitButtonText: 'Create',
        onSubmit: (name, description, count, isOpen) {
          context.read<GroupsBloc>().add(
                CreateGroupEvent(
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

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    throw UnimplementedError();
  }

  @override
  void onAfterMessage(BuildContext context) {
    context.read<agb.AllGroupsBloc>().add(agb.FetchGroups());
    context.goNamed(Globals.routes.groups);
  }
}
