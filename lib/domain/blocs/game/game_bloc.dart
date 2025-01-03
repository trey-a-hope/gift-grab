import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  static const int initialTime = 30;
  static const int flameTime = 10;
  static const int initialScore = 0;

  Timer? _gameTimer;
  Timer? _flameDisplayTimer;
  Timer? _flameCountdownTimer;
  bool _hasSpawnedFlame = false;

  GameBloc()
      : super(const GameState(
          score: initialScore,
          remainingTime: initialTime,
          flameRemainingTime: flameTime,
        )) {
    on<StartGameEvent>(_onStartGameEvent);
    on<ScorePointEvent>(_onScorePointEvent);
    on<TimerTickEvent>(_onTimerTickEvent);
    on<DisplayFlameEvent>(_onDisplayFlameEvent);
    on<StartFlameCountdownEvent>(_onStartFlameCountdownEvent);
    on<DeactivateFlameEvent>(_onDeactivateFlameEvent);
    on<FlameTickEvent>(_onFlameTickEvent);
    on<ResetGameEvent>(_onResetGameEvent);
  }

  void startTimer() {
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTickEvent()),
    );

    final randomSeconds = 1;
    _flameDisplayTimer = Timer(
      Duration(seconds: randomSeconds),
      () {
        if (!_hasSpawnedFlame) {
          add(DisplayFlameEvent());
          _hasSpawnedFlame = true;
        }
      },
    );
  }

  void stopTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;

    _flameDisplayTimer?.cancel();
    _flameDisplayTimer = null;

    _flameCountdownTimer?.cancel();
    _flameCountdownTimer = null;
  }

  void _onDisplayFlameEvent(DisplayFlameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(isFlameSpawned: true));
  }

  void _onStartFlameCountdownEvent(
      StartFlameCountdownEvent event, Emitter<GameState> emit) {
    debugPrint('Starting flame countdown');
    emit(state.copyWith(
      isSantaFlamed: true,
      flameRemainingTime: flameTime,
    ));
    _startFlameCountdown();
  }

  void _onStartGameEvent(StartGameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      score: initialScore,
      remainingTime: initialTime,
      flameRemainingTime: flameTime,
      isSantaFlamed: false,
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

  void _startFlameCountdown() {
    _flameCountdownTimer?.cancel();
    _flameCountdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        add(FlameTickEvent());
      },
    );
  }

  void _onDeactivateFlameEvent(
      DeactivateFlameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isSantaFlamed: false,
      flameRemainingTime: flameTime,
    ));
  }

  void _onFlameTickEvent(FlameTickEvent event, Emitter<GameState> emit) {
    final newTime = state.flameRemainingTime - 1;
    debugPrint('Flame time left...$newTime seconds...');
    if (newTime <= 0) {
      _flameCountdownTimer?.cancel();
      emit(state.copyWith(
        isSantaFlamed: false,
        flameRemainingTime: flameTime,
      ));
    } else {
      emit(state.copyWith(
        flameRemainingTime: newTime,
      ));
    }
  }

  void _onResetGameEvent(ResetGameEvent event, Emitter<GameState> emit) {
    emit(const GameState(
      score: initialScore,
      remainingTime: initialTime,
      flameRemainingTime: flameTime,
      isGameOver: false,
    ));
  }

  @override
  Future<void> close() {
    stopTimer();
    return super.close();
  }
}
