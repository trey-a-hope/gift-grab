import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';

class GameOverOverlay extends StatelessWidget {
  final GiftGrabGame game;

  const GameOverOverlay({
    required this.game,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: 'Game Over',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Score: ${game.score}',
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
                  game.resetGame!();
                },
                child: Text(
                  'Play Again?',
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
