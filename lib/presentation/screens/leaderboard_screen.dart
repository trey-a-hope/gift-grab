import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_records_list_view.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:smart_bloc/smart_bloc.dart';

class LeaderboardScreen extends SmartBloc<LeaderboardBloc, LeaderboardState> {
  const LeaderboardScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    state = state as LeaderboardLoaded;

    return LeaderboardRecordsListView(
      entries: state.entries,
      title: 'Resets every first of the month at 12:00am.',
      noResults: NoResultsEnum.leaderboard,
    );
  }

  @override
  void listener(BuildContext context, LeaderboardState state) {
    super.listener(context, state);

    if (state is LeaderboardSuccess) {
      context.read<LeaderboardBloc>().add(
            FetchLeaderboard(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<LeaderboardBloc>().add(FetchLeaderboard());
    return GGScaffoldWidget(
      title: 'Leaderboard',
      child: Center(
        child: BlocConsumer<LeaderboardBloc, LeaderboardState>(
          listener: listener,
          builder: builder,
        ),
      ),
    );
  }
}
