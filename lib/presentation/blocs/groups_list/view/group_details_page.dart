import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/blocs/group_users/view/group_users_page.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';
import 'package:nakama/nakama.dart';

class GroupDetailsPage extends StatelessWidget {
  final Group group;

  const GroupDetailsPage(this.group);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String avatarUrl = Globals.emptyProfile;
    if (group.avatarUrl != null && group.avatarUrl!.isNotEmpty) {
      avatarUrl = group.avatarUrl!;
    }

    return GGScaffoldWidget(
      title: group.name ?? 'Unknown Group Name',
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // TODO: Add edit feature to upload picture to cloud.
                Padding(
                  padding: EdgeInsetsGeometry.all(32),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(32), // Adjust radius as needed
                    child: Image.network(avatarUrl),
                  ),
                ),
                Text(
                  'Group Is Open: ${group.open}',
                  style: theme.textTheme.headlineLarge,
                ),
                Padding(
                  padding: EdgeInsetsGeometry.all(32),
                  child: Text(
                    group.description ?? 'No description...',
                    style: theme.textTheme.displayLarge,
                  ),
                )
              ],
            ),
          ),
          Expanded(child: GroupUsersPage(group.id))
        ],
      ),
    );
  }
}
