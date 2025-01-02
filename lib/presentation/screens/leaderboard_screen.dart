import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    final leaderboardRecords = [];

    final theme = Theme.of(context);

    return GGScaffoldWidget(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weekly Leaderboard',
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.displayLarge!.fontSize! * 2
                    : theme.textTheme.displayLarge!.fontSize,
              ),
            ),
            Text(
              'Resets every Monday at 12:00am.',
              style: theme.textTheme.headlineSmall!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.headlineSmall!.fontSize! * 2
                    : theme.textTheme.headlineSmall!.fontSize,
              ),
            ),
            const Gap(50),
            Expanded(
              child: leaderboardRecords.isEmpty
                  ? Center(
                      child: Text('No records for this week yet...',
                          style: theme.textTheme.displayLarge),
                    )
                  : ListView.builder(
                      itemCount: leaderboardRecords.length,
                      itemBuilder: ((_, index) => LeaderboardRecordWidget(
                            leaderboardRecord: leaderboardRecords[index],
                          )),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: Globals.isTablet ? 400 : 200,
                height: Globals.isTablet ? 100 : 50,
                child: ElevatedButton(
                  onPressed: () => context.goNamed(Globals.routes.main),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: Globals.isTablet ? 50 : 25,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
