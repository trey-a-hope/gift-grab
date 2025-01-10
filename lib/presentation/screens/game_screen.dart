import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'package:gift_grab/presentation/overlays/game_over_overlay.dart';
import 'package:gift_grab/data/constants/screens.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GameWidget<GiftGrabGame>(
          game: GiftGrabGame(
            leaderboardBloc: context.read<LeaderboardBloc>(),
          ),
          overlayBuilderMap: {
            Screens.gameOver.name: (context, game) =>
                GameOverOverlay(game: game),
          },
        ),
      );
}
