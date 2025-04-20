import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:gift_grab/domain/blocs/game/game_bloc.dart';
import 'package:gift_grab/presentation/components/cookie_component.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';

class CookieSpawner extends Component
    with
        HasGameReference<GiftGrabGame>,
        FlameBlocListenable<GameBloc, GameState> {
  bool _hasSpawned = false;

  @override
  void onNewState(GameState state) {
    if (state.isCookieSpawned && !_hasSpawned) {
      _hasSpawned = true;
      final randomPosition = Vector2(
        Random().nextDouble() * game.size.x,
        Random().nextDouble() * game.size.y,
      );
      add(CookieComponent(startPosition: randomPosition));
    }
  }
}
