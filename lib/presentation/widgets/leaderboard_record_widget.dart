import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:nakama/nakama.dart';

class LeaderboardRecordWidget extends StatelessWidget {
  final LeaderboardRecord leaderboardRecord;

  final double _avatarRadius = 30;

  const LeaderboardRecordWidget({
    required this.leaderboardRecord,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ownerId = leaderboardRecord.ownerId;
    if (ownerId == null) {
      throw Exception('Rank Does Not Have Owner ID...');
    }

    return ListTile(
      leading: CircleAvatar(
        radius: _avatarRadius,
        backgroundColor: Colors.blue,
        child: Text(
          '${leaderboardRecord.rank}',
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
            'UNKNOWN USER - ${leaderboardRecord.score}',
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
      trailing: CircleAvatar(
        radius: _avatarRadius,
        backgroundImage: const NetworkImage(
          Globals.emptyProfile,
        ),
      ),
    );
  }
}
