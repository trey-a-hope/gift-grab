import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_widget.dart';
import 'package:gift_grab/presentation/widgets/no_results_widget.dart';

class LeaderboardRecordsListView extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final String title;
  final NoResultsEnum noResults;

  const LeaderboardRecordsListView({
    super.key,
    required this.entries,
    required this.title,
    required this.noResults,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            title,
            style: theme.textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: entries.isEmpty
              ? NoResultsWidget(noResults)
              : ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: ((context, index) =>
                      LeaderboardRecordListTile(entry: entries[index]))),
        ),
      ],
    );
  }
}
