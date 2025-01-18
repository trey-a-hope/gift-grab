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
  FriendsBloc({required this.authBloc})
      : _nakamaService = NakamaService(),
        super(FriendsInitial(cursor: null)) {
    on<FetchFriends>(_onFetchFriends);
    on<FetchMoreFriends>(_onFetchMoreFriends);
  }

  Future<void> _onFetchFriends(
    FetchFriends event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      final friendsList = await getNakamaClient().listFriends(
        session: session,
        limit: Globals.paginationLimit,
      );

      final cursor = friendsList.cursor == '' ? null : friendsList.cursor;

      emit(
        FriendsLoaded(
          friends: friendsList.friends ?? [],
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
      if (session == null) return;

      final friendsList = await getNakamaClient().listFriends(
        session: session,
        limit: Globals.paginationLimit,
        cursor: state.cursor,
      );

      final cursor = friendsList.cursor == '' ? null : friendsList.cursor;

      emit(FriendsLoaded(
        friends: friendsList.friends ?? [],
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
}
