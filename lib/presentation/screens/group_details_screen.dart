import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/group_member_details_widget.dart';
import 'package:go_router/go_router.dart';

import '../widgets/gg_scaffold_widget.dart';

class Group {
  final String name;
  final String description;
  final List members;

  Group({required this.name, required this.description, required this.members});
}

class GroupDetailsScreen extends ConsumerWidget {
  final Group group;

  const GroupDetailsScreen({
    required this.group,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GGScaffoldWidget(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              group.name ?? 'No Name...',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const Gap(20),
            Text(
              group.description ?? 'No Description...',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // Expanded(
            //   child: members.when(
            //     data: (data) => data.isEmpty
            //         ? const Center(
            //             child: Text('No Members'),
            //           )
            //         : ListView.builder(
            //             itemCount: data.length,
            //             itemBuilder: (c, i) => GroupMemberDetailsWidget(
            //               groupUser: data[i],
            //             ),
            //           ),
            //     error: (err, stack) => Center(
            //       child: Text(
            //         err.toString(),
            //       ),
            //     ),
            //     loading: () => const Center(child: CircularProgressIndicator()),
            //   ),
            // ),
            GGButtonWidget(
              title: 'Back',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
