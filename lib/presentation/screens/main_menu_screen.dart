import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionData = ref.watch(Providers.nakamaSessionDataProvider);
    final packageInfo = ref.watch(Providers.packageInfoProvider);

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
                if (session.avatarUrl != null) ...[
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      session.avatarUrl!.isNotEmpty
                          ? session.avatarUrl!
                          : Globals.emptyProfile,
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
                SizedBox(
                  width: Globals.isTablet ? 400 : 200,
                  height: Globals.isTablet ? 100 : 50,
                  child: ElevatedButton(
                    onPressed: () => context.goNamed(Globals.routes.game),
                    child: Text(
                      'Play',
                      style: TextStyle(
                        fontSize: Globals.isTablet ? 50 : 25,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                SizedBox(
                  width: Globals.isTablet ? 400 : 250,
                  height: Globals.isTablet ? 100 : 50,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.goNamed(Globals.routes.leaderboard),
                    child: Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: Globals.isTablet ? 50 : 25,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                SizedBox(
                  width: Globals.isTablet ? 400 : 250,
                  height: Globals.isTablet ? 100 : 50,
                  child: ElevatedButton(
                    onPressed: () => context.goNamed(Globals.routes.settings),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: Globals.isTablet ? 50 : 25,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                SizedBox(
                  width: Globals.isTablet ? 400 : 200,
                  height: Globals.isTablet ? 100 : 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(Providers.nakamaAuthProvider.notifier).logout();
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: Globals.isTablet ? 50 : 25,
                      ),
                    ),
                  ),
                ),
                const Gap(50),
                packageInfo.when(
                  data: (info) => Text(
                    'Version ${info.version} - Build ${info.buildNumber}',
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontSize: Globals.isTablet
                          ? theme.textTheme.headlineSmall!.fontSize! * 2
                          : theme.textTheme.headlineSmall!.fontSize,
                    ),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text(
                    err.toString(),
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontSize: Globals.isTablet
                          ? theme.textTheme.headlineSmall!.fontSize! * 2
                          : theme.textTheme.headlineSmall!.fontSize,
                    ),
                  ),
                ),
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
