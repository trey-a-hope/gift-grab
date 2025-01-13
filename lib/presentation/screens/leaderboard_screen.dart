import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_widget.dart';
import 'package:gift_grab/presentation/widgets/stateless_bloc.dart';
import 'package:go_router/go_router.dart';

class LeaderboardScreen
    extends StatelessBloc<LeaderboardBloc, LeaderboardState> {
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
            style: theme.textTheme.headlineSmall!.copyWith(
              fontSize: Globals.isTablet
                  ? theme.textTheme.headlineSmall!.fontSize! * 2
                  : theme.textTheme.headlineSmall!.fontSize,
            ),
          ),
        ),
        Expanded(
          child: state.entries.isEmpty
              ? Center(
                  child: Text('No records for this week yet...',
                      style: theme.textTheme.displayLarge),
                )
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
  bool shouldShowMessage(LeaderboardState state) =>
      state is LeaderboardError || state is LeaderboardActionSuccess;

  @override
  void onAfterMessage(BuildContext context) =>
      context.read<LeaderboardBloc>().add(
            FetchLeaderboard(),
          );

  @override
  Widget build(BuildContext context) {
    context.read<LeaderboardBloc>().add(FetchLeaderboard());

    return GGScaffoldWidget(
      title: 'Leaderboard',
      goBack: () => context.goNamed(Globals.routes.main),
      child: SafeArea(
        child: Center(
          child: BlocConsumer<LeaderboardBloc, LeaderboardState>(
            listener: listener,
            builder: builder,
          ),
        ),
      ),
    );
  }
}
