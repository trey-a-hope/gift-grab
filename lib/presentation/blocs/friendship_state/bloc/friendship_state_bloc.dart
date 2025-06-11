import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/friends.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'friendship_state_event.dart';
part 'friendship_state_state.dart';

class FriendshipStateBloc
    extends Bloc<FriendshipStateEvent, FriendshipStateState> {
  final AuthBloc authBloc;
  final FriendsBloc friendsBloc;
  final NakamaSessionService _nakamaSessionService;

  FriendshipStateBloc(
    this.authBloc,
    this.friendsBloc,
    FriendshipState friendshipState,
  )   : _nakamaSessionService = NakamaSessionService(),
        super(FriendshipStateState(friendshipState)) {
    on<ListFriends>(
      (event, emit) async => BlocHandler<FriendshipStateState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final res = await _fetchFriends(
            session,
            friendshipState: friendshipState,
            clearCursor: false,
          );

          final curFriends = event.clearCursor ? [] : state.friends;

          emit(state.copyWith(
            friends: [...curFriends, ...res.$2],
            cursor: res.$1,
          ));
        },
        emit: emit,
        state: state,
      ),
    );

    on<CancelRequest>(
      (event, emit) async => BlocHandler<FriendshipStateState>().handle(
        action: () async {
          friendsBloc.add(DeleteFriend(event.uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(success: friendsState.success!));
              add(ListFriends(clearCursor: true));

              break;
            }
            if (friendsState.error != null) {
              emit(state.copyWith(error: friendsState.error!));
              break;
            }
          }
        },
        emit: emit,
        state: state,
      ),
    );

    add(ListFriends(clearCursor: false));
  }

  Future<(String? newCursor, List<Friend> newFriends)> _fetchFriends(
    Session session, {
    required FriendshipState friendshipState,
    required bool clearCursor,
  }) async {
    final cursor = clearCursor ? null : state.cursor;

    final friendsList = await getNakamaClient().listFriends(
      session: session,
      limit: Globals.paginationLimit,
      friendshipState: friendshipState,
      cursor: cursor,
    );

    final newCursor = friendsList.cursor == '' ? null : friendsList.cursor;

    final newFriends = friendsList.friends ?? [];

    return (newCursor, newFriends);
  }
}
