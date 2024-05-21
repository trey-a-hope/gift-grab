import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nakamaLeaderboardProvider =
        ref.watch(Providers.nakamaLeaderboardProvider);

    final theme = Theme.of(context);

    return ScreenBackgroundWidget(
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
              child: nakamaLeaderboardProvider.when(
                data: (leaderboardRecords) {
                  if (leaderboardRecords.isEmpty) {
                    return Center(
                      child: Text('No records for this week yet...',
                          style: theme.textTheme.displayLarge),
                    );
                  }

                  return ListView.builder(
                    itemCount: leaderboardRecords.length,
                    itemBuilder: ((_, index) => LeaderboardRecordWidget(
                          leaderboardRecord: leaderboardRecords[index],
                        )),
                  );
                },
                error: (error, stackTrace) => Text(
                  'Error: ${error.toString()}',
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: Globals.isTablet ? 400 : 200,
                height: Globals.isTablet ? 100 : 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
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
