import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';

class LeaderboardScreen extends SmartBloc<LeaderboardBloc, LeaderboardState> {
  const LeaderboardScreen({
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'Resets every Monday at 12:00am.',
            style: theme.textTheme.headlineMedium!,
          ),
        ),
        Expanded(
          child: state.entries.isEmpty
              ? NoResultsWidget(NoResultsEnum.leaderboard)
              : ListView.builder(
                  itemCount: state.entries.length,
                  itemBuilder: ((_, index) => LeaderboardRecordWidget(
                        entry: state.entries[index],
                      )),
                ),
        ),
      ],
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
