import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_widget.dart';
import 'package:go_router/go_router.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Leaderboard',
      goBack: () => context.goNamed(Globals.routes.main),
      child: SafeArea(
        child: BlocProvider(
          create: (context) => LeaderboardBloc()..add(FetchLeaderboardEvent()),
          child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (context, state) => switch (state) {
              LeaderboardLoading() =>
                Center(child: const CircularProgressIndicator()),
              LeaderboardError() => Text('Error: ${state.message}'),
              LeaderboardLoaded() => Column(
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
                              itemBuilder: ((_, index) =>
                                  LeaderboardRecordWidget(
                                    entry: state.entries[index],
                                  )),
                            ),
                    ),
                  ],
                ),
              _ => const SizedBox(),
            },
          ),
        ),
      ),
    );
  }
}
