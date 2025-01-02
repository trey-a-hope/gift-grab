import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class StartGame extends GameEvent {}

class ScorePoint extends GameEvent {}

class TimerTick extends GameEvent {}

class ActivateFlame extends GameEvent {}

class DeactivateFlame extends GameEvent {}

class FlameTick extends GameEvent {}

class ResetGame extends GameEvent {}
