import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;
  final FriendshipState friendshipState;

  FriendsBloc({
    required this.authBloc,
    required this.friendshipState,
  })  : _nakamaService = NakamaService(),
        super(FriendsInitial(cursor: null)) {
    on<FetchFriends>(_onFetchFriends);
    on<FetchMoreFriends>(_onFetchMoreFriends);
    on<DeleteFriend>(_onDeleteFriend);
    on<AddFriend>(_onAddFriend);
    on<BlockFriend>(_onBlockFriend);
  }

  Future<void> _onFetchFriends(
    FetchFriends event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final friendsList = await getNakamaClient().listFriends(
        session: session,
        limit: Globals.paginationLimit,
        friendshipState: friendshipState,
      );

      final cursor = friendsList.cursor == '' ? null : friendsList.cursor;

      final friends = friendsList.friends ?? [];

      emit(
        FriendsLoaded(
          friends: friends,
          cursor: cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onFetchMoreFriends(
    FetchMoreFriends event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final friendsList = await getNakamaClient().listFriends(
        session: session,
        limit: Globals.paginationLimit,
        cursor: state.cursor,
        friendshipState: friendshipState,
      );

      final cursor = friendsList.cursor == '' ? null : friendsList.cursor;

      final friends = friendsList.friends ?? [];

      emit(FriendsLoaded(
        friends: [...event.friends, ...friends],
        cursor: cursor,
      ));
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onDeleteFriend(
    DeleteFriend event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      await getNakamaClient().deleteFriends(
        session: session,
        ids: [event.uid],
      );

      emit(
        FriendsSuccess(
          message: 'Friend deleted successfully',
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onAddFriend(
    AddFriend event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      await getNakamaClient().addFriends(
        session: session,
        ids: [event.uid],
      );

      emit(
        FriendsSuccess(
          message: 'Friend added successfully',
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onBlockFriend(
    BlockFriend event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      await getNakamaClient().blockFriends(
        session: session,
        ids: [event.uid],
      );

      emit(
        FriendsSuccess(
          message: 'Friend blocked successfully',
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }
}
