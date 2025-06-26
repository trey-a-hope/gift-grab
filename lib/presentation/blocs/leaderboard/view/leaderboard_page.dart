import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_list_tile.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';
import 'package:gift_grab_ui/modal_util.dart';

import '../leaderboard.dart';

class LeaderboardPage extends StatelessWidget {
  final String uid;
  const LeaderboardPage(this.uid, {super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LeaderboardBloc>().add(FetchLeaderboard());
    return LeaderboardView(uid);
  }
}

class LeaderboardView extends StatelessWidget {
  final String uid;

  const LeaderboardView(this.uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaderboardBloc, LeaderboardState>(
      listener: (context, state) {
        if (state.error != null) {
          ModalUtil.showError(title: state.error!);
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);

        final entries = state.entries;

        return GGScaffoldWidget(
          title: 'Leaderboard',
          child: Center(
            child: state.isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'Resets every first of the month at 12:00am.',
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                      Expanded(
                        child: entries.isEmpty
                            ? NoResultsWidget(NoResultsEnum.leaderboard)
                            : ListView.builder(
                                itemCount: entries.length,
                                itemBuilder: ((context, index) =>
                                    LeaderboardRecordListTile(
                                      uid: uid,
                                      entry: entries[index],
                                    )),
                              ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
