import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:gift_grab/domain/blocs/game/game_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/domain/blocs/santa/santa_bloc.dart';
import 'package:gift_grab/presentation/components/ice_component.dart';
import 'package:gift_grab/presentation/spawners/flame_spawner.dart';
import 'package:gift_grab/presentation/spawners/gift_spawner.dart';
import 'package:gift_grab/presentation/components/hud_text_components.dart';
import 'package:gift_grab/presentation/components/santa_component.dart';
import 'package:gift_grab/presentation/components/background_component.dart';
import 'package:gift_grab/presentation/inputs/joystick.dart';

class GameStateHandler extends Component
    with HasGameRef<GiftGrabGame>, FlameBlocListenable<GameBloc, GameState> {
  late final LeaderboardBloc leaderboardBloc;

  @override
  Future<void> onLoad() async {
    // Navigate up through the component tree to find FlameMultiBlocProvider
    Component? current = parent;
    while (current != null && current is! FlameMultiBlocProvider) {
      current = current.parent;
    }

    if (current is FlameMultiBlocProvider) {
      final providers = current;
      final leaderboardProvider = providers.children
          .whereType<FlameBlocProvider<LeaderboardBloc, LeaderboardState>>()
          .first;
      leaderboardBloc = leaderboardProvider.bloc;
    }
  }

  @override
  void onNewState(GameState state) {
    if (state.isGameOver) {
      leaderboardBloc.add(SubmitScoreEvent(score: state.score));

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
  int score = 0;
  Function()? resetGame;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<LeaderboardBloc, LeaderboardState>(
            create: () => LeaderboardBloc(),
          ),
          FlameBlocProvider<SantaBloc, SantaState>(
            create: () => SantaBloc(size / 2),
          ),
          FlameBlocProvider<GameBloc, GameState>(
            create: () => GameBloc()..add(StartGameEvent()),
          ),
        ],
        children: [
          PositionComponent(
            size: size,
            children: [
              GameStateHandler(),
              BackgroundComponent(),
              SantaComponent(joystick: joystick),
              HUDTextComponents(),
              FlameSpawner(),
              GiftSpawner(),
              IceComponent(
                  startPosition: Vector2(size.x * 0.25, size.y * 0.25)),
              IceComponent(
                  startPosition: Vector2(size.x * 0.75, size.y * 0.75)),
            ],
          ),
        ],
      ),
    );

    await add(joystick);
  }
}
