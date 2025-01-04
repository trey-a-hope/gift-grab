// part of 'santa_bloc.dart';

// class SantaState extends Equatable {
//   final bool isFrozen;
//   final bool isFlamed;
//   final double speed;
//   final MovementState movement;
//   final Vector2 position;

//   const SantaState({
//     this.isFrozen = false,
//     this.isFlamed = false,
//     required this.speed,
//     this.movement = MovementState.idle,
//     required this.position,
//   });

//   SantaState copyWith({
//     bool? isFrozen,
//     bool? isFlamed,
//     double? speed,
//     MovementState? movement,
//     Vector2? position,
//   }) {
//     return SantaState(
//       isFrozen: isFrozen ?? this.isFrozen,
//       isFlamed: isFlamed ?? this.isFlamed,
//       speed: speed ?? this.speed ,
//       movement: movement ?? this.movement,
//       position: position ?? this.position,
//     );
//   }

//   @override
//   List<Object?> get props => [isFrozen, isFlamed, speed, movement, position];
// }
