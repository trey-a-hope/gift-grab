part of 'gift_grab_game.dart';

class GameStateHandler extends Component
    with HasGameRef<GiftGrabGame>, FlameBlocListenable<GameBloc, GameState> {
  @override
  void onNewState(GameState state) {
    debugPrint('onNewState: ${state.toString()}');

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
