import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:gift_grab/presentation/blocs/game/game_bloc.dart';
import 'package:gift_grab/presentation/components/flame_component.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';

class FlameSpawner extends Component
    with
        HasGameReference<GiftGrabGame>,
        FlameBlocListenable<GameBloc, GameState> {
  bool _hasSpawned = false;

  @override
  void onNewState(GameState state) {
    if (state.isFlameSpawned && !_hasSpawned) {
      _hasSpawned = true;
      final randomPosition = Vector2(
        Random().nextDouble() * game.size.x,
        Random().nextDouble() * game.size.y,
      );
      add(FlameComponent(startPosition: randomPosition));
    }
  }
}
