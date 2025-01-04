part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class StartGameEvent extends GameEvent {}

class ResetGameEvent extends GameEvent {}

class TimerTickEvent extends GameEvent {}

class ScorePointEvent extends GameEvent {}

class DisplayFlameEvent extends GameEvent {}

class StartFlameCountdownEvent extends GameEvent {}

class FlameTickEvent extends GameEvent {}

class DeactivateFlameEvent extends GameEvent {}

// Santa related events
class FreezeSantaEvent extends GameEvent {}

class UnfreezeSantaEvent extends GameEvent {}

class IncreaseSantaSpeedEvent extends GameEvent {}

class ResetSantaSpeedEvent extends GameEvent {}
