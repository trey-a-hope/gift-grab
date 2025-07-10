import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/data/enums/screens.dart';
import 'package:gift_grab_ui/game/gift_grab_game.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GameWidget<GiftGrabGame>(
          game: GiftGrabGame(
            onEndGame: (score) => debugPrint('Game ended with score: $score'),
          ),
          overlayBuilderMap: {
            Screens.gameOver.name: (context, game) => GameOverOverlay(
                  game.score,
                  game.resetGame!,
                ),
          },
        ),
      );
}
