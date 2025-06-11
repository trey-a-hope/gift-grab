import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;

  FriendsBloc(
    this.authBloc, {
    NakamaSessionService? nakamaSessionService,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(FriendsState()) {
    on<AddFriend>(
      (event, emit) => BlocHandler<FriendsState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          await getNakamaClient().addFriends(
            session: session,
            ids: [event.uid],
          );

          emit(state.copyWith(success: 'Friend request sent'));
        },
        emit: emit,
        state: state,
      ),
    );
    on<DeleteFriend>(
      (event, emit) => BlocHandler<FriendsState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          await getNakamaClient().deleteFriends(
            session: session,
            ids: [event.uid],
          );

          emit(state.copyWith(success: 'Friend request canceled'));
        },
        emit: emit,
        state: state,
      ),
    );
  }
}
