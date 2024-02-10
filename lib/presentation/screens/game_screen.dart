import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/util/config/screens.dart';
import 'package:gift_grab/presentation/screens/game_over_screen.dart';
import 'package:gift_grab/util/config/providers.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: GameWidget(
          game: ref.read(Providers.giftGrabFlameGameProvider),
          overlayBuilderMap: {
            Screens.gameOver.name: (context, game) => const GameOverScreen(),
          },
        ),
      );
}
