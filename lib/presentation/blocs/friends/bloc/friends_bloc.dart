import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab_ui/bloc_handler.dart';
import 'package:nakama/nakama.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final SessionService sessionService;

  FriendsBloc(this.sessionService) : super(FriendsState()) {
    on<Add>(_onAdd);
    on<Delete>(_onDelete);
    on<Block>(_onBlock);
  }

  Future<void> _onAdd(
    Add event,
    Emitter<FriendsState> emit,
  ) async =>
      await BlocHandler<FriendsState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await getNakamaClient().addFriends(
            session: session,
            ids: [event.uid],
          );

          emit(state.copyWith(success: 'Friend request sent'));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onDelete(
    Delete event,
    Emitter<FriendsState> emit,
  ) async =>
      await BlocHandler<FriendsState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await getNakamaClient().deleteFriends(
            session: session,
            ids: [event.uid],
          );

          emit(state.copyWith(success: 'Friend request deleted'));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onBlock(
    Block event,
    Emitter<FriendsState> emit,
  ) async =>
      await BlocHandler<FriendsState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await getNakamaClient().blockFriends(
            session: session,
            ids: [event.uid],
          );

          emit(state.copyWith(success: 'Friend blocked'));
        },
        emit: emit,
        state: state,
      );
}
