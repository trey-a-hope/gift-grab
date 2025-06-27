import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/friends/bloc/friends_bloc.dart';
import 'package:gift_grab_ui/bloc_handler.dart';
import 'package:nakama/nakama.dart';

part 'friendship_group_event.dart';
part 'friendship_group_state.dart';

class FriendshipGroupBloc
    extends Bloc<FriendshipGroupEvent, FriendshipGroupState> {
  final FriendsBloc friendsBloc;
  final SessionService sessionService;
  final FriendshipState friendshipState;

  FriendshipGroupBloc(
    this.friendsBloc,
    this.friendshipState,
    this.sessionService,
  ) : super(FriendshipGroupState(friendshipState)) {
    on<ListFriends>(_onListFriends);
    on<AcceptIncomingRequest>(_onAcceptIncomingRequest);
    on<CancelOutgoingRequest>(_onCancelOutgoingRequest);
    on<RejectIncomingRequest>(_onRejectIncomingRequest);
    on<DeleteFriend>(_onDeleteFriend);

    add(ListFriends(clearCursor: false));
  }

  Future<void> _onListFriends(
    ListFriends event,
    Emitter<FriendshipGroupState> emit,
  ) async =>
      await BlocHandler<FriendshipGroupState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final res = await _fetchFriends(
            session,
            friendshipState: friendshipState,
            clearCursor: false,
          );

          final curFriends = event.clearCursor ? [] : state.friends;

          emit(
            state.copyWith(
              friends: [...curFriends, ...res.$2],
              cursor: res.$1,
            ),
          );
        },
        emit: emit,
        state: state,
      );

  Future<void> _onAcceptIncomingRequest(
    AcceptIncomingRequest event,
    Emitter<FriendshipGroupState> emit,
  ) async =>
      await BlocHandler<FriendshipGroupState>().handle(
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

  Future<void> _onCancelOutgoingRequest(
    CancelOutgoingRequest event,
    Emitter<FriendshipGroupState> emit,
  ) async =>
      await BlocHandler<FriendshipGroupState>().handle(
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

  Future<void> _onRejectIncomingRequest(
    RejectIncomingRequest event,
    Emitter<FriendshipGroupState> emit,
  ) async =>
      await BlocHandler<FriendshipGroupState>().handle(
        action: () async {
          friendsBloc.add(Delete(event.uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(success: 'Request rejected'));
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
    Emitter<FriendshipGroupState> emit,
  ) async =>
      await BlocHandler<FriendshipGroupState>().handle(
        action: () async {
          friendsBloc.add(Delete(event.uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(success: 'Friend deleted'));
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

  Future<
      (
        String? newCursor,
        List<Friend> newFriends,
      )> _fetchFriends(
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
