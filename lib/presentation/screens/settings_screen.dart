import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final session = ref.watch(Providers.nakamaSessionDataProvider);

    return GGScaffoldWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Settings',
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.displayLarge!.fontSize! * 2
                    : theme.textTheme.displayLarge!.fontSize,
              ),
            ),
            const Gap(50),
            GGButtonWidget(
              title: 'Edit Profile',
              onPressed: () => context.goNamed(Globals.routes.editProfile),
            ),
            const Gap(20),
            GGButtonWidget(
              title: 'Pick Avatar',
              onPressed: () => context.goNamed(Globals.routes.pickAvatar),
            ),
            const Gap(20),
            GGButtonWidget(
              title: 'Sign Out',
              onPressed: () async {
                final confirm = await ModalService.showConfirmation(
                  context: context,
                  title: 'Sign Out?',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                ref.read(Providers.nakamaAuthProvider.notifier).logout();
              },
            ),
            const Gap(20),
            session.when(
              data: (data) => data == null
                  ? const SizedBox()
                  : GGButtonWidget(
                      title: 'Delete Profile',
                      onPressed: () async {
                        final confirm =
                            await ModalService.showInputMatchConfirmation(
                          context: context,
                          title: 'Delete Account?',
                          hintText: 'Enter your email to confirm.',
                          match: data.email,
                        );

                        if (confirm == null || confirm == false) {
                          return;
                        }

                        await ref
                            .read(Providers.nakamaAuthProvider.notifier)
                            .deleteAccount();
                      },
                    ),
              error: (err, stack) => Text(err.toString()),
              loading: () => const CircularProgressIndicator(),
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
