import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/constants/screens.dart';
import 'package:gift_grab/domain/providers/nakama_provider.dart';
import 'package:gift_grab/domain/providers/providers.dart';
import 'package:gift_grab/presentation/games/gift_grab_game.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';

class GameOverScreen extends ConsumerWidget {
  final GiftGrabGame gameRef;
  const GameOverScreen({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NakamaProvider nakamaProvider = ref.watch(Providers.nakamaProvider);
    nakamaProvider.writeLeaderboardRecord(score: gameRef.score);
    final theme = Theme.of(context);
    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Game Over',
                style: theme.textTheme.displayLarge!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displayLarge!.fontSize! * 2
                      : theme.textTheme.displayLarge!.fontSize,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Score: ${gameRef.score}',
                style: theme.textTheme.displayLarge!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displayLarge!.fontSize! * 3
                      : theme.textTheme.displayLarge!.fontSize,
                ),
              ),
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Screens.gameOver);
                  gameRef.reset();
                  gameRef.resumeEngine();
                },
                child: Text(
                  'Play Again?',
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
                  gameRef.removeMenu(menu: Screens.gameOver);
                  gameRef.reset();
                  gameRef.addMenu(menu: Screens.main);
                },
                child: Text(
                  'Main Menu',
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
