import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';

class TournamentListTile extends StatelessWidget {
  final Tournament tournament;

  const TournamentListTile(
    this.tournament, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      // onTap: () => context.pushNamed(
      //   Globals.routes.groupDetails,
      //   pathParameters: {'groupId': group.id},
      //   extra: group,
      // ),
      leading: CircleAvatar(
        child: Text(
          '${tournament.size}/${tournament.maxSize} players...',
        ),
      ),
      title: Text(
        tournament.title ?? 'Unknown Title',
        style: theme.textTheme.displayMedium,
      ),
      subtitle: Text(
        'Lasts ${tournament.duration ?? 0} seconds...',
        style: theme.textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
