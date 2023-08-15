import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/providers/nakama_provider.dart';
import 'package:gift_grab/domain/providers/providers.dart';
import 'package:gift_grab/presentation/games/gift_grab_game.dart';
import 'package:gift_grab/presentation/screens/game_play.dart';
import 'package:gift_grab/presentation/screens/menus/menu_background_widget.dart';

class MainMenu extends ConsumerWidget {
  final GiftGrabGame gameRef;
  const MainMenu({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NakamaProvider nakamaProvider = ref.watch(Providers.nakamaProvider);

    return MenuBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Gift Grab',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 100 : 50,
                ),
              ),
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  nakamaProvider.authUserViaEmail(
                    email: 'trey.a.hope@gmail.com',
                    password: '123password',
                  );

                  debugPrint('Session has started...');

                  // gameRef.removeMenu(menu: Menu.main);
                  // gameRef.resumeEngine();
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
                onPressed: () {
                  gameRef.removeMenu(menu: Menu.main);
                  gameRef.addMenu(menu: Menu.leaderboard);
                },
                child: Text(
                  'Leaderboards',
                  style: TextStyle(
                    fontSize: Globals.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),

            //  gameRef.removeMenu(menu: Menu.gameOver);
            //             gameRef.reset();
            //             gameRef.addMenu(menu: Menu.main);
          ],
        ),
      ),
    );
  }
}
