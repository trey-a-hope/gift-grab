import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/clan_details_widget.dart';
import 'package:nakama/nakama.dart';

class ClanDetailsListWidget extends StatelessWidget {
  final List<Group> groups;
  final String currentUid;

  const ClanDetailsListWidget({
    required this.groups,
    required this.currentUid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return groups.isEmpty
        ? Center(
            child: Text(
              'No Groups :(',
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.displayLarge!.fontSize! * 2
                    : theme.textTheme.displayLarge!.fontSize,
              ),
            ),
          )
        : ListView.builder(
            itemCount: groups.length,
            itemBuilder: (c, i) => ClanDetailsWidget(
              group: groups[i],
              isOwner: groups[i].creatorId == currentUid,
            ),
          );
  }
}
