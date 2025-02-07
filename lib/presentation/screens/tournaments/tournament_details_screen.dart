import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/extensions/int_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nakama/nakama.dart';
import 'package:timeago/timeago.dart' as timeago;

class TournamentDetailsScreen extends StatelessWidget {
  final Tournament tournament;

  const TournamentDetailsScreen({
    required this.tournament,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    debugPrint('Tournament Info: ${tournament.toString()}');

    final durationHours = ((tournament.duration ?? 0) / 3600).round();

    DateTime? startActive = tournament.startActive.fromMillisecondsSinceEpoch();
    DateTime? endActive = tournament.endActive.fromMillisecondsSinceEpoch();
    DateTime? nextReset = tournament.nextReset.fromMillisecondsSinceEpoch();
    DateTime? prevReset = tournament.prevReset.fromMillisecondsSinceEpoch();

    return GGScaffoldWidget(
      title: tournament.title ?? 'Unknown Tournament',
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Text(
                '"${tournament.description ?? 'No Description'}"',
                style: theme.textTheme.displayLarge,
              ),
              Gap(16),
              ListTile(
                leading: Icon(MdiIcons.listStatus),
                title: Text(
                  'Active',
                  style: theme.textTheme.displayLarge,
                ),
                trailing: Text(
                  ' ${tournament.canEnter == true ? 'True' : 'False'}',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              Gap(16),
              ListTile(
                leading: Icon(MdiIcons.clock),
                title: Text(
                  'Duration',
                  style: theme.textTheme.displayLarge,
                ),
                trailing: Text(
                  '$durationHours hr(s)',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              Gap(16),
              if (startActive != null) ...[
                ListTile(
                  leading: Icon(MdiIcons.timelapse),
                  title: Text(
                    'Start Active',
                    style: theme.textTheme.displayLarge,
                  ),
                  trailing: Text(
                    timeago.format(
                      startActive,
                      allowFromNow: true,
                    ),
                    style: theme.textTheme.displayLarge,
                  ),
                ),
              ],
              Gap(16),
              if (prevReset != null) ...[
                ListTile(
                  leading: Icon(MdiIcons.timeline),
                  title: Text(
                    'Previous Reset',
                    style: theme.textTheme.displayLarge,
                  ),
                  trailing: Text(
                    timeago.format(
                      prevReset,
                      allowFromNow: true,
                    ),
                    style: theme.textTheme.displayLarge,
                  ),
                ),
              ],
              Gap(16),
              if (nextReset != null) ...[
                ListTile(
                  leading: Icon(MdiIcons.timer3),
                  title: Text(
                    'Next Reset',
                    style: theme.textTheme.displayLarge,
                  ),
                  trailing: Text(
                    timeago.format(
                      nextReset,
                      allowFromNow: true,
                    ),
                    style: theme.textTheme.displayLarge,
                  ),
                ),
              ],
              Gap(16),
              if (endActive != null) ...[
                ListTile(
                  leading: Icon(MdiIcons.timer),
                  title: Text(
                    'End Active',
                    style: theme.textTheme.displayLarge,
                  ),
                  trailing: Text(
                    timeago.format(
                      endActive,
                      allowFromNow: true,
                    ),
                    style: theme.textTheme.displayLarge,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
