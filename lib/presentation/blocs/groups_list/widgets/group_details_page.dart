import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/blocs/group_users/view/group_users_page.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:nakama/nakama.dart';

class GroupDetailsPage extends StatelessWidget {
  final Group group;

  const GroupDetailsPage(this.group);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: group.name ?? 'Unknown Group Name',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: GroupUsersPage(
                    group.id,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Group Is Open: ${group.open}',
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
                child: Padding(
              padding: EdgeInsetsGeometry.all(32),
              child: Text(
                group.description ?? 'No description...',
                style: theme.textTheme.displayLarge,
              ),
            )),
          )
        ],
      ),
    );
  }
}
