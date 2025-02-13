import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/tournaments/tournaments_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/tournament_list_tile.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:smart_bloc/smart_bloc.dart';

class TournamentsScreen extends SmartBloc<TournamentsBloc, TournamentsState> {
  const TournamentsScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, state) {
    state = state as TournamentsLoaded;

    final tournaments = state.tournaments;

    return Column(
      children: [
        Expanded(
          child: tournaments.isEmpty
              ? NoResultsWidget(NoResultsEnum.tournaments)
              : ListView.builder(
                  itemCount: tournaments.length,
                  itemBuilder: (c, i) => TournamentListTile(
                    tournaments[i],
                  ),
                ),
        ),
        if (state.cursor != null) ...[
          ElevatedButton(
            child: const Text('Fetch More Tournaments'),
            onPressed: () => context.read<TournamentsBloc>().add(
                  FetchMoreTournaments(tournaments: state.tournaments),
                ),
          )
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Tournaments',
      child: BlocConsumer<TournamentsBloc, TournamentsState>(
        listener: listener,
        builder: builder,
      ),
    );
  }
}
