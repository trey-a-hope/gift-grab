import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/clan_details_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final session = ref.read(Providers.nakamaSessionDataProvider);
    final groups = ref.watch(Providers.nakamaGroupsProvider);

    String? currentUid = session.value?.uid;

    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Groups',
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.displayLarge!.fontSize! * 2
                    : theme.textTheme.displayLarge!.fontSize,
              ),
            ),
            if (currentUid != null) ...[
              Expanded(
                child: groups.when(
                  data: (list) => list.isEmpty
                      ? Center(
                          child: Text(
                            'No Groups :(',
                            style: theme.textTheme.displayLarge!.copyWith(
                              fontSize: Globals.isTablet
                                  ? theme.textTheme.displayLarge!.fontSize! * 2
                                  : theme.textTheme.displayLarge!.fontSize,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (c, i) => ClanDetailsWidget(
                            group: list[i],
                            currentUserId: currentUid,
                          ),
                        ),
                  error: (err, stack) => Text(
                    err.toString(),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
            const Gap(20),
            GGButtonWidget(
              title: 'Create Group',
              onPressed: () => context.goNamed(
                Globals.routes.createGroup,
              ),
            ),
            const Gap(20),
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
