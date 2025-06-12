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
  final FriendshipState friendshipState;

  FriendshipStateBloc(
    this.authBloc,
    this.friendsBloc,
    this.friendshipState,
  )   : _nakamaSessionService = NakamaSessionService(),
        super(FriendshipStateState(friendshipState)) {
    on<ListFriends>(_onListFriends);
    on<CancelOutgoingRequest>(_onCancelOutgoingRequest);
    on<AcceptIncomingRequest>(_onAcceptIncomingRequest);
    on<RejectIncomingRequest>(_onRejectIncomingRequest);
    on<DeleteFriend>(_onDeleteFriend);
    on<BlockFriend>(_onBlockFriend);
    on<UnblockFriend>(_onUnblockFriend);

    add(ListFriends(clearCursor: false));
  }

  Future<void> _onListFriends(
    ListFriends event,
    Emitter<FriendshipStateState> emit,
  ) async =>
      BlocHandler<FriendshipStateState>().handle(
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
      );

  Future<void> _onCancelOutgoingRequest(
    CancelOutgoingRequest event,
    Emitter<FriendshipStateState> emit,
  ) async =>
      BlocHandler<FriendshipStateState>().handle(
        action: () async {
          friendsBloc.add(Delete(event.uid));

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
      );

  Future<void> _onAcceptIncomingRequest(
    AcceptIncomingRequest event,
    Emitter<FriendshipStateState> emit,
  ) async =>
      BlocHandler<FriendshipStateState>().handle(
        action: () async {
          friendsBloc.add(Add(event.uid));

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
      );

  Future<void> _onRejectIncomingRequest(
    RejectIncomingRequest event,
    Emitter<FriendshipStateState> emit,
  ) async =>
      BlocHandler<FriendshipStateState>().handle(
        action: () async {
          friendsBloc.add(Delete(event.uid));

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
      );

  Future<void> _onDeleteFriend(
    DeleteFriend event,
    Emitter<FriendshipStateState> emit,
  ) async =>
      BlocHandler<FriendshipStateState>().handle(
        action: () async {
          friendsBloc.add(Delete(event.uid));

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
      );

  Future<void> _onBlockFriend(
    BlockFriend event,
    Emitter<FriendshipStateState> emit,
  ) async =>
      BlocHandler<FriendshipStateState>().handle(
        action: () async {
          friendsBloc.add(Block(event.uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(success: 'User blocked'));
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
      );

  Future<void> _onUnblockFriend(
    UnblockFriend event,
    Emitter<FriendshipStateState> emit,
  ) async =>
      BlocHandler<FriendshipStateState>().handle(
        action: () async {
          friendsBloc.add(Delete(event.uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(success: 'User unblocked'));
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
      );

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
//UnblockFriend
