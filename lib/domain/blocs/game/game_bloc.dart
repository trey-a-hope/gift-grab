import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  static const int initialTime = 30;
  static const int flameImmunityDuration = 10;
  static const double originalSpeed = 500;

  Timer? _gameTimer;
  Timer? _flameDisplayTimer;
  Timer? _flameCountdownTimer;
  Timer? _frozenCountdown;
  Timer? _cookieCountdown;
  bool _hasSpawnedFlame = false;

  GameBloc() : super(GameState()) {
    on<StartGameEvent>(_onStartGameEvent);
    on<ScorePointEvent>(_onScorePointEvent);
    on<TimerTickEvent>(_onTimerTickEvent);
    on<DisplayFlameEvent>(_onDisplayFlameEvent);
    on<StartFlameCountdownEvent>(_onStartFlameCountdownEvent);
    on<DeactivateFlameEvent>(_onDeactivateFlameEvent);
    on<FlameTickEvent>(_onFlameTickEvent);
    on<ResetGameEvent>(_onResetGameEvent);

    // Santa related events
    on<FreezeSantaEvent>(_onFreezeSantaEvent);
    on<UnfreezeSantaEvent>(_onUnfreezeSantaEvent);
    on<IncreaseSantaSpeedEvent>(_onIncreaseSantaSpeedEvent);
    on<ResetSantaSpeedEvent>(_onResetSantaSpeedEvent);
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

    _frozenCountdown?.cancel();
    _frozenCountdown = null;

    _cookieCountdown?.cancel();
    _cookieCountdown = null;
  }

  void _onResetGameEvent(ResetGameEvent event, Emitter<GameState> emit) {
    stopTimer();
    emit(GameState(
      remainingTime: initialTime,
      flameRemainingTime: flameImmunityDuration,
      score: 0,
      isGameOver: false,
      isSantaFlamed: false,
      isSantaFrozen: false,
      santaSpeed: originalSpeed,
      isFlameSpawned: false,
    ));
    _hasSpawnedFlame = false;
  }

  void _onDeactivateFlameEvent(
      DeactivateFlameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isSantaFlamed: false,
      flameRemainingTime: flameImmunityDuration,
    ));
  }

  void _onDisplayFlameEvent(DisplayFlameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(isFlameSpawned: true));
  }

  void _onTimerTickEvent(TimerTickEvent event, Emitter<GameState> emit) {
    final newTime = state.remainingTime - 1;
    if (newTime <= 0) {
      _gameTimer?.cancel();
      emit(state.copyWith(
        remainingTime: 0,
        isGameOver: true,
      ));
    } else {
      emit(state.copyWith(remainingTime: newTime));
    }
  }

  void _onStartGameEvent(StartGameEvent event, Emitter<GameState> emit) {
    emit(GameState(
      remainingTime: initialTime,
      score: 0,
      isGameOver: false,
    ));
    startTimer();
  }

  void _onScorePointEvent(ScorePointEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(score: state.score + 1));
  }

  void _onStartFlameCountdownEvent(
      StartFlameCountdownEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isSantaFlamed: true,
      flameRemainingTime: flameImmunityDuration,
    ));
    _startFlameCountdown();
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

  void _onFlameTickEvent(FlameTickEvent event, Emitter<GameState> emit) {
    final newTime = state.flameRemainingTime - 1;
    if (newTime <= 0) {
      _flameCountdownTimer?.cancel();
      emit(state.copyWith(
        isSantaFlamed: false,
        flameRemainingTime: flameImmunityDuration,
      ));
    } else {
      emit(state.copyWith(flameRemainingTime: newTime));
    }
  }

  // Santa related event handlers
  void _onFreezeSantaEvent(FreezeSantaEvent event, Emitter<GameState> emit) {
    if (!state.isSantaFrozen) {
      _frozenCountdown?.cancel();
      emit(state.copyWith(
        isSantaFrozen: true,
      ));

      _frozenCountdown = Timer(const Duration(seconds: 3), () {
        add(UnfreezeSantaEvent());
      });
    }
  }

  void _onUnfreezeSantaEvent(
      UnfreezeSantaEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(
      isSantaFrozen: false,
    ));
  }

  void _onIncreaseSantaSpeedEvent(
      IncreaseSantaSpeedEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(santaSpeed: state.santaSpeed * 2));
  }

  void _onResetSantaSpeedEvent(
      ResetSantaSpeedEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(santaSpeed: originalSpeed));
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    _flameDisplayTimer?.cancel();
    _flameCountdownTimer?.cancel();
    _frozenCountdown?.cancel();
    _cookieCountdown?.cancel();
    return super.close();
  }
}
