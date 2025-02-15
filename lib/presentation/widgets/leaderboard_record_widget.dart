import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:gift_grab/presentation/widgets/clickable_avatar.dart';

class LeaderboardRecordListTile extends StatelessWidget {
  final LeaderboardEntry entry;

  final double _avatarRadius = 30;

  const LeaderboardRecordListTile({
    required this.entry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        radius: _avatarRadius,
        backgroundColor: Colors.blue,
        child: Text(
          '${entry.record.rank}',
          style: theme.textTheme.headlineLarge,
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
          child: Text('${entry.user.username} - ${entry.record.score}',
              style: theme.textTheme.headlineLarge!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      trailing: ClickableAvatar(entry.user),
    );
  }
}
