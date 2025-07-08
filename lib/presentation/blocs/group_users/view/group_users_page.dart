import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/widgets/user_list_tile.dart';

import '../group_users.dart';

class GroupUsersPage extends StatelessWidget {
  final String groupId;

  const GroupUsersPage(this.groupId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupUsersBloc(
        context.read<SessionService>(),
        groupId: groupId,
      )..add(ListGroupUsers()),
      child: const GroupUsersView(),
    );
  }
}

class GroupUsersView extends StatelessWidget {
  const GroupUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

        return Column(
          children: [
            Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Text(
                  'Members',
                  style: theme.textTheme.displayLarge,
                )),
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: groupUsers.length,
              itemBuilder: (_, index) {
                final groupUser = groupUsers[index];
                return UserListTile(groupUser.user);
              },
            ))
          ],
        );
      },
    );
  }
}
