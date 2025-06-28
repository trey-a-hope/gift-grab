import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/presentation/blocs/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'package:gift_grab/data/constants/screens.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GameWidget<GiftGrabGame>(
          game: GiftGrabGame(context.read<LeaderboardBloc>()),
          overlayBuilderMap: {
            Screens.gameOver.name: (context, game) => GameOverOverlay(
                  game.score,
                  game.resetGame!,
                ),
          },
        ),
      );
}
