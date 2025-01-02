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
    on<StartGameEvent>(_onStartGameEvent);
    on<ScorePointEvent>(_onScorePointEvent);
    on<TimerTickEvent>(_onTimerTickEvent);
    on<ActivateFlameEvent>(_onActivateFlameEvent);
    on<DeactivateFlameEvent>(_onDeactivateFlameEvent);
    on<FlameTickEvent>(_onFlameTickEvent);
    on<ResetGameEvent>(_onResetGameEvent);
  }

  void startTimer() {
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTickEvent()),
    );
  }

  void stopTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }

  void _onStartGameEvent(StartGameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      score: initialScore,
      remainingTime: initialTime,
      flameRemainingTime: flameTime,
      isFlameActive: false,
      isGameOver: false,
    ));

    startTimer();
  }

  void _onScorePointEvent(ScorePointEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(score: state.score + 1));
  }

  void _onTimerTickEvent(TimerTickEvent event, Emitter<GameState> emit) {
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

  void _onActivateFlameEvent(
      ActivateFlameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isFlameActive: true,
      flameRemainingTime: flameTime,
    ));
  }

  void _onDeactivateFlameEvent(
      DeactivateFlameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isFlameActive: false,
      flameRemainingTime: flameTime,
    ));
  }

  void _onFlameTickEvent(FlameTickEvent event, Emitter<GameState> emit) {
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

  void _onResetGameEvent(ResetGameEvent event, Emitter<GameState> emit) {
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
