import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
      onTap: () => context.pushNamed(
        Globals.routes.tournament,
        pathParameters: {'tournamentId': tournament.id},
        extra: tournament,
      ),
      title: Text(
        tournament.title ?? 'Unknown Title',
        style: theme.textTheme.displayMedium,
      ),
      trailing: Icon(
        tournament.canEnter == true ? MdiIcons.check : MdiIcons.cancel,
      ),
    );
  }
}
