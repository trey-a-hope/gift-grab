part of 'santa_bloc.dart';

abstract class SantaEvent extends Equatable {
  const SantaEvent();

  @override
  List<Object?> get props => [];
}

class FreezeSantaEvent extends SantaEvent {}

class UnfreezeSantaEvent extends SantaEvent {}

// class FlameSantaEvent extends SantaEvent {}

class UnflameSantaEvent extends SantaEvent {}

class IncreaseSantaSpeedEvent extends SantaEvent {}

class ResetSantaSpeedEvent extends SantaEvent {}

class UpdateSantaMovementEvent extends SantaEvent {
  final MovementState movement;
  final Vector2 position;

  const UpdateSantaMovementEvent({
    required this.movement,
    required this.position,
  });

  @override
  List<Object?> get props => [movement, position];
}
