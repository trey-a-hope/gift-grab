import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/util/config/globals.dart';
import 'package:gift_grab/util/config/providers.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends ConsumerWidget {
  // final GiftGrabGame gameRef;
  const MainMenuScreen({
    Key? key,
    // required this.gameRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Gift Grab',
                style: theme.textTheme.displayLarge!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displayLarge!.fontSize! * 2
                      : theme.textTheme.displayLarge!.fontSize,
                ),
              ),
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  // ref
                  //     .read(Providers.gameIsActiveNotifier.notifier)
                  //     .setIsActive(true);
                  // ref.read(Providers.giftGrabFlameGameProvider).resumeEngine();
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(
                          Providers.nakamaSessionAsyncNotifierProvider.notifier)
                      .signOut();
                  // gameRef.addMenu(menu: Screens.login);
                  // gameRef.removeMenu(menu: Screens.main);
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
        ),
      ),
    );
  }
}
