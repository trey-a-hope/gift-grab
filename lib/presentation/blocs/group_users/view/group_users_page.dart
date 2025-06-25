import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/presentation/widgets/user_list_tile.dart';

import '../group_users.dart';

class GroupUsersPage extends StatelessWidget {
  final String groupId;

  const GroupUsersPage(this.groupId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupUsersBloc(
        groupId: groupId,
      ),
      child: const GroupUsersView(),
    );
  }
}

class GroupUsersView extends StatelessWidget {
  const GroupUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupUsersBloc, GroupUsersState>(
      builder: (context, state) {
        final groupUsers = state.groupUsers;

        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(
            child: Text(state.error!),
          );
        }

        return ListView.builder(
          itemCount: groupUsers.length,
          itemBuilder: (_, index) {
            final groupUser = groupUsers[index];
            return UserListTile(groupUser.user);
          },
        );
      },
    );
  }
}
