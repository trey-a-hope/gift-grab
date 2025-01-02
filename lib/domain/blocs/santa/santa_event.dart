import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:gift_grab/presentation/components/santa_component.dart';

abstract class SantaEvent extends Equatable {
  const SantaEvent();

  @override
  List<Object?> get props => [];
}

class FreezeSanta extends SantaEvent {}

class UnfreezeSanta extends SantaEvent {}

class FlameSanta extends SantaEvent {}

class UnflameSanta extends SantaEvent {}

class IncreaseSantaSpeed extends SantaEvent {}

class ResetSantaSpeed extends SantaEvent {}

class UpdateSantaMovement extends SantaEvent {
  final MovementState movement;
  final Vector2 position;

  const UpdateSantaMovement({
    required this.movement,
    required this.position,
  });

  @override
  List<Object?> get props => [movement, position];
}
