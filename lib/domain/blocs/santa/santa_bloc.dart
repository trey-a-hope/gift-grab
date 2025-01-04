// import 'package:equatable/equatable.dart';
// import 'package:flame/components.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gift_grab/presentation/components/santa_component.dart';

// part 'santa_event.dart';
// part 'santa_state.dart';

// class SantaBloc extends Bloc<SantaEvent, SantaState> {
//   static const double _originalSpeed = 500;

//   SantaBloc(Vector2 initialPosition)
//       : super(
//           SantaState(
//             speed: _originalSpeed,
//             position: initialPosition,
//           ),
//         ) {
//     on<FreezeSantaEvent>(_onFreezeSantaEvent);
//     on<UnfreezeSantaEvent>(_onUnfreezeSantaEvent);
//     on<FlameSantaEvent>(_onFlameSantaEvent);
//     on<UnflameSantaEvent>(_onUnflameSantaEvent);
//     on<IncreaseSantaSpeedEvent>(_onIncreaseSantaSpeedEvent);
//     on<ResetSantaSpeedEvent>(_onResetSantaSpeedEvent);
//     on<UpdateSantaMovementEvent>(_onUpdateSantaMovementEvent);
//   }

//   void _onFreezeSantaEvent(FreezeSantaEvent event, Emitter<SantaState> emit) {
//     if (!state.isFrozen) {
//       emit(state.copyWith(
//         isFrozen: true,
//         movement: MovementState.frozen,
//       ));
//     }
//   }

//   void _onUnfreezeSantaEvent(
//       UnfreezeSantaEvent event, Emitter<SantaState> emit) {
//     emit(state.copyWith(
//       isFrozen: false,
//       movement: MovementState.idle,
//     ));
//   }

//   void _onFlameSantaEvent(FlameSantaEvent event, Emitter<SantaState> emit) {
//     if (!state.isFrozen) {
//       emit(state.copyWith(isFlamed: true));
//     }
//   }

//   void _onUnflameSantaEvent(UnflameSantaEvent event, Emitter<SantaState> emit) {
//     emit(state.copyWith(isFlamed: false));
//   }

//   void _onIncreaseSantaSpeedEvent(
//       IncreaseSantaSpeedEvent event, Emitter<SantaState> emit) {
//     emit(state.copyWith(speed: state.speed * 2));
//   }

//   void _onResetSantaSpeedEvent(
//       ResetSantaSpeedEvent event, Emitter<SantaState> emit) {
//     emit(state.copyWith(speed: _originalSpeed));
//   }

//   void _onUpdateSantaMovementEvent(
//       UpdateSantaMovementEvent event, Emitter<SantaState> emit) {
//     emit(state.copyWith(
//       movement: event.movement,
//       position: event.position,
//     ));
//   }
// }
