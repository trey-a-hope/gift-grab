import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class StartGameEvent extends GameEvent {}

class ScorePointEvent extends GameEvent {}

class TimerTickEvent extends GameEvent {}

class ActivateFlameEvent extends GameEvent {}

class DeactivateFlameEvent extends GameEvent {}

class FlameTickEvent extends GameEvent {}

class ResetGameEvent extends GameEvent {}
