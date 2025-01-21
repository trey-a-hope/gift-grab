import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:gift_grab/domain/blocs/game/game_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/presentation/components/ice_component.dart';
import 'package:gift_grab/presentation/spawners/cookie_spawner.dart';
import 'package:gift_grab/presentation/spawners/flame_spawner.dart';
import 'package:gift_grab/presentation/spawners/gift_spawner.dart';
import 'package:gift_grab/presentation/components/hud_text_components.dart';
import 'package:gift_grab/presentation/components/santa_component.dart';
import 'package:gift_grab/presentation/components/background_component.dart';
import 'package:gift_grab/presentation/inputs/joystick.dart';

class GameStateHandler extends Component
    with HasGameRef<GiftGrabGame>, FlameBlocListenable<GameBloc, GameState> {
  @override
  void onNewState(GameState state) {
    if (state.isGameOver) {
      bloc.stopTimer();

      gameRef.leaderboardBloc.add(SubmitScore(score: state.score));
      // Flame -> Flutter Bloc conversion.
      gameRef.score = state.score;
      gameRef.resetGame = () {
        gameRef.resumeEngine();
        gameRef.overlays.remove('gameOver');
        bloc.add(ResetGameEvent());
      };
      // Normal gameRef variables.
      gameRef.pauseEngine();
      gameRef.overlays.add('gameOver');
    }
  }
}

class GiftGrabGame extends FlameGame with DragCallbacks, HasCollisionDetection {
  // Store state variables on the widget since Flame overlays are part of
  // the game engine system, and Flutter Bloc is part of the widget system.
  final LeaderboardBloc leaderboardBloc;
  int score = 0;
  Function()? resetGame;

  late final JoystickComponent _joystick;

  GiftGrabGame({required this.leaderboardBloc}) {
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
              BackgroundComponent(),
              SantaComponent(joystick: _joystick),
              HUDTextComponents(),
              FlameSpawner(),
              GiftSpawner(),
              CookieSpawner(),
              IceComponent(),
            ],
          ),
        ],
      ),
    );

    await add(_joystick);
  }
}
