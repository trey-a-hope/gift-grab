import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final AuthBloc authBloc;

  FriendsBloc({required this.authBloc}) : super(FriendsInitial()) {
    on<FetchFriends>(_onFetchFriends);
  }

  Future<void> _onFetchFriends(
    FetchFriends event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading());

    try {
      // final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      // if (session == null) return;

      // debugPrint('Score: ${event.score}');

      // await getNakamaClient().writeLeaderboardRecord(
      //   session: session,
      //   leaderboardName: _leaderboardName,
      //   score: event.score,
      // );

      emit(FriendsLoaded());
    } on GrpcError catch (e) {
      emit(FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(FriendsError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
