import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/tournament/tournament_bloc.dart';
import 'package:gift_grab/presentation/extensions/int_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_records_list_view.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nakama/nakama.dart';
import 'package:timeago/timeago.dart' as timeago;

class TournamentScreen extends SmartBloc<TournamentBloc, TournamentState> {
  final Tournament tournament;

  const TournamentScreen({
    required this.tournament,
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    final theme = Theme.of(context);

    debugPrint('Tournament Info: ${tournament.toString()}');

    final durationHours = ((tournament.duration ?? 0) / 3600).round();

    DateTime? startActive = tournament.startActive.fromMillisecondsSinceEpoch();
    DateTime? endActive = tournament.endActive.fromMillisecondsSinceEpoch();
    DateTime? nextReset = tournament.nextReset.fromMillisecondsSinceEpoch();
    DateTime? prevReset = tournament.prevReset.fromMillisecondsSinceEpoch();

    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          ListTile(
            leading: Icon(MdiIcons.listStatus),
            title: Text(
              'Active',
              style: theme.textTheme.displayLarge,
            ),
            trailing: Text(
              ' ${tournament.canEnter == true ? 'True' : 'False'}',
              style: theme.textTheme.displayLarge,
            ),
          ),
          Gap(16),
          ListTile(
            leading: Icon(MdiIcons.clock),
            title: Text(
              'Duration',
              style: theme.textTheme.displayLarge,
            ),
            trailing: Text(
              '$durationHours hr(s)',
              style: theme.textTheme.displayLarge,
            ),
          ),
          Gap(16),
          if (startActive != null) ...[
            ListTile(
              leading: Icon(MdiIcons.timelapse),
              title: Text(
                'Start Active',
                style: theme.textTheme.displayLarge,
              ),
              trailing: Text(
                timeago.format(
                  startActive,
                  allowFromNow: true,
                ),
                style: theme.textTheme.displayLarge,
              ),
            ),
          ],
          Gap(16),
          if (prevReset != null) ...[
            ListTile(
              leading: Icon(MdiIcons.timeline),
              title: Text(
                'Previous Reset',
                style: theme.textTheme.displayLarge,
              ),
              trailing: Text(
                timeago.format(
                  prevReset,
                  allowFromNow: true,
                ),
                style: theme.textTheme.displayLarge,
              ),
            ),
          ],
          Gap(16),
          if (nextReset != null) ...[
            ListTile(
              leading: Icon(MdiIcons.timer3),
              title: Text(
                'Next Reset',
                style: theme.textTheme.displayLarge,
              ),
              trailing: Text(
                timeago.format(
                  nextReset,
                  allowFromNow: true,
                ),
                style: theme.textTheme.displayLarge,
              ),
            ),
          ],
          Gap(16),
          if (endActive != null) ...[
            ListTile(
              leading: Icon(MdiIcons.timer),
              title: Text(
                'End Active',
                style: theme.textTheme.displayLarge,
              ),
              trailing: Text(
                timeago.format(
                  endActive,
                  allowFromNow: true,
                ),
                style: theme.textTheme.displayLarge,
              ),
            ),
          ],
          Expanded(
            child: LeaderboardRecordsListView(
              entries: state.entries,
              title: tournament.description ?? 'No Description',
              noResults: NoResultsEnum.tournaments,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Tournament',
      child: BlocProvider(
        create: (context) => TournamentBloc(context.read<AuthBloc>())
          ..add(FetchTournamentRecords(tournamentId: tournament.id)),
        child: BlocConsumer<TournamentBloc, TournamentState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
