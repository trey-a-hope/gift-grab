import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/group_member_details_widget.dart';
import 'package:go_router/go_router.dart';

import '../widgets/screen_background_widget.dart';

class GroupDetailsScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailsScreen({
    required this.groupId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(Providers.nakamaGroupUsersProvider(groupId));

    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              groupId,
            ),
            const Gap(20),
            Expanded(
              child: members.when(
                data: (data) => data.isEmpty
                    ? const Center(
                        child: Text('No Members'),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (c, i) => GroupMemberDetailsWidget(
                          groupUser: data[i],
                        ),
                      ),
                error: (err, stack) => Center(
                  child: Text(
                    err.toString(),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
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
