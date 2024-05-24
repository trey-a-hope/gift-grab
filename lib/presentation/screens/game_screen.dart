import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:gift_grab/presentation/screens/game_over_screen.dart';
import 'package:gift_grab/data/constants/screens.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

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
