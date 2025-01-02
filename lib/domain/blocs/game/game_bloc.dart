import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/game/game_state.dart';
import 'game_event.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  static const int initialTime = 10;
  static const int flameTime = 10;
  static const int initialScore = 0;

  Timer? _gameTimer;

  GameBloc()
      : super(const GameState(
          score: initialScore,
          remainingTime: initialTime,
          flameRemainingTime: flameTime,
        )) {
    on<StartGame>(_onStartGame);
    on<ScorePoint>(_onScorePoint);
    on<TimerTick>(_onTimerTick);
    on<ActivateFlame>(_onActivateFlame);
    on<DeactivateFlame>(_onDeactivateFlame);
    on<FlameTick>(_onFlameTick);
    on<ResetGame>(_onResetGame);
  }

  void startTimer() {
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTick()),
    );
  }

  void stopTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    emit(state.copyWith(
      score: initialScore,
      remainingTime: initialTime,
      flameRemainingTime: flameTime,
      isFlameActive: false,
      isGameOver: false,
    ));

    startTimer();
  }

  void _onScorePoint(ScorePoint event, Emitter<GameState> emit) {
    emit(state.copyWith(score: state.score + 1));
  }

  void _onTimerTick(TimerTick event, Emitter<GameState> emit) {
    final newTime = state.remainingTime - 1;
    if (newTime <= 0) {
      emit(
        state.copyWith(
          remainingTime: 0,
          isGameOver: true,
        ),
      );
    } else {
      emit(state.copyWith(remainingTime: newTime));
    }
  }

  void _onActivateFlame(ActivateFlame event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isFlameActive: true,
      flameRemainingTime: flameTime,
    ));
  }

  void _onDeactivateFlame(DeactivateFlame event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isFlameActive: false,
      flameRemainingTime: flameTime,
    ));
  }

  void _onFlameTick(FlameTick event, Emitter<GameState> emit) {
    if (!state.isFlameActive) return;

    final newTime = state.flameRemainingTime - 1;
    if (newTime <= 0) {
      emit(state.copyWith(
        isFlameActive: false,
        flameRemainingTime: flameTime,
      ));
    } else {
      emit(state.copyWith(flameRemainingTime: newTime));
    }
  }

  void _onResetGame(ResetGame event, Emitter<GameState> emit) {
    emit(const GameState(
      score: initialScore,
      remainingTime: initialTime,
      flameRemainingTime: flameTime,
      isFlameActive: false,
      isGameOver: false,
    ));
  }

  @override
  Future<void> close() {
    stopTimer();
    return super.close();
  }
}
