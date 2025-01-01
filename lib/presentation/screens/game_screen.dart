import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/gift_grab_game.dart';
import 'package:gift_grab/presentation/overlays/game_over_overlay.dart';
import 'package:gift_grab/data/constants/screens.dart';

final _game = GiftGrabGame();

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: GameWidget<GiftGrabGame>(
          game: _game,
          overlayBuilderMap: {
            Screens.gameOver.name: (context, game) => GameOverOverlay(
                  game: game,
                ),
          },
        ),
      );
}
