import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/util/config/globals.dart';
import 'package:gift_grab/util/config/providers.dart';
import 'package:gift_grab/presentation/widgets/leaderboard_record_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:go_router/go_router.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nakamaLeaderboardAsync =
        ref.watch(Providers.nakamaLeaderboardAsyncNotifierProvider);
    final theme = Theme.of(context);

    return ScreenBackgroundWidget(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Leaderboard',
                style: theme.textTheme.displayLarge!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displayLarge!.fontSize! * 2
                      : theme.textTheme.displayLarge!.fontSize,
                ),
              ),
            ),
            Expanded(
              child: nakamaLeaderboardAsync.when(
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

              // FutureBuilder<List<LeaderboardRecord>>(
              //   future:
              //       nakamaLeaderboardAsyncNotifier.listLeaderboardRecords(20),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else if (!snapshot.hasData || snapshot.data == null) {
              //       return const Text('None');
              //     } else {
              //       List<LeaderboardRecord> leaderboardRecords = snapshot.data!;

              //       if (leaderboardRecords.isEmpty) {
              //         return Center(
              //           child: Text('No records for this week yet...',
              //               style: theme.textTheme.displayLarge),
              //         );
              //       }

              //       return ListView.builder(
              //         itemCount: leaderboardRecords.length,
              //         itemBuilder: ((_, index) => LeaderboardRecordWidget(
              //             leaderboardRecord: leaderboardRecords[index])),
              //       );
              //     }
              //   },
              // ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: Globals.isTablet ? 400 : 200,
                height: Globals.isTablet ? 100 : 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                    // gameRef.addMenu(menu: Screens.main);
                    // gameRef.removeMenu(menu: Screens.leaderboard);
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
