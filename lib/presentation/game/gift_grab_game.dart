import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';

part 'game_state_handler.dart';

class GiftGrabGame extends FlameGame with DragCallbacks, HasCollisionDetection {
  // Store state variables on the widget since Flame overlays are part of
  // the game engine system, and Flutter Bloc is part of the widget system.
  int score = 0;
  Function()? resetGame;

  late final JoystickComponent _joystick;

  GiftGrabGame() {
    _joystick = createJoystick();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      FlameBlocProvider<GameBloc, GameState>(
        create: () => GameBloc()..add(StartGameEvent()),
        children: [
          PositionComponent(
            size: size,
            children: [
              GameStateHandler(),
              BackgroundComponent<GiftGrabGame>(),
              SantaComponent<GiftGrabGame>(joystick: _joystick),
              HUDTextComponents<GiftGrabGame>(),
              FlameSpawner<GiftGrabGame>(),
              GiftSpawner<GiftGrabGame>(),
              CookieSpawner<GiftGrabGame>(),
              IceComponent<GiftGrabGame>(),
            ],
          ),
        ],
      ),
    );

    await add(_joystick);
  }
}
