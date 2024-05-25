import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionData = ref.watch(Providers.nakamaSessionDataProvider);
    final selectedAvatar = ref.watch(Providers.selectedAvatarProvider);

    // final packageInfo = ref.watch(Providers.packageInfoProvider);

    final theme = Theme.of(context);

    return ScreenBackgroundWidget(
      child: Center(
        child: sessionData.when(
          data: (session) {
            if (session == null) {
              context.goNamed(Globals.routes.login);
              return const SizedBox();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Gift Grab',
                  style: theme.textTheme.displayLarge!.copyWith(
                    fontSize: Globals.isTablet
                        ? theme.textTheme.displayLarge!.fontSize! * 2
                        : theme.textTheme.displayLarge!.fontSize,
                  ),
                ),
                const Gap(20),
                if (selectedAvatar != null) ...[
                  Lottie.asset(
                    selectedAvatar.path,
                    height: 200,
                  ),
                ],

                if (session.avatar == null ||
                    LottieAvatar.findByName(session.avatar) == null) ...[
                  const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      Globals.emptyProfile,
                    ),
                  ),
                ],
                const Gap(20),
                Text(
                  'Welcome Back, ${session.username}',
                  style: theme.textTheme.displayLarge!.copyWith(
                    fontSize: Globals.isTablet
                        ? theme.textTheme.bodyLarge!.fontSize! * 2
                        : theme.textTheme.bodyLarge!.fontSize,
                  ),
                ),
                const Gap(50),
                GGButtonWidget(
                  title: 'Play',
                  onPressed: () => context.goNamed(Globals.routes.game),
                ),
                const Gap(20),
                GGButtonWidget(
                  title: 'Leaderboard',
                  onPressed: () => context.goNamed(Globals.routes.leaderboard),
                ),
                const Gap(20),
                GGButtonWidget(
                  title: 'Groups',
                  onPressed: () => context.goNamed(Globals.routes.groups),
                ),
                const Gap(20),
                GGButtonWidget(
                  title: 'Settings',
                  onPressed: () => context.goNamed(Globals.routes.settings),
                ),

                const Gap(20),
                GGButtonWidget(
                  title: 'Sign Out',
                  onPressed: () =>
                      ref.read(Providers.nakamaAuthProvider.notifier).logout(),
                ),

                const Gap(50),
                // packageInfo.when(
                //   data: (info) => Text(
                //     'Version ${info.version} - Build ${info.buildNumber}',
                //     style: theme.textTheme.headlineSmall!.copyWith(
                //       fontSize: Globals.isTablet
                //           ? theme.textTheme.headlineSmall!.fontSize! * 2
                //           : theme.textTheme.headlineSmall!.fontSize,
                //     ),
                //   ),
                //   loading: () => const CircularProgressIndicator(),
                //   error: (err, stack) => Text(
                //     err.toString(),
                //     style: theme.textTheme.headlineSmall!.copyWith(
                //       fontSize: Globals.isTablet
                //           ? theme.textTheme.headlineSmall!.fontSize! * 2
                //           : theme.textTheme.headlineSmall!.fontSize,
                //     ),
                //   ),
                // ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
        ),
      ),
    );
  }
}
