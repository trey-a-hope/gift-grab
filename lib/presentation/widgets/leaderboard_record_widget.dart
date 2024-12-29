import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/models/leaderboard_record/leaderboard_record_model.dart';

class LeaderboardRecordWidget extends ConsumerWidget {
  final LeaderboardRecordModel leaderboardRecord;

  final double _avatarRadius = 30;

  const LeaderboardRecordWidget({
    required this.leaderboardRecord,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerId = leaderboardRecord.ownerId;
    if (ownerId == null) {
      throw Exception('Rank Does Not Have Owner ID...');
    }

    return ListTile(
      leading: CircleAvatar(
        radius: _avatarRadius,
        backgroundColor: Colors.blue,
        child: Text(
          leaderboardRecord.rank,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      title: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        height: 50,
        child: Center(
          child: Text(
            // '${user.username} - ${leaderboardRecord.score}',
            '$ownerId - ${leaderboardRecord.score}',
            style: Globals.isTablet
                ? Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )
                : Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
          ),
        ),
      ),
      trailing:

          // lottieAvatar != null
          //     ? LottieBuilder.asset(lottieAvatar.path)
          //     :

          CircleAvatar(
        radius: _avatarRadius,
        backgroundImage: const NetworkImage(
          Globals.emptyProfile,
        ),
      ),
    );

    // return FutureBuilder<User>(
    //   future: ref.read(Providers.nakamaUsersProvider.notifier).getUser(
    //         uid: ownerId,
    //       ),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     }

    //     if (snapshot.hasError) {
    //       return Center(child: Text(snapshot.error.toString()));
    //     }

    //     final user = snapshot.data;

    //     if (user == null) {
    //       throw Exception('User is null...');
    //     }

    //     LottieAvatar? lottieAvatar;
    //     if (leaderboardRecord.metadata != null) {
    //       final metaData = json.decode(
    //         leaderboardRecord.metadata!,
    //       );
    //       lottieAvatar = LottieAvatar.findByName(
    //         metaData['avatar'],
    //       );
    //     }

    //     return ListTile(
    //       leading: CircleAvatar(
    //         radius: _avatarRadius,
    //         backgroundColor: Colors.blue,
    //         child: Text(
    //           '${leaderboardRecord.rank}',
    //           style: Theme.of(context).textTheme.headlineLarge,
    //         ),
    //       ),
    //       title: Container(
    //         decoration: BoxDecoration(
    //           border: Border.all(color: Colors.white),
    //           borderRadius: BorderRadius.circular(5),
    //           color: Colors.white,
    //         ),
    //         height: 50,
    //         child: Center(
    //           child: Text(
    //             '${user.username} - ${leaderboardRecord.score}',
    //             style: Globals.isTablet
    //                 ? Theme.of(context).textTheme.headlineLarge!.copyWith(
    //                       color: Colors.black,
    //                       fontWeight: FontWeight.bold,
    //                     )
    //                 : Theme.of(context).textTheme.bodyLarge!.copyWith(
    //                       color: Colors.black,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //           ),
    //         ),
    //       ),
    //       trailing: lottieAvatar != null
    //           ? LottieBuilder.asset(lottieAvatar.path)
    //           : CircleAvatar(
    //               radius: _avatarRadius,
    //               backgroundImage: const NetworkImage(
    //                 Globals.emptyProfile,
    //               ),
    //             ),
    //     );
    //   },
    // );
  }
}
