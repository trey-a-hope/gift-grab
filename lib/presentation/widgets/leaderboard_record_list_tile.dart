import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/blocs/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:gift_grab/domain/extensions/string_extensions.dart';
import 'package:gift_grab/domain/entities/leaderboard_entry.dart';
import 'package:gift_grab/presentation/widgets/user_list_tile.dart';

class LeaderboardRecordListTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final String uid;

  const LeaderboardRecordListTile({
    required this.entry,
    required this.uid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onLongPress: () {
        if (uid == entry.user.id) {
          context.read<LeaderboardBloc>().add(DeleteRecord());
        }
      },
      child: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Row(
          children: [
            Expanded(child: UserListTile(entry.user)),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(4),
                  child: Text(
                    '${entry.record.rank?.ordinal}',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ),
            ),
            const Gap(16),
            Card(
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Text(
                  '${entry.record.score} gifts',
                  style: theme.textTheme.headlineLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
