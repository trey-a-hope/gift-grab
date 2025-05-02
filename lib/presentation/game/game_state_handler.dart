part of 'gift_grab_game.dart';

class GameStateHandler extends Component
    with
        HasGameReference<GiftGrabGame>,
        FlameBlocListenable<GameBloc, GameState> {
  @override
  void onNewState(GameState state) {
    debugPrint('onNewState: ${state.toString()}');

    if (state.isGameOver) {
      bloc.stopTimer();

      game.leaderboardBloc.add(SubmitScore(state.score));

      // Flame -> Flutter Bloc conversion.
      game.score = state.score;
      game.resetGame = () {
        game.resumeEngine();
        game.overlays.remove('gameOver');
        bloc.add(ResetGameEvent());
      };
      // Normal gameRef variables.
      game.pauseEngine();
      game.overlays.add('gameOver');
    }
  }
}
