import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';

class LeaderboardRecordWidget extends StatelessWidget {
  final LeaderboardEntry entry;

  final double _avatarRadius = 30;

  const LeaderboardRecordWidget({
    required this.entry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: _avatarRadius,
        backgroundColor: Colors.blue,
        child: Text(
          '${entry.record.rank}',
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
            '${entry.user.username} - ${entry.record.score}',
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
        backgroundImage: NetworkImage(
          entry.user.avatarUrl ?? Globals.emptyProfile,
        ),
      ),
    );
  }
}
