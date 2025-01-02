import 'package:flame/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/presentation/components/santa_component.dart';
import 'package:gift_grab/domain/blocs/santa/santa_event.dart';
import 'package:gift_grab/domain/blocs/santa/santa_state.dart';

class SantaBloc extends Bloc<SantaEvent, SantaState> {
  static const double _originalSpeed = 500;

  SantaBloc(Vector2 initialPosition)
      : super(
          SantaState(
            speed: _originalSpeed,
            position: initialPosition,
          ),
        ) {
    on<FreezeSanta>(_onFreezeSanta);
    on<UnfreezeSanta>(_onUnfreezeSanta);
    on<FlameSanta>(_onFlameSanta);
    on<UnflameSanta>(_onUnflameSanta);
    on<IncreaseSantaSpeed>(_onIncreaseSantaSpeed);
    on<ResetSantaSpeed>(_onResetSantaSpeed);
    on<UpdateSantaMovement>(_onUpdateSantaMovement);
  }

  void _onFreezeSanta(FreezeSanta event, Emitter<SantaState> emit) {
    if (!state.isFrozen) {
      emit(state.copyWith(
        isFrozen: true,
        movement: MovementState.frozen,
      ));
    }
  }

  void _onUnfreezeSanta(UnfreezeSanta event, Emitter<SantaState> emit) {
    emit(state.copyWith(
      isFrozen: false,
      movement: MovementState.idle,
    ));
  }

  void _onFlameSanta(FlameSanta event, Emitter<SantaState> emit) {
    if (!state.isFrozen) {
      emit(state.copyWith(isFlamed: true));
    }
  }

  void _onUnflameSanta(UnflameSanta event, Emitter<SantaState> emit) {
    emit(state.copyWith(isFlamed: false));
  }

  void _onIncreaseSantaSpeed(
      IncreaseSantaSpeed event, Emitter<SantaState> emit) {
    emit(state.copyWith(speed: state.speed * 2));
  }

  void _onResetSantaSpeed(ResetSantaSpeed event, Emitter<SantaState> emit) {
    emit(state.copyWith(speed: _originalSpeed));
  }

  void _onUpdateSantaMovement(
      UpdateSantaMovement event, Emitter<SantaState> emit) {
    emit(state.copyWith(
      movement: event.movement,
      position: event.position,
    ));
  }
}
