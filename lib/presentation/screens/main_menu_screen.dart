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
    final theme = Theme.of(context);

    return ScreenBackgroundWidget(
      child: Center(
        child: sessionData.when(
          data: (session) {
            if (session == null) {
              context.goNamed(Globals.routeLogin);
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
                Text(
                  'Welcome Back, ${session.email}',
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
                    onPressed: () {
                      context.goNamed(Globals.routeGame);
                    },
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
                    onPressed: () => context.goNamed(Globals.routeLeaderboard),
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
